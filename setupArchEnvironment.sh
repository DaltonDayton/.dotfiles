#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
    echo "Linux OS detected"

#    echo ""
#    echo ">>> Creating directories"
#    echo ""
#    # Declare an array of directories to be checked and created
#    directories=(
#        "$HOME/Pictures"
#        "$HOME/Pictures/Backgrounds"
#        "$HOME/Pictures/Screenshots"
#    )
#
#    # Loop through the array and create directories if they don't exist
#    for dir in "${directories[@]}"; do
#        if [ ! -d "$dir" ]; then
#            echo "Creating directory: $dir"
#            mkdir -p "$dir"
#        else
#            echo ">>> Directory already exists: $dir"
#        fi
#    done

    echo ""
    echo ">>> update"
    echo ""
    sudo pacman -Syu

    echo ""
    echo "############################"
    echo "##### Packages / Pacman #####"
    echo "############################"
    echo ""
    # Declare an array of packages to be checked and installed
    packages=(
        # Terminal utilities
        "tmux" # Terminal multiplexer for multiple terminal sessions
        "zsh" # Enhanced UNIX shell with improved features and support for plugins
        "zoxide" # Fast directory navigation tool
        "fzf" # Command-line fuzzy finder for finding files and other items

        # Development tools
        "base-devel" # Group containing tools essential for building (compiling and linking)
        "git" # Distributed version control system
        "curl" # Tool for transferring data from or to a server with various protocols
        "gnupg" # Encryption software that provides secure communication and data storage

        # Build systems
        "ninja" # Small build system with a focus on speed, designed for speed
        "cmake" # Cross-platform family of tools designed to build, test, and package software
        "autoconf" # Generates scripts to automatically configure software source code packages
        "automake" # Generates Makefile.in files compliant with the GNU Coding Standards
        "bison" # General-purpose parser generator that converts an annotated context-free grammar into a C program

        # Libraries for development
        "openssl" # Toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols
        "libyaml" # Library for parsing and emitting data in YAML format
        "readline" # Library providing a set of functions for use by applications that allow users to edit command lines
        "zlib" # Compression library used for data compression
        "gmp" # Free library for arbitrary precision arithmetic
        "ncurses" # Libraries for building text-based user interfaces
        "libffi" # Provides a portable, high level programming interface to various calling conventions
        "gdbm" # Library for GNU database manager, provides database functions
        "db" # Oracle Berkeley DB, provides embedded database support
        "util-linux" # Miscellaneous system utilities for Linux

        # Programming languages and compilers
        "rust" # Systems programming language focused on safety and concurrency

        # Fonts
        "ttf-font-awesome"
        "noto-fonts-emoji"

        "insync"
    )


    # Loop through the array and check/install packages
    for package in "${packages[@]}"; do
        # Check if the package is already installed with pacman
        if pacman -Qi "$package" &>/dev/null; then
            echo ">>> $package is already installed"
        else
            echo "Installing $package"
            sudo pacman -S "$package" --noconfirm
        fi
    done

    echo ""
    echo "##################"
    echo "#### Symlinks ####"
    echo "##################"
    echo ""

    # Declare an array of symlinks to be created
    symlinks=(
        "$HOME/.gitconfig:$HOME/.dotfiles/.gitconfig"
        "$HOME/.bashrc:$HOME/.dotfiles/.bashrc"
        "$HOME/.zshrc:$HOME/.dotfiles/.zshrc"
        "$HOME/.vimrc:$HOME/.dotfiles/.vimrc"
        "$HOME/.config/nvim:$HOME/.dotfiles/.config/nvim"
        "$HOME/.config/tmux:$HOME/.dotfiles/.config/tmux"
        "$HOME/.config/kitty/kitty.conf:$HOME/.dotfiles/.config/kitty/kitty.conf"
        "$HOME/.config/hypr/hyprland.conf:$HOME/.dotfiles/.config/hypr/hyprland.conf"
        "$HOME/.config/hypr/keybindings.conf:$HOME/.dotfiles/.config/hypr/keybindings.conf"
        "$HOME/.config/hypr/monitors.conf:$HOME/.dotfiles/.config/hypr/monitors.conf"
    )

    # Loop through the array and create symlinks
    for symlink_pair in "${symlinks[@]}"; do
        source="${symlink_pair#*:}"
        destination="${symlink_pair%%:*}"

        # Check if the destination exists and is not a symlink
        if [ -e "$destination" ] && [ ! -L "$destination" ]; then
            echo "Non-symlink file found at $destination. Removing and creating symlink."
            rm "$destination"
            ln -s "$source" "$destination"
        elif [ -L "$destination" ]; then
            echo ">>> Symlink already exists at $destination. Skipping."
        else
            echo "Creating symlink for $destination"
            ln -s "$source" "$destination"
        fi
    done

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
    echo "================================================"
    echo "===== Set up asdf for node/ruby management ====="
    echo "================================================"
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


#    echo ""
#    echo "###############"
#    echo "#### Fonts ####"
#    echo "###############"
#    echo ""
#
#    # Check if the .nerd-fonts directory exists
#    if [ ! -d "$HOME/.nerd-fonts" ]; then
#        echo "Cloning nerd-fonts repository..."
#        git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git "$HOME/.nerd-fonts"
#    else
#        echo ">>> .nerd-fonts directory already exists"
#    fi
#
#    # Declare an array of fonts to be checked and installed
#    fonts=(
#        "FiraCode"
#    )
#
#    # Loop through the array and check/install fonts
#    for font in "${fonts[@]}"; do
#        # Check if the font is already installed with fc-list
#        if ! fc-list | grep -qi "$font"; then
#            echo "Installing $font Nerd Font..."
#            cd "$HOME/.nerd-fonts"
#            ./install.sh "$font"
#        else
#            echo ">>> $font Nerd Font is already installed"
#        fi
#    done

fi # End of Linux OS detection

