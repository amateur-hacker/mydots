#!/usr/bin/env bash

# Default action is to increase brightness
action="increase"

# Function to send brightness change notification
function send_notification() {
	# Send the notification for brightness change using notify-send
	notify-send -a "changebrightness" -u low -r 9993 -h int:value:"$2" -i "brightness-$1" "Brightness: $2%" -t 1500
}

# Parse command line options
while getopts ":dufl" opt; do
	case ${opt} in
	d) # Decrease brightness
		action="decrease"
		;;
	u) # Increase brightness (default)
		action="increase"
		;;
	f) # Set brightness to maximum
		action="maximum"
		;;
	l) # Set brightness to minimum
		action="minimum"
		;;
	\?)
		echo "Usage: $0 [-u] [-d] [-f] [-l]" 1>&2
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

# Get the current brightness level
current_brightness=$(ddcutil --display 1 getvcp 10 | cut -d '=' -f2 | cut -d ',' -f1 | sed 's/ //g')

# Check if current brightness is already at maximum (100%)
if [ "$current_brightness" -eq 100 ] && [ "$action" == "increase" ]; then
	notify-send -a "changebrightness" -u low -r 9993 "Brightness is already at maximum."
	exit 0
elif [ "$current_brightness" -eq 0 ] && [ "$action" == "decrease" ]; then
	notify-send -a "changebrightness" -u low -r 9993 "Brightness is already at minimum."
	exit 0
fi

# Calculate the new brightness level
if [ "$action" == "maximum" ]; then
	new_brightness=100
	send_notification "up" "100"
elif [ "$action" == "minimum" ]; then
	new_brightness=0
	send_notification "down" "0"
elif [ "$action" == "increase" ]; then
	new_brightness=$((current_brightness + 20))
	send_notification "up" "$new_brightness"
else
	new_brightness=$((current_brightness - 20))
	send_notification "down" "$new_brightness"
fi

# If new brightness exceeds 100%, set it to 100%
if [ "$new_brightness" -gt 100 ]; then
	new_brightness=100
elif [ "$new_brightness" -lt 0 ]; then
	new_brightness=0
fi

# Set the new brightness level
ddcutil --display 1 setvcp 10 "$new_brightness"
