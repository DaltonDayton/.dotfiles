# WSL Ubuntu Dotfiles Development Guide

This document provides comprehensive context and instructions for continuing development of the WSL Ubuntu dotfiles system. It's designed to allow another Claude Code instance to immediately understand and continue work on this project.

## Project Overview

### Purpose
This is Dalton's personal dotfiles repository containing a modular configuration management system specifically adapted for WSL Ubuntu environments. It's based on an existing Arch Linux dotfiles system located in `../arch/`, with packages and installation methods adapted for Ubuntu.

### Key Architecture
- **Modular Design**: Each tool/application has its own module in `modules/`
- **Install + Configure Pattern**: Each module implements `install_<name>()` and `configure_<name>()` functions
- **Symlink-based Config**: Configuration files are symlinked from module directories to system locations
- **Shared Utilities**: `modules/common.sh` provides package management and symlinking functions
- **Environment-based**: Uses `.env` file for context-specific settings (git name/email, environment type)

## Current Project State

### Completed Modules (in order)
1. **git** - Git and GitHub CLI setup with user configuration
2. **tmux** - Terminal multiplexer with TPM (Tmux Plugin Manager)
3. **shell** - Enhanced shell environment (zsh, starship, eza, bat, fzf, yazi, zoxide)
4. **asdf** - Version manager installed via Go (handles Node.js and other development tools)
5. **claude-code** - Claude Code CLI with WSL-optimized installation

### Current Module Dependencies
```
git (standalone)
tmux (standalone)
shell (standalone, but depends on various external tools)
asdf (depends on golang-go, provides Node.js)
claude-code (depends on asdf for Node.js)
```

### Installation Order
The modules are installed in this specific order in `install.sh`:
```bash
MODULES=(
  "git"
  "tmux"
  "shell"
  "asdf"
  "claude-code"
)
```

## Key Technical Decisions Made

### 1. asdf Installation Method
- **Decision**: Use Go-based installation (`go install github.com/asdf-vm/asdf/cmd/asdf@latest`)
- **Rationale**: More reliable than git clone method, gets latest version automatically
- **Dependencies**: Requires `golang-go` package

### 2. WSL-Specific Optimizations
- **PATH Management**: Critical to prioritize asdf shims over Windows tools
- **Environment Validation**: Extensive debugging output for troubleshooting WSL conflicts
- **Shell Integration**: Configure both bash and zsh for compatibility

### 3. Package Installation Strategies
- **Standard apt packages**: Use existing `install_packages()` function
- **External tools**: Create module-specific installation functions
- **Examples**:
  - `install_eza()`: Uses official PPA installation
  - `install_yazi()`: Uses snap package manager
  - `install_starship()`: Uses official curl installation script

## Module Conversion Process

### Step 1: Analyze Arch Module
1. Read `../arch/modules/<name>/<name>.sh` to understand structure
2. Identify package dependencies and configuration files
3. Note any Arch-specific installation methods (AUR, etc.)

### Step 2: Package Mapping
- **Direct mappings**: Many packages have same names (`git`, `tmux`, `curl`)
- **Name changes**: `github-cli` → `gh`, `openssh` → `openssh-client`
- **Alternative sources**: Research if package is available in Ubuntu repos
- **External installation**: For tools not in apt, find official installation method

### Step 3: Adaptation Strategy
```bash
function install_module() {
  # Map Arch packages to Ubuntu equivalents
  local packages=(
    "ubuntu-package-1"
    "ubuntu-package-2"
  )
  install_packages "${packages[@]}"
  
  # Handle special installations
  install_special_tool_if_needed
  
  configure_module
}

function configure_module() {
  # Usually config files can be copied directly
  CONFIG_SOURCE="$MODULES_DIR/module/config/file"
  CONFIG_DEST="$HOME/.config/module"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"
  
  # Add any module-specific setup
}
```

### Step 4: Test and Validate
- Test individual module: `source modules/common.sh && source modules/name/name.sh && install_name`
- Test full installation: `./install.sh`
- Verify idempotency: Run installation multiple times

## Available Tools and Utilities

### In `modules/common.sh`
- `install_packages()`: Installs list of apt packages with retry logic
- `ensure_package_installed()`: Individual package installation with version support
- `symlink_config()`: Safe symlink creation without destructive overwrites
- `install_github_deb()`: Downloads and installs .deb packages from GitHub releases
- `install_starship()`: Starship prompt installation
- `ensure_github_cli_ppa()`: Adds GitHub CLI PPA

### Module-Specific Functions (examples)
- `install_eza()` in shell module: PPA-based installation
- `install_yazi()` in shell module: Snap-based installation
- Shell integration helpers for PATH management

## WSL-Specific Considerations

### PATH Management
WSL environments can have conflicts between Windows and Linux tool versions. Key patterns:

```bash
# Prioritize asdf shims
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

# Verify tool sources
if [[ "$(which node)" != *".asdf/shims"* ]]; then
  echo "Warning: Using Windows Node.js instead of asdf version"
fi
```

### Environment Validation
Include comprehensive environment checking:
```bash
echo "Environment check:"
echo "  Tool version: $(tool --version 2>/dev/null || echo 'unknown')"
echo "  Tool path: $(which tool 2>/dev/null || echo 'not found')"
echo "  Current PATH: $PATH"
```

### Shell Integration
Configure both bash and zsh:
```bash
# Add to both ~/.bashrc and ~/.zshrc
if [ -f ~/.bashrc ]; then
  # Add configuration
fi
if [ -f ~/.zshrc ]; then
  # Add configuration (may differ slightly for zsh)
fi
```

## Development Workflow

### Quick Start for New Claude Instance
1. **Read this file** to understand context
2. **Check current state**: `ls -la modules/` to see available modules
3. **Review install.sh**: See current module order and setup
4. **Test existing setup**: Run `./install.sh` to verify current state
5. **Check arch modules**: `ls -la ../arch/modules/` to see what could be converted

### Adding New Modules
1. **Create directory**: `mkdir -p modules/<name>/config`
2. **Copy config files**: `cp -r ../arch/modules/<name>/config/* modules/<name>/config/`
3. **Create module script**: Adapt `../arch/modules/<name>/<name>.sh` for Ubuntu
4. **Test individually**: Source and test the module function
5. **Add to install.sh**: Add module name to MODULES array
6. **Test full installation**: Run complete installation script

### Testing Commands
```bash
# Test individual module
cd /home/dalton/.dotfiles/wsl_ubuntu
source modules/common.sh
source modules/<name>/<name>.sh
install_<name>

# Test full installation
./install.sh

# Validate script syntax
bash -n install.sh
bash -n modules/<name>/<name>.sh

# Check installation
which <tool>
<tool> --version
```

## File Structure
```
wsl_ubuntu/
├── .env_default          # Environment template (copy to .env)
├── install.sh             # Main installation orchestrator
├── DEVELOPMENT.md         # This file
├── modules/
│   ├── common.sh          # Shared utilities
│   ├── git/
│   │   ├── git.sh         # Git + GitHub CLI setup
│   │   └── config/
│   │       └── .gitconfig # Git configuration
│   ├── tmux/
│   │   ├── tmux.sh        # Tmux + TPM setup
│   │   └── config/
│   │       └── tmux.conf  # Tmux configuration
│   ├── shell/
│   │   ├── shell.sh       # Enhanced shell tools
│   │   └── config/        # Shell configurations
│   ├── asdf/
│   │   └── asdf.sh        # Go-based asdf installation
│   └── claude-code/
│       └── claude-code.sh # WSL-optimized Claude Code
```

## Remaining Work Opportunities

### Modules from Arch Not Yet Converted
- **python**: Python development environment with Poetry
- **neovim**: LazyVim-based editor configuration (complex, many plugins)
- **kitty**: Terminal emulator (may need WSL adaptations)
- **misc**: System utilities and fonts
- **solaar**: Logitech device management (may not be relevant for WSL)

### Areas for Enhancement
- **Error handling**: More robust fallback strategies
- **Version management**: Explicit version pinning options
- **Testing**: Automated validation of module conversions
- **Documentation**: Per-module README files
- **CI/CD**: Automated testing in clean Ubuntu environments

## Common Issues and Solutions

### Package Not Found
- **Research**: Check if package exists in Ubuntu repos: `apt search <package>`
- **Alternative sources**: Look for PPAs, snaps, or GitHub releases
- **Manual installation**: Create custom installation function

### Configuration Conflicts
- **WSL PATH issues**: Ensure Linux tools take priority over Windows versions
- **Permission problems**: Use asdf/user-space installations to avoid sudo
- **Shell integration**: Test in both bash and zsh environments

### Installation Failures
- **Dependency order**: Ensure modules install in correct dependency order
- **Network issues**: Add retry logic and alternative download sources
- **Idempotency**: Always check if tool already installed before attempting installation

## Contact and Continuation

This project is designed to be continued seamlessly. Key context:
- **User**: Dalton Dayton, experienced developer familiar with dotfiles
- **Goal**: Complete, working WSL Ubuntu dotfiles system based on existing Arch setup
- **Approach**: Modular, maintainable, idempotent installation system
- **Priority**: Reliability and WSL compatibility over features

When continuing work, focus on:
1. **Understanding existing patterns** before adding new modules
2. **Testing thoroughly** in WSL environment
3. **Maintaining idempotency** and error handling
4. **Documenting decisions** and updating this file as needed

The architecture is solid and the conversion process is well-established. New modules should follow existing patterns and be thoroughly tested before integration.