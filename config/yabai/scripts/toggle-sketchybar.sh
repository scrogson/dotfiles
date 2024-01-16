#!/usr/bin/env bash

# Call sketchybar and capture the output
output=$(sketchybar --query bar)

# Use jq to parse 'hidden' and 'height' fields
hidden=$(echo "$output" | jq -r '.hidden')
height=$(echo "$output" | jq -r '.height')

# Check the value of 'hidden' and execute commands accordingly
if [ "$hidden" = "off" ]; then
    sketchybar --bar hidden=on
    yabai -m config external_bar all:0:0
elif [ "$hidden" = "on" ]; then
    sketchybar --bar hidden=off
    yabai -m config external_bar all:${height}:0
fi
