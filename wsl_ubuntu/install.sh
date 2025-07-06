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

# Ensure apt is updated
ensure_apt_updated

echo "Starting WSL Ubuntu dotfiles installation..."

MODULES=(
  "git"
  "tmux"
  "shell"
  "asdf"
  "claude-code"
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
    echo ""
    
    # Note: The shell module may switch to zsh and continue with remaining modules
    # If this happens, execution will not return here - it continues in the zsh environment
  else
    echo "Warning: Module script $MODULE_SCRIPT not found!"
  fi
done

echo "====================="
echo "Installation complete!"
echo "====================="
