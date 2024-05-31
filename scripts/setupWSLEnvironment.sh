#!/bin/bash

# Function to check if a package is installed
is_package_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to install a package if it's not already installed
install_package() {
    if is_package_installed "$1"; then
        echo "$1 is already installed."
    else
        echo "Installing $1..."
        sudo apt-get install -y "$1"
    fi
}

# Function to create a symlink if it doesn't already exist
create_symlink() {
    if [ -L "$2" ]; then
        echo "Symlink $2 already exists."
    else
        echo "Creating symlink from $1 to $2..."
        ln -s "$1" "$2"
    fi
}

# Update and upgrade packages
echo "Updating and upgrading packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install packages
install_package git
install_package curl
install_package vim

# Create symlinks
create_symlink "$HOME/.dotfiles/_home/.gitconfig" "$HOME/.gitconfig"

# Add more package installations and symlink creations as needed

echo "Setup complete."

