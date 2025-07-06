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

# Function to install yazi via snap
function install_yazi() {
  if command -v yazi &>/dev/null; then
    echo "yazi is already installed."
    return 0
  fi

  echo "Installing yazi via snap..."
  sudo snap install yazi --classic
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
    "curl" # Required for GitHub installations
    "wget" # Required for eza installation
    "gpg"  # Required for eza PPA
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

  # Update yazi packages if yazi is available
  if command -v ya &>/dev/null; then
    ya pkg upgrade
  fi

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # Shell switching logic - if we're not already in zsh, switch and continue
  if [ -z "$ZSH_VERSION" ]; then
    echo "→ Switching to zsh and continuing installation..."
    
    # Set zsh as the default shell
    local zsh_path=$(which zsh)
    if [ -z "$zsh_path" ]; then
      echo "Error: zsh not found in PATH. Please ensure zsh is installed."
      return 1
    fi
    
    echo "→ Setting zsh as default shell ($zsh_path)..."
    chsh -s "$zsh_path" || {
      echo "✖ failed to chsh – you might need to run this with sudo or set your password."
      return 1
    }
    
    # Create continuation script for remaining modules
    local continue_script="/tmp/continue_install_in_zsh.sh"
    echo "→ Creating continuation script for remaining modules..."
    
    cat > "$continue_script" << EOF
#!/usr/bin/env bash
set -e
trap 'echo "An error occurred. Exiting..."; exit 1;' ERR

echo "🐚 Continuing installation with proper zsh environment configured..."

# Get the directory of the original script  
SCRIPT_DIR="$SCRIPT_DIR"
MODULES_DIR="\$SCRIPT_DIR/modules"

# Source common functions
source "\$MODULES_DIR/common.sh"

# Load environment variables
if [ -f "\$SCRIPT_DIR/.env" ]; then
  source "\$SCRIPT_DIR/.env"
else
  echo "Error: .env file not found!"
  exit 1
fi

# Ensure apt is updated
ensure_apt_updated

# Process remaining modules (after shell)
REMAINING_MODULES=(
  "asdf"
  "claude-code"
)

for module in "\${REMAINING_MODULES[@]}"; do
  MODULE_SCRIPT="\$MODULES_DIR/\${module}/\${module}.sh"
  if [ -f "\$MODULE_SCRIPT" ]; then
    echo "====================="
    echo "Processing \$module..."
    echo "====================="
    source "\$MODULE_SCRIPT"
    "install_\$module"
    echo ""
  else
    echo "Warning: Module script \$MODULE_SCRIPT not found!"
  fi
done

echo "====================="
echo "Installation complete!"
echo "====================="
echo "Environment: \$ENVIRONMENT"
echo "Context: \$CONTEXT"

# Clean up
rm -f "\$0"
EOF
    
    chmod +x "$continue_script"
    
    echo "→ Initializing zsh environment and continuing installation..."
    # First trigger zsh initialization, then continue with bash script
    zsh -l -c "echo 'Zsh environment initialized!'"
    echo "→ Continuing installation with remaining modules..."
    exec bash "$continue_script"
  else
    echo "✓ Already running in zsh v$ZSH_VERSION"
    # Set zsh as default if not already set
    local zsh_path=$(which zsh)
    if [ "$SHELL" != "$zsh_path" ]; then
      echo "→ Setting zsh as default shell ($zsh_path)..."
      chsh -s "$zsh_path"
    fi
  fi
}
