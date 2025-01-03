#!/usr/bin/bash

# Function to install the module
function install_asdf() {
    # Define the list of packages required for this module
    local packages=(
        # asdf dependencies
        "git"
        "curl"

        # Ruby dependencies
        "base-devel"
        "rust"
        "libffi"
        "libyaml"
        "openssl"
        "zlib"

        # Don't think this is needed. Takes so long to build
        # Listed as optional ruby dependency
        # "gcc6"

        # "autoconf"
        # "patch"
        # "rust"
        # "yaml-cpp"
        # "readline"
        # "gmp"
        # "ncurses"
        # "gdbm"
        # "db"
        # "util-linux"
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

    # Check if asdf is already installed
    if ! command -v asdf &>/dev/null; then
        echo "asdf is not installed. Installing now..."
        # Clone asdf's repository if it doesn't exist
        if [ ! -d "$asdf_dir" ]; then
            git clone https://github.com/asdf-vm/asdf.git "$asdf_dir"
        fi
        # Source asdf scripts for this session
        if [ -f "$asdf_dir/asdf.sh" ]; then
            . "$asdf_dir/asdf.sh"
        fi
        if [ -f "$asdf_dir/completions/asdf.bash" ]; then
            . "$asdf_dir/completions/asdf.bash"
        fi
    else
        echo "asdf is already installed."
    fi

    # Function to handle asdf plugin installation
    install_asdf_plugin() {
        local name=$1
        if ! asdf plugin-list | grep -q "^$name\$"; then
            echo "Adding $name plugin..."
            asdf plugin-add $name
        else
            echo "$name plugin is already added."
        fi
    }

    # Install and set Node.js
    install_asdf_plugin "nodejs"
    asdf install nodejs latest
    asdf global nodejs latest

    # Install and set Ruby
    install_asdf_plugin "ruby"
    asdf install ruby latest
    asdf global ruby latest

    echo "asdf setup for Node.js and Ruby completed."
}
