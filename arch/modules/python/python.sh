#!/usr/bin/bash

# Function to install the module
function install_python() {
  # Define the list of packages required for this module
  local packages=(
    "uv"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_python
}

# Function to configure the module
function configure_python() {
  # Install latest stable Python if not already installed
  if ! uv python list | grep -q "python"; then
    echo "Installing latest stable Python with uv..."
    uv python install
  else
    echo "Python is already installed via uv."
  fi

  # Set up uv shell completion for zsh if shell module is enabled
  if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "uv generate-shell-completion zsh" "$HOME/.zshrc"; then
      echo "Adding uv shell completion to .zshrc..."
      echo 'eval "$(uv generate-shell-completion zsh)"' >> "$HOME/.zshrc"
    else
      echo "uv shell completion already configured."
    fi
  fi

  echo "uv Python management is configured."
  echo "Use 'uv python install <version>' to install specific Python versions."
  echo "Use 'uv python pin <version>' in projects to set project Python version."
}
