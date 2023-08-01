#!/bin/bash

# Start Terminator
terminator &

# Wait for a few seconds to make sure Terminator is launched (adjust the sleep time if needed)
sleep 2

# Function to send a command to Terminator window and wait for it to complete
function execute_command() {
    xdotool type "$1"
    xdotool key Return
    #sleep 2
}

# Send the first command to the current Terminator window
execute_command "$1"

# Split Terminator window vertically
if [ "$#" -ge 2 ]; then
    xdotool key ctrl+shift+e
    sleep 2
    execute_command "$2"
    if [ "$#" -ge 3 ]; then
        # move left window
        xdotool key alt+Left
        xdotool key ctrl+shift+o
        sleep 2
        execute_command "$3"
        if [ "$#" -ge 4 ]; then
            # move right window
            xdotool key alt+Right
            # Split Terminator window horizontally in the second split window
            xdotool key ctrl+shift+o
            sleep 2
            execute_command "$4"
        else
            exit 0
        fi
    else
        exit 0
    fi
else
    exit 0
fi

