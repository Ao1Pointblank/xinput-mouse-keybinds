# xinput-mouse-keybinds
simple shell script to make application-specific mouse button actions possible

# Explanation:
I have a mouse with a DPI/resolution button that I don't use much.
This script is intended to run in the background and determine if a particular mouse button has been pressed.
Then it will attempt to run an xdotool key combo or other command based on the window name/class

# Variables (things you will need to change)
**Window names and associated binds** - I used discord, splitgate, and freetube as examples
```bash
    if echo "$active_window" | grep -q "discord"; then
    	xdotool key "alt+shift+Up" #navigate to top unread channel in discord
    elif echo "$active_window" | grep -q "PortalWars-Linux-Shipping"; then
		xdotool key "H" #put down a spray in splitgate
    elif echo "$active_window" | grep -q "FreeTube"; then
		xdotool key "ctrl+R" #reload freetube window
    fi
```
you can use the following command in terminal and then quickly click on the target window to identify it's name/class:  
```bash
sleep 3 ; xprop -id $(xdotool getactivewindow) | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'
```

#
**MOUSE_ID** - run *xinput --list* and find the name of your mouse

$ ``xinput --list``
```
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ Keychron Keychron K1 SE                 	id=9	[slave  pointer  (2)]
⎜   ↳ Logitech G403 HERO Gaming Mouse         	id=14	[slave  pointer  (2)]
⎜   ↳ Logitech G403 HERO Gaming Mouse Keyboard	id=15	[slave  pointer  (2)]
⎜   ↳ 2.4G Composite Devic Consumer Control   	id=11	[slave  pointer  (2)]
⎜   ↳ 2.4G Composite Devic Mouse              	id=17	[slave  pointer  (2)]
```
use your best judgement here when picking which is your mouse.


#
**STATE1 and STATE2** - just the part that specifies which button to look at. button[10] in my case.
use the following command to test your mouse buttons and find which one is the one you are wanting to bind:
```bash
watch -n 0.1 xinput --query-state $MOUSE_ID
```
(replace $MOUSE_ID with the actual number from ``xinput --list``)

# Setup
You will need to make a startup program to get this .sh file running in the background once you log in. This depends on your distro I guess, but is easy on Linux Mint (that's all I know)

# Inspiration/Acknowledgements
https://unix.stackexchange.com/questions/106736/detect-if-mouse-button-is-pressed-then-invoke-a-script-or-command	
#
I think that's all... make an issue if you need help!
