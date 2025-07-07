#!/usr/bin/env bash

# Variables
DATE=$(date +%Y-%m-%d_%H-%M-%S)
DIR="$HOME/Pictures/Screenshots"
FILE="$DIR/$DATE.png"
NOTIFY_ICON="$FILE"

# Ensure directory exists
mkdir -p "$DIR"

# Take screenshot based on argument
case "$1" in
full)
  maim "$FILE"
  ;;
area)
  maim -s "$FILE"
  ;;
window)
  maim -i $(xdotool getactivewindow) "$FILE"
  ;;
clipboard)
  maim | xclip -selection clipboard -t image/png
  dunstify "󰹑 Screenshot copied to clipboard"
  exit 0
  ;;
*)
  echo "Usage: $0 {full|area|window|clipboard}"
  exit 1
  ;;
esac

# Copy to clipboard
xclip -selection clipboard -t image/png -i "$FILE"

# Send notification with image preview
dunstify -u low -i "$NOTIFY_ICON" "󰹑 Screenshot Saved & Copied" "$FILE"

# Optionally: Open image viewer (e.g. viewnior, feh)
# Uncomment if you want auto-open
# viewnior "$FILE" &

exit 0
