#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$MODULES_DIR/common.sh"

# Update package lists
echo "Updating package lists..."
sudo apt update

# List of modules to install
MODULES=(
  "git"
  "shell"
  "asdf"
  "neovim"
)

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

