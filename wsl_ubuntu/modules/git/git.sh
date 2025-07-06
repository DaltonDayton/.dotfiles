#!/usr/bin/bash

# Function to install the module
function install_git() {
  # Ensure GitHub CLI PPA is added before installing
  ensure_github_cli_ppa

  # Define the list of packages required for this module
  local packages=(
    "git"
    "gh"             # GitHub CLI (from PPA)
    "openssh-client" # SSH client for Ubuntu
    "bat"            # bat command for paging
    "man-db"         # Manual pages
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

  # Check if user config exists and has correct values
  local config_changed=false
  if [ ! -f "$user_config" ]; then
    config_changed=true
  else
    local current_name=$(grep "name = " "$user_config" | sed 's/.*name = //')
    local current_email=$(grep "email = " "$user_config" | sed 's/.*email = //')
    if [ "$current_name" != "$GIT_NAME" ] || [ "$current_email" != "$GIT_EMAIL" ]; then
      config_changed=true
    fi
  fi

  if [ "$config_changed" = true ]; then
    echo "[user]" >"$user_config"
    echo "  name = $GIT_NAME" >>"$user_config"
    echo "  email = $GIT_EMAIL" >>"$user_config"
    echo "Updated Git user configuration."
  else
    echo "Git user configuration is already correct."
  fi

  echo "Git configured for $CONTEXT context."

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.
}
