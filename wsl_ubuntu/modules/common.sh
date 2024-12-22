#!/usr/bin/env bash

# Function to install a list of packages
function install_packages() {
  local packages=("$@")
  for package_entry in "${packages[@]}"; do
    if [[ "$package_entry" == *"="* ]]; then
      # If a specific version is specified
      IFS='=' read -r pkg ver <<< "$package_entry"
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
  if dpkg -l | grep -qw "^ii.*$package"; then
    installed_version=$(dpkg -l | grep "^ii" | grep " $package " | awk '{print $3}' | cut -d'-' -f1)
    if [ "$version" != "latest" ]; then
      if [ "$installed_version" != "$version" ]; then
        echo "$package is at version $installed_version, but version $version is required."
        # Attempt to install the specific version
        sudo apt install -y "$package=$version" || {
          echo "Failed to install $package version $version."
          echo "Please install it manually."
        }
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
      sudo apt install -y "$package"
    else
      echo "Installing $package version $version..."
      sudo apt install -y "$package=$version" || {
        echo "Failed to install $package version $version."
        echo "Please install it manually."
      }
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
  if [ ! -L "$dest_path" ] || [ "$(readlink -f "$dest_path")" != "$(readlink -f "$source_path")" ]; then
    ln -sfn "$source_path" "$dest_path"
    echo "Created or updated symlink from $source_path to $dest_path"
  else
    echo "Symlink from $source_path to $dest_path already correctly set."
  fi
}

