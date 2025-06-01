#!/usr/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$MODULES_DIR/common.sh"

# Setup or load environment variables
setup_env_file "$SCRIPT_DIR"

# Ensure 'yay' is installed
ensure_yay_installed

echo "Synchronizing package databases..."
yay -Sy --noconfirm

MODULES=()

# Modules for both Arch and WSL
if [[ "$ENVIRONMENT" == "arch" || "$ENVIRONMENT" == "wsl" ]]; then
  MODULES+=(
    # "git"
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

for module in "${MODULES[@]}"; do
  MODULE_SCRIPT="$MODULES_DIR/${module}/${module}.sh"
  if [ -f "$MODULE_SCRIPT" ]; then
    echo "====================="
    echo "Processing $module..."
    echo "====================="
    source "$MODULE_SCRIPT"
    "install_$module"
  else
    echo "Error: Module $module not found!"
  fi
done

