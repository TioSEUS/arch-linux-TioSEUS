#!/bin/bash
DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$DIR"

if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

RANDOM_PIC=$(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -z "$RANDOM_PIC" ]; then exit 1; fi

swww img "$RANDOM_PIC" --transition-type grow --transition-pos 0.5,0.5 --transition-step 90 --transition-fps 60
matugen image "$RANDOM_PIC"
killall -SIGUSR2 waybar
