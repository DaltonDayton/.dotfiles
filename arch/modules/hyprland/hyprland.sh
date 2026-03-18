#!/usr/bin/bash

# Function to install the module
function install_hyprland() {
  # Define the list of packages required for this module
  local packages=(
    # Authentication Agent
    hyprpolkitagent

    # Qt Wayland Support
    qt5-wayland qt6-wayland

    # Fonts
    ttf-font-awesome
    otf-font-awesome
    noto-fonts
    noto-fonts-emoji

    # Utilities
    cliphist
    waybar
    hyprpaper
    hyprlauncher
    hypridle
    hyprlock
    pavucontrol
    pipewire-pulse
    jq # JSON processor for scripts
    btop
    spotify

    # File Extension Discovery
    xdg-utils
    desktop-file-utils
    shared-mime-info
    archlinux-xdg-menu
    # Also ran this, but idk if it's needed: `sudo update-mime-database /usr/share/mime`

    # Display manager
    sddm

    # Bluetooth utilities
    bluez       # Bluetooth protocol stack
    bluez-utils # Bluetooth utilities
    blueman     # Bluetooth manager GUI

    # Screenshot Utilities
    grim
    grimblast-git
    hyprpicker
    slurp
    satty
    wl-clipboard

    # gifs / mp4
    wf-recorder

    # OCR
    tesseract
    tesseract-data-eng

    # Voice Dictation
    voxtype # Push-to-talk voice-to-text (whisper.cpp based)
    wtype   # Wayland virtual keyboard (typing backend for voxtype)

    # Application Launcher / dmenu
    rofi # Window switcher, run dialog, dmenu replacement (Wayland native since 2.0)

    # # Essential utilities
    # "network-manager-applet"

    # # Enhanced tools and utilities
    # "rofi-wayland" # Application launcher (better than wofi)
    swaync # Notification center
    # "cliphist"     # Clipboard manager
    # "hyprshade"    # Blue light filter and screen effects
    # "hypridle"     # Idle daemon
    # "hyprlock"     # Screen locker
    # "hyprpicker"   # Color picker
    #
    # # Screenshot and media tools
    # "grim"  # Screenshot utility
    # "slurp" # Region selector for screenshots
    # "satty" # Screenshot annotation tool
    # "swww"  # Wallpaper daemon
    #
    # # System utilities
    # "playerctl"     # Media player control
    # "brightnessctl" # Brightness control
    # "pamixer"       # Audio control
    # "pavucontrol"   # Audio control GUI
    # "btop"          # Enhanced system monitor

    # # Themes and appearance
    # "catppuccin-gtk-theme-mocha" # GTK theme
    # "nwg-look"                   # Run nwg-look to configure themes
    # "hyprcursor"
    # "bibata-cursor-theme-bin"
    #
    # # "swayidle"
    # # "sway-audio-idle-inhibit-git"
  )

  # Install the packages using the install_packages function
  install_packages "${packages[@]}"

  # Proceed to configuration
  configure_hyprland
}

# Function to configure the module
function configure_hyprland() {
  # set -euo pipefail

  # Load device identity (sets DEVICE_NAME from ~/.config/device.env)
  load_device_env

  # hypr
  local config_source="$MODULES_DIR/hyprland/hypr"
  local config_dest="$HOME/.config/"
  symlink_config "$config_source" "$config_dest"

  # Deploy device-specific monitors config as a relative symlink within the repo,
  # falling back to default. Relative so the symlink is portable across machines.
  local hypr_dir="$MODULES_DIR/hyprland/hypr"
  local monitors_target
  if [ -f "$hypr_dir/monitors/${DEVICE_NAME}.conf" ]; then
    monitors_target="monitors/${DEVICE_NAME}.conf"
    log_info "Using monitors config for device: $DEVICE_NAME"
  else
    monitors_target="monitors/default.conf"
    log_warn "No monitors config found for '$DEVICE_NAME', falling back to default"
  fi
  ln -sfn "$monitors_target" "$hypr_dir/monitors.conf"
  log_success "Set monitors.conf -> $monitors_target"

  # Deploy device-specific hyprpaper config as a relative symlink within the repo,
  # falling back to default.
  local hyprpaper_target
  if [ -f "$hypr_dir/hyprpaper/${DEVICE_NAME}.conf" ]; then
    hyprpaper_target="hyprpaper/${DEVICE_NAME}.conf"
    log_info "Using hyprpaper config for device: $DEVICE_NAME"
  else
    hyprpaper_target="hyprpaper/default.conf"
    log_warn "No hyprpaper config found for '$DEVICE_NAME', falling back to default"
  fi
  ln -sfn "$hyprpaper_target" "$hypr_dir/hyprpaper.conf"
  log_success "Set hyprpaper.conf -> $hyprpaper_target"

  # waybar
  config_source="$MODULES_DIR/hyprland/waybar"
  config_dest="$HOME/.config/"
  symlink_config "$config_source" "$config_dest"

  # wallpapers
  config_source="$MODULES_DIR/hyprland/wallpapers"
  config_dest="$HOME/.config/wallpapers"
  symlink_config "$config_source" "$config_dest"

  # Enable and start bluetooth service if not already enabled/running
  if ! systemctl is-enabled bluetooth.service >/dev/null 2>&1; then
    log_info "Enabling bluetooth service..."
    sudo systemctl enable bluetooth.service
  fi

  if ! systemctl is-active bluetooth.service >/dev/null 2>&1; then
    log_info "Starting bluetooth service..."
    sudo systemctl start bluetooth.service
  fi

  # SDDM (display manager) setup
  configure_sddm

  # Voxtype (voice dictation) setup
  configure_voxtype

  # Swaync (notification center) setup
  configure_swaync

  # Cliphist (clipboard manager) setup
  configure_cliphist

  # Additional configuration steps can be added here
  # For example, setting environment variables, running setup scripts, etc.

  # May not be needed with hyprland.conf update and bibata-cursor-theme-bin
  # NOTE: rofi-wayland is now replaced by rofi 2.0+ which has native Wayland support
  # # Copy Bibata cursor themes from local dotfiles
  # local bibata_source="$MODULES_DIR/hyprland/Bibata-Cursors"
  # local icons_dest="$HOME/.local/share/icons"
  #
  # # Ensure icons directory exists
  # mkdir -p "$icons_dest"
  #
  # # Copy each Bibata theme
  # for theme in "Bibata-Modern-Amber" "Bibata-Modern-Classic" "Bibata-Modern-Ice"; do
  #   if [ -d "$bibata_source/$theme" ]; then
  #     if [ ! -d "$icons_dest/$theme" ]; then
  #       echo "Installing $theme cursor theme..."
  #       cp -r "$bibata_source/$theme" "$icons_dest/"
  #     else
  #       echo "$theme cursor theme is already installed."
  #     fi
  #   else
  #     echo "Warning: $theme not found in $bibata_source"
  #   fi
  # done

}

# Function to configure SDDM display manager
function configure_sddm() {
  local theme_dir="/usr/share/sddm/themes/catppuccin-mocha-pink"

  # Symlink sddm.conf — requires sudo as /etc is root-owned
  local config_source="$MODULES_DIR/hyprland/config/sddm.conf"
  local config_dest="/etc/sddm.conf"
  if [ "$(readlink "$config_dest" 2>/dev/null)" != "$config_source" ]; then
    log_info "Symlinking /etc/sddm.conf..."
    sudo ln -sfn "$config_source" "$config_dest"
    log_success "Symlinked /etc/sddm.conf -> $config_source"
  else
    log_info "/etc/sddm.conf already up to date"
  fi

  # Install catppuccin SDDM theme from dotfiles
  if [ ! -d "$theme_dir" ]; then
    log_info "Installing catppuccin-mocha-pink SDDM theme..."
    sudo mkdir -p "$theme_dir"
    sudo cp -r "$MODULES_DIR/hyprland/sddm-theme/." "$theme_dir/"
    log_success "catppuccin-mocha-pink SDDM theme installed"
  else
    log_info "catppuccin-mocha-pink SDDM theme already installed"
  fi

  # Deploy device-specific theme.conf if one exists (e.g. theme.laptop.conf)
  local theme_conf_source="$MODULES_DIR/hyprland/sddm-theme/theme.${DEVICE_NAME}.conf"
  if [ -f "$theme_conf_source" ]; then
    log_info "Deploying $DEVICE_NAME SDDM theme.conf..."
    sudo cp "$theme_conf_source" "$theme_dir/theme.conf"
    log_success "Deployed $DEVICE_NAME SDDM theme.conf"
  fi

  # Enable and start sddm service
  if ! systemctl is-enabled sddm.service >/dev/null 2>&1; then
    log_info "Enabling sddm service..."
    sudo systemctl enable sddm.service
  fi

  if ! systemctl is-active sddm.service >/dev/null 2>&1; then
    log_info "Starting sddm service..."
    sudo systemctl start sddm.service
  fi
}

# Function to configure voxtype voice dictation
function configure_voxtype() {
  local voxtype_dir="$MODULES_DIR/hyprland/voxtype"
  local config_dest="$HOME/.config/voxtype"
  local hypr_conf_source="$MODULES_DIR/hyprland/hypr/conf.d/voxtype-submap.conf"
  local hypr_conf_dest="$HOME/.config/hypr/conf.d/voxtype-submap.conf"

  # Deploy device-specific voxtype config as a relative symlink within the repo,
  # falling back to default.
  local config_target
  if [ -f "$voxtype_dir/configs/${DEVICE_NAME}.toml" ]; then
    config_target="configs/${DEVICE_NAME}.toml"
    log_info "Using voxtype config for device: $DEVICE_NAME"
  else
    config_target="configs/default.toml"
    log_warn "No voxtype config found for '$DEVICE_NAME', falling back to default"
  fi
  ln -sfn "$config_target" "$voxtype_dir/config.toml"
  log_success "Set voxtype config.toml -> $config_target"

  # Symlink voxtype config directory
  symlink_config "$voxtype_dir" "$config_dest"

  # Symlink voxtype submap config for compositor integration
  # Note: hyprland.conf already sources this file via the dotfiles repo config
  if [ -f "$hypr_conf_source" ]; then
    symlink_config "$hypr_conf_source" "$hypr_conf_dest"
  fi

  # Download the whisper model configured for this device
  if command -v voxtype >/dev/null 2>&1; then
    log_info "Downloading voxtype whisper model (if not already present)..."
    voxtype setup --download
  else
    log_warn "voxtype not found in PATH. Run manually after install: voxtype setup --download"
  fi

  # Install systemd user service if not already installed
  local service_file="$HOME/.config/systemd/user/voxtype.service"
  if [ -f "$service_file" ]; then
    log_info "Voxtype systemd service already installed"
  elif command -v voxtype >/dev/null 2>&1; then
    log_info "Installing voxtype systemd user service..."
    voxtype setup systemd
    voxtype setup compositor hyprland
  else
    log_warn "voxtype not found in PATH. Run manually after install:"
    log_warn "  voxtype setup systemd"
    log_warn "  voxtype setup compositor hyprland"
  fi
}

# Function to configure swaync notification center
function configure_swaync() {
  # Remove dunst if installed (conflicts with swaync)
  if pacman -Qi dunst &>/dev/null; then
    log_info "Removing dunst (replaced by swaync)"
    sudo pacman -Rns --noconfirm dunst
  fi

  local config_source="$MODULES_DIR/hyprland/swaync"
  local config_dest="$HOME/.config/swaync"
  symlink_config "$config_source" "$config_dest"
}

# Function to configure cliphist clipboard manager
function configure_cliphist() {
  local config_dir="$HOME/.config/cliphist"
  local config_file="$config_dir/config"
  local override_dir="$HOME/.config/systemd/user/cliphist.service.d"
  local override_file="$override_dir/config.conf"

  # Desired config content (max history to 100 items for security)
  local desired_config="max-items=100"

  # Desired systemd override content
  local desired_override
  desired_override="$(cat << EOF
[Unit]
# Remove hard dependency on graphical-session.target so it can start manually
Requisite=

[Service]
ExecStart=
ExecStart=/usr/bin/wl-paste --watch cliphist -config-path $config_file store
EOF
)"

  # Write cliphist config if missing or content has changed
  mkdir -p "$config_dir"
  if [ ! -f "$config_file" ] || [ "$(cat "$config_file")" != "$desired_config" ]; then
    log_info "Writing cliphist config (max-items=100)..."
    printf '%s\n' "$desired_config" > "$config_file"
  else
    log_info "Cliphist config already up to date"
  fi

  # Write systemd override if missing or content has changed
  mkdir -p "$override_dir"
  local needs_reload=false
  if [ ! -f "$override_file" ] || [ "$(cat "$override_file")" != "$desired_override" ]; then
    log_info "Writing cliphist systemd service override..."
    printf '%s\n' "$desired_override" > "$override_file"
    needs_reload=true
  else
    log_info "Cliphist systemd override already up to date"
  fi

  if [ "$needs_reload" = true ]; then
    systemctl --user daemon-reload
  fi

  # Enable cliphist service if not already enabled
  if ! systemctl --user is-enabled cliphist.service >/dev/null 2>&1; then
    log_info "Enabling cliphist service..."
    systemctl --user enable cliphist.service
  fi

  # Note: Service will auto-start on next graphical session login
  # Don't try to start it now if graphical-session.target isn't active
  if systemctl --user is-active graphical-session.target >/dev/null 2>&1; then
    if ! systemctl --user is-active cliphist.service >/dev/null 2>&1; then
      log_info "Starting cliphist service..."
      systemctl --user start cliphist.service
    fi
  else
    log_info "Cliphist service will auto-start on next login (graphical-session.target not active)"
  fi
}
