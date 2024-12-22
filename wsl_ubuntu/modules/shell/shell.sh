#!/usr/bin/env bash

# Function to install the module
function install_shell() {
  # Define the list of packages required for this module
  local packages=(
    "zsh"
    "bat"
    "less"
    "curl"
    "git"
    "gpg"
    "build-essential"  # Includes gcc, make, etc.
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Install starship
  install_fzf

  # Install starship
  install_starship

  # Install eza
  install_eza

  # Install zoxide
  install_zoxide

  # Install yazi
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

  # Set zsh as the default shell
  if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s /bin/zsh
  else
    echo "zsh is the default shell."
  fi
}

# Function to install fzf
function install_fzf() {
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
}

# Function to install starship
function install_starship() {
  if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  else
    echo "starship is already installed."
  fi
}

# Function to install eza
function install_eza() {
  if ! command -v eza &> /dev/null; then
    echo "Installing eza..."

    # Add the GPG key
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg

    # Add the repository
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list

    # Set permissions
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

    # Update package lists
    sudo apt update

    # Install eza
    sudo apt install -y eza

  else
    echo "eza is already installed."
  fi
}

# Function to install zoxide
function install_zoxide() {
  if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."

    # Run the recommended install script
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

  else
    echo "zoxide is already installed."
  fi
}

# Function to install yazi
function install_yazi() {
  if ! command -v yazi &> /dev/null; then
    echo "Installing yazi..."

    # Install dependencies
    echo "Installing build-essential and other dependencies..."
    sudo apt-get update
    sudo apt-get install -y build-essential

    # Install Rust via rustup if not already installed
    if ! command -v rustup &> /dev/null; then
      echo "Installing Rust via rustup..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      source "$HOME/.cargo/env"
    else
      echo "Rust is already installed. Updating Rust toolchain..."
      rustup update
    fi

    # Clone yazi repository
    YAZI_DIR="$HOME/yazi"
    if [ -d "$YAZI_DIR" ]; then
      echo "Removing existing yazi directory..."
      rm -rf "$YAZI_DIR"
    fi

    echo "Cloning yazi repository..."
    git clone https://github.com/sxyazi/yazi.git "$YAZI_DIR"

    # Build yazi
    cd "$YAZI_DIR"
    echo "Building yazi from source..."
    cargo build --release --locked

    # Install yazi
    sudo install -m 755 target/release/yazi /usr/local/bin

    # Clean up
    cd ~
    rm -rf "$YAZI_DIR"

    # Verify installation
    if command -v yazi &> /dev/null; then
      echo "yazi installed successfully."
    else
      echo "Failed to install yazi."
    fi
  else
    echo "yazi is already installed."
  fi
}

