#!/usr/bin/env python3
import os
import shutil
import datetime
import argparse

# List of Neovim config directories
NVIM_DIRS = ["~/.local/state/nvim/", "~/.local/share/nvim/", "~/.cache/nvim/"]

# Parse command-line arguments for backup name
parser = argparse.ArgumentParser(description="Backup Neovim config directories.")
parser.add_argument(
    "--name",
    "-n",
    type=str,
    default="nvim_backup",
    help="Base name for the backup. Directory will be created in the format [name]_ddMMMyy_HHMMSS",
)
args = parser.parse_args()

# Define the backup root directory in HOME
home_dir = os.path.expanduser("~")
backup_base = os.path.join(home_dir, "neovim_backups")
os.makedirs(backup_base, exist_ok=True)

# Create a timestamp in the format ddMMMyy_HHMMSS (e.g., 29Mar23_112237)
timestamp = datetime.datetime.now().strftime("%d%b%y_%H%M%S")
backup_dir = os.path.join(backup_base, f"{args.name}_{timestamp}")
os.makedirs(backup_dir, exist_ok=True)

# Copy each directory into the backup folder with unique names
for src in NVIM_DIRS:
    src_expanded = os.path.expanduser(src)
    if os.path.exists(src_expanded):
        # Combine parent directory name with the current directory name to avoid collisions
        parent_name = os.path.basename(os.path.dirname(src_expanded.rstrip(os.sep)))
        folder_name = (
            f"{parent_name}_{os.path.basename(os.path.normpath(src_expanded))}"
        )
        dst = os.path.join(backup_dir, folder_name)
        shutil.copytree(src_expanded, dst)
        print(f"Backed up {src_expanded} to {dst}")
    else:
        print(f"Directory {src_expanded} does not exist.")

