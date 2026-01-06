#!/usr/bin/env bash
# OCR Screenshot Script for Hyprland
# Takes a screenshot, extracts text using tesseract, and copies to clipboard

set -e

# Temp files
TEMP_SCREENSHOT="/tmp/ocr-screenshot.png"
TEMP_OUTPUT="/tmp/ocr-result"

# Cleanup on exit
cleanup() {
    rm -f "$TEMP_SCREENSHOT" "${TEMP_OUTPUT}.txt"
}
trap cleanup EXIT

# Take screenshot with freeze (region/window selection)
grimblast --freeze copysave area "$TEMP_SCREENSHOT"

# Perform OCR
if tesseract "$TEMP_SCREENSHOT" "$TEMP_OUTPUT" -l eng 2>/dev/null; then
    # Extract text and copy to clipboard
    if [[ -f "${TEMP_OUTPUT}.txt" ]]; then
        cat "${TEMP_OUTPUT}.txt" | wl-copy
        notify-send "OCR" "Text extracted and copied to clipboard" -i "$TEMP_SCREENSHOT"
    else
        notify-send "OCR Error" "Failed to extract text" -u critical
        exit 1
    fi
else
    notify-send "OCR Error" "Tesseract failed to process image" -u critical
    exit 1
fi
