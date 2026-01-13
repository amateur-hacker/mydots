#!/bin/bash

# Check which waybar theme is set
THEMEIS=$(realpath ~/.config/waybar/style.css | sed 's/.*\/\(.*\)\.css/\1/')

# Change theme
if [ "$THEMEIS" == "style1" ]; then
  SWITCHTO="style2"
elif [ "$THEMEIS" == "style2" ]; then
  SWITCHTO="style3"
else
  SWITCHTO="style1"
fi

# Set the waybar theme
echo "$SWITCHTO.css"
THEMEFILE="$HOME/.config/waybar/styles/${SWITCHTO}.css"
if [ -f "$THEMEFILE" ]; then
  ln -sf "$THEMEFILE" "$HOME/.config/waybar/style.css"

else
  echo "Error: $THEMEFILE not found"
  exit 1
fi

pkill waybar
setsid -f waybar >/dev/null 2>&1 &
