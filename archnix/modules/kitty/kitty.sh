#!/usr/bin/bash

# Function to install the module
function install_kitty() {
  # Define the list of packages required for this module
  local packages=(
    "kitty"
    "ttf-firacode-nerd"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_kitty
}

# Function to configure the module
function configure_kitty() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/kitty/config/kitty.conf"
  CONFIG_DEST="$HOME/.config/kitty/kitty.conf"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
