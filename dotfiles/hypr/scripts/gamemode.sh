#!/bin/bash
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = 1 ]; then
    hyprctl --batch "keyword animations:enabled 0; keyword decoration:blur:enabled 0; keyword decoration:shadow:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0"
    notify-send -e -u low "Gamemode" "ativado" 2>/dev/null
else
    hyprctl --batch "keyword animations:enabled 1; keyword decoration:shadow:enabled 1; keyword general:gaps_in 4; keyword general:gaps_out 10; keyword general:border_size 2; keyword decoration:rounding 12"
    notify-send -e -u normal "Gamemode" "desativado" 2>/dev/null
fi
