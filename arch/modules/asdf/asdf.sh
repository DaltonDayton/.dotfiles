#!/usr/bin/bash

# Function to install the module
function install_asdf() {
    # Define the list of packages required for this module
    local packages=(
        "asdf-vm"

        # Ruby dependencies
        # "base-devel"
        # "rust"
        # "libffi"
        # "libyaml"
        # "openssl"
        # "zlib"
    )

    # Install the packages using the install_packages function
    install_packages "${packages[@]}"

    # Proceed to configuration
    configure_asdf
}

# Function to configure the module
function configure_asdf() {
    # Additional configuration steps can be added here
    # For example, setting environment variables, running setup scripts, etc.

    # Directory for asdf installation
    asdf_dir="$HOME/.asdf"

    # Function to handle asdf plugin installation
    install_asdf_plugin() {
        local name=$1
        if ! asdf list | grep "^$name\$"; then
            echo "Adding $name plugin..."
            asdf plugin add $name
        else
            echo "$name plugin is already added."
        fi
    }

    # Install and set Node.js
    install_asdf_plugin "nodejs"
    asdf install nodejs latest
    asdf set -u nodejs latest

    # # Install and set Ruby
    # install_asdf_plugin "ruby"
    # asdf install ruby latest
    # asdf global ruby latest
}
