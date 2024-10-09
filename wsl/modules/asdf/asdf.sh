#!/usr/bin/env bash

# Function to install the module
function install_asdf() {
    # Define the list of packages required for this module
    local packages=(
        # asdf dependencies
        "git"
        "curl"

        # Node.js dependencies
        "dirmngr"
        "gpg"

        # Ruby dependencies
        "autoconf"
        "bison"
        "build-essential"
        "libssl-dev"
        "libyaml-dev"
        "libreadline6-dev"
        "zlib1g-dev"
        "libncurses5-dev"
        "libffi-dev"
        "libgdbm6"
        "libgdbm-dev"
        "libdb-dev"
    )

    # Install the packages using the install_packages function
    install_packages "${packages[@]}"

    # Proceed to configuration
    configure_asdf
}

# Function to configure the module
function configure_asdf() {
    # Directory for asdf installation
    asdf_dir="$HOME/.asdf"

    # Check if asdf is already installed
    if ! command -v asdf &>/dev/null; then
        echo "asdf is not installed. Installing now..."
        # Clone asdf's repository if it doesn't exist
        if [ ! -d "$asdf_dir" ]; then
            git clone https://github.com/asdf-vm/asdf.git "$asdf_dir"
        fi
        # Add asdf to shell configuration
        SHELL_CONFIG_FILE="$HOME/.bashrc"  # Change to .zshrc if you use zsh
        if ! grep -q 'source \$HOME/.asdf/asdf.sh' "$SHELL_CONFIG_FILE"; then
            echo '. "$HOME/.asdf/asdf.sh"' >> "$SHELL_CONFIG_FILE"
            echo "Added asdf initialization to $SHELL_CONFIG_FILE"
        fi
        if ! grep -q 'source \$HOME/.asdf/completions/asdf.bash' "$SHELL_CONFIG_FILE"; then
            echo '. "$HOME/.asdf/completions/asdf.bash"' >> "$SHELL_CONFIG_FILE"
            echo "Added asdf completions to $SHELL_CONFIG_FILE"
        fi
        # Source asdf scripts for this session
        . "$asdf_dir/asdf.sh"
        . "$asdf_dir/completions/asdf.bash"
    else
        echo "asdf is already installed."
    fi

    # Function to handle asdf plugin installation
    install_asdf_plugin() {
        local name=$1
        if ! asdf plugin-list | grep -q "^$name\$"; then
            echo "Adding $name plugin..."
            asdf plugin-add "$name"
        else
            echo "$name plugin is already added."
        fi
    }

    # Install and set Node.js
    install_asdf_plugin "nodejs"
    # Import Node.js release team's OpenPGP keys to verify downloads
    # bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

    asdf install nodejs latest
    asdf global nodejs latest

    # Install and set Ruby
    install_asdf_plugin "ruby"
    asdf install ruby latest
    asdf global ruby latest

    echo "asdf setup for Node.js and Ruby completed."
}

