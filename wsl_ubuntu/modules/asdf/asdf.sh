#!/usr/bin/bash

# Function to install the module
function install_asdf() {
  # Define the list of packages required for this module
  local packages=(
    "curl"
    "git"
    "golang-go"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_asdf
}

# Function to configure the module
function configure_asdf() {
  # Check if asdf is already installed
  if command -v asdf &>/dev/null; then
    echo "asdf is already installed, version: $(asdf --version 2>/dev/null || echo 'unknown')"
  else
    echo "Installing asdf via Go..."

    # Ensure Go bin directory is in PATH for this session
    export PATH="$PATH:$(go env GOPATH)/bin"

    # Install asdf using go install
    go install github.com/asdf-vm/asdf/cmd/asdf@latest

    if [ $? -eq 0 ]; then
      echo "asdf installed successfully via Go"
    else
      echo "Failed to install asdf via Go, falling back to manual installation"
      return 1
    fi
  fi

  # Ensure Go bin directory is in PATH for shell configuration
  go_bin_path="$(go env GOPATH)/bin"

  # Configure shell integration
  configure_shell_integration "$go_bin_path"

  # Source asdf for current session if available
  if [ -f "$go_bin_path/asdf" ]; then
    export PATH="$go_bin_path:$PATH"
  fi

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
  asdf set -u nodejs latest

  echo "asdf configuration complete!"
  echo "Node.js version: $(asdf current nodejs 2>/dev/null || echo 'Not set')"
  echo "Note: You may need to restart your terminal to use asdf commands."
}

# Function to configure shell integration
function configure_shell_integration() {
  local go_bin_path="$1"

  # Configuration for .bashrc
  if [ -f ~/.bashrc ]; then
    if ! grep -q "asdf completion" ~/.bashrc; then
      echo "Adding asdf to ~/.bashrc..."
      cat >>~/.bashrc <<'EOF'

# asdf version manager
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$(go env GOPATH)/bin:$PATH"
source <(asdf completion bash)
EOF
    else
      echo "asdf already configured in ~/.bashrc"
    fi
  fi

  # Note: .zshrc already has proper asdf PATH configuration, so we only add completion
  if [ -f ~/.zshrc ]; then
    if ! grep -q "asdf completion" ~/.zshrc; then
      echo "Adding asdf completion to ~/.zshrc..."
      cat >>~/.zshrc <<'EOF'

# asdf completion
source <(asdf completion zsh)
EOF
    else
      echo "asdf already configured in ~/.zshrc"
    fi
  fi
}
