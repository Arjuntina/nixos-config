#! /usr/bin/env bash

# Get current brightness (rounded to int)
# Using awk!
BRIGHTNESS=$(light -G | awk '{printf "%.0f", $1}')

# We want the brightness bar to be 20 characters long
# Set the length of the filled in part of the bar (BAR_LENGTH) to equal BRIGHTNESS / 5 (integer division)
# Means n lengths of the bar will be filled for any brightness between 5n & 5n+4 (eg. 5 bars filled = brightnesses 25-29)
BAR_LENGTH=$(( BRIGHTNESS / 5 ))

BAR_CHARS=""
for ((i = 0; i < BAR_LENGTH; i++)); do
    BAR_CHARS+="█"
done

EMPTY_CHARS=""
for ((i = 20; i > BAR_LENGTH; i--)); do
    EMPTY_CHARS+="░"
done

# Send notification via swaync
# Use -h string:x-canonical-private-synchronous:brightness to have notifications use the same id
notify-send -a "brightness" -h string:x-canonical-private-synchronous:brightness \
    "Brightness: ${BRIGHTNESS}%" "$BAR_CHARS$EMPTY_CHARS"
