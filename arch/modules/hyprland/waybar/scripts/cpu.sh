#!/bin/bash
# CPU usage and temperature script for waybar

# Get CPU usage (percentage, integer)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%3.0f", 100 - $1}')

# Get CPU temperature (integer, rounded)
CPU_TEMP=$(sensors | grep "Tctl:" | awk '{printf "%2.0f", $2}' | sed 's/\.0//')

# Format output with fixed width using monospace for numbers
printf "<span size=\"13000\" foreground=\"#cba6f7\">⬡</span> <span font_family=\"monospace\">%s%% %s°C</span>" "$CPU_USAGE" "$CPU_TEMP"
