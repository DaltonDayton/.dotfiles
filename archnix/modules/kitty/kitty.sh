#!/usr/bin/bash

# Function to install the module
function install_kitty() {
  # Define the list of packages required for this module
  local packages=(
    "kitty"
  )

  # Install the packages using ensure_package_installed function
  for package_entry in "${packages[@]}"; do
    if [[ "$package_entry" == *"="* ]]; then
      # If a specific version is specified
      IFS='=' read -r pkg ver <<< "$package_entry"
      ensure_package_installed "$pkg" "$ver"
    else
      # Install the latest version
      ensure_package_installed "$package_entry"
    fi
  done

  # Proceed to configuration
  configure_kitty
}

# Function to configure the module
function configure_kitty() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/kitty/config"
  CONFIG_DEST="$HOME/.config/kitty"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}

