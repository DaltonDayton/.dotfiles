# AGENTS.md - Dotfiles Repository Guide

## Build/Test Commands
- **Install all modules**: `./install.sh` (requires `.env` file)
- **Install specific module**: Edit `MODULES` array in `install.sh` and run
- **Test module**: Source module script and call `install_<module_name>` function
- **Validate shell scripts**: Use `shellcheck` on `.sh` files

## Code Style Guidelines

### Shell Scripts (.sh files)
- Use `#!/usr/bin/bash` shebang
- Set `set -e` for error handling
- Use `trap 'echo "An error occurred. Exiting..."; exit 1;' ERR`
- Function naming: `install_<module_name>()` and `configure_<module_name>()`
- Variable naming: UPPERCASE for globals, lowercase for locals
- Quote variables: `"$variable"` not `$variable`
- Use `local` for function variables
- Array syntax: `packages=("item1" "item2")`

### Lua (Neovim config)
- Indent: 2 spaces (configured in `.stylua.toml`)
- Use stylua for formatting

### General Conventions
- Modular design: Each tool gets its own module directory
- Idempotent scripts: Safe to run multiple times
- Use `symlink_config()` function for config file linking
- Package installation via `install_packages()` function
- Environment variables in `.env` file (copy from `.env_default`)