#! /usr/bin/env bash

# Screenshot script

# Intended Functionality:
# Take a screenshot of a selected area on screen and copy it to the clipboard on hyprland!
# Features I want:
# The ability to edit the screenshot
# The ability to save the screenshot to a file, if needed

# Explanation of key programs used:
# Grim: captures an entire screen or part of a screen rendered by wayland
#       only works as a typed terminal command - arguments to this command need to be piped from other commands (eg. slurp)
# slurp: a program that allows for a user to select a region of a wayland screen by dragging their mouse
#        this output is then piped into grim
# swappy: a program that allows annotation of screenshots
#         supposed to emulate a macos screenshot tool
# wl-clipboard: a cli utility that allows users to send items to the system clipboard and retrieve items from the system clipboard
#               the system clipboard is built into wayland, but cannot be accessed without this special tool

# grim -g "$(slurp)" - takes a screenshot and sends it to stdout
# swappy -f - opens it for annotation
# After annotation, saeit to a temp file
# wl-copy to put the file on my clipboard
grim -g "$(slurp)" - | swappy -f - -o /tmp/swappy-output.png && wl-copy < /tmp/swappy-output.png

# To-do: customize swappy (can customize some aspects of the software & stuff like what directory to save files to)
