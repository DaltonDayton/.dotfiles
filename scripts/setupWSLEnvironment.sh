#!/bin/bash

echo ""
echo "============================"
echo "=== Updating Packages... ==="
echo "============================"
echo ""
echo "Updating and upgrading packages..."
sudo apt-get update && sudo apt-get upgrade -y

echo ""
echo "=============================="
echo "=== Installing Packages... ==="
echo "=============================="
echo ""
# Define packages on separate lines for easy modification
packages=(
	vim
	zsh
	eza
)

# Loop through the packages and install if not already installed
for pkg in "${packages[@]}"; do
    if ! dpkg -s $pkg &> /dev/null; then
        echo "Installing $pkg..."
        sudo apt-get install -y $pkg
    else
        echo "$pkg is already installed."
    fi
done

echo "Installing starship"
if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship is already installed."
fi

echo ""
echo "=============================="
echo "=== Setting up Symlinks... ==="
echo "=============================="
echo ""
# Define symlink mappings from source to destination
declare -A links=(
    ["$HOME/.dotfiles/_home/.gitconfig"]="$HOME/.gitconfig"
    ["$HOME/.dotfiles/_config/starship.toml"]="$HOME/.config/starship.toml"
)

# Create symlinks
for src in "${!links[@]}"; do
    dest="${links[$src]}"

    # Check if the destination directory exists; if not, create it
    dest_dir=$(dirname "$dest")
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
        echo "Created directory $dest_dir"
    fi

    # Create the symlink if it does not exist or update if incorrect
    if [ ! -L "$dest" ] || [ "$(readlink "$dest")" != "$src" ]; then
        ln -sfn "$src" "$dest"
        echo "Created or updated symlink from $src to $dest"
    else
        echo "Symlink from $src to $dest already correctly set."
    fi
done

echo ""
echo "============================="
echo "=== Setting Default Shell ==="
echo "============================="
echo ""
# Set zsh as the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s /bin/zsh
else
    echo "zsh is already the default shell."
fi

echo ""
echo "======================="
echo "=== Setup Complete. ==="
echo "======================="
echo ""

