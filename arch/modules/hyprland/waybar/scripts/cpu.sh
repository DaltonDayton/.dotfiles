#!/bin/bash
# CPU usage and temperature script for waybar

# Get CPU usage (percentage)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | awk '{printf "%3.0f", $1}')

# Get CPU temperature
CPU_TEMP=$(sensors | grep "Tctl:" | awk '{print $2}' | sed 's/+//;s/°C//')

# Format output
printf "<span size=\"13000\" foreground=\"#cba6f7\">⬡</span> %s%% %s°C" "$CPU_USAGE" "$CPU_TEMP"
