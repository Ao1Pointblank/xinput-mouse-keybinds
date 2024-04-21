#!/bin/bash
#https://github.com/Ao1Pointblank/xinput-mouse-keybinds
#run the following command in terminal to find the names of active windows (you will need the window names later):
#sleep 3 ; xprop -id $(xdotool getactivewindow) | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'

#INSTANCE CONTROL
#prevent multiple instances of script from running. new instance will replace old one (making reloading the script easier)
LOCK_FILE="/tmp/button10.lock"
if [ -e "$LOCK_FILE" ]; then
    #check if the process associated with the lock file is still running
    PID=$(cat "$LOCK_FILE" 2>/dev/null)
    if [ -n "$PID" ] && ps -p "$PID" > /dev/null; then
        echo "Old instance is still running. Killing it."
        echo
        kill -TERM "$PID"
        sleep 2 #allow time for the old instance to terminate

        #check if the old instance is still running
        if ps -p "$PID" > /dev/null; then
            echo "Old instance did not terminate. Exiting."
            exit 1
        fi
    else
        echo "Lock file exists but the associated process is not running. Proceeding."
        echo
    fi
fi
#create lock file with the pid of the current process
echo "$$" > "$LOCK_FILE"

#MOUSE KEY REMAP
#function to determine active window
get_active_window() {
    xprop -id "$(xdotool getactivewindow)" | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'
}

handle_active_window() {
    local active_window="$1"
    COMMAND=""

    case "$active_window" in
        *discord*)
            COMMAND="xdotool key 'alt+shift+Up'" ;;
        *PortalWars-Linux-Shipping*)
            COMMAND="xdotool key 'f+h'" ;;
        *steam_app_782330*) 		#doom eternal
            COMMAND="xdotool key 'g+f'; xdotool key 'g'" ;;
        *steam_app_553850*) 		#helldivers
            COMMAND="xdotool key 'ISO_Group_Shift'" ;;
        *steam_app_1240440*) 		#halo infinite
            COMMAND="xdotool key 'g'" ;;
        *Audacious*)
            COMMAND="bash -c '/home/pointblank/.local/share/nemo/scripts/💿\ Music/🎼\ Edit\ Current\ Audacious\ Opus'" ;;
        *Nemo-desktop*)
            COMMAND="sleep 0.2; dbus-send --session --dest=org.Cinnamon --type=method_call --print-reply /org/Cinnamon org.Cinnamon.ShowOverview 1> /dev/null" ;;
        *)
            echo "No command specified" ;;
    esac

    if [ -n "$COMMAND" ]; then
        eval "$COMMAND"
        echo "# NEW EVENT:"
        echo "Command run: $COMMAND"
    fi
}


#while loop go brrrr
MOUSE_ID=$(xinput --list | grep -i -m 1 'Gaming Mouse' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[10\]')

while true; do
    sleep 0.1
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[10\]')
    if comm -13 <(echo "$STATE1") <(echo "$STATE2") | grep -q 'button\[10\]=down'; then
        WINDOW_CLASS=$(get_active_window)
        handle_active_window "$WINDOW_CLASS"
        echo "Button pressed in: $WINDOW_CLASS"
        echo
    fi
    STATE1=$STATE2
done

#remove lock file when script is killed or finished
rm "$LOCK_FILE"
