#!/usr/bin/bash

# Function to install the module
function install_misc() {
  # Define the list of packages required for this module
  local packages=()

  if [[ "$ENVIRONMENT" == "arch" || "$ENVIRONMENT" == "wsl" ]]; then
    packages+=(
      # Fonts
      "noto-fonts-emoji" # adds icons to browser
      "ttf-cascadia-code-nerd"
      "inter-font"
    )
  fi

  if [[ "$ENVIRONMENT" == "arch" ]]; then
    packages+=(
      # Browser
      # NOTE: set about:config -> gfx.canvas.accelerated = false
      "firefox-developer-edition"

      # Notes
      # TODO: Move to a module and git clone personal_notes?
      # "obsidian"
    )
  fi

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
