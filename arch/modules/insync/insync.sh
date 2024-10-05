#!/usr/bin/bash

# Function to install the module
function install_insync() {
  # Define the list of packages required for this module
  local packages=(
    "insync"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_insync
}

# Function to configure the module
function configure_insync() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$HOME/Insync/daltondayton1@gmail.com/Google Drive/Development"
  CONFIG_DEST="$HOME/Development/Drive"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
