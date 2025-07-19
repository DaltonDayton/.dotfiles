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
cp .env_default .env    # Configure environment variables
./install.sh           # Run full installation

# Development and testing
shellcheck install.sh                    # Validate main script syntax
shellcheck modules/*/**.sh               # Validate all module scripts
./install.sh                            # Re-run installation (idempotent)

# Individual module testing
source modules/common.sh && source modules/git/git.sh && install_git

# Testing individual components
chmod +x install.sh                      # Make script executable if needed
```

### Architecture Overview

The Arch system uses a modular approach where:
- `install.sh` orchestrates the installation of enabled modules (defined in MODULES array)
- Each module in `modules/` handles a specific tool/application
- Modules implement `install_<name>()` and `configure_<name>()` functions
- Configuration files are symlinked from `modules/<name>/config/` to system locations
- `modules/common.sh` provides shared utilities for package management and symlinking
- `.env` file provides environment-specific configuration (ENVIRONMENT, CONTEXT, GIT_NAME, GIT_EMAIL)

### Current Active Modules

Currently enabled in install.sh:
- **git**: Git and GitHub CLI configuration
- **shell**: Zsh with Zinit, Starship prompt, modern CLI tools (eza, bat, fzf, yazi)
- **tmux**: Terminal multiplexer setup
- **asdf**: Development tool version management
- **neovim**: LazyVim-based editor with extensive plugin configuration
- **kitty**: Terminal emulator
- **misc**: Additional utilities and tools
- **solaar**: Logitech device management
- **hyprland**: Wayland compositor with complete desktop environment (waybar, cursors, window management)

Available but not currently enabled:
- **python**: Python development environment
- **gaming**: Gaming packages (Steam, Lutris, Wine, Discord, etc.)
- **insync**: Google Drive synchronization client

### Key Architectural Patterns

- **Idempotent Operations**: All scripts can be run multiple times safely
- **Non-destructive Symlinks**: Uses `symlink_config()` utility that creates/updates symlinks safely
- **Package Version Pinning**: Supports `package=version` syntax for specific versions
- **Environment-based Configuration**: Uses `.env` file for context-specific settings
- **Module Independence**: Each module manages its own dependencies and configuration
- **Retry Logic**: Package installation includes retry mechanisms with validation

### Safety Features

- Uses `set -e` with error trapping for safe script execution
- Package installation validation through `ensure_package_installed()`
- Symlink safety checks to prevent data loss
- Environment variable validation

## Working with This Repository

### Adding New Modules
1. Copy `arch/modules/_example_module/` template to `modules/<name>/`
2. Rename `example_module.sh` to `<name>.sh` and replace `exampleModule` with actual name
3. Implement `install_<name>()` function with package list and configuration call
4. Implement `configure_<name>()` function with symlink operations
5. Add configuration files to module's `config/` directory
6. Add module name to `MODULES` array in `arch/install.sh`

### Modifying Existing Configurations
- Configuration files live in `modules/<name>/config/`
- Changes are deployed via symlinks to system locations
- Test changes by running individual module functions

### Development Workflow
1. Make changes in appropriate module's config directory
2. Test with `shellcheck` for shell scripts
3. Run individual module or full `install.sh` to apply changes
4. Verify symlinks and configurations are properly deployed
5. Test installation on clean system or container when possible

### Common Debugging Commands
```bash
# Check symlink status
ls -la ~/.config/                        # Verify config symlinks
ls -la ~/                               # Verify home directory symlinks

# Module-specific testing
yay -Q | grep <package>                  # Check if package is installed
pacman -Qq <package>                     # Verify package installation
```

## Important Notes

- **Always work from the `arch/` directory** when making dotfiles changes
- The system is designed for Arch Linux but modules can be adapted for other distributions
- Configuration changes should be made in module config directories, not in system locations directly
- The repository supports multiple environments but Arch is the primary maintained system
- **Package Manager**: Uses `yay` (AUR helper) which gets auto-installed if missing
- **Error Handling**: Scripts use `set -e` and error trapping - expect immediate exit on failures