#!/usr/bin/env bash

# Default window size (can be absolute pixels or percentage of monitor size).
# Example: "960" (px) or "50%" (percentage).
WIDTH=${1:-50%}
HEIGHT=${2:-50%}

# Pixel offset between stacked windows.
OFFSET=${3:-20}

# Get the active workspace ID.
WS_ID=$(hyprctl -j activewindow | jq '.workspace.id')

# Get all windows on that workspace, base64 encoded for safe parsing.
mapfile -t WINDOWS < <(hyprctl -j clients | jq -r ".[] | select(.workspace.id == ${WS_ID}) | @base64")

# Get the focused monitor's geometry.
MONITOR=$(hyprctl -j monitors | jq ".[] | select(.focused==true)")
MON_X=$(echo "$MONITOR" | jq '.x')
MON_Y=$(echo "$MONITOR" | jq '.y')
MON_W=$(echo "$MONITOR" | jq '.width')
MON_H=$(echo "$MONITOR" | jq '.height')

# Convert WIDTH & HEIGHT to pixels if they are given as percentages
if [[ "$WIDTH" == *% ]]; then
  WIDTH=$((MON_W * ${WIDTH%%%} / 100))
fi

if [[ "$HEIGHT" == *% ]]; then
  HEIGHT=$((MON_H * ${HEIGHT%%%} / 100))
fi

# Calculate centered position on monitor
CENTER_X=$((MON_X + (MON_W - WIDTH) / 2))
CENTER_Y=$((MON_Y + (MON_H - HEIGHT) / 2))

TOPMOST="" # Keep track of the last (topmost) window
INDEX=0    # Stack index counter

# Toggle all windows floating state
hyprctl dispatch workspaceopt allfloat

# Loop through each window in this workspace
for WIN_B64 in "${WINDOWS[@]}"; do
  # Decode JSON info for window
  WIN=$(echo "$WIN_B64" | base64 -d)

  # Extract active window's address and floating state
  ADDR=$(echo "$WIN" | jq -r '.address')
  FLOATING=$(echo "$WIN" | jq -r '.floating')

  # Compute position with incremental offset
  X=$((CENTER_X - OFFSET * INDEX))
  Y=$((CENTER_Y - OFFSET * INDEX))

  # If the window is not floating yet, resize and move it
  if [[ "$FLOATING" == "false" ]]; then
    hyprctl --batch "
        dispatch resizewindowpixel exact $WIDTH $HEIGHT,address:$ADDR;
        dispatch movewindowpixel exact $X $Y,address:$ADDR
    "
  fi

  # Update topmost window reference
  TOPMOST=$ADDR
  INDEX=$((INDEX + 1))
done

# Focus the last (topmost) window
if [[ -n "$TOPMOST" ]]; then
  hyprctl dispatch focuswindow address:$TOPMOST
fi
