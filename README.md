# ⚠️ Heads Up (stupid project alert):    
this project turns out to be very stupid. one restless night, I had a Eureka moment and realized there is a much more obvious and simpler way to get a mouse to run scripts. there is also a better way to write the script file itself, that detects window classes. The better method simply uses ``xbindkeys``, but does still rely on [Piper](https://github.com/libratbag/piper) to set the mouse DPI button to a useable key (Button 10, aka b:10+Release in xbindkeys terms, for me)
The simpler script will be linked in an Issue report on this Repo, or I will make a new Repo entirely and delete this one. But this code is kinda embarassing in a funny way so I may leave it up. 

# xinput-mouse-keybinds
simple shell script to make application-specific mouse button actions possible

# Explanation:
I have a mouse with a DPI/resolution button that I don't use much.
This script is intended to run in the background and determine if a particular mouse button has been pressed.
Then it will attempt to run an xdotool key combo or other command based on the window name/class

# Variables (things you will need to change)
**Window names and associated binds** - I used discord, splitgate, and some other steam games as example applications
```bash
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
        *)
            echo "No command specified" ;;
    esac
```
It should be pretty easy for you to add/replace these case examples following this syntax.


you can use the following command in terminal and then quickly click on the target window to identify it's name/class:  (or if you are on Cinnamon DE, Melange is another easy way)
```bash
sleep 3 ; xprop -id $(xdotool getactivewindow) | awk -F '=' '/WM_CLASS/{print $2}' | tr -d '",' | sed -e 's/^[[:space:]]*//'
```

#
**MOUSE_ID** - run *xinput --list* and find the name of your mouse

$ ``xinput --list`` (example output)
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

# Troubleshooting    
I have noticed that some USB ports the mouse is plugged into do not detect all the buttons properly. I don't think it is even dependent on USB version/number, since the ones on my motherboard are very clearly marked.    
Anyway, you may need to try different ports to get some of the higher-numbered buttons to show with ``xinput --query-state $MOUSE_ID``.    
Example of different buttons being detected in different USB ports: (I have the script set to use ``button[10]``)    
![Screenshot from 2024-04-22 20-44-45](https://github.com/Ao1Pointblank/xinput-mouse-keybinds/assets/88149675/f0b6b91e-e7a8-4a88-b5d6-fe1a39e29bb0)

# Inspiration/Acknowledgements
https://unix.stackexchange.com/questions/106736/detect-if-mouse-button-is-pressed-then-invoke-a-script-or-command	
#
I think that's all... make an issue if you need help!
