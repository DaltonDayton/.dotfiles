#!/bin/bash

# Function to ensure apt is updated
function ensure_apt_updated() {
  echo "Updating package lists..."
  sudo apt update
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
  if dpkg -l | grep -q "^ii  $package "; then
    installed_version=$(dpkg -l | grep "^ii  $package " | awk '{print $3}')
    if [ "$version" != "latest" ]; then
      if [ "$installed_version" != "$version" ]; then
        echo "$package is at version $installed_version, but version $version is required."
        echo "Please install $package version $version manually."
      else
        echo "$package is already at the required version $version."
      fi
    else
      echo "$package is already installed."
    fi
  else
    # Package is not installed - single installation attempt
    if [ "$version" == "latest" ]; then
      echo "Installing $package..."
      if sudo apt install -y "$package"; then
        echo "$package installed successfully."
      else
        echo "Failed to install $package."
        exit 1
      fi
    else
      echo "Installing $package version $version..."
      if sudo apt install -y "$package=$version"; then
        echo "$package version $version installed successfully."
      else
        echo "Failed to install $package version $version."
        exit 1
      fi
    fi
  fi
}

# Function to create symlinks safely
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

# Function to add GitHub CLI PPA
function ensure_github_cli_ppa() {
  if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
    echo "Adding GitHub CLI PPA..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    echo "GitHub CLI PPA added successfully."
  else
    echo "GitHub CLI PPA already configured."
  fi
}

# Function to install packages from GitHub releases (deb packages)
function install_github_deb() {
  local repo="$1"
  local package_name="$2"
  local deb_pattern="$3"

  # Check if already installed
  if command -v "$package_name" &>/dev/null; then
    echo "$package_name is already installed."
    return 0
  fi

  echo "Installing $package_name from GitHub releases..."

  # Get latest release download URL
  local download_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" |
    grep "browser_download_url.*$deb_pattern" |
    cut -d '"' -f 4 | head -1)

  if [ -z "$download_url" ]; then
    echo "Failed to find download URL for $package_name"
    exit 1
  fi

  # Download and install
  local temp_dir=$(mktemp -d)
  local deb_file="$temp_dir/$package_name.deb"

  if curl -L "$download_url" -o "$deb_file" && sudo dpkg -i "$deb_file"; then
    echo "$package_name installed successfully."
    rm -rf "$temp_dir"
  else
    echo "Failed to install $package_name."
    rm -rf "$temp_dir"
    exit 1
  fi
}

# Function to install starship prompt
function install_starship() {
  if command -v starship &>/dev/null; then
    echo "starship is already installed."
    return 0
  fi

  echo "Installing starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  echo "starship installed successfully."
}

# Function to validate installation of critical components
function validate_installation() {
  local components=("$@")
  for component in "${components[@]}"; do
    if ! command -v "$component" &>/dev/null; then
      echo "Error: $component is not installed or not in PATH."
      exit 1
    fi
  done
  echo "All required components are installed and accessible."
}
