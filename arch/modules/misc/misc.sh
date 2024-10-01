#!/usr/bin/bash

# Function to install the module
function install_misc() {
  # Define the list of packages required for this module
  local packages=(
    "bat"
    "less"
    "expressvpn"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # No extra config for misc. If needed, break into its own module.
}
