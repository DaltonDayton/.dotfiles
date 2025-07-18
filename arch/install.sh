#!/usr/bin/bash

set -e # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
# shellcheck source=modules/common.sh
source "$MODULES_DIR/common.sh"

# Load environment variables
if [ -f "$SCRIPT_DIR/.env" ]; then
  source "$SCRIPT_DIR/.env"
else
  echo "Error: .env file not found!"
  exit 1
fi

# Ensure 'yay' is installed
ensure_yay_installed

echo "Synchronizing package databases..."
yay -Sy --noconfirm

MODULES=(
  # "git"
  # "shell"
  # "tmux"
  # "asdf"
  # "python"
  # "neovim"
  # "misc"
  # "kitty"
  # "solaar"
  #
  # "hyprland"
)

for module in "${MODULES[@]}"; do
  MODULE_SCRIPT="$MODULES_DIR/${module}/${module}.sh"
  if [ -f "$MODULE_SCRIPT" ]; then
    echo "====================="
    echo "Processing $module..."
    echo "====================="
    # shellcheck disable=SC1090
    source "$MODULE_SCRIPT"
    "install_$module"
  else
    echo "Error: Module $module not found!"
  fi
done
