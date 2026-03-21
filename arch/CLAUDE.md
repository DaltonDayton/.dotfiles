# Arch Linux Dotfiles

Modular Arch Linux configuration management system. Modules handle package installation and config deployment via symlinks.

## Commands

```bash
./install.sh                    # Run full installation (idempotent)
shellcheck install.sh           # Validate main script syntax
shellcheck modules/**/*.sh      # Validate all module scripts

# Test a single module
source modules/common.sh && source modules/git/git.sh && install_git

# Check package status
yay -Q | grep <package>
pacman -Qq <package>
```

## Architecture

- `install.sh` runs modules listed in the `MODULES` array (uncomment to enable)
- Each module in `modules/<name>/` has `<name>.sh` implementing `install_<name>()` and `configure_<name>()`
- `install_<name>()` declares packages and calls `install_packages()`
- `configure_<name>()` uses `symlink_config()` to deploy config files
- `modules/common.sh` provides shared utilities: `install_packages()`, `symlink_config()`, `ensure_package_installed()`
- `.env` file (from `.env_default`) provides environment-specific settings (ENVIRONMENT, CONTEXT, GIT_NAME, GIT_EMAIL)

## Available Modules

All modules are toggled by uncommenting in the `MODULES` array in `install.sh`:

- **git** — Git and GitHub CLI configuration
- **shell** — Zsh with Zinit, Starship prompt, modern CLI tools (eza, bat, fzf, yazi)
- **tmux** — Terminal multiplexer
- **asdf** — Development tool version management
- **python** — Python development environment
- **neovim** — LazyVim-based editor with extensive plugins
- **misc** — Additional utilities and tools
- **kitty** — Terminal emulator
- **solaar** — Logitech device management
- **fonts** — Font installation
- **obsidian** — Obsidian note-taking app
- **nvidia** — NVIDIA/Optimus driver setup (run before hyprland on NVIDIA systems)
- **theme** — GTK/Qt theming (run before hyprland)
- **hyprland** — Wayland compositor with full desktop environment (waybar, cursors, etc.)
- **gaming** — Gaming packages (Steam, Lutris, Wine, Discord, etc.)
- **insync** — Google Drive synchronization client
- **claude-code** — Claude Code CLI configuration

## Adding New Modules

1. Copy `modules/_example_module/` to `modules/<name>/`
2. Rename script, implement `install_<name>()` and `configure_<name>()`
3. Add config files to `config/` subdirectory
4. Add module name to `MODULES` array in `install.sh`

## Key Patterns

- **Idempotent** — all scripts safe to re-run
- **Non-destructive symlinks** — `symlink_config()` won't clobber real files
- **Version pinning** — supports `package=version` syntax
- **Error trapping** — `set -e` with trap; scripts exit immediately on failure
