#!/usr/bin/bash

# Function to install the module
function install_python() {
  log_info "Setting up Python development environment with uv"

  # Install system Python packages that might be needed
  local packages=(
    "python3"         # System Python 3
    "python3-pip"     # pip package manager (fallback)
    "python3-venv"    # venv module for virtual environments
    "python3-dev"     # Python development headers
    "build-essential" # Compiler toolchain for building Python packages
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Install uv - modern Python package and project manager
  if ! command -v uv &>/dev/null; then
    log_info "Installing uv (modern Python package manager)..."

    # Use the official uv installer
    if curl -LsSf https://astral.sh/uv/install.sh | sh; then
      log_success "uv installed successfully"

      # Add uv to PATH for current session
      export PATH="$HOME/.cargo/bin:$PATH"
    else
      log_error "Failed to install uv"
      return 1
    fi
  else
    log_info "uv is already installed"
  fi

  # Proceed to configuration
  configure_python
}

# Function to configure the module
function configure_python() {
  log_info "Configuring uv Python management"

  # Ensure uv is in PATH for this session
  export PATH="$HOME/.cargo/bin:$PATH"

  # Install latest stable Python if not already installed
  if ! uv python list 2>/dev/null | grep -q "python"; then
    log_info "Installing latest stable Python with uv..."
    log_debug "Running: uv python install"
    if uv python install; then
      log_success "Latest Python installed successfully"
    else
      log_warn "Failed to install Python via uv, but continuing..."
    fi
  else
    log_info "Python is already installed via uv"
  fi

  # Add uv to PATH in shell configuration if not already there
  local shell_configs=("$HOME/.bashrc" "$HOME/.zshrc")
  local path_line='export PATH="$HOME/.cargo/bin:$PATH"'

  for config in "${shell_configs[@]}"; do
    if [ -f "$config" ]; then
      if ! grep -q ".cargo/bin" "$config"; then
        log_info "Adding uv to PATH in $(basename "$config")"
        echo "" >>"$config"
        echo "# uv - Python package and project manager" >>"$config"
        echo "$path_line" >>"$config"
      fi
    fi
  done

  # Set up uv shell completion for zsh if shell module is enabled
  if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "uv generate-shell-completion zsh" "$HOME/.zshrc"; then
      log_info "Adding uv shell completion to .zshrc..."
      echo 'eval "$(uv generate-shell-completion zsh)"' >>"$HOME/.zshrc"
      log_success "uv shell completion added to .zshrc"
    else
      log_info "uv shell completion already configured"
    fi
  fi

  # Set up uv shell completion for bash
  if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "uv generate-shell-completion bash" "$HOME/.bashrc"; then
      log_info "Adding uv shell completion to .bashrc..."
      echo 'eval "$(uv generate-shell-completion bash)"' >>"$HOME/.bashrc"
      log_success "uv shell completion added to .bashrc"
    else
      log_info "uv shell completion already configured for bash"
    fi
  fi

  log_success "Python development environment is configured"
  log_info "Use 'uv python install <version>' to install specific Python versions"
  log_info "Use 'uv python pin <version>' in projects to set project Python version"
  log_info "Use 'uv init' to create new Python projects"
}
