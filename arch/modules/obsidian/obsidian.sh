#!/usr/bin/bash

function install_obsidian() {
  # Define the list of packages required for this module
  local packages=(
    "obsidian"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_obsidian
}

# Function to configure the module
function configure_obsidian() {
  # Create Obsidian vault directories if they don't exist
  local personal_vault="$HOME/vaults/Personal"
  local work_vault="$HOME/vaults/Work"

  if [ ! -d "$personal_vault" ]; then
    mkdir -p "$personal_vault"
    echo "Created Personal vault directory: $personal_vault"
  else
    echo "Personal vault directory already exists: $personal_vault"
  fi

  if [ ! -d "$work_vault" ]; then
    mkdir -p "$work_vault"
    echo "Created Work vault directory: $work_vault"
  else
    echo "Work vault directory already exists: $work_vault"
  fi
}
