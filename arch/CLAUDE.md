# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular Arch Linux dotfiles system that manages system configuration through independent modules. The architecture separates package installation from configuration deployment using symlinks.

## Core Commands

### Installation and Setup
```bash
# Run full installation
./install.sh

# Test installation script syntax
shellcheck install.sh
```

### Module Management
```bash
# Enable/disable modules by editing the MODULES array in install.sh
# Modules are located in modules/ directory

# Individual module structure:
# modules/<name>/<name>.sh          # Installation script
# modules/<name>/config/            # Configuration files to symlink
```

## Architecture

### Module System
- Each module implements `install_<name>()` and `configure_<name>()` functions
- Installation function defines packages and calls `install_packages()`
- Configuration function uses `symlink_config()` to deploy config files
- All modules source `modules/common.sh` for shared utilities

### Key Utilities (modules/common.sh)
- `install_packages()` - Handles AUR/official packages with version pinning
- `symlink_config()` - Safely creates symlinks without destructive rm -rf
- `ensure_package_installed()` - Individual package installation with validation

### Module Configuration
- Git configuration automatically handled with hardcoded values
- System optimized for Arch Linux personal use
- All configuration deployed via symlinks to appropriate system locations

## Current Active Modules
- `git` - Git and GitHub CLI setup
- `shell` - Zsh with Zinit, Starship, file tools (eza, bat, fzf, yazi)
- `tmux` - Terminal multiplexer
- `asdf` - Version manager for development tools
- `neovim` - LazyVim-based configuration with extensive plugins
- `kitty` - Terminal emulator
- `solaar` - Logitech device management

## Development Patterns

### Adding New Modules
1. Copy `_example_module/` template to `modules/<name>/`
2. Edit script to replace `exampleModule` with actual implementation
3. Add configuration files to `config/` subdirectory
4. Add module name to `MODULES` array in install.sh

### Safety Features
- Uses `set -e` with error trapping for safe execution
- Idempotent operations - can be run multiple times safely
- Package version pinning support via `package=version` syntax
- Non-destructive symlink management

### Configuration Philosophy
- Configuration files live in module-specific `config/` directories
- Symlinks created to proper system locations (~/.config/, ~/, etc.)
- No manual file copying - everything managed through symlinks
- Module independence - each handles its own dependencies