#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
	echo "Linux OS detected"

	echo ""
	echo "##################"
	echo "#### Packages ####"
	echo "##################"
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
		~/.gitconfig:~/.dotfiles/.gitconfig
		~/.bashrc.d/:~/.dotfiles/.bashrc.d/
		~/.config/nvim:~/.dotfiles/.config/nvim
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
