#!/usr/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$MODULES_DIR/common.sh"

# Ensure 'yay' is installed
ensure_yay_installed

# Perform a system update once
echo "Updating system..."
yay -Syu --noconfirm

# List of modules to install
MODULES=(
  "git"
  "hyprland"
  "zsh"
  "neovim"
  "kitty"
  "solaar"
)

for module in "${MODULES[@]}"; do
  MODULE_SCRIPT="$MODULES_DIR/${module}/${module}.sh"
  if [ -f "$MODULE_SCRIPT" ]; then
    echo "Processing $module..."
    source "$MODULE_SCRIPT"
    "install_$module"
  else
    echo "Error: Module $module not found!"
  fi
done

# Install all missing packages at once
if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
  echo "Installing missing packages..."
  yay -S --needed --noconfirm "${MISSING_PACKAGES[@]}"
else
  echo "All packages are already installed and up to date."
fi

