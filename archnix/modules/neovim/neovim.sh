#!/usr/bin/bash

# Function to install the module
function install_neovim() {
  # Define the list of packages required for this module
  local packages=(
    "neovim"
    "lazygit"
    "ripgrep"
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
  configure_neovim
}

# Function to configure the module
function configure_neovim() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/neovim/nvim"
  CONFIG_DEST="$HOME/.config/nvim"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}

