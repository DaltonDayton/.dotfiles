# README

This repository contains my personal dotfiles and configuration scripts for various operating systems and environments. It's organized into directories based on the specific setup, making it easier to manage and deploy configurations as needed.

## Directory Structure

- **arch/**: Configuration files and installation scripts for Arch Linux. Also ArchWSL
- **nixos/**: Configuration files and scripts for NixOS.
- **other_configs/**: Miscellaneous configuration files that don't fit into the other categories.
- **scripts/**: Miscellaneous scripts
- **wsl_ubuntu/**: Configurations for Windows Subsystem for Linux. (Ubuntu)

## Usage

### Cloning the Repository

Clone this repository to your home directory (or any location you prefer):

```bash
git clone https://github.com/DaltonDayton/.dotfiles.git ~/.dotfiles
```

## Notes

- **Backup Existing Configurations:** Before running any installation scripts or applying configurations, it's recommended to back up your existing configuration files to prevent any loss of personalized settings.

- **Review Scripts and Configurations:** Make sure to review the scripts and configuration files to understand the changes that will be made to your system.

- **Permissions:** Some scripts may require elevated permissions (e.g., `sudo`) to install packages or modify system configurations. You will be prompted for your password when necessary.

- **Idempotency:** The scripts are designed to be idempotent, meaning they can be run multiple times without causing unintended side effects.

## Windows and ArchWSL

### Terminal (Windows)

1. Download [Alacritty](https://alacritty.org/)
1. Install CaskaydiaCove Nerd Font
   - [Nerd Fonts - Downloads](https://www.nerdfonts.com/font-downloads)
1. Copy alacritty.toml from `../other_configs/alacritty.toml` to `C:\Users\[user]\AppData\Roaming\alacritty\alacritty.toml`
   - Create the file/directory if needed

### WSL

1. Install WSL2
   - `wsl --install`
2. Restart
3. Install [ArchWSL](https://github.com/yuk7/ArchWSL)
4. [Set up user](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/#set-up-the-default-user)
5. ~~? This one might be done by gh auth login ?~~
   - ~~install openssh and ssh-keygen based on github's docs~~
   - ~~`sudo pacman -Syu openssh`~~
   - ~~`ssh-keygen -t ed25519 -C "50755420+DaltonDayton@users.noreply.github.com"`~~
6. Authorize `gh auth login`
7. `git clone git@github.com:DaltonDayton/.dotfiles.git`
