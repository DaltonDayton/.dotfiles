# AGENTS.md - Dotfiles Repository Guide

## Build/Test Commands
- **Install all modules**: `./install.sh`
- **Install specific module**: Edit `MODULES` array in `install.sh` and run
- **Test single module**: `source modules/common.sh && source modules/<name>/<name>.sh && install_<name>`
- **Validate shell scripts**: `shellcheck install.sh modules/*/*.sh`
- **Test module function**: `bash -c "source modules/common.sh && source modules/<name>/<name>.sh && configure_<name>"`
- **Lint Lua files**: `stylua --check modules/neovim/nvim/` (format: `stylua modules/neovim/nvim/`)

## Code Style Guidelines

### Shell Scripts (.sh files)
- Use `#!/usr/bin/bash` shebang with `set -e` and error trap
- Function naming: `install_<module_name>()` and `configure_<module_name>()`
- Variable naming: UPPERCASE for globals, lowercase with `local` for function vars
- Always quote variables: `"$variable"` and use arrays: `packages=("item1" "item2")`
- Package installation: Use `install_packages "${packages[@]}"` with version pinning support
- Configuration: Use `symlink_config "$source" "$dest"` for safe symlinking
- Error handling: Include retry logic and validation via `ensure_package_installed()`

### Lua (Neovim config)
- Indent: 2 spaces (enforced by `.stylua.toml`)
- Use stylua for formatting, follow LazyVim plugin structure

### Module Architecture
- Each module: `modules/<name>/<name>.sh` with `config/` subdirectory
- Idempotent operations, automated configuration deployment
- Source `modules/common.sh` for shared utilities (`install_packages`, `symlink_config`)
- Test individual modules before adding to `MODULES` array in `install.sh`