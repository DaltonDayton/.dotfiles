#!/usr/bin/bash

# Function to install the module
function install_shell() {
  # Define the list of packages required for this module
  local packages=(
    "zsh"
    "starship"
    "eza"
    "zoxide"
    "bat"
    "less"
    "fzf"
    "yazi"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

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
  ya pack -u

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # Set zsh as the default shell
  if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Setting zsh as the default shell..."
    chsh -s /bin/zsh
  else
    echo "zsh is the default shell."
  fi
}
