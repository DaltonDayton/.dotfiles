#!/usr/bin/bash

# Function to install the module
function install_hyprland() {
  # Define the list of packages required for this module
  local packages=(
    # Nvidia
    nvidia-dkms
    nvidia-open-dkms
    linux-zen-headers
    nvidia-utils
    lib32-nvidia-utils
    egl-wayland

    # Authentication Agent
    hyprpolkitagent

    # Qt Wayland Support
    qt5-wayland qt6-wayland

    # Fonts
    ttf-font-awesome
    otf-font-awesome
    noto-fonts
    noto-fonts-emoji

    # Utilities
    cliphist
    waybar
    hyprpaper
    hyprlauncher
    hypridle
    hyprlock
    pavucontrol
    pipewire-pulse
    jq # JSON processor for scripts
    btop
    spotify

    # File Extension Discovery
    xdg-utils
    desktop-file-utils
    shared-mime-info
    archlinux-xdg-menu
    # Also ran this, but idk if it's needed: `sudo update-mime-database /usr/share/mime`

    # Bluetooth utilities
    bluez       # Bluetooth protocol stack
    bluez-utils # Bluetooth utilities
    blueman     # Bluetooth manager GUI

    # Screenshot Utilities
    grim
    grimblast-git
    hyprpicker
    slurp
    satty
    wl-clipboard

    # gifs / mp4
    wf-recorder

    # OCR
    tesseract
    tesseract-data-eng

    # # Essential utilities
    # "network-manager-applet"

    # # Enhanced tools and utilities
    # "rofi-wayland" # Application launcher (better than wofi)
    # "swaync"       # Notification center
    # "cliphist"     # Clipboard manager
    # "hyprshade"    # Blue light filter and screen effects
    # "hypridle"     # Idle daemon
    # "hyprlock"     # Screen locker
    # "hyprpicker"   # Color picker
    #
    # # Screenshot and media tools
    # "grim"  # Screenshot utility
    # "slurp" # Region selector for screenshots
    # "satty" # Screenshot annotation tool
    # "swww"  # Wallpaper daemon
    #
    # # System utilities
    # "playerctl"     # Media player control
    # "brightnessctl" # Brightness control
    # "pamixer"       # Audio control
    # "pavucontrol"   # Audio control GUI
    # "btop"          # Enhanced system monitor

    # # Themes and appearance
    # "catppuccin-gtk-theme-mocha" # GTK theme
    # "nwg-look"                   # Run nwg-look to configure themes
    # "hyprcursor"
    # "bibata-cursor-theme-bin"
    #
    # # "swayidle"
    # # "sway-audio-idle-inhibit-git"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_hyprland
}

# Function to configure the module
function configure_hyprland() {
  # set -euo pipefail

  # TODO: dunst config

  # hypr
  CONFIG_SOURCE="$MODULES_DIR/hyprland/hypr"
  CONFIG_DEST="$HOME/.config/"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # waybar
  CONFIG_SOURCE="$MODULES_DIR/hyprland/waybar"
  CONFIG_DEST="$HOME/.config/"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # wallpapers
  CONFIG_SOURCE="$MODULES_DIR/hyprland/wallpapers"
  CONFIG_DEST="$HOME/.config/wallpapers"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Enable and start bluetooth service if not already enabled/running
  if ! systemctl is-enabled bluetooth.service >/dev/null 2>&1; then
    echo "Enabling bluetooth service..."
    sudo systemctl enable bluetooth.service
  fi

  if ! systemctl is-active bluetooth.service >/dev/null 2>&1; then
    echo "Starting bluetooth service..."
    sudo systemctl start bluetooth.service
  fi

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # May not be needed with hyprland.conf update and bibata-cursor-theme-bin
  # # Copy Bibata cursor themes from local dotfiles
  # local bibata_source="$MODULES_DIR/hyprland/Bibata-Cursors"
  # local icons_dest="$HOME/.local/share/icons"
  #
  # # Ensure icons directory exists
  # mkdir -p "$icons_dest"
  #
  # # Copy each Bibata theme
  # for theme in "Bibata-Modern-Amber" "Bibata-Modern-Classic" "Bibata-Modern-Ice"; do
  #   if [ -d "$bibata_source/$theme" ]; then
  #     if [ ! -d "$icons_dest/$theme" ]; then
  #       echo "Installing $theme cursor theme..."
  #       cp -r "$bibata_source/$theme" "$icons_dest/"
  #     else
  #       echo "$theme cursor theme is already installed."
  #     fi
  #   else
  #     echo "Warning: $theme not found in $bibata_source"
  #   fi
  # done

}
