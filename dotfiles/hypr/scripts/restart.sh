#!/usr/bin/env bash
case "$1" in
    swaync) pkill swaync 2>/dev/null; sleep 0.2; swaync & ;;
    waybar) pkill waybar 2>/dev/null; sleep 0.2; waybar & ;;
    all|"") pkill swaync waybar 2>/dev/null; sleep 0.3; waybar &; swaync & ;;
    *) echo "Uso: $0 {all|waybar|swaync}"; exit 1 ;;
esac
