#!/bin/bash
# 🖤 Static Catppuccin Mocha Borders for Hyprland

# Ordered Mocha accent colors for a smooth gradient
mocha_border_colors=(
  "0xfff38ba8" # Red
  "0xfffab387" # Peach
  "0xfff9e2af" # Yellow
  "0xffa6e3a1" # Green
  "0xff94e2d5" # Teal
  "0xff89b4fa" # Blue
  "0xffb4befe" # Lavender
  "0xffcba6f7" # Mauve
  "0xfff5c2e7" # Pink
  "0xffeba0ac" # Rosewater
)

# Join them into a single string
border_colors="${mocha_border_colors[*]}"

# Set active border with a 270deg gradient
hyprctl keyword general:col.active_border $border_colors 270deg

# Optional: same gradient for inactive (commented out)
#hyprctl keyword general:col.inactive_border $border_colors 270deg
