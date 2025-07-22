#!/usr/bin/bash

function install_fonts() {
  log_info "Installing font packages for better Unicode and programming support"

  # Define the list of font packages for Ubuntu
  local packages=(
    # Noto fonts - Google's comprehensive Unicode font family
    "fonts-noto"             # Base Unicode font family
    "fonts-noto-cjk"         # Chinese, Japanese, Korean character support
    "fonts-noto-color-emoji" # Color emoji support for browsers and applications
    "fonts-noto-extra"       # Additional Noto font variants

    # Programming fonts
    "fonts-cascadia-code" # Microsoft's monospace font for terminals/editors
    "fonts-firacode"      # Monospace font with programming ligatures

    # System/UI fonts
    "fonts-inter"      # Modern sans-serif font optimized for UI/system text
    "fonts-liberation" # Liberation fonts (metric-compatible with Arial, Times, Courier)
    "fonts-roboto"     # Google's modern UI font

    # Additional useful fonts
    "fonts-powerline"    # Powerline symbols for terminal prompts
    "fonts-font-awesome" # Icon font for web/UI elements
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_fonts
}

# Function to configure the module
function configure_fonts() {
  log_info "Updating font cache..."

  # Update font cache to ensure all fonts are available
  if fc-cache -fv; then
    log_success "Font cache updated successfully"
  else
    log_warn "Failed to update font cache, but continuing..."
  fi

  # Note: In WSL, fonts are also available from Windows if WSL is configured properly
  log_info "Note: WSL can also access Windows fonts if configured in /etc/fonts/local.conf"
}
