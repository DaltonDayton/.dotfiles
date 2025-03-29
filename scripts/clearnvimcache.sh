#!/usr/bin/bash

BACKUP_DIR="$HOME/.nvim_cache_backup"
NVIM_DIRS=(
  "$HOME/.local/state/nvim/"
  "$HOME/.local/share/nvim/"
  "$HOME/.cache/nvim/"
)
DRY_RUN=false

function backup_nvim_cache() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would backup Neovim cache..."

    # Show what would be backed up
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    CURRENT_BACKUP="$BACKUP_DIR/$TIMESTAMP"
    echo "[DRY RUN] Would create backup directory: $CURRENT_BACKUP"

    for dir in "${NVIM_DIRS[@]}"; do
      if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")
        echo "[DRY RUN] Would backup $dir to $CURRENT_BACKUP/$dir_name"
      fi
    done
    return
  fi

  # Original backup code...
  echo "Backing up Neovim cache..."

  # Create backup directory with timestamp
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  CURRENT_BACKUP="$BACKUP_DIR/$TIMESTAMP"
  mkdir -p "$CURRENT_BACKUP"

  # Backup each directory
  for dir in "${NVIM_DIRS[@]}"; do
    if [ -d "$dir" ]; then
      dir_name=$(basename "$dir")
      echo "Backing up $dir to $CURRENT_BACKUP/$dir_name"
      cp -r "$dir" "$CURRENT_BACKUP/"
    fi
  done

  echo "Backup completed to $CURRENT_BACKUP"
}

function restore_nvim_cache() {
  # List available backups
  if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR")" ]; then
    echo "No backups available."
    return 1
  fi

  echo "Available backups:"
  ls -1 "$BACKUP_DIR" | cat -n

  # Ask user to select a backup
  echo -n "Enter backup number to restore (or 0 to cancel): "
  read selection

  if [ "$selection" = "0" ]; then
    echo "Restore cancelled."
    return 0
  fi

  # Get the selected backup directory
  backup_name=$(ls -1 "$BACKUP_DIR" | sed -n "${selection}p")
  if [ -z "$backup_name" ]; then
    echo "Invalid selection."
    return 1
  fi

  selected_backup="$BACKUP_DIR/$backup_name"

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would restore from $selected_backup"

    # Show what would be restored
    for dir in "${NVIM_DIRS[@]}"; do
      dir_name=$(basename "$dir")
      if [ -d "$selected_backup/$dir_name" ]; then
        echo "[DRY RUN] Would restore $selected_backup/$dir_name to $dir"
      fi
    done
    return
  fi

  # Restore each directory
  for dir in "${NVIM_DIRS[@]}"; do
    dir_name=$(basename "$dir")
    if [ -d "$selected_backup/$dir_name" ]; then
      echo "Restoring $dir_name..."
      rm -rf "$dir"
      mkdir -p "$(dirname "$dir")"
      cp -r "$selected_backup/$dir_name" "$(dirname "$dir")"
    fi
  done

  echo "Restore completed from $selected_backup"
}

function clear_nvim_cache() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would clear Neovim cache..."
    for dir in "${NVIM_DIRS[@]}"; do
      if [ -d "$dir" ]; then
        echo "[DRY RUN] Would remove $dir"
      fi
    done
    return
  fi

  echo "Clearing Neovim cache..."
  for dir in "${NVIM_DIRS[@]}"; do
    if [ -d "$dir" ]; then
      echo "Removing $dir"
      rm -rf "$dir"
    fi
  done
  echo "Cache cleared."
}

# Function to display help
function show_help() {
  echo "Usage: $0 [--dry-run|-n] [--help|-h] {backup|restore|clear}"
  echo "  --dry-run, -n  - Show what would be done without making changes"
  echo "  --help, -h     - Display this help message"
  echo "  backup         - Create a backup of Neovim cache files"
  echo "  restore        - Restore a previous backup"
  echo "  clear          - Clear all Neovim cache files"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run | -n)
    DRY_RUN=true
    shift
    ;;
  --help | -h)
    COMMAND="help"
    shift
    ;;
  backup | restore | clear)
    COMMAND=$1
    shift
    ;;
  *)
    echo "Unknown option: $1"
    echo "Usage: $0 [--dry-run|-n] [--help|-h] {backup|restore|clear}"
    exit 1
    ;;
  esac
done

# Main menu
case "$COMMAND" in
backup)
  backup_nvim_cache
  ;;
restore)
  restore_nvim_cache
  ;;
clear)
  clear_nvim_cache
  ;;
help)
  show_help
  ;;
*)
  show_help
  ;;
esac
