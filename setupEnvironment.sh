#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
	echo "Linux OS detected"

	echo ""
	echo "#################################"
	echo "##### Enabling Repositories #####"
	echo "#################################"
	echo ""

	# Check and enable RPM Fusion free repository
	if ! dnf repolist | grep -q rpmfusion-free; then
		echo "Enabling RPM Fusion free repository..."
		sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
	else
		echo "RPM Fusion free repository is already enabled."
	fi

	# Check and enable RPM Fusion nonfree repository
	if ! dnf repolist | grep -q rpmfusion-nonfree; then
		echo "Enabling RPM Fusion nonfree repository..."
		sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
	else
		echo "RPM Fusion nonfree repository is already enabled."
	fi

	echo ""
	echo "##########################"
	echo "##### Packages / DNF #####"
	echo "##########################"
	echo ""
	# Declare an array of packages to be checked and installed
	packages=(
		"fish"
		"neovim"
		"solaar"
		"nodejs"
	)

	# Loop through the array and check/install packages
	for package in "${packages[@]}"; do
		# Check if the package is already installed with dnf
		if dnf list installed "$package" >/dev/null 2>&1; then
			echo ">>> $package is already installed"
		else
			echo "Installing $package"
			sudo dnf install "$package" -y
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
		"$HOME/.config/solaar:$HOME/.dotfiles/.config/solaar"
		"$HOME/.config/hypr/hyprland.conf:$HOME/.dotfiles/.config/hypr"
		"$HOME/.config/fish:$HOME/.dotfiles/.config/fish"
		"$HOME/.config/kitty:$HOME/.dotfiles/.config/kitty"
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
	echo "###############"
	echo "#### Fonts ####"
	echo "###############"
	echo ""

	# Check if the .nerd-fonts directory exists
	if [ ! -d "$HOME/.nerd-fonts" ]; then
		echo "Cloning nerd-fonts repository..."
		git clone --depth 1 git@github.com:ryanoasis/nerd-fonts.git "$HOME/.nerd-fonts"
	else
		echo ">>> .nerd-fonts directory already exists"
	fi

	# Declare an array of fonts to be checked and installed
	fonts=(
		"FiraCode"
	)

	# Loop through the array and check/install fonts
	for font in "${fonts[@]}"; do
		# Check if the font is already installed with fc-list
		if ! fc-list | grep -qi "$font"; then
			echo "Installing $font Nerd Font..."
			cd "$HOME/.nerd-fonts"
			./install.sh "$font"
		else
			echo ">>> $font Nerd Font is already installed"
		fi
	done

fi # End of Linux OS detection
