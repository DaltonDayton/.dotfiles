#!/bin/bash

function ensure_yay_installed() {
  if ! command -v yay &> /dev/null; then
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
      IFS='=' read -r pkg ver <<< "$package_entry"
      ensure_package_installed "$pkg" "$ver"
    else
      # Install the latest version
      ensure_package_installed "$package_entry"
    fi
  done
}


# Initialize an array to collect missing packages
declare -a MISSING_PACKAGES=()

function ensure_package_installed() {
  local package="$1"
  local version="${2:-latest}"

  # Check if the package is installed
  if pacman -Qq "$package" &> /dev/null; then
    echo "$package is already installed."
    # Check if a specific version is required
    if [ "$version" != "latest" ]; then
      # Get the installed version
      installed_version=$(pacman -Q "$package" | awk '{print $2}')
      if [ "$installed_version" != "$version" ]; then
        echo "$package is at version $installed_version, needs to be updated to $version."
        MISSING_PACKAGES+=("$package=$version")
      else
        echo "$package is already at version $version."
      fi
    fi
  else
    # Package is not installed
    if [ "$version" == "latest" ]; then
      echo "$package will be installed."
      MISSING_PACKAGES+=("$package")
    else
      echo "$package version $version will be installed."
      MISSING_PACKAGES+=("$package=$version")
    fi
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
