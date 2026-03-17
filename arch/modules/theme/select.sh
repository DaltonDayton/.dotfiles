#!/usr/bin/bash
# Theme selector — launches rofi picker and applies the selected theme.

THEME_DIR="$(dirname "$(readlink -f "$0")")"
SWITCH_PY="$THEME_DIR/switch.py"
PALETTES_DIR="$THEME_DIR/palettes"

# Show display names in rofi
selected=$(python3 "$SWITCH_PY" list --rofi | rofi -dmenu -i -p " Theme")

[ -z "$selected" ] && exit 0

# Strip " (active)" suffix if present
selected="${selected% (active)}"

# Find the palette file whose meta.name matches the selection
for palette_file in "$PALETTES_DIR"/*.toml; do
    name=$(python3 -c "
import tomllib
with open('$palette_file', 'rb') as f:
    print(tomllib.load(f)['meta']['name'])
")
    if [ "$name" = "$selected" ]; then
        palette=$(basename "$palette_file" .toml)
        python3 "$SWITCH_PY" apply "$palette"
        exit 0
    fi
done
