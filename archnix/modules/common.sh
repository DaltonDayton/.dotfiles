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

function ensure_package_installed() {
  # TODO: This is slow. Find a better way to check if already installed at correct version
  local package="$1"
  local version="${2:-latest}"

  if yay -Qs "^${package}$" > /dev/null; then
    echo "$package is already installed."
    if [ "$version" == "latest" ]; then
      echo "Updating $package to the latest version..."
      yay -Syu --noconfirm "$package"
    else
      echo "Ensuring $package is at version $version..."
      yay -S --noconfirm "$package=$version"
    fi
  else
    if [ "$version" == "latest" ]; then
      echo "Installing $package..."
      yay -S --noconfirm "$package"
    else
      echo "Installing $package version $version..."
      yay -S --noconfirm "$package=$version"
    fi
  fi
}

function prompt_and_backup() {
  local dest_file="$1"
  local backup_file="${dest_file}.backup.$(date +%s)"

  if [ -f "$dest_file" ]; then
    read -p "File $dest_file exists. Overwrite? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      cp "$dest_file" "$backup_file"
      echo "Backed up $dest_file to $backup_file"
      return 0  # Proceed with overwrite
    else
      echo "Skipped updating $dest_file"
      return 1  # Skip overwrite
    fi
  else
    return 0  # File doesn't exist, proceed
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
