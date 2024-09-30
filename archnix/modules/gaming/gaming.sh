#!/usr/bin/bash

# Function to install the module
function install_gaming() {
  # Define the list of packages required for this module
  local packages=(
    # Core
    "wine"
    "winetricks"

    # Launcher
    "lutris"
    "steam"

    # Communication
    "discord-canary"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  # configure_gaming
}

# Function to configure the module
# function configure_gaming() {

# # TODO:
# # Define the source and destination of configuration files
# # These can be duplicated if multiple iterations need to be symlinked

# CONFIG_SOURCE="$MODULES_DIR/gaming/config/files"
# CONFIG_DEST="$HOME/.config/gaming"

# symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

# Additional configuration steps can be added here
# For example, setting environment variables, running setup scripts, etc.
# }
