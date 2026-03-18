#!/usr/bin/bash

# Function to install the theme module
function install_theme() {
  local packages=(
    "python-jinja" # Jinja2 templating engine
  )

  install_packages "${packages[@]}"

  configure_theme
}

# Function to configure the theme module
function configure_theme() {
  local theme_dir="$MODULES_DIR/theme"
  local switch_py="$theme_dir/switch.py"

  # Ensure generated directory exists
  mkdir -p "$theme_dir/generated"

  # Apply current theme (or default to catppuccin-mocha)
  local current_theme="catppuccin-mocha"
  if [ -f "$theme_dir/current.toml" ]; then
    current_theme=$(python3 -c "
import tomllib
with open('$theme_dir/current.toml', 'rb') as f:
    print(tomllib.load(f).get('theme', 'catppuccin-mocha'))
")
  fi

  log_info "Applying theme: $current_theme"
  python3 "$switch_py" apply "$current_theme"
}
