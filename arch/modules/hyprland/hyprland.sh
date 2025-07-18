#!/usr/bin/bash

# Function to install the module
function install_hyprland() {
  # Define the list of packages required for this module
  local packages=(
    "hyprland"
    "xdg-desktop-portal"
    "xdg-desktop-portal-hyprland"
    "wl-clipboard"
    "waybar"
    "wofi"
    "kitty"
    "dunst"
    "polkit-gnome"
    "linux-headers"
    "nvidia-dkms"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "network-manager-applet"
    # "swayidle"
    # "sway-audio-idle-inhibit-git"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_hyprland
}

# Function to configure the module
function configure_hyprland() {
  # set -euo pipefail

  # Symlink custom userprefs.conf
  CONFIG_SOURCE="$MODULES_DIR/hyprland/hypr"
  CONFIG_DEST="$HOME/.config/hypr"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
