#!/bin/bash

APP_COMMAND=("$@")

# Check if the command exists
if ! command -v "${APP_COMMAND[0]}" &>/dev/null; then
  echo "Error: Command '${APP_COMMAND[0]}' not found."
  exit 1
fi

# Launch the app in the background
"${APP_COMMAND[@]}" &

APP_PID=$!

# Wait for the app's window to appear and be focused (timeout 5s max)
TIMEOUT=50 # number of 0.1s intervals = 5 seconds
while ((TIMEOUT > 0)); do
  sleep 0.1

  # Get focused window PID (use jq to parse activewindow info)
  FOCUSED_PID=$(hyprctl activewindow -j | jq -r '.pid // empty')

  if [[ "$FOCUSED_PID" == "$APP_PID" ]]; then
    break
  fi

  ((TIMEOUT--))
done

if ((TIMEOUT == 0)); then
  echo "Warning: Window for '${APP_COMMAND[0]}' not detected or not focused in time."
fi

# Now get window position and size
WINDOW_INFO=$(hyprctl activewindow -j)

AT_X=$(echo "$WINDOW_INFO" | jq '.at[0]')
AT_Y=$(echo "$WINDOW_INFO" | jq '.at[1]')
SIZE_W=$(echo "$WINDOW_INFO" | jq '.size[0]')
SIZE_H=$(echo "$WINDOW_INFO" | jq '.size[1]')

CENTER_X=$((AT_X + SIZE_W / 2))
CENTER_Y=$((AT_Y + SIZE_H / 2))

# Warp the cursor
hyprctl dispatch cursorpos "$CENTER_X" "$CENTER_Y"
