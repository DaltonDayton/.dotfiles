#!/usr/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

# Parse command line arguments
DRY_RUN=false
SHOW_HELP=false

while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  -h | --help)
    SHOW_HELP=true
    shift
    ;;
  *)
    echo "Unknown option: $1"
    echo "Use --help for usage information"
    exit 1
    ;;
  esac
done

if [[ "$SHOW_HELP" == "true" ]]; then
  echo "Usage: $0 [options]"
  echo
  echo "Options:"
  echo "  --dry-run    Show what would be installed without actually doing it"
  echo "  -h, --help   Show this help message"
  echo
  echo "Examples:"
  echo "  $0                # Normal installation"
  echo "  $0 --dry-run      # Preview what would be installed"
  exit 0
fi

if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 DRY RUN MODE - No actual changes will be made"
  echo "================================================"
  echo
fi

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$MODULES_DIR/common.sh"

# Load module dependencies
source "$MODULES_DIR/dependencies.sh"

# Handle dry-run mode completely separately for safety
if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 SAFE DRY-RUN MODE - Analyzing configuration only"
  echo "=================================================="
  echo

  # Use safe defaults without any file operations
  export ENVIRONMENT="arch"
  export CONTEXT="personal"
  export GIT_NAME="Test User"
  export GIT_EMAIL="test@example.com"

  echo "📝 Using default environment values:"
  echo "   ENVIRONMENT=$ENVIRONMENT"
  echo "   CONTEXT=$CONTEXT"
  echo

  # Skip all actual setup
  echo "🔧 Would ensure yay is installed"
  echo "🔄 Would synchronize package databases (yay -Sy)"
  echo
else
  # Normal execution path
  setup_env_file "$SCRIPT_DIR"
  ensure_yay_installed
  echo "Synchronizing package databases..."
  yay -Sy --noconfirm
fi

MODULES=()

# Modules for both Arch and WSL
if [[ "$ENVIRONMENT" == "arch" || "$ENVIRONMENT" == "wsl" ]]; then
  MODULES+=(
    "git"
    # "shell"
    # "tmux"
    # "asdf"
    # "python"
    # "neovim"
    # "misc"
  )
fi

# Modules exclusive to Arch
if [[ "$ENVIRONMENT" == "arch" ]]; then
  MODULES+=(
    # "hyprland"
    # "kitty"
    # "solaar"
    # "insync"
    # "gaming"
  )
fi

# Modules exclusive to WSL
if [[ "$ENVIRONMENT" == "wsl" ]]; then
  MODULES+=(
    # Nothing exclusive to WSL at the moment
  )
fi

# Resolve dependencies and get installation order
echo "🔍 Resolving module dependencies..."
RESOLVED_MODULES=($(resolve_dependencies "${MODULES[@]}"))

echo "📋 Installation order: ${RESOLVED_MODULES[*]}"
echo

# Install modules in dependency order
if [[ "$DRY_RUN" == "true" ]]; then
  # SAFE: Only analyze module files, never execute them
  for module in "${RESOLVED_MODULES[@]}"; do
    echo "====================="
    echo "Analyzing $module..."
    echo "====================="

    MODULE_SCRIPT="$MODULES_DIR/$module/$module.sh"
    if [[ -f "$MODULE_SCRIPT" ]]; then
      echo "✅ Module script found: $MODULE_SCRIPT"
      echo "📋 Dependencies: ${MODULE_DEPENDENCIES[$module]:-none}"

      # Show what packages would be installed (parse from script)
      if grep -q "local packages=(" "$MODULE_SCRIPT"; then
        echo "📦 Packages that would be installed:"
        grep -A 10 "local packages=(" "$MODULE_SCRIPT" | grep -E '^\s*"[^"]*"' | sed 's/.*"\([^"]*\)".*/     - \1/'
      fi

      # Show what configs would be symlinked
      if grep -q "symlink_config" "$MODULE_SCRIPT"; then
        echo "🔗 Configurations that would be symlinked:"
        grep -B 2 -A 2 "symlink_config" "$MODULE_SCRIPT" | grep -E 'CONFIG_(SOURCE|DEST)=' | sed 's/.*="\([^"]*\)".*/     \1/'
      fi

      echo "✅ Module '$module' analyzed (NOT EXECUTED)"
    else
      echo "❌ Module script not found: $MODULE_SCRIPT"
    fi
    echo
  done
else
  # NORMAL: Actually install modules
  for module in "${RESOLVED_MODULES[@]}"; do
    install_module_with_deps "$module"
  done
fi

echo
if [[ "$DRY_RUN" == "true" ]]; then
  echo "🎉 Dry run completed successfully!"
  echo "💡 To actually install, run: $0"
else
  echo "🎉 All modules processed successfully!"
fi
