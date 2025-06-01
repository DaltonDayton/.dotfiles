#!/bin/bash

# Function to ensure 'yay' is installed
function ensure_yay_installed() {
  if ! command -v yay &>/dev/null; then
    echo "yay is not installed. Installing yay..."
    # Install dependencies for building yay
    sudo pacman -S --needed --noconfirm git base-devel
    # Clone yay repository and install
    temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"
    pushd "$temp_dir/yay"
    makepkg -si --noconfirm
    popd
    rm -rf "$temp_dir"
    echo "yay installed successfully."
  else
    echo "yay is already installed."
  fi
}

# Function to install a list of packages
function install_packages() {
  local packages=("$@")
  for package_entry in "${packages[@]}"; do
    if [[ "$package_entry" == *"="* ]]; then
      # If a specific version is specified
      IFS='=' read -r pkg ver <<<"$package_entry"
      ensure_package_installed "$pkg" "$ver"
    else
      ensure_package_installed "$package_entry"
    fi
  done
}

function ensure_package_installed() {
  local package="$1"
  local version="${2:-latest}"

  # Check if the package is installed
  if pacman -Qq "$package" &>/dev/null; then
    installed_version=$(pacman -Q "$package" | awk '{print $2}')
    if [ "$version" != "latest" ]; then
      if [ "$installed_version" != "$version" ]; then
        echo "$package is at version $installed_version, but version $version is required."
        # Handle the version mismatch (e.g., prompt the user, attempt to downgrade)
        # Downgrading can be complex; consider notifying the user instead
        echo "Please downgrade $package to version $version manually."
      else
        echo "$package is already at the required version $version."
      fi
    else
      echo "$package is already installed."
    fi
  else
    # Package is not installed
    if [ "$version" == "latest" ]; then
      echo "Installing $package..."
      yay -S --needed --noconfirm "$package"
    else
      echo "Installing $package version $version..."
      # Attempt to install the specific version
      yay -S --noconfirm "$package=$version" || {
        echo "Failed to install $package version $version."
        echo "Please install it manually."
      }
    fi
  fi
}

# Function to detect the current environment
function detect_environment() {
  if grep -q Microsoft /proc/version 2>/dev/null; then
    echo "wsl"
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  elif [ -f /etc/os-release ]; then
    # Try to detect other environments from os-release
    local id=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
    case "$id" in
      arch) echo "arch" ;;
      ubuntu) echo "wsl" ;; # Assume Ubuntu means WSL for now
      *) echo "unknown" ;;
    esac
  else
    echo "unknown"
  fi
}

# Function to prompt for user input with a default value
function prompt_with_default() {
  local prompt="$1"
  local default="$2"
  local var_name="$3"

  if [ -n "$default" ]; then
    read -p "$prompt [$default]: " input
    if [ -z "$input" ]; then
      input="$default"
    fi
  else
    read -p "$prompt: " input
    while [ -z "$input" ]; do
      echo "This field is required."
      read -p "$prompt: " input
    done
  fi

  # Use declare to set the variable dynamically
  declare -g "$var_name"="$input"
}

# Function to setup or validate .env file
function setup_env_file() {
  local script_dir="$1"
  local env_file="$script_dir/.env"
  local env_default="$script_dir/.env_default"

  # If .env already exists, just source it and return
  if [ -f "$env_file" ]; then
    echo "Found existing .env file."
    source "$env_file"
    return 0
  fi

  echo "🚀 Setting up your dotfiles environment..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo

  # Detect environment automatically
  local detected_env=$(detect_environment)
  echo "Detected environment: $detected_env"
  echo

  # Get current git config if available
  local current_git_name=""
  local current_git_email=""
  if command -v git &>/dev/null; then
    current_git_name=$(git config --global user.name 2>/dev/null || echo "")
    current_git_email=$(git config --global user.email 2>/dev/null || echo "")
  fi

  # Load defaults from .env_default if it exists
  local default_env="arch"
  local default_context="personal"
  local default_git_name="$current_git_name"
  local default_git_email="$current_git_email"

  if [ -f "$env_default" ]; then
    source "$env_default"
    default_env="$ENVIRONMENT"
    default_context="$CONTEXT"
    if [ -z "$default_git_name" ]; then
      default_git_name="$GIT_NAME"
    fi
    if [ -z "$default_git_email" ]; then
      default_git_email="$GIT_EMAIL"
    fi
  fi

  # Override default environment with detected one if it's not unknown
  if [ "$detected_env" != "unknown" ]; then
    default_env="$detected_env"
  fi

  echo "Please provide the following information:"
  echo

  # Prompt for values
  prompt_with_default "Environment (arch/wsl)" "$default_env" "ENVIRONMENT"
  prompt_with_default "Context (personal/work)" "$default_context" "CONTEXT"
  prompt_with_default "Git Name" "$default_git_name" "GIT_NAME"
  prompt_with_default "Git Email" "$default_git_email" "GIT_EMAIL"

  echo
  echo "Creating .env file with the following configuration:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ENVIRONMENT=\"$ENVIRONMENT\""
  echo "CONTEXT=\"$CONTEXT\""
  echo "GIT_NAME=\"$GIT_NAME\""
  echo "GIT_EMAIL=\"$GIT_EMAIL\""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo

  # Ask for confirmation
  read -p "Does this look correct? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Setup cancelled. You can run this script again or manually create the .env file."
    exit 1
  fi

  # Create the .env file
  cat > "$env_file" << EOF
# Auto-generated .env file
# You can edit this file manually if needed

ENVIRONMENT="$ENVIRONMENT"
CONTEXT="$CONTEXT"

# Git configuration
GIT_NAME="$GIT_NAME"
GIT_EMAIL="$GIT_EMAIL"
EOF

  echo "✅ Created .env file successfully!"
  echo
}

# Global arrays to track module dependencies and installation status
declare -A MODULE_DEPENDENCIES
declare -A MODULE_INSTALLED

# Function to declare module dependencies
function declare_module_dependencies() {
  local module="$1"
  shift
  local dependencies=("$@")

  # Store dependencies as a space-separated string
  MODULE_DEPENDENCIES["$module"]="${dependencies[*]}"
}

# Function to check if a module is installed
function is_module_installed() {
  local module="$1"
  [[ "${MODULE_INSTALLED[$module]:-false}" == "true" ]]
}

# Function to mark a module as installed
function mark_module_installed() {
  local module="$1"
  MODULE_INSTALLED["$module"]="true"
}

# Function to resolve dependencies using topological sort
function resolve_dependencies() {
  local modules=("$@")
  local resolved=()
  local visiting=()

  # Function to visit a module and its dependencies
  visit_module() {
    local module="$1"

    # Check if already resolved
    for resolved_module in "${resolved[@]}"; do
      if [[ "$resolved_module" == "$module" ]]; then
        return 0
      fi
    done

    # Check for circular dependency
    for visiting_module in "${visiting[@]}"; do
      if [[ "$visiting_module" == "$module" ]]; then
        echo "Error: Circular dependency detected involving module '$module'"
        echo "Dependency chain: ${visiting[*]} -> $module"
        exit 1
      fi
    done

    # Mark as visiting
    visiting+=("$module")

    # Visit dependencies first
    local deps="${MODULE_DEPENDENCIES[$module]:-}"
    if [[ -n "$deps" ]]; then
      for dep in $deps; do
        # Check if dependency module exists
        if [[ ! -f "$MODULES_DIR/$dep/$dep.sh" ]]; then
          echo "Warning: Dependency '$dep' for module '$module' not found. Skipping."
          continue
        fi
        visit_module "$dep"
      done
    fi

    # Remove from visiting and add to resolved
    visiting=("${visiting[@]/$module}")
    resolved+=("$module")
  }

  # Visit all requested modules
  for module in "${modules[@]}"; do
    visit_module "$module"
  done

  # Return resolved order
  printf '%s\n' "${resolved[@]}"
}

# Function to install a module with dependency checking
function install_module_with_deps() {
  local module="$1"

  # Check if already installed
  if is_module_installed "$module"; then
    echo "Module '$module' is already installed."
    return 0
  fi

  # Check if module script exists
  local module_script="$MODULES_DIR/$module/$module.sh"
  if [[ ! -f "$module_script" ]]; then
    echo "Error: Module '$module' not found at $module_script"
    return 1
  fi

  # Install dependencies first
  local deps="${MODULE_DEPENDENCIES[$module]:-}"
  if [[ -n "$deps" ]]; then
    echo "Installing dependencies for '$module': $deps"
    for dep in $deps; do
      if [[ -f "$MODULES_DIR/$dep/$dep.sh" ]]; then
        install_module_with_deps "$dep"
      else
        echo "Warning: Dependency '$dep' for module '$module' not found. Continuing anyway."
      fi
    done
  fi

  # Install the module
  echo "====================="
  echo "Processing $module..."
  echo "====================="
  source "$module_script"
  "install_$module"
  mark_module_installed "$module"

  echo "✅ Module '$module' installed successfully."
}

# Function to symlink configuration files or directories without using rm -rf
function symlink_config() {
  local source_path="$1"
  local dest_path="$2"

  # Ensure the parent directory of the destination exists
  dest_dir=$(dirname "$dest_path")
  if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
    echo "Created directory $dest_dir"
  fi

  # Create the symlink if it does not exist or update if incorrect
  if [ ! -L "$dest_path" ] || [ "$(readlink "$dest_path")" != "$source_path" ]; then
    ln -sfn "$source_path" "$dest_path"
    echo "Created or updated symlink from $source_path to $dest_path"
  else
    echo "Symlink from $source_path to $dest_path already correctly set."
  fi
}
