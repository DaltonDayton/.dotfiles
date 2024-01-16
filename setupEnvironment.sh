#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
	echo "Linux OS detected"

	echo ""
	echo "###########################"
	echo "#### Packages / Pacman ####"
	echo "###########################"
	echo ""
	# Declare an array of packages to be checked and installed
	packages=(
		"zsh"
		"zsh-completions"
		"zsh-autosuggestions"
		"fzf"
		"zsh-syntax-highlighting"
		"tere"
	)

	# Loop through the array and check/install packages
	for package in "${packages[@]}"; do
		# Check if the package is already installed with pacman
		if pacman -Qq "$package" >/dev/null 2>&1; then
			echo ">>> $package is already installed"
		else
			echo "Installing $package"
			sudo pacman -S "$package" --noconfirm
		fi
	done

	echo ""
	echo "########################"
	echo "#### Packages / yay ####"
	echo "########################"
	echo ""
	# Declare an array of packages to be checked and installed
	packages=(
		"neovim-git"
		"wl-clipboard"
	)

	# Loop through the array and check/install packages
	for package in "${packages[@]}"; do
		# Check if the package is already installed with yay
		if yay -Q "$package" >/dev/null 2>&1; then
			echo ">>> $package is already installed"
		else
			echo "Installing $package"
			yay -S "$package"
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
		"$HOME/.zshrc:$HOME/.dotfiles/.zshrc"
		"$HOME/.config/nvim:$HOME/.dotfiles/.config/nvim"
		"$HOME/.config/hypr/hyprland.conf:$HOME/.dotfiles/.config/hypr/"
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

fi # End of Linux OS detection
