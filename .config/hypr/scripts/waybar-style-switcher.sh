#!/usr/bin/env bash

# Get the current stylesheet name
CURRENT_STYLE=$(realpath ~/.config/waybar/style.css | sed 's|.*/\(.*\)\.css|\1|')

# Rotate to next style
if [ "$CURRENT_STYLE" == "style1" ]; then
  NEXT_STYLE="style2"
elif [ "$CURRENT_STYLE" == "style2" ]; then
  NEXT_STYLE="style3"
else
  NEXT_STYLE="style1"
fi

# Path to the new stylesheet
STYLE_FILE="$HOME/.config/waybar/styles/${NEXT_STYLE}.css"

# Apply the new style
if [ -f "$STYLE_FILE" ]; then
  ln -sf "$STYLE_FILE" "$HOME/.config/waybar/style.css"
  echo "Switched to style: $NEXT_STYLE"
else
  echo "Error: Style file not found: $STYLE_FILE"
  exit 1
fi

# Reload Waybar
pkill waybar
setsid -f waybar >/dev/null 2>&1 &
