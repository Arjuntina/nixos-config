#! /usr/bin/env bash

# Screenshot script

# Intended Functionality:
# Take a screenshot of a selected area on screen and copy it to the clipboard on hyprland!
# Features I want:
# The ability to edit the screenshot, if I want to
# The ability to save the screenshot to a file, if I want to

# Explanation of key programs used:
# Grim: captures an entire screen or part of a screen rendered by wayland
#       only works as a typed terminal command - arguments to this command need to be piped from other commands (eg. slurp)
# slurp: a program that allows for a user to select a region of a wayland screen by dragging their mouse
#        this output is then piped into grim
# swappy: a program that allows annotation of screenshots
#         supposed to emulate a macos screenshot tool
# wl-clipboard: a cli utility that allows users to send items to the system clipboard and retrieve items from the system clipboard
#               the system clipboard is built into wayland, but cannot be accessed without this special tool

# Have multiple functionalities depending on the input passed into the program
case "$1" in
    1)
        # If input = 1, take screenshot from mouse selection & annotate the screenshot with swappy
        # grim -g "$(slurp)" - takes a screenshot and sends it to stdout
        # swappy -f - opens it for annotation
        # After annotation, saeit to a temp file
        # wl-copy to put the file on my clipboard
        grim -g "$(slurp)" - | swappy -f - -o /tmp/swappy-output.png && wl-copy < /tmp/swappy-output.png
        # Send a notification of the screenshot
        notify-send "󰚓 Screenshot saved" "Annotated screenshot copied to clipboard."
        ;;
    2)
        # If input = 2, take screenshot from mouse selection but do NOT use swappy to annotate screenshot
        # grim -g "$(slurp)" - takes a screenshot and sends it to stdout
        # wl-copy to immediately copy the screenshot to the clipboard
        grim -g "$(slurp)" - | wl-copy
        # Send a notification of the screenshot
        notify-send "󰚓 Screenshot taken" "Region copied to clipboard."
        ;;
    3)
        # If input = 3, take screenshot of the entire screen!
        # grim - to capture the entire screen
        # wl-copy to save the screenshot to the clipboard
        # slurp not used because no region needs to be selected
        grim - | wl-copy
        # Send a notification of the screenshot
        notify-send "🖥️ Fullscreen screenshot" "Image copied to clipboard."
        ;;
    *)
        # If no input is provided, display some help info (copied from chatgpt)
        echo "Usage: $0 [1|2]"
        echo "1 - Select region, annotate, copy to clipboard"
        echo "2 - Select region, copy to clipboard (no annotation)"
        echo "3 - Fullscreen screenshot, copy to clipboard"
        ;;
esac



# To-do: customize swappy (can customize some aspects of the software & stuff like what directory to save files to)
# To-do: use zsh in script instead of bash??
