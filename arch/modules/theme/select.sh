#!/usr/bin/bash
# Theme selector — launches rofi picker and applies the selected theme.

THEME_DIR="$(dirname "$(readlink -f "$0")")"
SWITCH_PY="$THEME_DIR/switch.py"

# Get list of palettes, format for rofi
# Output: "name  Display Name (type)" with * for current
selected=$(python3 "$SWITCH_PY" list | rofi -dmenu -i -p " Theme")

# Extract palette name (first word)
palette=$(echo "$selected" | awk '{print $1}')

if [ -n "$palette" ]; then
    python3 "$SWITCH_PY" apply "$palette"
fi
