# README

This repository contains my personal dotfiles and scripts to automate the setup of my development environment. The goal is to streamline the installation and configuration of the tools and applications I use regularly.

## Overview

- **install.sh**: The main script that orchestrates the installation and configuration of all modules.
- **modules/**: A directory containing individual modules for different tools and configurations.
  - Each module has its own installation script (`module_name.sh`) and may include a `config/` directory with configuration files.
- **common.sh**: A script located in `modules/` that contains common functions and utilities used across modules.

## Usage

1. **Make the `install.sh` script executable**:

   ```bash
   chmod +x install.sh
   ```

2. **Run the installation script**:

   ```bash
   ./install.sh
   ```

   This script will:

   - Ensure that `yay` (an AUR helper) is installed.
   - Synchronize package databases.
   - Install and configure each module listed in the `MODULES` array within `install.sh`.

## Modules

The installation and configuration are organized into modules for better modularity and maintainability. Below is a brief explanation of each module:

### asdf

- **Purpose**: Manages multiple runtime versions using [asdf](https://github.com/asdf-vm/asdf).

### gaming

- **Purpose**: Sets up gaming-related tools and configurations.

### git

- **Purpose**: Configures Git settings.

### hyprland

- **Purpose**: Installs and configures [Hyprland](https://github.com/hyprwm/Hyprland), a dynamic tiling Wayland compositor.
- **Notes**:
  - Clones and installs [Hyprdots](https://github.com/prasanthrangan/hyprdots).
  - Only symlinks `userprefs.conf` for custom settings.

### kitty

- **Purpose**: Installs and configures the [Kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator.

### misc

- **Purpose**: Handles miscellaneous installations and configurations that don't fit into other modules.

### neovim

- **Purpose**: Sets up [Neovim](https://neovim.io/) with custom configurations and plugins.
- **Features**:
  - Uses Lua for configuration.
  - Includes a rich set of plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

### solaar

- **Purpose**: Installs and configures [Solaar](https://pwr-solaar.github.io/Solaar/) for managing Logitech devices.
- **Notes**:
  - Adds the user to the `input` group for device access.
  - Customizes device settings via `config.yaml` and `rules.yaml`.

### tmux

- **Purpose**: Installs and configures [tmux](https://github.com/tmux/tmux), a terminal multiplexer.
- **Features**:
  - Custom key bindings and options.
  - Plugin management with [TPM](https://github.com/tmux-plugins/tpm).
  - Includes themes and additional plugins.

### zsh

- **Purpose**: Installs and configures [Zsh](https://www.zsh.org/) with custom settings and plugins.
- **Features**:
  - Sets Zsh as the default shell.
  - Includes plugins like `eza`, `zoxide`, `starship`, and `fzf`.

## Customization

- **Adding a New Module**:

  1. Copy `_example_module` and modify following tips within.

  Manually

  1. Create a new directory under `modules/` with the module's name.
  2. Add an installation script named `module_name.sh`.
  3. Include any configuration files in a `config/` subdirectory.
  4. Update the `MODULES` array in `install.sh` to include the new module.

- **Modifying Existing Modules**:

  - Edit the corresponding `module_name.sh` script to change installation steps.
  - Update configuration files in the `config/` directory as needed.

- **Running Specific Modules**:
  - Edit the `MODULES` array in `install.sh` to include only the modules you want to install or configure.

## Notes

- **Idempotency**: The scripts are designed to be idempotent. Running them multiple times should not cause unintended side effects.
- **Dependencies**:
  - The scripts assume an Arch Linux or Arch-based distribution due to the use of `pacman` and `yay`.
  - Ensure that `git` is installed, or the git module is enabled at the top of the list, before running `install.sh` since it's required for cloning repositories.
- **Permissions**:
  - Some scripts may require `sudo` privileges, especially when installing packages or modifying system configurations.
  - The `install.sh` script will prompt for your password when necessary.

## Troubleshooting

- **Module-Specific Issues**:

  - Check the corresponding `module_name.sh` script and logs for any errors during installation or configuration.

- **Common Issues**:
  - If a package fails to install, make sure your package databases are up to date and that you have an active internet connection.
  - Ensure that you have the necessary permissions to install packages and modify configurations.
