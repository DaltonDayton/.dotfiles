#!/bin/bash

echo ""
echo "============================"
echo "=== Updating Packages... ==="
echo "============================"
echo ""
echo "Updating and upgrading packages..."
yay -Syu --noconfirm

echo ""
echo "=============================="
echo "=== Installing Packages... ==="
echo "=============================="
echo ""

# Define packages on separate lines for easy modification
packages=(
    # Terminal
    vim
    zsh
    exa
    ripgrep
    bat
    tmux
    starship
    # zellij-git

    # Python
    python
    python-pip
    python-pynvim
    python-virtualenv

    # # Neovim dependencies
    ninja
    cmake
    unzip
    curl
    base-devel
    xclip

    # asdf dependencies
    autoconf
    patch
    rust
    openssl
    yaml-cpp
    readline
    zlib
    gmp
    ncurses
    libffi
    gdbm
    db
    util-linux

    # # Other dependencies
    # git
    # go
)

# Loop through the packages and install if not already installed
for pkg in "${packages[@]}"; do
    if ! yay -Qq $pkg &> /dev/null; then
        echo "Installing $pkg..."
        yay -S --noconfirm $pkg
    else
        echo "$pkg is already installed."
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
echo "============================"
echo "=== Installing Zoxide... ==="
echo "============================"
echo ""

# Check if zoxide is installed
if ! command -v zoxide &> /dev/null; then
    echo "Zoxide is not installed. Installing now..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    echo "Zoxide installation completed."
else
    echo "Zoxide is already installed."
fi

echo ""
echo "========================="
echo "=== Installing TPM... ==="
echo "========================="
echo ""
# Clone TPM repository into the default tmux plugins folder
tpm_dir="$HOME/.tmux/plugins/tpm"

if [ ! -d "$tpm_dir" ]; then
    echo "Cloning TPM repository..."
    git clone https://github.com/tmux-plugins/tpm $tpm_dir
else
    echo "TPM is already installed."
fi

echo ""
echo "======================================"
echo "=== Cloning and Building Neovim... ==="
echo "======================================"
echo ""

# Save the current directory
original_dir=$(pwd)

# Define the directory where Neovim will be cloned
nvim_dir="$HOME/neovim"

# Check if the Neovim directory exists
if [ ! -d "$nvim_dir" ]; then
    # Clone the Neovim repository
    echo "Cloning Neovim repository..."
    git clone https://github.com/neovim/neovim.git "$nvim_dir"
else
    # Update the repository
    echo "Updating Neovim repository..."
    git -C "$nvim_dir" pull
fi

# Build Neovim
echo "Building Neovim..."
cd "$nvim_dir"
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Return to the original directory
cd "$original_dir"

echo "Neovim installation or update completed."

echo ""
echo "================================================="
echo "===== Set up asdf for Node.js/Ruby management ==="
echo "================================================="
echo ""

# Directory for asdf installation
asdf_dir="$HOME/.asdf"

# Check if asdf is already installed
if ! command -v asdf &>/dev/null; then
    echo "asdf is not installed. Installing now..."
    # Clone asdf's repository if it doesn't exist
    if [ ! -d "$asdf_dir" ]; then
        git clone https://github.com/asdf-vm/asdf.git "$asdf_dir"
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
        asdf plugin-add $name
    else
        echo "$name plugin is already added."
    fi
}

# Install and set Node.js
install_asdf_plugin "nodejs"
asdf install nodejs latest
asdf global nodejs latest

echo "==="
echo "=== The Ruby section can hang for a while on the initial run."
echo "==="

# Install and set Ruby
install_asdf_plugin "ruby"
asdf install ruby latest
asdf global ruby latest

echo "asdf setup for Node.js and Ruby completed."

echo ""
echo "================================"
echo "=== Cloning and Building fzf ==="
echo "================================"
echo ""

# Define the directory where fzf will be cloned
fzf_dir="$HOME/fzf"

# Check if the fzf directory exists
if [ ! -d "$fzf_dir" ]; then
    # Clone the fzf repository
    echo "Cloning fzf repository..."
    git clone https://github.com/junegunn/fzf.git "$fzf_dir"
else
    # Update the repository
    echo "Updating fzf repository..."
    git -C "$fzf_dir" pull
fi

# Build fzf
echo "Building fzf..."
cd "$fzf_dir"
./install --bin

# Return to the original directory
cd "$original_dir"

echo "fzf installation or update completed."

echo ""
echo "=============================="
echo "=== Setting up Symlinks... ==="
echo "=============================="
echo ""

# Define symlink mappings from source to destination
declare -A links=(
    # Home
    ["$HOME/.dotfiles/_home/.gitconfig"]="$HOME/.gitconfig"
    ["$HOME/.dotfiles/_home/.vimrc"]="$HOME/.vimrc"
    ["$HOME/.dotfiles/_home/.zshrc"]="$HOME/.zshrc"

    # Config
    ["$HOME/.dotfiles/_config/starship.toml"]="$HOME/.config/starship.toml"
    ["$HOME/.dotfiles/_config/nvim"]="$HOME/.config/nvim"
    ["$HOME/.dotfiles/_config/tmux/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
    ["$HOME/.dotfiles/_config/tmux/tmux.reset.conf"]="$HOME/.config/tmux/tmux.reset.conf"
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
echo "======================="
echo "=== Setup Complete. ==="
echo "======================="
echo ""

