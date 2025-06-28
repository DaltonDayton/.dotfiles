# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is Dalton's personal dotfiles repository containing modular configuration management systems for different environments. The repository is organized by environment/platform with the primary focus on Arch Linux systems.

## Directory Structure

```
.
├── arch/               # Arch Linux dotfiles system (primary)
├── other_configs/      # Standalone configuration files
├── scripts/           # Utility scripts
└── CLAUDE.md          # This file
```

## Primary Development Environment: Arch Linux

The main dotfiles system is located in `arch/` and contains a complete modular configuration management system. **When working with dotfiles configuration, always work in the `arch/` directory.**

### Core Commands

```bash
# Setup and installation (run from arch/ directory)
cd arch/
cp .env_default .env    # Configure environment
./install.sh           # Run full installation

# Development and testing
shellcheck install.sh  # Validate shell script syntax
```

### Architecture Overview

The Arch system uses a modular approach where:
- `install.sh` orchestrates the installation of enabled modules
- Each module in `modules/` handles a specific tool/application
- Modules implement `install_<name>()` and `configure_<name>()` functions
- Configuration files are symlinked from `modules/<name>/config/` to system locations
- `modules/common.sh` provides shared utilities for package management and symlinking

### Current Active Modules

- **git**: Git and GitHub CLI configuration
- **shell**: Zsh with Zinit, Starship prompt, modern CLI tools (eza, bat, fzf, yazi)
- **tmux**: Terminal multiplexer setup
- **asdf**: Development tool version management
- **neovim**: LazyVim-based editor with extensive plugin configuration
- **kitty**: Terminal emulator
- **python**: Python development environment
- **misc**: Additional utilities and tools
- **solaar**: Logitech device management

### Key Architectural Patterns

- **Idempotent Operations**: All scripts can be run multiple times safely
- **Non-destructive Symlinks**: Uses `symlink_config()` utility that won't overwrite existing files
- **Package Version Pinning**: Supports `package=version` syntax for specific versions
- **Environment-based Configuration**: Uses `.env` file for context-specific settings
- **Module Independence**: Each module manages its own dependencies and configuration

### Safety Features

- Uses `set -e` with error trapping for safe script execution
- Package installation validation through `ensure_package_installed()`
- Symlink safety checks to prevent data loss
- Environment variable validation

## Working with This Repository

### Adding New Modules
1. Copy `arch/modules/_example_module/` template
2. Implement installation and configuration functions
3. Add configuration files to module's `config/` directory
4. Add module name to `MODULES` array in `arch/install.sh`

### Modifying Existing Configurations
- Configuration files live in `modules/<name>/config/`
- Changes are deployed via symlinks to system locations
- Test changes by running individual module functions

### Development Workflow
1. Make changes in appropriate module's config directory
2. Test with `shellcheck` for shell scripts
3. Run individual module or full `install.sh` to apply changes
4. Verify symlinks and configurations are properly deployed

## Important Notes

- **Always work from the `arch/` directory** when making dotfiles changes
- The system is designed for Arch Linux but modules can be adapted for other distributions
- Configuration changes should be made in module config directories, not in system locations directly
- The repository supports multiple environments but Arch is the primary maintained system