#!/usr/bin/env python3
import os
import shutil
import datetime
import argparse
import sys

# List of Neovim config directories
NVIM_DIRS = ["~/.local/state/nvim/", "~/.local/share/nvim/", "~/.cache/nvim/"]

# Define the backup root directory in HOME
home_dir = os.path.expanduser("~")
backup_base = os.path.join(home_dir, "neovim_backups")
os.makedirs(backup_base, exist_ok=True)

# Setup command-line arguments with mutually exclusive modes
parser = argparse.ArgumentParser(
    description="Backup, restore, or clear Neovim config directories."
)
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("--backup", "-b", action="store_true",
                   help="Create a backup of the Neovim config directories")
group.add_argument("--restore", "-r", action="store_true",
                   help="Restore Neovim config directories from a backup")
group.add_argument("--clear", "-c", action="store_true",
                   help="Completely clear the Neovim configuration directories (state, share, cache)")
parser.add_argument("--name", "-n", type=str, default="nvim_backup",
                    help="Base name for the backup (used only in backup mode). "
                         "The backup directory will be named in the format [name]_ddMMMyy_HHMMSS")

# If no arguments are provided, show help and exit.
if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(0)

args = parser.parse_args()


def get_backup_mapping():
    """
    Returns a mapping between unique backup subfolder names and their corresponding original directories.
    For example, "~/.local/state/nvim/" maps to a key like "state_nvim".
    """
    mapping = {}
    for src in NVIM_DIRS:
        src_expanded = os.path.expanduser(src)
        parent_name = os.path.basename(
            os.path.dirname(src_expanded.rstrip(os.sep)))
        key = f"{parent_name}_{os.path.basename(
            os.path.normpath(src_expanded))}"
        mapping[key] = src_expanded
    return mapping


def clear_directories():
    """
    Completely removes all Neovim config directories.
    """
    for src in NVIM_DIRS:
        src_expanded = os.path.expanduser(src)
        if os.path.exists(src_expanded):
            shutil.rmtree(src_expanded)
            print(f"Cleared {src_expanded}")
        else:
            print(f"Directory {src_expanded} does not exist, skipping.")


if args.clear:
    confirm = input(
        "This will permanently delete your Neovim configuration directories. Proceed? (y/N): ").strip()
    if confirm.lower() != "y":
        print("Aborting clear operation.")
        sys.exit(0)
    clear_directories()
    sys.exit(0)

if args.restore:
    # List available backups
    backup_dirs = sorted(
        d for d in os.listdir(backup_base)
        if os.path.isdir(os.path.join(backup_base, d))
    )
    if not backup_dirs:
        print(f"No backups found in {backup_base}.")
        sys.exit(1)
    print("Available backups:")
    for i, backup in enumerate(backup_dirs):
        print(f"{i+1}. {backup}")
    try:
        selection = input("Select a backup by number: ").strip()
        idx = int(selection) - 1
        if idx < 0 or idx >= len(backup_dirs):
            print("Invalid selection.")
            sys.exit(1)
    except Exception:
        print("Invalid input.")
        sys.exit(1)
    selected_backup = os.path.join(backup_base, backup_dirs[idx])
    print(f"Restoring backup from {selected_backup}")

    # Mapping from backup subfolder names to their original directories
    restore_mapping = get_backup_mapping()

    confirm = input(
        "This will overwrite your current Neovim configuration. Proceed? (y/N): ").strip()
    if confirm.lower() != "y":
        print("Aborting restore.")
        sys.exit(0)

    # For each configuration directory, clear it and restore from the backup
    for subfolder, target_dir in restore_mapping.items():
        backup_subfolder = os.path.join(selected_backup, subfolder)
        if os.path.exists(backup_subfolder):
            if os.path.exists(target_dir):
                shutil.rmtree(target_dir)
            shutil.copytree(backup_subfolder, target_dir)
            print(f"Restored {backup_subfolder} to {target_dir}")
        else:
            print(f"Backup does not contain expected folder: {subfolder}")
    print("Restore completed.")

elif args.backup:
    # Create a timestamp in the format ddMMMyy_HHMMSS (e.g., 29Mar23_112237)
    timestamp = datetime.datetime.now().strftime("%d%b%y_%H%M%S")
    backup_dir = os.path.join(backup_base, f"{args.name}_{timestamp}")
    os.makedirs(backup_dir, exist_ok=True)

    # Copy each configuration directory into the backup directory with unique subfolder names
    for src in NVIM_DIRS:
        src_expanded = os.path.expanduser(src)
        if os.path.exists(src_expanded):
            parent_name = os.path.basename(
                os.path.dirname(src_expanded.rstrip(os.sep)))
            folder_name = f"{parent_name}_{
                os.path.basename(os.path.normpath(src_expanded))}"
            dst = os.path.join(backup_dir, folder_name)
            shutil.copytree(src_expanded, dst)
            print(f"Backed up {src_expanded} to {dst}")
        else:
            print(f"Directory {src_expanded} does not exist.")
    print("Backup completed.")
