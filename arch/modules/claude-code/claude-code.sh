#!/usr/bin/bash

# Function to install the module
function install_claude-code() {
  # Verify asdf is available
  if ! command -v asdf &>/dev/null; then
    echo "Error: asdf is required but not found. Please install the asdf module first."
    exit 1
  fi

  # Proceed to configuration
  configure_claude-code
}

# Function to configure the module
function configure_claude-code() {
  echo "Setting up Claude Code with asdf-managed Node.js..."

  # Ensure we're in a valid directory before running Go commands
  cd "$SCRIPT_DIR" 2>/dev/null || cd /

  # Ensure Go bin directory is in PATH (for Go-installed asdf)
  export PATH="$(go env GOPATH)/bin:$PATH"

  # Verify asdf is properly configured
  if ! command -v asdf &>/dev/null; then
    echo "Error: asdf command not found in PATH. Please ensure asdf is properly installed."
    exit 1
  fi

  # Ensure asdf shims are prioritized in PATH (critical for avoiding Windows npm)
  if [ -d "$HOME/.asdf/shims" ]; then
    export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
    echo "Added asdf shims to PATH with priority"
  fi

  # Display environment info for debugging
  echo "Environment check:"
  echo "  asdf version: $(asdf --version 2>/dev/null || echo 'unknown')"
  echo "  Current PATH: $PATH"
  echo "  Node.js path: $(which node 2>/dev/null || echo 'not found')"
  echo "  npm path: $(which npm 2>/dev/null || echo 'not found')"

  # Ensure Node.js is available via asdf
  if ! asdf current nodejs &>/dev/null; then
    echo "Installing latest Node.js via asdf..."
    asdf install nodejs latest
    asdf set -u nodejs latest

    # Reinitialize shell environment after asdf installation
    echo "Reinitializing shell environment to load asdf configuration..."
    if [ -f ~/.zshrc ]; then
      source ~/.zshrc
    elif [ -f ~/.bashrc ]; then
      source ~/.bashrc
    fi
  else
    echo "Node.js already available via asdf: $(asdf current nodejs)"
  fi

  # Refresh environment for asdf shims
  hash -r

  # Verify npm is available
  if ! command -v npm &>/dev/null; then
    echo "Error: npm not available. Node.js installation may have failed."
    exit 1
  fi

  echo "Using Node.js: $(node --version 2>/dev/null || echo 'version unknown')"
  echo "Using npm: $(npm --version 2>/dev/null || echo 'version unknown')"

  # Verify we're using asdf-managed versions, not Windows versions
  node_path=$(which node 2>/dev/null)
  npm_path=$(which npm 2>/dev/null)

  if [[ "$node_path" != *".asdf/shims"* ]]; then
    echo "Warning: Node.js path ($node_path) is not from asdf shims!"
    echo "This may cause npm conflicts. Attempting to fix PATH..."
    export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
    hash -r
    node_path=$(which node 2>/dev/null)
    echo "Updated Node.js path: $node_path"
  fi

  if [[ "$npm_path" != *".asdf/shims"* ]]; then
    echo "Warning: npm path ($npm_path) is not from asdf shims!"
    echo "This may cause the call stack overflow error."
    export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
    hash -r
    npm_path=$(which npm 2>/dev/null)
    echo "Updated npm path: $npm_path"
  fi

  # Check if Claude Code is already installed
  if command -v claude &>/dev/null; then
    echo "Claude Code is already installed: $(claude --version)"
  else
    # Clear npm cache to prevent stack overflow issues
    echo "Clearing npm cache to prevent installation issues..."
    npm cache clean --force 2>/dev/null || echo "Cache clean failed, continuing..."

    # Install Claude Code globally
    echo "Installing Claude Code..."
    if npm install -g @anthropic-ai/claude-code; then
      echo "Claude Code installed successfully!"

      # Refresh asdf shims after installation
      asdf reshim nodejs

      # Verify installation
      if command -v claude &>/dev/null; then
        echo "Claude Code version: $(claude --version)"
      else
        echo "Error: Claude command not available after installation."
        echo "Try restarting your terminal or running 'source ~/.bashrc' (or ~/.zshrc)"
      fi
    else
      echo "Error: Claude Code installation failed."
      echo "Try running the script again or install manually with: npm install -g @anthropic-ai/claude-code"
    fi
  fi

  echo "Claude Code setup complete!"
  echo "Note: Global npm packages are managed by asdf and will persist across Node.js version changes."
}
