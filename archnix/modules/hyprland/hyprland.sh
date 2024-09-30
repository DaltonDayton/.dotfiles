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
  set -euo pipefail

  HYDE_DIR="$HOME/HyDE"
  HYDE_REPO="https://github.com/prasanthrangan/hyprdots"

  # Clone or update HyDE repository
  if [ -d "$HYDE_DIR" ]; then
    echo "HyDE directory already exists. Updating repository..."
    git -C "$HYDE_DIR" pull
  else
    git clone --depth 1 "$HYDE_REPO" "$HYDE_DIR"
  fi

  # Run HyDE install script
  pushd "$HYDE_DIR/Scripts"
  if ./install.sh; then
    echo "HyDE installed successfully."
  else
    echo "HyDE installation failed."
    popd
    exit 1
  fi
  popd

  # Symlink custom userprefs.conf
  CONFIG_SOURCE="$MODULES_DIR/hyprland/hypr/userprefs.conf"
  CONFIG_DEST="$HOME/.config/hypr/userprefs.conf"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
