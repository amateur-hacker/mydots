#!/usr/bin/env bash

iDIR="$HOME/.config/dunst/icons"
step=10

# Pick icon based on brightness level
get_icon() {
  local level=$1
  if [ "$level" -le 20 ]; then
    echo "$iDIR/brightness-20.png"
  elif [ "$level" -le 40 ]; then
    echo "$iDIR/brightness-40.png"
  elif [ "$level" -le 60 ]; then
    echo "$iDIR/brightness-60.png"
  elif [ "$level" -le 80 ]; then
    echo "$iDIR/brightness-80.png"
  else echo "$iDIR/brightness-100.png"; fi
}

# Notify user
notify_user() {
  local level=$1
  notify-send -e \
    -h string:x-canonical-private-synchronous:brightness_notif \
    -h int:value:$level -u low \
    -i "$(get_icon "$level")" \
    "Brightness: $level%"
}

# Get brightness
get_brightness() {
  local target=$1 id=$2
  if [ "$target" = internal ]; then
    brightnessctl -m | cut -d, -f4 | tr -d '%'
  else
    ddcutil --display "$id" getvcp 10 2>/dev/null |
      awk -F 'value =' '/current value/ {gsub(",", "", $2); print $2}' |
      awk '{print $1}'
  fi
}

# Set brightness
set_brightness() {
  local target=$1 id=$2 value=$3
  if [ "$target" = internal ]; then
    brightnessctl set "$value%"
  else
    ddcutil --display "$id" setvcp 10 "$value" >/dev/null
  fi
}

# Change brightness (get/inc/dec/set/low/high)
change_brightness() {
  local target=$1 action=$2 value=$3 id=$4
  local current new

  current=$(get_brightness "$target" "$id")

  case "$action" in
  get)
    echo "$current"
    return
    ;;
  inc) new=$((current + step)) ;;
  dec) new=$((current - step)) ;;
  set) new=$value ;;
  low) new=5 ;;
  high) new=100 ;;
  esac

  ((new < 5)) && new=5
  ((new > 100)) && new=100

  set_brightness "$target" "$id" "$new"
  notify_user "$new"
}

# Loop external monitors
for_each_monitor() {
  local action=$1 value=$2
  for id in $(hyprctl monitors -j |
    jq -r '.[] | select(.name|test("^eDP")==false) | .id'); do
    change_brightness monitor "$action" "$value" "$id"
  done
}

# Entry point
case "$1" in
--get) change_brightness internal get ;;
--inc) change_brightness internal inc ;;
--dec) change_brightness internal dec ;;
--low) change_brightness internal low ;;
--high) change_brightness internal high ;;

--mon-get) for_each_monitor get ;;
--mon-inc) for_each_monitor inc ;;
--mon-dec) for_each_monitor dec ;;
--mon-low) for_each_monitor low ;;
--mon-high) for_each_monitor high ;;

*)
  echo "Usage: $0 [--get|--inc|--dec|--low|--high|--mon-get|--mon-inc|--mon-dec|--mon-low|--mon-high]"
  ;;
esac
