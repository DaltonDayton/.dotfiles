#!/usr/bin/bash

# Function to install the module
function install_misc() {
  # Define the list of packages required for this module
  local packages=(
    # VPN
    "expressvpn"

    # Fonts
    "ttf-symbola"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-firacode-nerd"
    "ttf-font-awesome"

    # Notes
    "obsidian"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
