# README

This repository contains my personal dotfiles and configuration scripts for various operating systems and environments. It's organized into directories based on the specific setup, making it easier to manage and deploy configurations as needed.

## Directory Structure

- **arch/**: Configuration files and installation scripts for Arch Linux.
- **nixos/**: Configuration files and scripts for NixOS.
- **wsl/**: Configurations for Windows Subsystem for Linux.
- **other_configs/**: Miscellaneous configuration files and scripts that don't fit into the other categories.

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
