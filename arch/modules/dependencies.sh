#!/usr/bin/bash

# Module dependency declarations
# This file defines the dependency relationships between modules
# Dependencies are resolved automatically during installation

# Core modules (no dependencies)
# - git: Base requirement for many modules
# - misc: Provides fonts and basic utilities

# Shell and terminal modules
declare_module_dependencies "shell" "git"           # git needed for zinit installation
declare_module_dependencies "tmux" "git"            # git needed for TPM (Tmux Plugin Manager)

# Development tools
declare_module_dependencies "neovim" "git"          # git needed for lazy.nvim and plugins
declare_module_dependencies "asdf" "git"            # git needed for plugin management
declare_module_dependencies "python" "asdf"         # asdf can manage Python versions

# Desktop environment (Arch-specific)
declare_module_dependencies "hyprland" "git"        # git needed for HyDE repository
declare_module_dependencies "kitty" "misc"          # misc provides fonts for terminal

# Utility modules
declare_module_dependencies "solaar" "misc"         # misc provides fonts for GUI
declare_module_dependencies "insync" "misc"         # misc provides fonts for GUI

# Gaming (depends on misc for fonts in gaming UIs)
declare_module_dependencies "gaming" "misc"

# Note: Dependencies are automatically resolved in the correct order
# Circular dependencies are detected and will cause an error
# Missing dependencies will show warnings but won't stop installation
