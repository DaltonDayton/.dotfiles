# CLAUDE.md

Personal dotfiles repository with modular configuration management, primarily targeting Arch Linux.

## Directory Structure

```
.
├── arch/               # Arch Linux dotfiles system (primary) — see arch/CLAUDE.md
├── shared_configs/     # Shared configuration templates (Claude Code, Neovim)
├── wsl_ubuntu/         # WSL Ubuntu dotfiles system
├── other_configs/      # Standalone configuration files
├── scripts/            # Utility scripts
```

## Quick Reference

```bash
# Arch Linux setup (run from arch/ directory)
cp arch/.env_default arch/.env   # Configure environment variables
arch/install.sh                  # Run full installation (idempotent)

# Validate shell scripts
shellcheck arch/install.sh
shellcheck arch/modules/**/*.sh
```

## Key Concepts

- **Modular architecture**: Each tool/app is a self-contained module in `arch/modules/`
- **Symlink-based deployment**: Config files in modules are symlinked to system locations
- **Idempotent**: All scripts can be run multiple times safely
- **Package manager**: Uses `yay` (AUR helper) on Arch

For detailed architecture, module list, and development patterns, see `arch/CLAUDE.md`.

## Important Notes

- **Always work from `arch/`** when making Arch dotfiles changes
- Configuration changes go in `arch/modules/<name>/config/`, not system locations directly
- Scripts use `set -e` with error trapping — expect immediate exit on failures
- Modules are enabled/disabled by uncommenting in the `MODULES` array in `arch/install.sh`

