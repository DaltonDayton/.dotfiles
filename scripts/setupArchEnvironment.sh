#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo ""
echo "=============================="
echo "=== Updating the system... ==="
echo "=============================="
echo ""
yay -Syu

echo ""
echo "=============================="
echo "=== Installing Packages... ==="
echo "=============================="
echo ""
# Define packages on separate lines for easy modification
packages=(
    # Terminal Applications
    bat

    # Development
    neovim-git

    # Fonts
    ttf-iosevka-nerd

    # TODO: look into setup for adwaita
    adwaita-cursors
    adwaita-icon-theme
)

# Loop through the packages and install if not already installed
for pkg in "${packages[@]}"; do
    if ! yay -Q $pkg &> /dev/null; then
        echo "Installing $pkg..."
        yay -S --noconfirm $pkg
    else
        echo "$pkg is already installed."
    fi
done

echo ""
echo "=============================="
echo "=== Setting up Symlinks... ==="
echo "=============================="
echo ""
# Define symlink mappings from source to destination
declare -A links=(
    # Home
    ["$HOME/.dotfiles/_home/.gitconfig"]="$HOME/.gitconfig"
    ["$HOME/.dotfiles/_home/.zshrc"]="$HOME/.zshrc"

    # Config
    ["$HOME/.dotfiles/_config/nvim"]="$HOME/nvim"
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

# echo ""
# echo "============================================"
# echo "=== Set up asdf for node/ruby management ==="
# echo "============================================"
# echo ""
# # Check if asdf is already installed
# if command -v asdf &>/dev/null; then
#     echo "asdf is already installed"
# else
#     echo "Building asdf from source"
#     # Clone asdf's repository if it doesn't exist
#     if [ ! -d "$HOME/.asdf" ]; then
#         git clone https://github.com/asdf-vm/asdf.git ~/.asdf
#     fi
# fi
# . "$HOME/.asdf/asdf.sh"
# . "$HOME/.asdf/completions/asdf.bash"
#
# # TODO: only do the following if necessary
# asdf plugin add nodejs
# asdf install nodejs latest
# asdf global nodejs latest
#
# asdf plugin add ruby
# asdf install ruby latest
# asdf global ruby latest
#
# echo ""
# echo "==============="
# echo "=== Add TPM ==="
# echo "==============="
# echo ""
# # Check if the TPM directory already exists
# if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
#     echo "Cloning TPM..."
#     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# else
#     echo "TPM is already installed."
# fi


echo ""
echo "============================="
echo "=== Installation Complete ==="
echo "============================="
echo ""
