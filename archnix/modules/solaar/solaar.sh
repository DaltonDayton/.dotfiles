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

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # Ensure the 'uinput' group exists
  if ! getent group uinput > /dev/null; then
    echo "Creating 'uinput' group..."
    sudo groupadd uinput
  fi

  # Add the user to the 'uinput' group if not already a member
  if id -nG "$USER" | grep -qw "uinput"; then
    echo "User $USER is already in the 'uinput' group."
  else
    echo "Adding user $USER to the 'uinput' group..."
    sudo usermod -aG uinput "$USER"
    echo "You may need to log out and log back in for the group change to take effect."
  fi

  # Create udev rule for /dev/uinput
  if [ ! -f /etc/udev/rules.d/99-uinput.rules ]; then
    echo "Creating udev rule for /dev/uinput..."
    sudo tee /etc/udev/rules.d/99-uinput.rules > /dev/null <<EOF
KERNEL=="uinput", SUBSYSTEM=="misc", MODE="0660", GROUP="uinput"
EOF
    sudo udevadm control --reload-rules
    sudo udevadm trigger
  else
    echo "udev rule for /dev/uinput already exists."
  fi

  # Load uinput module
  if ! lsmod | grep -q "^uinput"; then
    echo "Loading uinput module..."
    sudo modprobe uinput
    # Make it load on boot
    echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf > /dev/null
  else
    echo "uinput module is already loaded."
  fi
}

