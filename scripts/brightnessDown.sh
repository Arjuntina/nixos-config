#! /usr/bin/env bash

# Increse brightness with the light utility
light -U 5

# Get current brightness (rounded to int)
BRIGHTNESS=$(light -G | awk '{printf "%.0f", $1}')

# Create a visual bar (max 20 blocks)
BAR_LENGTH=$((BRIGHTNESS * 20 / 100))
BAR=$(printf '█%.0s' $(seq 1 $BAR_LENGTH))
EMPTY=$(printf '░%.0s' $(seq 1 $((20 - BAR_LENGTH))))

# Send notification via swaync
notify-send -a "brightness" -h string:x-canonical-private-synchronous:brightness \
    "Brightness: ${BRIGHTNESS}%" "$BAR$EMPTY"
