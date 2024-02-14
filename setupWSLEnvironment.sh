#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
    echo "Linux OS detected"

    echo ""
    echo ">>> update"
    echo ""
    sudo apt update && sudo apt upgrade -y

    echo ""
    echo "=========================="
    echo "===== Packages / APT ====="
    echo "=========================="
    echo ""
    # Declare an array of packages to be checked and installed
    packages=(
        "tmux"
        # Neovim dependencies
        "ninja-build"
        "gettext"
        "cmake"
        "make"
        "unzip"
        "curl"
        "python3-venv"
        "ripgrep"
        "gcc"
        # asdf (Ruby) dependencies
        "autoconf"
        "patch"
        "build-essential"
        "rustc"
        "libssl-dev"
        "libyaml-dev"
        "libreadline-dev"
        "zlib1g-dev"
        "libgmp-dev"
        "libncurses5-dev"
        "libffi-dev"
        "libgdbm6"
        "libgdbm-dev"
        "libdb-dev"
        "uuid-dev"
    )

    # Loop through the array and install packages with apt
    for package in "${packages[@]}"; do
        echo "Installing $package"
        sudo apt install "$package" -y
    done

    echo ">>> Autoremoving unnecessary packages"
    sudo apt autoremove -y

    echo ""
    echo "============================="
    echo "Installing Neovim from source"
    echo "============================="
    echo ""
    # Check if Neovim is already installed
    if command -v nvim &>/dev/null; then
        echo "Neovim is already installed"
    else
        echo "Building Neovim from source"
        # Clone Neovim's repository if it doesn't exist
        if [ ! -d "$HOME/neovim" ]; then
            git clone https://github.com/neovim/neovim $HOME/neovim
        fi
        cd $HOME/neovim
        # Build and install Neovim
        make CMAKE_BUILD_TYPE=Release
        sudo make install
        cd $HOME/.dotfiles
    fi

    echo ""
    echo "===================="
    echo "===== Symlinks ====="
    echo "===================="
    echo ""
    # Ensure ~/.config exists
    if [ ! -d "$HOME/.config" ]; then
        echo "Creating $HOME/.config directory"
        mkdir -p "$HOME/.config"
    fi

    # Declare an array of symlinks to be created
    symlinks=(
        "$HOME/.gitconfig:$HOME/.dotfiles/.gitconfig"
        "$HOME/.bashrc:$HOME/.dotfiles/.bashrc_wsl"
        "$HOME/.config/nvim:$HOME/.dotfiles/.config/nvim"
        "$HOME/.config/tmux:$HOME/.dotfiles/.config/tmux"
    )

    # Loop through the array and create symlinks
    for symlink_pair in "${symlinks[@]}"; do
        source="${symlink_pair#*:}"
        destination="${symlink_pair%%:*}"

        # Check if the symlink exists and is not broken
        if [ ! -e "$destination" ]; then
            echo "Creating symlink for $destination"
            ln -s "$source" "$destination"
        else
            echo ">>> $destination symlink already exists"
        fi
    done

    echo ""
    echo "================================================"
    echo "===== Set up asdf for node/ruby management ====="
    echo "================================================ (This can take a few minutes. Especially Ruby.)"
    echo ""
    # Check if asdf is already installed
    if command -v asdf &>/dev/null; then
        echo "asdf is already installed"
    else
        echo "Building asdf from source"
        # Clone asdf's repository if it doesn't exist
        if [ ! -d "$HOME/.asdf" ]; then
            git clone https://github.com/asdf-vm/asdf.git ~/.asdf
        fi
    fi
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"

    asdf plugin add nodejs
    asdf install nodejs latest
    asdf global nodejs latest

    asdf plugin add ruby
    asdf install ruby latest
    asdf global ruby latest

    echo ""
    echo "============================================="
    echo "Installation complete. Restart your terminal."
    echo "============================================="
    echo ""
fi # End of Linux OS detection

