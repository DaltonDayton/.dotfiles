#!/usr/bin/bash

function install_misc() {
  local packages=(
    # Fonts
    "noto-fonts-emoji"       # adds icons to browser
    "ttf-cascadia-code-nerd" # good for terminals/editors
    "inter-font"             # good for system

    # Browser
    # NOTE: set about:config -> gfx.canvas.accelerated = false
    "firefox-developer-edition"

    # Notes
    # TODO: Move to a module and git clone personal_notes?
    # "obsidian"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
