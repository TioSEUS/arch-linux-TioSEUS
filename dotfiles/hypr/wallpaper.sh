#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | shuf -n1)

if [ -z "$WALLPAPER" ]; then
    echo "[WARN] Nenhum wallpaper em $WALL_DIR"
    exit 1
fi

# Método 1: SWWW (preferido)
if command -v swww >/dev/null 2>&1; then
    if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon --format xrgb &
        sleep 1
    fi
    swww img "$WALLPAPER" --transition-type grow --transition-duration 2 --transition-fps 30
    echo "[OK] Wallpaper (swww): $(basename "$WALLPAPER")"
    exit 0
fi

# Método 2: hyprpaper (fallback)
if command -v hyprpaper >/dev/null 2>&1; then
    killall hyprpaper 2>/dev/null
    sleep 1
    CONF="$HOME/.config/hyprpaper/hyprpaper.conf"
    mkdir -p ~/.config/hyprpaper
    echo "preload = $WALLPAPER" > "$CONF"
    echo "wallpaper = ,$WALLPAPER" >> "$CONF"
    echo "splash = false" >> "$CONF"
    echo "ipc = on" >> "$CONF"
    hyprpaper -c "$CONF" >/dev/null 2>&1 &
    echo "[OK] Wallpaper (hyprpaper): $(basename "$WALLPAPER")"
    exit 0
fi

# Método 3: swaybg (último recurso)
if command -v swaybg >/dev/null 2>&1; then
    killall swaybg 2>/dev/null
    swaybg -m fill -i "$WALLPAPER" &
    echo "[OK] Wallpaper (swaybg): $(basename "$WALLPAPER")"
    exit 0
fi

echo "[ERR] Nenhum gerenciador de wallpaper disponível"
exit 1
