#!/usr/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Enhanced error handling
trap 'handle_error $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "%s " "${FUNCNAME[@]}")' ERR

# shellcheck disable=SC2317  # Function called via trap
handle_error() {
  local exit_code=$1
  local line_number=$2
  # shellcheck disable=SC2034  # Used for debugging, may be needed in future
  local bash_line_number=$3
  local last_command=$4
  local function_stack=$5

  echo
  echo -e "\033[0;31m================================================\033[0m"
  echo -e "\033[0;31m  INSTALLATION FAILED\033[0m"
  echo -e "\033[0;31m================================================\033[0m"
  echo -e "\033[0;31mError Code:\033[0m $exit_code"
  echo -e "\033[0;31mLine Number:\033[0m $line_number"
  echo -e "\033[0;31mCommand:\033[0m $last_command"
  if [ -n "$function_stack" ]; then
    echo -e "\033[0;31mFunction Stack:\033[0m $function_stack"
  fi
  if [ -n "$CURRENT_MODULE" ]; then
    echo -e "\033[0;31mFailed Module:\033[0m $CURRENT_MODULE"
  fi
  if [ -n "$LOG_FILE" ]; then
    echo -e "\033[0;31mLog File:\033[0m $LOG_FILE"
  fi
  echo -e "\033[0;31m================================================\033[0m"
  exit "$exit_code"
}

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
# shellcheck source=modules/common.sh
source "$MODULES_DIR/common.sh"

# Parse command line arguments and initialize logging
parse_arguments "$@"
initialize_logging

# Ensure 'yay' is installed
ensure_yay_installed

log_info "Synchronizing package databases..."
yay -Sy --noconfirm

MODULES=(
  # "git"
  # "shell"
  # "tmux"
  # "asdf"
  # "python"
  # "neovim"
  # "misc"
  # "kitty"
  # "solaar"
  # "fonts"
  # "hyprland"
)

# Process all modules
TOTAL_MODULES=${#MODULES[@]}
CURRENT_MODULE_NUM=0
FAILED_MODULES=()
SUCCESSFUL_MODULES=()

log_info "Found $TOTAL_MODULES modules to process"

for module in "${MODULES[@]}"; do
  CURRENT_MODULE_NUM=$((CURRENT_MODULE_NUM + 1))

  if run_module "$module" "$CURRENT_MODULE_NUM" "$TOTAL_MODULES" "$MODULES_DIR"; then
    SUCCESSFUL_MODULES+=("$module")
  else
    FAILED_MODULES+=("$module")
  fi
done

# Show final summary and exit with appropriate code
if show_final_summary SUCCESSFUL_MODULES FAILED_MODULES; then
  exit 0
else
  exit 1
fi
