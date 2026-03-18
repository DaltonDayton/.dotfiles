#!/usr/bin/bash

# NVIDIA driver module for Optimus laptops (iGPU + dGPU)
#
# What this module does:
#   1. Installs NVIDIA driver packages (DKMS-based for kernel compatibility)
#   2. Configures early KMS by adding NVIDIA modules to the initramfs
#   3. Enables nvidia_drm.modeset=1 via modprobe (required for Wayland compositors)
#   4. On Optimus laptops, restricts Xorg/SDDM to the Intel iGPU to prevent
#      NVIDIA segfaults on warm reboot
#
# Why nvidia_drm.modeset=1?
#   Wayland compositors (Hyprland, Sway, etc.) require atomic kernel modesetting
#   to manage display outputs. Without it, the NVIDIA DRM driver falls back to
#   legacy modesetting which causes display issues and crashes.
#
# Why early KMS (initramfs modules)?
#   Loading NVIDIA modules early ensures modeset is active before the display
#   manager starts. Without this, the modules may load after the compositor
#   has already initialized, causing a race condition.
#
# Note on AQ_NO_MODIFIERS:
#   If external monitors freeze on resolution changes through USB-C docks,
#   set env = AQ_NO_MODIFIERS,1 in hyprland.conf. This disables DRM buffer
#   modifiers that can cause issues with Intel iGPU outputs through docks.

function install_nvidia() {
  local packages=(
    nvidia-dkms
    nvidia-open-dkms
    linux-zen-headers
    nvidia-utils
    lib32-nvidia-utils
    egl-wayland
  )

  install_packages "${packages[@]}"

  configure_nvidia
}

function configure_nvidia() {
  load_device_env

  configure_nvidia_modeset
  configure_nvidia_initramfs

  # On Optimus laptops, restrict Xorg to the Intel iGPU to prevent NVIDIA
  # from segfaulting on warm reboot due to dirty GPU state.
  if [ "$DEVICE_NAME" = "laptop" ]; then
    configure_nvidia_xorg
  fi
}

# Enable nvidia_drm.modeset=1 via modprobe.d (persistent across kernel updates)
function configure_nvidia_modeset() {
  local modprobe_source="$MODULES_DIR/nvidia/config/nvidia-modeset.conf"
  local modprobe_dest="/etc/modprobe.d/nvidia-modeset.conf"

  if [ "$(readlink "$modprobe_dest" 2>/dev/null)" != "$modprobe_source" ]; then
    log_info "Symlinking $modprobe_dest..."
    sudo ln -sfn "$modprobe_source" "$modprobe_dest"
    log_success "Symlinked $modprobe_dest -> $modprobe_source"
  else
    log_info "$modprobe_dest already up to date"
  fi
}

# Add NVIDIA modules to initramfs for early KMS
function configure_nvidia_initramfs() {
  local mkinitcpio_conf="/etc/mkinitcpio.conf"
  local nvidia_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

  # Check if NVIDIA modules are already in MODULES=()
  local current_modules
  current_modules=$(grep '^MODULES=' "$mkinitcpio_conf" | sed 's/MODULES=(\(.*\))/\1/')

  if echo "$current_modules" | grep -q "nvidia"; then
    log_info "NVIDIA modules already in $mkinitcpio_conf"
    return
  fi

  log_info "Adding NVIDIA modules to $mkinitcpio_conf..."
  if [ -z "$current_modules" ]; then
    # MODULES=() is empty
    sudo sed -i "s/^MODULES=()/MODULES=($nvidia_modules)/" "$mkinitcpio_conf"
  else
    # MODULES=(...) has existing entries — append
    sudo sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 $nvidia_modules)/" "$mkinitcpio_conf"
  fi
  log_success "Added NVIDIA modules to initramfs config"

  log_info "Rebuilding initramfs..."
  sudo mkinitcpio -P
  log_success "Initramfs rebuilt"
}

# Restrict Xorg to the Intel iGPU on Optimus laptops
function configure_nvidia_xorg() {
  local xorg_source="$MODULES_DIR/nvidia/config/xorg-optimus.conf"
  local xorg_dest="/etc/X11/xorg.conf.d/20-nvidia-ignore.conf"

  if [ "$(readlink "$xorg_dest" 2>/dev/null)" != "$xorg_source" ]; then
    log_info "Symlinking $xorg_dest..."
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo ln -sfn "$xorg_source" "$xorg_dest"
    log_success "Symlinked $xorg_dest -> $xorg_source"
  else
    log_info "$xorg_dest already up to date"
  fi
}
