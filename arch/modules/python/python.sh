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
  log_info "Configuring uv Python management"
  
  # Install latest stable Python if not already installed
  if ! uv python list | grep -q "python"; then
    log_info "Installing latest stable Python with uv..."
    log_debug "Running: uv python install"
    uv python install
    log_success "Latest Python installed successfully"
  else
    log_info "Python is already installed via uv"
  fi

  # Set up uv shell completion for zsh if shell module is enabled
  if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "uv generate-shell-completion zsh" "$HOME/.zshrc"; then
      log_info "Adding uv shell completion to .zshrc..."
      echo 'eval "$(uv generate-shell-completion zsh)"' >> "$HOME/.zshrc"
      log_success "uv shell completion added to .zshrc"
    else
      log_info "uv shell completion already configured"
    fi
  fi

  log_success "uv Python management is configured"
  log_info "Use 'uv python install <version>' to install specific Python versions"
  log_info "Use 'uv python pin <version>' in projects to set project Python version"
}
