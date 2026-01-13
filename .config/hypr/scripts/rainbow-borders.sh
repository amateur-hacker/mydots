#!/bin/bash

function random_hex() {
  random_hex="0xff$(openssl rand -hex 3)"
  echo "$random_hex"
}

hyprctl keyword general:col.active_border "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" 270deg

# hyprctl keyword general:col.inactive_border "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" "$(rainbow_index)" 270deg
