#!/usr/bin/bash

# Function to install the module
function install_asdf() {
  # Define the list of packages required for this module
  local packages=(
    "curl"
    "git"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_asdf
}

# Function to configure the module
function configure_asdf() {
  # Directory for asdf installation
  asdf_dir="$HOME/.asdf"

  # Install asdf if not already present
  if [ ! -d "$asdf_dir" ]; then
    echo "Installing latest asdf (v0.18.0)..."
    git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch v0.18.0
  else
    echo "asdf already installed, updating to latest..."
    cd "$asdf_dir"
    git fetch origin
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
  fi

  # Add asdf to shell configuration files
  local asdf_source='source $HOME/.asdf/asdf.sh'
  local asdf_completions='source $HOME/.asdf/completions/asdf.bash'

  # Add to .bashrc if it exists
  if [ -f ~/.bashrc ]; then
    if ! grep -q "asdf.sh" ~/.bashrc; then
      echo "Adding asdf to ~/.bashrc..."
      echo "" >> ~/.bashrc
      echo "# asdf version manager" >> ~/.bashrc
      echo "$asdf_source" >> ~/.bashrc
      echo "$asdf_completions" >> ~/.bashrc
    else
      echo "asdf already configured in ~/.bashrc"
    fi
  fi

  # Add to .zshrc if it exists (for zsh users)
  if [ -f ~/.zshrc ]; then
    if ! grep -q "asdf.sh" ~/.zshrc; then
      echo "Adding asdf to ~/.zshrc..."
      echo "" >> ~/.zshrc
      echo "# asdf version manager" >> ~/.zshrc
      echo "$asdf_source" >> ~/.zshrc
      # Use zsh completions for zsh
      echo 'source $HOME/.asdf/completions/asdf.zsh' >> ~/.zshrc
    else
      echo "asdf already configured in ~/.zshrc"
    fi
  fi

  # Source asdf for current session
  source "$asdf_dir/asdf.sh"

  # Function to handle asdf plugin installation
  install_asdf_plugin() {
    local name=$1
    if ! asdf plugin list | grep -q "^$name\$"; then
      echo "Adding $name plugin..."
      asdf plugin add "$name"
    else
      echo "$name plugin is already added."
    fi
  }

  # Install and set Node.js to latest
  install_asdf_plugin "nodejs"
  
  echo "Installing latest Node.js..."
  asdf install nodejs latest
  asdf global nodejs latest

  echo "asdf configuration complete!"
  echo "Node.js version: $(asdf current nodejs 2>/dev/null || echo 'Not set')"
  echo "Note: You may need to restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use asdf commands."
}