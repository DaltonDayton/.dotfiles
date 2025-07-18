# Dotfiles

Personal dotfiles and development environment configuration management system.

## Quick Start

```bash
git clone https://github.com/username/dotfiles ~/.dotfiles
cd ~/.dotfiles/arch
cp .env_default .env
./install.sh
```

## Overview

This repository contains a modular dotfiles configuration system designed specifically for Arch Linux environments. The system automates the setup and configuration of development tools through independent, reusable modules that can be safely run multiple times.

### Repository Structure

```
.
├── arch/               # Arch Linux configuration system (primary)
│   ├── modules/        # Modular tool configurations
│   │   ├── git/        # Git and GitHub CLI setup
│   │   ├── shell/      # Zsh, Starship, CLI tools
│   │   ├── neovim/     # LazyVim configuration
│   │   ├── tmux/       # Terminal multiplexer
│   │   └── ...         # Additional modules
│   ├── install.sh      # Main installation script
│   └── README.md       # Detailed arch-specific documentation
├── other_configs/      # Standalone configuration files
└── CLAUDE.md          # Development guidance for AI assistants
```

## Features

- **Modular Design**: Each tool/application has its own module
- **Idempotent**: Safe to run multiple times
- **Symlink-based**: Non-destructive configuration deployment
- **Version Pinning**: Support for specific package versions
- **Environment-aware**: Context-specific configurations

## Current Modules

- **Git & GitHub CLI**: Version control and collaboration tools
- **Shell Environment**: Zsh with Zinit, Starship prompt, modern CLI tools
- **Terminal**: Kitty terminal emulator with optimized configuration
- **Editor**: Neovim with LazyVim and extensive plugin ecosystem
- **Development Tools**: asdf version manager, Python environment
- **Multiplexer**: tmux for session management
- **File Management**: Modern replacements (eza, bat, fzf, yazi)
- **System Tools**: Logitech device management and utilities

## Usage

### Full Installation

```bash
cd arch/
cp .env_default .env    # Edit as needed
./install.sh
```

### Adding Custom Modules

1. Copy the example module:

   ```bash
   cp -r arch/modules/_example_module arch/modules/your_module
   ```

2. Edit the module script and add configuration files

3. Add module to `MODULES` array in `arch/install.sh`

### Testing Changes

```bash
# Validate shell scripts
shellcheck arch/install.sh

# Test individual modules by sourcing and calling functions
source arch/modules/common.sh
source arch/modules/git/git.sh
install_git
```

## Environment Configuration

Create and customize `.env` file in the `arch/` directory:

```bash
ENVIRONMENT=arch
CONTEXT=personal
GIT_NAME="Your Name"
GIT_EMAIL="your.email@domain.com"
```

## Requirements

- Arch Linux (or Arch-based distribution)
- Git (for initial clone and repository management)
- Base development tools (`base-devel` package group)

## Safety Features

- Error handling with immediate exit on failures
- Non-destructive symlink management
- Package installation validation
- Idempotent operations throughout

## Documentation

- See `arch/README.md` for detailed Arch Linux system documentation
- See `CLAUDE.md` for development and AI assistant guidance
- Individual modules contain inline documentation

## License

Personal use - modify as needed for your own dotfiles setup.
