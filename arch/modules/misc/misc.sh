#!/usr/bin/bash

function install_misc() {
  local packages=(
    # Browser
    # NOTE: set about:config -> gfx.canvas.accelerated = false
    "firefox-developer-edition"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
