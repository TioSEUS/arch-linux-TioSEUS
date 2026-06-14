#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"

CURRENT=$(hyprctl hyprpaper listloaded | tail -n1 | awk '{print $NF}')

NEXT=$(find "$WALL_DIR" -type f \( \
-name "*.png" -o \
-name "*.jpg" -o \
-name "*.jpeg" -o \
-name "*.webp" \
\) | shuf -n1)

hyprctl hyprpaper preload "$NEXT"

for MONITOR in $(hyprctl monitors -j | grep '"name"' | cut -d'"' -f4); do
    hyprctl hyprpaper wallpaper "$MONITOR,$NEXT"
done

notify-send "Wallpaper alterado" "$(basename "$NEXT")"
