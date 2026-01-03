#!/usr/bin/bash

# Function to install the module
function install_gaming() {
  # Define the list of packages required for this module
  local packages=(
    # Core
    "wine"
    "winetricks"
    # "wine-staging"  # Failing. Conflicts with 'wine'
    "dxvk"
    "vkd3d"
    "lib32-alsa-lib"
    "lib32-pipewire"
    "lib32-libpulse"
    "giflib"
    "lib32-giflib"
    "gnutls"
    "lib32-gnutls"
    "v4l-utils"
    "lib32-v4l-utils"
    "libxcomposite"
    "lib32-libxcomposite"
    "libxinerama"
    "lib32-libxinerama"
    "openal"
    "lib32-openal"
    "libxslt"
    "lib32-libxslt"

    # Vulkan & Performance Utilities
    "vulkan-icd-loader"
    "lib32-vulkan-icd-loader"
    "gamemode"
    "lib32-gamemode"
    "gamescope"
    "mangoh"
    "lib32-mangohud"

    # Launcher Dependencies?
    "curl"
    "cabextract"
    "wget"
    "unzip"
    "zenity"
    "xdg-utils"

    # Fonts
    # "ttf-ms-win11-auto" # Failing
    "ttf-liberation"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"

    # Launcher
    # "lutris"
    # "bottles"
    "steam"
    "faugus-launcher"

    # Communication
    # "discord"

    # WoW
    # "curseforge"
    # "weakauras-companion-bin"
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
