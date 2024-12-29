# README

This repository contains my personal dotfiles and scripts to automate the setup of my development environment. The goal is to streamline the installation and configuration of the tools and applications I use regularly.

## Table of Contents

- [Overview](#overview)
- [Usage](#usage)
- [Modules](#modules)
- [Customization](#customization)
  - [Adding a New Module](#adding-a-new-module)
  - [Modifying Existing Modules](#modifying-existing-modules)
  - [Running Specific Modules](#running-specific-modules)
- [Notes](#notes)
- [Troubleshooting](#troubleshooting)

## Overview

This repository contains my personal dotfiles and scripts to automate the setup of my development environment. The goal is to streamline the installation and configuration of the tools and applications I use regularly.

Key Features:

- **Modular Design**: Each tool or application is encapsulated in its own module for easier management and customization.
- **Idempotent**: The scripts are designed to run multiple times without causing unintended side effects.
- **Environment-Specific Configurations**: Easily adaptable for different setups, such as Arch Linux or WSL.

## Usage

1. **Create a `.env` file**:

   Copy the provided `.env_default` to `.env` and edit it to specify your environment:

   ```bash
   cp .env_default .env
   ```

   The `.env` file defines the environment (e.g., `arch` or `wsl`) and is required for the scripts to function correctly.

2. **Make the `install.sh` script executable**:

   ```bash
   chmod +x install.sh
   ```

3. **Run the installation script**:

   ```bash
   ./install.sh
   ```

   This script will:

   - Ensure that `yay` (an AUR helper) is installed.
   - Synchronize package databases.
   - Install and configure each module listed in the `MODULES` array within `install.sh`.

## Modules

The installation and configuration are organized into modules for better modularity and maintainability.

## Customization

### Adding a New Module

1. Copy the `_example_module` directory:

   ```bash
   cp -r modules/_example_module modules/<new_module_name>
   ```

2. Edit the `example_module.sh` script and rename it to `<new_module_name>.sh`.
3. Add any necessary configuration files under a `config/` directory within the module.
4. Update the `MODULES` array in `install.sh` to include `<new_module_name>`.

### Modifying Existing Modules

- Edit the corresponding `module_name.sh` script to change installation steps.
- Update configuration files in the `config/` directory as needed.

### Running Specific Modules

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

- **Common Issues**:

  - **Error: "Command not found" when running `install.sh`**:

    - Ensure the script is executable:
      ```bash
      chmod +x install.sh
      ```
    - Verify that your shell can locate the script:
      ```bash
      ./install.sh
      ```

  - **Error: "Package not found"**:

    - Check if the package is available in the official repositories or AUR.
    - Update your package databases:
      ```bash
      sudo pacman -Sy
      ```

  - **Environment variable-related errors**:
    - Ensure the `.env` file exists and is correctly configured:
      ```bash
      ENVIRONMENT=arch  # Example value
      ```
    - If `.env` is missing, recreate it from `.env_default`:
      ```bash
      cp .env_default .env
      ```

- **Module-Specific Issues**:
  - Check the corresponding `module_name.sh` script and logs for any errors during installation or configuration.
