#!/usr/bin/env bash

function install_neovim() {
  # Define the list of packages required
  local packages=(
    "git"
    "curl"
    "ripgrep"
    "python3-pip"
    "python3-pynvim"
    "xclip"
    "unzip"
    "tar"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Install Neovim from the pre-built binary
  install_neovim_prebuilt

  # Proceed to configuration
  configure_neovim
}

# Function to install Neovim from the pre-built binary
function install_neovim_prebuilt() {
  # Desired version
  desired_version="v0.10.2"

  # Check if Neovim is already installed and get its version
  if command -v nvim &>/dev/null; then
    installed_version=$(nvim --version | head -n1 | awk '{print $2}')
    if [ "$installed_version" == "${desired_version#v}" ]; then
      echo "Neovim ${desired_version#v} is already installed."
      return
    fi
  fi

  echo "Installing Neovim ${desired_version#v} from pre-built binary..."

  # Download the pre-built binary
  curl -LO https://github.com/neovim/neovim/releases/download/${desired_version}/nvim-linux64.tar.gz

  # Extract and install
  tar xzf nvim-linux64.tar.gz
  sudo mv nvim-linux64 /usr/local/neovim

  # Create a symlink
  sudo ln -sfn /usr/local/neovim/bin/nvim /usr/local/bin/nvim

  # Clean up
  rm nvim-linux64.tar.gz

  # Verify installation
  if command -v nvim &>/dev/null; then
    echo "Neovim ${desired_version#v} installed successfully."
  else
    echo "Failed to install Neovim."
  fi
}

# Function to configure the module
function configure_neovim() {
  # Symlink Neovim configuration
  CONFIG_SOURCE="$MODULES_DIR/neovim/nvim"
  CONFIG_DEST="$HOME/.config/nvim"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Install LazyGit
  install_lazygit
}

# Function to install LazyGit
function install_lazygit() {
  if ! command -v lazygit &>/dev/null; then
    echo "Installing LazyGit..."

    # Fetch the latest version number
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    LAZYGIT_TAR="lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
    LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/${LAZYGIT_TAR}"

    # Download and extract
    curl -Lo "$LAZYGIT_TAR" "$LAZYGIT_URL"
    tar xf "$LAZYGIT_TAR" lazygit

    # Install
    sudo install lazygit /usr/local/bin

    # Clean up
    rm lazygit "$LAZYGIT_TAR"

    echo "LazyGit installed successfully."
  else
    echo "LazyGit is already installed."
  fi
}

