# WSL Ubuntu Dotfiles

Automated development environment setup for WSL Ubuntu, providing a comprehensive and modular configuration system adapted from Arch Linux dotfiles.

## Quick Start

```bash
# Navigate to WSL Ubuntu directory
cd wsl_ubuntu/

# Configure environment
cp .env_default .env
# Edit .env with your details (GIT_NAME, GIT_EMAIL)

# Run installation
./install.sh
```

## Overview

This WSL Ubuntu dotfiles system provides automated installation and configuration of development tools specifically optimized for Windows Subsystem for Linux environments. The system is based on a proven modular architecture adapted from Arch Linux, with packages and installation methods tailored for Ubuntu.

### Key Features

- **WSL-Optimized**: Handles PATH conflicts between Windows and Linux tools
- **Modular Architecture**: Independent modules for each tool/application
- **Ubuntu Package Management**: Uses apt with PPA support for additional repositories
- **Idempotent Operations**: Safe to run multiple times without side effects
- **Symlink-based Configuration**: Non-destructive deployment of configuration files
- **Environment Awareness**: Context-specific configurations via .env file

## Available Modules

### Core Development Tools
- **git** - Git and GitHub CLI with user configuration
- **neovim** - LazyVim-based editor with extensive plugin ecosystem
- **tmux** - Terminal multiplexer with TPM (Tmux Plugin Manager)
- **asdf** - Version manager for multiple programming languages (Node.js, Python, etc.)

### Shell Enhancement
- **shell** - Comprehensive shell environment including:
  - Zsh with optimized configuration
  - Starship prompt for enhanced terminal experience
  - Modern CLI tools: `eza` (ls replacement), `bat` (cat with syntax highlighting)
  - File navigation: `fzf` (fuzzy finder), `yazi` (terminal file manager)
  - Smart directory jumping with `zoxide`

### Development Environment
- **claude-code** - Claude Code CLI with WSL-specific optimizations

## Installation Process

### Prerequisites

- WSL Ubuntu (or Ubuntu-based WSL distribution)
- Internet connection for package downloads
- Git (usually pre-installed in WSL)

### Environment Configuration

1. **Copy Environment Template**:
   ```bash
   cp .env_default .env
   ```

2. **Customize Settings**:
   ```bash
   # Edit .env file
   ENVIRONMENT="wsl"
   CONTEXT="personal"
   GIT_NAME="Your Full Name"
   GIT_EMAIL="your.email@example.com"
   ```

### Installation Steps

1. **Package Updates**: Synchronizes Ubuntu package databases
2. **Module Processing**: Installs each enabled module in dependency order
3. **Package Installation**: Downloads and installs required packages via apt, PPAs, and external sources
4. **Configuration Deployment**: Creates symlinks for configuration files
5. **Environment Setup**: Configures shell integration and PATH management

## WSL-Specific Considerations

### PATH Management
The system prioritizes Linux tools over Windows versions to avoid conflicts:

```bash
# asdf tools take priority
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
```

### Tool Verification
Installation includes environment validation to ensure proper tool sources:

```bash
# Example: Verify Node.js comes from asdf, not Windows
which node  # Should show: /home/user/.asdf/shims/node
```

### Shell Integration
Configurations work with both bash and zsh for maximum compatibility in WSL environments.

## Customization

### Enabling/Disabling Modules

Edit the `MODULES` array in `install.sh`:

```bash
MODULES=(
  "git"
  "tmux"
  "shell"
  "asdf"
  "neovim"
  "claude-code"
)
```

Comment out modules you don't want:
```bash
# "claude-code"  # Disabled
```

### Module Dependencies

Current module order respects dependencies:
```
git → tmux → shell → asdf → neovim → claude-code
```

- **asdf** provides Node.js required by claude-code
- **git** needed for repository operations
- **shell** provides enhanced terminal experience

### Adding Custom Configurations

Configuration files are located in each module's `config/` directory:
- Edit files directly in module directories
- Run `./install.sh` to deploy changes via symlinks
- Changes are automatically reflected in your environment

## Development Workflow

### Testing Individual Modules

```bash
# Test specific module
source modules/common.sh
source modules/git/git.sh
install_git
```

### Validating Installation

```bash
# Check script syntax
bash -n install.sh
bash -n modules/*/.*sh

# Verify tool installations
which git && git --version
which nvim && nvim --version
which tmux && tmux -V
```

### Re-running Installation

The system is idempotent - run `./install.sh` multiple times safely:
- Existing packages are skipped
- Configuration symlinks are updated
- No destructive operations

## Troubleshooting

### Common WSL Issues

#### Tool Conflicts
**Problem**: Using Windows versions instead of Linux tools
```bash
# Check tool source
which node
# If shows Windows path, restart terminal and check PATH
```

#### PATH Problems
**Problem**: Tools not found after installation
```bash
# Verify PATH configuration
echo $PATH
# Should include ~/.asdf/shims at the beginning
```

#### Package Installation Failures
```bash
# Update package databases
sudo apt update

# Install individual packages manually
sudo apt install <package-name>

# Check for PPA issues
sudo apt-add-repository --remove ppa:name/ppa
```

### Environment Issues

#### Missing .env File
```bash
# Recreate from template
cp .env_default .env
# Edit with your details
```

#### Permission Problems
```bash
# Check script permissions
chmod +x install.sh

# Verify module permissions
find modules/ -name "*.sh" -exec chmod +x {} \;
```

### Post-Installation Steps

1. **Restart Terminal**: Close and reopen WSL terminal completely
2. **Verify Environment**: Check that tools are available and from correct sources
3. **Test Configuration**: Ensure shell enhancements and tools work as expected
4. **Optional**: Run installation again to verify idempotency

## Architecture Details

For developers and advanced users interested in the technical implementation, module structure, and development workflow, see [DEVELOPMENT.md](DEVELOPMENT.md) for comprehensive technical documentation.

## Module Structure

```
wsl_ubuntu/
├── .env_default          # Environment configuration template
├── install.sh             # Main installation orchestrator  
├── DEVELOPMENT.md         # Technical developer documentation
├── README.md              # This file
└── modules/
    ├── common.sh          # Shared utilities (apt, symlinks, etc.)
    ├── git/               # Git and GitHub CLI setup
    ├── tmux/              # Terminal multiplexer configuration
    ├── shell/             # Enhanced shell environment
    ├── asdf/              # Development tool version manager
    ├── neovim/            # LazyVim editor configuration
    └── claude-code/       # Claude Code CLI setup
```

## Support

- **General Usage**: This README covers standard installation and usage
- **Development**: See [DEVELOPMENT.md](DEVELOPMENT.md) for technical details
- **Issues**: Module-specific problems are usually solved by running individual module installations