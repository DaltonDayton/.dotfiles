#!/usr/bin/env bash

# Function to install the module
function install_git() {
  # Define the list of packages required for this module
  local packages=(
    "git"
    "gh"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_git
}

# Function to configure the module
function configure_git() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/git/config/.gitconfig"
  CONFIG_DEST="$HOME/.gitconfig"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
