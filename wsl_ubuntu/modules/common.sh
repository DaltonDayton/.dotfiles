#!/bin/bash

# Logging configuration
LOG_FILE="${LOG_FILE:-}"
DEBUG_MODE="${DEBUG_MODE:-false}"

# Parse command line arguments
function parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    --debug)
      DEBUG_MODE=true
      shift
      ;;
    --log-file)
      LOG_FILE="$2"
      shift 2
      ;;
    --help | -h)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --debug           Enable debug mode with verbose output"
      echo "  --log-file FILE   Write logs to specified file"
      echo "  --help, -h        Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
    esac
  done

  export DEBUG_MODE
  export LOG_FILE
}

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
function log_info() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local formatted="[${timestamp}] ${BLUE}INFO${NC}: $message"

  echo -e "$formatted"
  if [ -n "${LOG_FILE:-}" ]; then
    echo "[${timestamp}] INFO: $message" >>"$LOG_FILE"
  fi
}

function log_success() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local formatted="[${timestamp}] ${GREEN}SUCCESS${NC}: $message"

  echo -e "$formatted"
  if [ -n "${LOG_FILE:-}" ]; then
    echo "[${timestamp}] SUCCESS: $message" >>"$LOG_FILE"
  fi
}

function log_warn() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local formatted="[${timestamp}] ${YELLOW}WARN${NC}: $message"

  echo -e "$formatted" >&2
  if [ -n "${LOG_FILE:-}" ]; then
    echo "[${timestamp}] WARN: $message" >>"$LOG_FILE"
  fi
}

function log_error() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local formatted="[${timestamp}] ${RED}ERROR${NC}: $message"

  echo -e "$formatted" >&2
  if [ -n "${LOG_FILE:-}" ]; then
    echo "[${timestamp}] ERROR: $message" >>"$LOG_FILE"
  fi
}

function log_debug() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local formatted="[${timestamp}] ${CYAN}DEBUG${NC}: $message"

  if [ "$DEBUG_MODE" = "true" ]; then
    echo -e "$formatted"
    if [ -n "${LOG_FILE:-}" ]; then
      echo "[${timestamp}] DEBUG: $message" >>"$LOG_FILE"
    fi
  fi
}

function log_module_start() {
  local module="$1"
  echo
  echo -e "${CYAN}===================================================${NC}"
  echo -e "${CYAN}  PROCESSING MODULE: ${module^^}${NC}"
  echo -e "${CYAN}===================================================${NC}"
  log_info "Starting $module module installation"
}

function log_module_end() {
  local module="$1"
  local status="$2"
  if [ "$status" = "success" ]; then
    log_success "Module $module completed successfully"
    echo -e "${GREEN}✓ $module module finished${NC}"
  else
    log_error "Module $module failed"
    echo -e "${RED}✗ $module module failed${NC}"
  fi
  echo
}

# Initialize logging system
function initialize_logging() {
  START_TIME=$(date +%s)
  export START_TIME

  if [ -n "$LOG_FILE" ]; then
    # Create log file and directory if needed
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
  fi

  log_info "Starting WSL Ubuntu dotfiles installation"
  log_info "Debug mode: $DEBUG_MODE"
  if [ -n "$LOG_FILE" ]; then
    log_info "Logging to file: $LOG_FILE"
  fi
}

# Run a single module with progress tracking
function run_module() {
  local module="$1"
  local current_num="$2"
  local total_modules="$3"
  local modules_dir="$4"

  CURRENT_MODULE="$module"
  export CURRENT_MODULE

  MODULE_SCRIPT="$modules_dir/${module}/${module}.sh"
  if [ ! -f "$MODULE_SCRIPT" ]; then
    log_error "Module script not found: $MODULE_SCRIPT"
    return 1
  fi

  log_module_start "$module"
  log_info "Processing module $current_num of $total_modules: $module"

  # Calculate elapsed time and estimates
  if [ -n "$START_TIME" ] && [ "$current_num" -gt 1 ]; then
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    AVG_TIME_PER_MODULE=$((ELAPSED / (current_num - 1)))
    REMAINING_MODULES=$((total_modules - current_num + 1))
    ESTIMATED_REMAINING=$((AVG_TIME_PER_MODULE * REMAINING_MODULES))
    log_info "Progress: $current_num/$total_modules | Elapsed: ${ELAPSED}s | Est. remaining: ${ESTIMATED_REMAINING}s"
  fi

  # Run module installation in subshell for isolation
  if (
    set -e
    # shellcheck disable=SC1090
    source "$MODULE_SCRIPT"
    "install_$module"
  ); then
    log_module_end "$module" "success"
    return 0
  else
    log_module_end "$module" "failed"
    return 1
  fi
}

# Show final installation summary
function show_final_summary() {
  local -n successful_modules_ref=$1
  local -n failed_modules_ref=$2

  # Calculate total time if START_TIME is available
  if [ -n "$START_TIME" ]; then
    TOTAL_TIME=$(($(date +%s) - START_TIME))
  else
    TOTAL_TIME="unknown"
  fi

  echo
  echo -e "\033[0;36m================================================\033[0m"
  echo -e "\033[0;36m  INSTALLATION COMPLETE\033[0m"
  echo -e "\033[0;36m================================================\033[0m"

  if [ "$TOTAL_TIME" != "unknown" ]; then
    log_info "Total installation time: ${TOTAL_TIME}s"
  fi

  if [ ${#successful_modules_ref[@]} -gt 0 ]; then
    log_info "Successful modules (${#successful_modules_ref[@]}): ${successful_modules_ref[*]}"
  fi

  if [ ${#failed_modules_ref[@]} -gt 0 ]; then
    log_warn "Failed modules (${#failed_modules_ref[@]}): ${failed_modules_ref[*]}"
    return 1
  else
    log_success "All modules completed successfully!"
    return 0
  fi
}

# Function to ensure apt is updated
function ensure_apt_updated() {
  log_info "Updating package lists..."
  if sudo apt update; then
    log_success "Package lists updated successfully"
  else
    log_error "Failed to update package lists"
    return 1
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

  log_debug "Checking package: $package"

  # Check if the package is installed
  if dpkg -l | grep -q "^ii  $package "; then
    installed_version=$(dpkg -l | grep "^ii  $package " | awk '{print $3}')
    if [ "$version" != "latest" ]; then
      if [ "$installed_version" != "$version" ]; then
        log_warn "$package is at version $installed_version, but version $version is required"
        log_warn "Please install $package version $version manually"
      else
        log_info "$package is already at the required version $version"
      fi
    else
      log_info "$package is already installed (version $installed_version)"
    fi
  else
    # Package is not installed - attempt installation
    if [ "$version" == "latest" ]; then
      log_info "Installing $package..."
      log_debug "Running: sudo apt install -y $package"
      if sudo apt install -y "$package"; then
        log_success "$package installed successfully"
        return 0
      else
        log_error "Failed to install $package"
        log_error "Please install it manually"
        return 1
      fi
    else
      log_info "Installing $package version $version..."
      log_debug "Running: sudo apt install -y $package=$version"
      if sudo apt install -y "$package=$version"; then
        log_success "$package version $version installed successfully"
        return 0
      else
        log_error "Failed to install $package version $version"
        log_error "Please install it manually"
        return 1
      fi
    fi
  fi
}

# Function to create symlinks safely
function symlink_config() {
  local source_path="$1"
  local dest_path="$2"

  log_debug "Symlinking $source_path -> $dest_path"

  # Ensure the parent directory of the destination exists
  dest_dir=$(dirname "$dest_path")
  if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
    log_info "Created directory $dest_dir"
  fi

  # Create the symlink if it does not exist or update if incorrect
  if [ ! -L "$dest_path" ] || [ "$(readlink "$dest_path")" != "$source_path" ]; then
    ln -sfn "$source_path" "$dest_path"
    log_success "Created symlink: $source_path -> $dest_path"
  else
    log_info "Symlink already correctly set: $dest_path"
  fi
}

# Function to add GitHub CLI PPA
function ensure_github_cli_ppa() {
  if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
    log_info "Adding GitHub CLI PPA..."
    log_debug "Downloading GitHub CLI keyring"
    if curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null; then
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
      sudo apt update
      log_success "GitHub CLI PPA added successfully"
    else
      log_error "Failed to add GitHub CLI PPA"
      return 1
    fi
  else
    log_info "GitHub CLI PPA already configured"
  fi
}

# Function to install packages from GitHub releases (deb packages)
function install_github_deb() {
  local repo="$1"
  local package_name="$2"
  local deb_pattern="$3"

  # Check if already installed
  if command -v "$package_name" &>/dev/null; then
    log_info "$package_name is already installed"
    return 0
  fi

  log_info "Installing $package_name from GitHub releases..."

  # Get latest release download URL
  log_debug "Fetching latest release info from $repo"
  local download_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" |
    grep "browser_download_url.*$deb_pattern" |
    cut -d '"' -f 4 | head -1)

  if [ -z "$download_url" ]; then
    log_error "Failed to find download URL for $package_name"
    return 1
  fi

  log_debug "Download URL: $download_url"

  # Download and install
  local temp_dir=$(mktemp -d)
  local deb_file="$temp_dir/$package_name.deb"

  log_info "Downloading $package_name..."
  if curl -L "$download_url" -o "$deb_file"; then
    log_info "Installing $package_name with dpkg..."
    if sudo dpkg -i "$deb_file"; then
      log_success "$package_name installed successfully"
      rm -rf "$temp_dir"
      return 0
    else
      log_error "Failed to install $package_name with dpkg"
      rm -rf "$temp_dir"
      return 1
    fi
  else
    log_error "Failed to download $package_name"
    rm -rf "$temp_dir"
    return 1
  fi
}

# Function to install starship prompt
function install_starship() {
  if command -v starship &>/dev/null; then
    log_info "starship is already installed"
    return 0
  fi

  log_info "Installing starship prompt..."
  if curl -sS https://starship.rs/install.sh | sh -s -- --yes; then
    log_success "starship installed successfully"
    return 0
  else
    log_error "Failed to install starship"
    return 1
  fi
}

# Function to validate installation of critical components
function validate_installation() {
  local components=("$@")
  local all_found=true

  for component in "${components[@]}"; do
    if ! command -v "$component" &>/dev/null; then
      log_error "$component is not installed or not in PATH"
      all_found=false
    else
      log_debug "$component found in PATH"
    fi
  done

  if [ "$all_found" = true ]; then
    log_success "All required components are installed and accessible"
    return 0
  else
    return 1
  fi
}
