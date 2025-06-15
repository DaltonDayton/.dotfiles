#!/usr/bin/bash

# Function to install the module
function install_git() {
  # Define the list of packages required for this module
  local packages=(
    "git"
    "github-cli"
    "openssh"
    "bat"
    "man-db"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_git
}

# Function to configure the module
function configure_git() {
  # These can be duplicated if multiple iterations need to be symlinked
  CONFIG_SOURCE="$MODULES_DIR/git/config/.gitconfig"
  CONFIG_DEST="$HOME/.gitconfig"
  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  local user_config="$HOME/.gitconfig_default_user"

  if [[ -z "$GIT_NAME" ]]; then
    echo "Error: GIT_NAME is not set in .env. Please add your name to the .env file."
    exit 1
  fi
  if [[ -z "$GIT_EMAIL" ]]; then
    echo "Error: GIT_EMAIL is not set in .env. Please add your email to the .env file."
    exit 1
  fi

  # TODO: Make this idempotent
  echo "[user]" > "$user_config"
  echo "  name = $GIT_NAME" >> "$user_config"
  echo "  email = $GIT_EMAIL" >> "$user_config"

  echo "Git configured for $CONTEXT context."

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
