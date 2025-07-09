#!/usr/bin/bash

# Function to install eza via its PPA
function install_eza() {
  if command -v eza &>/dev/null; then
    echo "eza is already installed."
    return 0
  fi

  echo "Installing eza from PPA..."
  sudo apt update
  sudo apt install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
  echo "eza installed successfully."
}

# Function to install rust and cargo
function install_rust() {
  if command -v cargo &>/dev/null; then
    echo "Rust/cargo is already installed."
    return 0
  fi

  echo "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Source cargo environment for current session
  source "$HOME/.cargo/env"

  echo "Rust installed successfully."
}

# Function to install yazi via cargo
function install_yazi() {
  # Ensure rust is installed first
  install_rust

  # Source cargo environment to ensure cargo is available
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi

  if command -v yazi &>/dev/null; then
    echo "yazi is already installed."
    return 0
  fi

  echo "Installing yazi via cargo..."
  cargo install yazi-fm yazi-cli
  echo "yazi installed successfully."
}

# Function to install the module
function install_shell() {
  # Install packages available via apt
  local apt_packages=(
    "zsh"
    "bat"
    "less"
    "fzf"
    "curl"            # Required for GitHub installations
    "wget"            # Required for eza installation
    "gpg"             # Required for eza PPA
    "build-essential" # Required for cargo compilation
  )

  install_packages "${apt_packages[@]}"

  # Install packages from custom sources
  install_starship
  install_eza
  install_github_deb "ajeetdsouza/zoxide" "zoxide" "zoxide.*amd64.deb"
  install_yazi

  # Proceed to configuration
  configure_shell
}

# Function to configure the module
function configure_shell() {
  CONFIG_SOURCE="$MODULES_DIR/shell/config/.zshrc"
  CONFIG_DEST="$HOME/.zshrc"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  CONFIG_SOURCE="$MODULES_DIR/shell/config/starship.toml"
  CONFIG_DEST="$HOME/.config/starship.toml"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  CONFIG_SOURCE="$MODULES_DIR/shell/config/yazi"
  CONFIG_DEST="$HOME/.config/yazi"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  # Source cargo environment to ensure ya is available
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi

  # Update yazi packages if ya is available
  if command -v ya &>/dev/null; then
    echo "Updating yazi packages..."
    ya pkg upgrade
  else
    echo "Warning: ya command not found. Yazi packages will not be updated."
  fi

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # Set zsh as the default shell
  local zsh_path=$(which zsh)
  if [ -z "$zsh_path" ]; then
    echo "Error: zsh not found in PATH. Please ensure zsh is installed."
    return 1
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    echo "Setting zsh as the default shell ($zsh_path)..."
    sudo chsh -s "$zsh_path" "$USER"
  else
    echo "zsh is already the default shell."
  fi
}
