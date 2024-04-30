#!/bin/bash

#application-specific commands
define_commands() {
    declare -A commands
    commands["discord"]="xdotool key 'alt+shift+Up'"						        #DISCORD navigate to unread
    commands["PortalWars-Linux-Shipping"]="xdotool key 'f+h'"				    #SPLITGATE pick up weapon and use spray
    commands["steam_app_782330"]="xdotool key 'g+f'; xdotool key 'g'"		#DOOMETERNAL icebomb (and switch back to frag)
    commands["steam_app_553850"]="xdotool key 'ISO_Group_Shift'"			  #HELLDIVERS2 free keybind
    commands["steam_app_1240440"]="xdotool key 'g'"							        #HALOINFINITE
    commands["Audacious"]="bash -c '$HOME/.local/share/nemo/scripts/edit-opus.sh'" #AUDACIOUS (example of a custom script being run from button10-redux.sh)
    commands["Nemo-desktop"]="sleep 0.2; dbus-send --session --dest=org.Cinnamon --type=method_call --print-reply /org/Cinnamon org.Cinnamon.ShowOverview 1> /dev/null" #CINNAMON show desktop overview

    #execute the command
    if [[ -n ${commands[$1]} ]]; then
    	echo "${commands[$1]}"
        eval "${commands[$1]}"
    else
        echo "No command defined for window: $1"
    fi
}

#detect active window
window=$(xprop -id "$(xdotool getactivewindow)" WM_CLASS | awk -F '"' '{print $4}')

echo "Detected window: $window"

#pass detected window to execute
define_commands "$window"
