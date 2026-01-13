#!/bin/bash

SCRIPTSDIR=$HOME/.config/hypr/scripts

# Kill already running process
_ps=(waybar dunst)
for _prs in "${_ps[@]}"; do
  if [[ $(pidof ${_prs}) ]]; then
    pkill ${_prs}
  fi
done

# Lauch notification daemon (dunst)
${SCRIPTSDIR}/Dunst.sh &

# Lauch statusbar (waybar)
${SCRIPTSDIR}/Waybar.sh &

# Reload Hyprland config
hyprctl reload config-only

# Reload pyprland
pypr reload &
