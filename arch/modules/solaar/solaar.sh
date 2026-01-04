#!/usr/bin/bash

# Function to install the module
function install_solaar() {
  # Define the list of packages required for this module
  local packages=(
    "solaar"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_solaar
}

# Function to configure the module
function configure_solaar() {
  CONFIG_SOURCE="$MODULES_DIR/solaar/config"
  CONFIG_DEST="$HOME/.config/solaar"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  local rule_source="$MODULES_DIR/solaar/config/42-logitech-unify-permissions.rules"
  local rule_dest="/etc/udev/rules.d/42-logitech-unify-permissions.rules"

  if [ ! -f "$rule_dest" ]; then
    log_info "Installing udev rule for Logitech devices..."
    sudo cp "$rule_source" "$rule_dest"
    sudo udevadm control --reload-rules
    log_success "udev rule installed"
  else
    log_info "udev rule already exists"
  fi
}
