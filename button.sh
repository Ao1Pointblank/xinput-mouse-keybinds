#!/bin/bash
#https://github.com/Ao1Pointblank/xinput-mouse-keybinds
#run the following command in terminal to find the names of active windows (you will need the window names later):
#sleep 3 ; xprop -id $(xdotool getactivewindow) | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'


#function to determine active window
get_active_window() {
    xprop -id "$(xdotool getactivewindow)" | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'
}

# Function to handle different active windows
handle_active_window() {
    local active_window="$1"

    if echo "$active_window" | grep -q "discord"; then
    	xdotool key "alt+shift+Up" #navigate to top unread channel in discord
    elif echo "$active_window" | grep -q "PortalWars-Linux-Shipping"; then
		xdotool key "H" #put down a spray in splitgate
    elif echo "$active_window" | grep -q "FreeTube"; then
		xdotool key "ctrl+R" #reload freetube window
    fi
}

# Main script
MOUSE_ID=$(xinput --list | grep -i -m 1 'Gaming Mouse' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')

STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[10\]')

while true; do
    sleep 0.1
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[10\]')
    if comm -13 <(echo "$STATE1") <(echo "$STATE2") | grep -q 'button\[10\]=down'; then
        COMMAND_RESULT=$(get_active_window)
        handle_active_window "$COMMAND_RESULT"
        echo "Button pressed in: <$COMMAND_RESULT>"
    fi
    STATE1=$STATE2
done
