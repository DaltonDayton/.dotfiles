#!/usr/bin/bash

# Function to install the module
function install_python() {
  # Define the list of packages required for this module
  local packages=(
    # "python"
    # "python-poetry"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  # configure_python
}

# Function to configure the module
# function configure_python() {
# These can be duplicated if multiple iterations need to be symlinked
# CONFIG_SOURCE="$MODULES_DIR/python/config/files"
# CONFIG_DEST="$HOME/.config/python"
#
# symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

# Additional configuration steps can be added here
# For example, setting environment variables, running setup scripts, etc.

# Check if the virtualenvs.in-project is already set to true
# if ! poetry config --list | grep -q 'virtualenvs.in-project = true'; then
#   poetry config virtualenvs.in-project true
#   echo "Virtualenvs are now set to be created in the project directory."
# else
#   echo "Virtualenvs are already set to be created in the project directory."
# fi
# }
