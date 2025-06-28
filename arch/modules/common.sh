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
  local retry_count=0
  local max_retries=3

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
    # Package is not installed - attempt installation with retry logic
    while [ $retry_count -lt $max_retries ]; do
      if [ "$version" == "latest" ]; then
        echo "Installing $package... (attempt $((retry_count + 1))/$max_retries)"
        if yay -S --needed --noconfirm "$package"; then
          echo "$package installed successfully."
          return 0
        fi
      else
        echo "Installing $package version $version... (attempt $((retry_count + 1))/$max_retries)"
        if yay -S --noconfirm "$package=$version"; then
          echo "$package version $version installed successfully."
          return 0
        fi
      fi

      retry_count=$((retry_count + 1))
      if [ $retry_count -lt $max_retries ]; then
        echo "Installation failed. Retrying in 5 seconds..."
        sleep 5
      fi
    done

    # All retries failed
    if [ "$version" == "latest" ]; then
      echo "Failed to install $package after $max_retries attempts."
    else
      echo "Failed to install $package version $version after $max_retries attempts."
    fi
    echo "Please install it manually."
    return 1
  fi
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

# Function to validate installation of critical components
function validate_installation() {
  local component="$1"
  local validation_type="${2:-command}" # Options: command, symlink, file
  local target="$3"

  case "$validation_type" in
  "command")
    if command -v "$component" &>/dev/null; then
      echo "✓ $component is available"
      return 0
    else
      echo "✗ $component is not available in PATH"
      return 1
    fi
    ;;
  "symlink")
    if [ -L "$target" ] && [ -e "$target" ]; then
      echo "✓ Symlink $target is correctly set"
      return 0
    else
      echo "✗ Symlink $target is missing or broken"
      return 1
    fi
    ;;
  "file")
    if [ -f "$target" ]; then
      echo "✓ File $target exists"
      return 0
    else
      echo "✗ File $target is missing"
      return 1
    fi
    ;;
  *)
    echo "Error: Unknown validation type $validation_type"
    return 1
    ;;
  esac
}
