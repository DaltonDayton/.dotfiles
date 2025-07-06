#!/usr/bin/bash

# Function to install the module
function install_claude-code() {
  # Verify asdf is available
  if ! command -v asdf &> /dev/null; then
    echo "Error: asdf is required but not found. Please install the asdf module first."
    exit 1
  fi

  # Proceed to configuration
  configure_claude-code
}

# Function to configure the module
function configure_claude-code() {
  echo "Setting up Claude Code with asdf-managed Node.js..."
  
  # Source asdf for current session if not already available
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
  fi
  
  # Ensure Node.js is available via asdf
  if ! asdf current nodejs &> /dev/null; then
    echo "Installing latest Node.js via asdf..."
    asdf install nodejs latest
    asdf global nodejs latest
  else
    echo "Node.js already available via asdf: $(asdf current nodejs)"
  fi
  
  # Verify npm is available
  if ! command -v npm &> /dev/null; then
    echo "Error: npm not available. Node.js installation may have failed."
    exit 1
  fi
  
  # Check if Claude Code is already installed
  if command -v claude-code &> /dev/null; then
    echo "Claude Code is already installed: $(claude-code --version)"
  else
    # Install Claude Code globally (no permission issues with asdf)
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    
    # Verify installation
    if command -v claude-code &> /dev/null; then
      echo "Claude Code installed successfully!"
      claude-code --version
    else
      echo "Claude Code installation may have failed. Try opening a new terminal and running 'claude-code --version'"
      echo "Make sure to restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to refresh your environment."
    fi
  fi
  
  echo "Claude Code setup complete!"
  echo "Note: Global npm packages are managed by asdf and will persist across Node.js version changes."
}