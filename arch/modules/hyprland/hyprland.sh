#!/usr/bin/bash

# Function to install the module
function install_hyprland() {
  # Define the list of packages required for this module
  local packages=(
    # Core Hyprland packages
    "hyprland"
    "xdg-desktop-portal"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"

    # Essential utilities
    "wl-clipboard"
    "waybar"
    "kitty"
    "polkit-gnome"
    "network-manager-applet"
    "jq" # JSON processor for scripts

    # Enhanced tools and utilities
    "rofi-wayland" # Application launcher (better than wofi)
    "swaync"       # Notification center
    "cliphist"     # Clipboard manager
    "hyprshade"    # Blue light filter and screen effects
    "hypridle"     # Idle daemon
    "hyprlock"     # Screen locker
    "hyprpicker"   # Color picker

    # Screenshot and media tools
    "grim"  # Screenshot utility
    "slurp" # Region selector for screenshots
    "satty" # Screenshot annotation tool
    "swww"  # Wallpaper daemon

    # System utilities
    "playerctl"     # Media player control
    "brightnessctl" # Brightness control
    "pamixer"       # Audio control
    "pavucontrol"   # Audio control GUI

    # NVIDIA specific packages
    "linux-headers"
    "nvidia-dkms"
    "nvidia-utils"
    "lib32-nvidia-utils"

    # ===== Start Review =====
    # "swayidle"
    # "sway-audio-idle-inhibit-git"
    # ===== End Review =====
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_hyprland
}

# Function to configure the module
function configure_hyprland() {
  # set -euo pipefail

  # hypr
  CONFIG_SOURCE="$MODULES_DIR/hyprland/hypr"
  CONFIG_DEST="$HOME/.config/hypr"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # waybar
  CONFIG_SOURCE="$MODULES_DIR/hyprland/waybar"
  CONFIG_DEST="$HOME/.config/waybar"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
