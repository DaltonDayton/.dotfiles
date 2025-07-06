#!/usr/bin/bash

# Function to install the module
function install_tmux() {
  # Define the list of packages required for this module
  local packages=(
    "tmux"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_tmux
}

# Function to configure the module
function configure_tmux() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/tmux/config/tmux.conf"
  CONFIG_DEST="$HOME/.config/tmux/tmux.conf"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # Install TPM if not already installed
  TPM_DIR="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$TPM_DIR" ]; then
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    echo "TPM is already installed."
  fi
}