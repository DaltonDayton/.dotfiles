# Arch Linux Dotfiles System

Comprehensive modular configuration management system for Arch Linux development environments.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Available Modules](#available-modules)
- [Installation Process](#installation-process)
- [Customization](#customization)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)

## Overview

This Arch Linux dotfiles system provides automated installation and configuration of development tools through a modular architecture. Each tool is encapsulated in its own module, allowing for selective installation and easy customization.

### Key Features

- **Modular Design**: Independent modules for each tool/application
- **Idempotent Operations**: Safe to run multiple times without side effects
- **Symlink-based Configuration**: Non-destructive deployment of configuration files
- **Package Version Pinning**: Support for specific package versions
- **AUR Integration**: Automatic yay installation and AUR package support
- **Error Handling**: Robust error handling with immediate exit on failures
- **Automated Setup**: No manual configuration required

## Quick Start

```bash
# Navigate to arch directory
cd arch/

# Run installation
./install.sh
```

## Architecture

### Module System

Each module follows a consistent structure:

```
modules/<module_name>/
├── <module_name>.sh    # Installation and configuration script
└── config/             # Configuration files to be symlinked
    ├── file1.conf
    └── file2.toml
```

### Core Functions

Every module implements two main functions:
- `install_<module_name>()` - Handles package installation
- `configure_<module_name>()` - Manages configuration deployment

### Common Utilities (modules/common.sh)

- `install_packages()` - Batch package installation with version support
- `ensure_package_installed()` - Individual package installation with retry logic
- `symlink_config()` - Safe symlink creation without destructive operations
- `ensure_yay_installed()` - Automatic AUR helper installation

## Available Modules

### Core Development Tools

- **git** - Git and GitHub CLI with optimized configuration
- **shell** - Zsh with Zinit plugin manager, Starship prompt
- **neovim** - LazyVim-based configuration with extensive plugin ecosystem
- **tmux** - Terminal multiplexer with custom key bindings
- **asdf** - Version manager for multiple programming languages

### CLI Enhancement Tools

- **shell** includes:
  - `eza` - Modern replacement for ls
  - `bat` - Syntax-highlighted cat alternative
  - `fzf` - Fuzzy finder for files and command history
  - `yazi` - Terminal file manager

### Development Environment

- **python** - Python development environment setup
- **kitty** - GPU-accelerated terminal emulator

### Desktop Environment

- **hyprland** - Wayland compositor with complete desktop environment
  - Comprehensive window management and workspace features
  - Waybar status bar with custom styling
  - Cursor themes (Bibata variants)
  - Integration with hypridle, hyprlock, hyprshade
  - NVIDIA support and optimizations

### System Tools

- **misc** - Additional utilities and system enhancements
- **solaar** - Logitech device management
- **insync** - Google Drive synchronization client

### Gaming

- **gaming** - Complete gaming setup
  - Steam and Lutris game managers
  - Wine compatibility layer
  - Discord for gaming communication
  - Supporting gaming utilities and libraries

## Installation Process

### Prerequisites

- Arch Linux or Arch-based distribution
- Git (for repository cloning)
- Base development tools (`base-devel` package group)
- Internet connection for package downloads

### Installation Steps

1. **Package Database Sync**: Updates Arch package databases
2. **yay Installation**: Installs AUR helper if not present
3. **Module Processing**: Iterates through enabled modules in MODULES array
4. **Package Installation**: Downloads and installs required packages
5. **Configuration Deployment**: Creates symlinks for configuration files

## Customization

### Enabling/Disabling Modules

Edit the `MODULES` array in `install.sh`:

```bash
MODULES=(
  "git"
  "shell"
  "tmux"
  "asdf"
  "neovim"
  "misc"
  "kitty"
  "solaar"
  "hyprland"
  # "python"    # Available but disabled
  # "gaming"    # Available but disabled
  # "insync"    # Available but disabled
)
```

### Adding New Modules

1. **Copy Template**:
   ```bash
   cp -r modules/_example_module modules/your_module
   ```

2. **Edit Module Script**:
   ```bash
   # Rename and edit the script
   mv modules/your_module/example_module.sh modules/your_module/your_module.sh
   ```

3. **Implement Functions**:
   ```bash
   install_your_module() {
     local packages=(
       "package1"
       "package2=1.2.3"  # Version pinning
     )
     install_packages "${packages[@]}"
     configure_your_module
   }

   configure_your_module() {
     symlink_config "$HOME/.dotfiles/arch/modules/your_module/config/config.conf" "$HOME/.config/app/config.conf"
   }
   ```

4. **Add Configuration Files**:
   Place configuration files in `modules/your_module/config/`

5. **Enable Module**:
   Add `"your_module"` to the MODULES array

### Modifying Existing Configurations

- Configuration files are located in `modules/<name>/config/`
- Edit files directly in the module's config directory
- Run `./install.sh` or individual module function to deploy changes
- Symlinks automatically update to reflect changes

## Development Workflow

### Testing Changes

```bash
# Validate shell script syntax
shellcheck install.sh
shellcheck modules/*/**.sh

# Test individual modules
source modules/common.sh
source modules/git/git.sh
install_git

# Re-run full installation (idempotent)
./install.sh
```

### Debugging

```bash
# Check package installation
yay -Q | grep <package_name>
pacman -Qq <package_name>

# Verify symlinks
ls -la ~/.config/
ls -la ~/

# Check module function availability
declare -f install_git
declare -f configure_git
```

### Safety Features

- **Error Handling**: Scripts use `set -e` with error trapping
- **Non-destructive Symlinks**: `symlink_config()` safely manages symlinks
- **Package Validation**: `ensure_package_installed()` validates installation
- **Retry Logic**: Package installation includes retry mechanisms
- **Idempotent Operations**: Can be run multiple times safely

## Troubleshooting

### Common Issues

#### Script Execution Errors

```bash
# Make script executable
chmod +x install.sh

# Check for syntax errors
shellcheck install.sh
```

#### Package Installation Failures

```bash
# Update package databases
sudo pacman -Sy

# Manual package installation
yay -S <package_name>

# Check AUR package availability
yay -Ss <package_name>
```

#### Configuration Issues

```bash
# Check module-specific configuration files
ls -la modules/*/config/

# Verify symlinks are properly created
ls -la ~/.config/
```

#### Module-Specific Issues

- Check individual module scripts for errors
- Verify configuration file paths and permissions
- Test module functions individually
- Review symlink destinations for conflicts

### Post-Installation Steps

1. **Terminal Restart**: Close and reopen terminal completely
2. **Shell Reload**: Allow new shell configuration to load
3. **Plugin Installation**: Some tools may need additional setup on first run
4. **Verification**: Test key tools and configurations

### Getting Help

- Review module-specific documentation in script comments
- Check the main repository README for general guidance
- Consult tool-specific documentation for configuration options
- Use `--help` flags with installed CLI tools

## Notes

- **Target Platform**: Designed specifically for Arch Linux
- **Package Manager**: Uses `yay` for both official and AUR packages
- **Configuration Strategy**: Symlink-based for easy maintenance
- **Module Independence**: Each module manages its own dependencies
- **Version Control**: Git-based configuration management