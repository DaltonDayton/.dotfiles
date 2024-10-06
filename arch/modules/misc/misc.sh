#!/usr/bin/bash

# Function to install the module
function install_misc() {
  # Define the list of packages required for this module
  local packages=(
    # Browser
    # NOTE: set about:config -> gfx.canvas.accelerated = false
    "firefox-developer-edition"

    # VPN
    "expressvpn"

    # Fonts
    "ttf-symbola"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "ttf-firacode-nerd"
    "ttf-font-awesome"

    # Notes
    # TODO: Move to a module and git clone personal_notes?
    "obsidian"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
