#!/usr/bin/bash

# Function to install the module
function install_hyprland() {
  # Define the list of packages required for this module
  local packages=(
    "swayidle"
    "sway-audio-idle-inhibit-git"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_hyprland
}

# Function to configure the module
function configure_hyprland() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/hyprland/hypr/userprefs.conf"
  CONFIG_DEST="$HOME/.config/hypr/userprefs.conf"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # TODO: install HyDE via install script, then run hyde cli?
  # Or maybe just import themes using cli:
  # https://github.com/HyDE-Project/hyde-gallery
}
