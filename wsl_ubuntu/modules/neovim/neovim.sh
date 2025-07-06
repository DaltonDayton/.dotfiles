#!/usr/bin/bash

# Function to compare semantic versions
function version_compare() {
  local version1=$1
  local version2=$2

  # Remove 'v' prefix if present
  version1=${version1#v}
  version2=${version2#v}

  # Compare versions using sort -V
  if [ "$(printf '%s\n' "$version1" "$version2" | sort -V | head -n1)" = "$version1" ]; then
    if [ "$version1" = "$version2" ]; then
      return 0 # Equal
    else
      return 1 # version1 < version2
    fi
  else
    return 2 # version1 > version2
  fi
}

# Function to install neovim from source with version checking
function install_neovim_from_source() {
  echo "Checking neovim versions..."

  # Get current installed version
  local current_version=""
  if command -v nvim &>/dev/null; then
    current_version=$(nvim --version 2>/dev/null | head -1 | grep -o 'v[0-9.]*' | head -1)
    echo "Current neovim version: ${current_version:-none}"
  else
    echo "Neovim not currently installed"
  fi

  # Get latest version from GitHub
  echo "Fetching latest neovim version from GitHub..."
  local latest_version=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)

  if [ -z "$latest_version" ]; then
    echo "Error: Could not fetch latest neovim version"
    exit 1
  fi

  echo "Latest neovim version: $latest_version"

  # Compare versions - only build if we need to
  if [ -n "$current_version" ]; then
    version_compare "$current_version" "$latest_version"
    local result=$?

    case $result in
    0)
      echo "Neovim is already up to date ($current_version)"
      return 0
      ;;
    2)
      echo "Current version ($current_version) is newer than latest release ($latest_version)"
      return 0
      ;;
    1)
      echo "Newer version available ($latest_version), building from source..."
      ;;
    esac
  else
    echo "Installing neovim $latest_version from source..."
  fi

  # Build dependencies
  local build_deps=(
    "ninja-build"
    "gettext"
    "libtool"
    "libtool-bin"
    "autoconf"
    "automake"
    "cmake"
    "g++"
    "pkg-config"
    "unzip"
    "curl"
    "doxygen"
    "git"
    "build-essential"
  )

  echo "Installing build dependencies..."
  install_packages "${build_deps[@]}"

  # Create build directory
  local build_dir="/tmp/neovim-build"
  rm -rf "$build_dir"
  mkdir -p "$build_dir"

  # Use subshell to contain working directory changes
  (
    echo "Cloning neovim repository..."
    cd "$build_dir"
    git clone https://github.com/neovim/neovim.git
    cd neovim

    echo "Checking out version $latest_version..."
    git checkout "$latest_version"

    echo "Building neovim (this may take several minutes)..."
    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local

    if [ $? -ne 0 ]; then
      echo "Error: Neovim build failed"
      exit 1
    fi

    echo "Installing neovim to /usr/local..."
    sudo make install

    if [ $? -ne 0 ]; then
      echo "Error: Neovim installation failed"
      exit 1
    fi
  )

  # Check if build/install succeeded (subshell exit codes)
  if [ $? -ne 0 ]; then
    echo "Error: Neovim build or installation failed"
    rm -rf "$build_dir"
    exit 1
  fi

  # Cleanup (working directory automatically restored by subshell)
  rm -rf "$build_dir"

  # Verify installation
  if command -v nvim &>/dev/null; then
    echo "Neovim installed successfully: $(nvim --version | head -1)"
  else
    echo "Error: Neovim installation verification failed"
    exit 1
  fi
}

# Function to install lazygit from GitHub releases
function install_lazygit() {
  # Check if already installed
  if command -v lazygit &>/dev/null; then
    echo "lazygit is already installed: $(lazygit --version)"
    return 0
  fi

  echo "Installing lazygit from GitHub releases..."

  # Get latest release download URL
  local latest_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)

  if [ -z "$latest_version" ]; then
    echo "Error: Could not fetch latest lazygit version"
    exit 1
  fi

  # Remove 'v' prefix for download URL
  local version_number=${latest_version#v}
  local download_url="https://github.com/jesseduffield/lazygit/releases/download/${latest_version}/lazygit_${version_number}_Linux_x86_64.tar.gz"

  echo "Downloading lazygit $latest_version..."

  # Download and install
  local temp_dir=$(mktemp -d)
  local tar_file="$temp_dir/lazygit.tar.gz"

  if curl -L "$download_url" -o "$tar_file"; then
    cd "$temp_dir"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    echo "lazygit installed successfully."
    rm -rf "$temp_dir"
  else
    echo "Failed to download lazygit."
    rm -rf "$temp_dir"
    exit 1
  fi

  # Verify installation
  if command -v lazygit &>/dev/null; then
    echo "Lazygit version: $(lazygit --version)"
  else
    echo "Error: lazygit installation verification failed"
    exit 1
  fi
}

# Function to install the module
function install_neovim() {
  # Define the list of runtime packages required for this module
  local packages=(
    "ripgrep"
    "unzip"
    "git" # Should already be installed from git module
  )

  # Install runtime packages
  echo "Installing runtime dependencies..."
  install_packages "${packages[@]}"

  # Install neovim from source (with version checking)
  install_neovim_from_source

  # Install lazygit from GitHub releases
  install_lazygit

  # Proceed to configuration
  configure_neovim
}

# Function to configure the module
function configure_neovim() {
  # Symlink the entire nvim configuration directory
  CONFIG_SOURCE="$MODULES_DIR/neovim/nvim"
  CONFIG_DEST="$HOME/.config/nvim"

  symlink_config "$CONFIG_SOURCE" "$CONFIG_DEST"

  echo "Neovim configuration deployed successfully!"
  echo "Start neovim with 'nvim' - LazyVim will automatically install plugins on first run."
}
