#!/usr/bin/bash

function install_fonts() {
  # Define the list of packages required for this module
  local packages=(
    # Fonts - Essential typography for system and development
    "noto-fonts"             # Base Unicode font family
    "noto-fonts-cjk"         # Chinese, Japanese, Korean character support
    "noto-fonts-emoji"       # Emoji support for browsers and applications
    "noto-fonts-extra"       # Additional Noto font variants
    "ttf-cascadia-code-nerd" # Microsoft's monospace font with Nerd Font icons for terminals/editors
    "inter-font"             # Modern sans-serif font optimized for UI/system text
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_fonts
}

# Function to configure the module
function configure_fonts() {
  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  fc-cache -fv
}
