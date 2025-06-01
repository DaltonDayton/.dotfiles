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
- **Dependency Management**: Automatic resolution and installation of module dependencies in the correct order.
- **Idempotent**: The scripts are designed to run multiple times without causing unintended side effects.
- **Environment-Specific Configurations**: Easily adaptable for different setups, such as Arch Linux or WSL.

## Usage

1. **Make the `install.sh` script executable**:

   ```bash
   chmod +x install.sh
   ```

2. **Run the installation script**:

   ```bash
   ./install.sh           # Normal installation
   ./install.sh --dry-run # Preview what would be installed
   ./install.sh --help    # Show usage information
   ```

   On first run, the script will automatically:
   - **Detect your environment** (Arch Linux or WSL)
   - **Prompt for configuration** with smart defaults
   - **Create the `.env` file** automatically
   - **Use existing git configuration** when available

   The script will then:
   - Ensure that `yay` (an AUR helper) is installed.
   - Synchronize package databases.
   - **Resolve module dependencies** automatically.
   - **Install modules in the correct order** based on their dependencies.
   - Install and configure each module listed in the `MODULES` array within `install.sh`.

### Manual .env Configuration (Optional)

If you prefer to configure manually, you can still:

```bash
cp .env_default .env
# Edit .env with your preferred settings
```

4. Close the terminal completely (or exit WSL)
5. Reopen and allow the new shell to install
6. (Optional) Exit and restart the terminal one last time

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
4. **Declare dependencies** in `modules/dependencies.sh`:
   ```bash
   declare_module_dependencies "<new_module_name>" "git" "misc"
   ```
5. Update the `MODULES` array in `install.sh` to include `<new_module_name>`.

### Modifying Existing Modules

- Edit the corresponding `module_name.sh` script to change installation steps.
- Update configuration files in the `config/` directory as needed.

### Running Specific Modules

- Edit the `MODULES` array in `install.sh` to include only the modules you want to install or configure.

### Dependency Management

The system automatically manages dependencies between modules:

- **Automatic Resolution**: Dependencies are resolved using topological sorting to ensure correct installation order.
- **Circular Dependency Detection**: The system detects and prevents circular dependencies.
- **Missing Dependency Warnings**: If a dependency is missing, the system shows a warning but continues installation.

**Current Dependencies:**
- `neovim`, `tmux`, `shell`, `asdf`, `hyprland` → depend on `git`
- `python` → depends on `asdf`
- `kitty`, `solaar`, `insync`, `gaming` → depend on `misc` (for fonts)

**Testing and Validation:**
```bash
./test_dependencies.sh  # Validate dependency declarations
./test_env_setup.sh     # Test environment detection
./install.sh --dry-run  # Preview installation without changes
```

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
    - The script should automatically create the `.env` file on first run
    - If you encounter issues, you can manually recreate it:
      ```bash
      rm .env  # Remove the problematic file
      ./install.sh  # Run again to trigger the setup wizard
      ```
    - Or create it manually from the template:
      ```bash
      cp .env_default .env
      # Edit .env with your settings
      ```

- **Module-Specific Issues**:
  - Check the corresponding `module_name.sh` script and logs for any errors during installation or configuration.
