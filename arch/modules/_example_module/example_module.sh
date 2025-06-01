#!/usr/bin/bash

# Function to install the module
# TODO:
# TIP: `:%s/exampleModule/[module name]/g`
function install_exampleModule() {
  # NOTE: For environment specific packages, see the 'misc' module and the 'install.sh' script
  # NOTE: To declare dependencies, add them to modules/dependencies.sh:
  #       declare_module_dependencies "exampleModule" "git" "misc"

  # Define the list of packages required for this module
  local packages=(
    "package1"       # Replace with actual package names
    "package2=1.2.3" # Example of specifying a specific version
    # Add more packages as needed
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_exampleModule
}

# Function to configure the module
function configure_exampleModule() {
  # TODO:
  # Define the source and destination of configuration files
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/exampleModule/config/files"
  CONFIG_DEST="$HOME/.config/exampleModule"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
