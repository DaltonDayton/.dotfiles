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
        "neovim"
        "tmux"
        "solaar"
#        "swaybg"
#        "grim"
#        "slurp"
#        "vlc"
#        "ffmpeg"
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
        "$HOME/.config/nvim:$HOME/.dotfiles/.config/nvim"
        "$HOME/.config/tmux:$HOME/.dotfiles/.config/tmux"
        "$HOME/.config/solaar:$HOME/.dotfiles/.config/solaar"
#        "$HOME/.config/hypr:$HOME/.dotfiles/.config/hypr"
#        "$HOME/.config/kitty:$HOME/.dotfiles/.config/kitty"
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

    # TODO: https://asdf-vm.com/guide/getting-started.html

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

