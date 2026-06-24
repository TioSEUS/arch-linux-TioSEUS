#!/bin/bash

# Garante que o daemon swww está rodando
if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon --format xrgb &
    sleep 1
fi

WALL_DIR="$HOME/Pictures/Wallpapers"

# Pega um wallpaper aleatório (ou o primeiro)
WALLPAPER=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | shuf -n1)

if [ -z "$WALLPAPER" ]; then
    echo "[WARN] Nenhum wallpaper encontrado em $WALL_DIR"
    exit 1
fi

# Aplica com transição suave (funciona em TODOS os monitores automaticamente)
swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 2 \
    --transition-fps 30

echo "[OK] Wallpaper aplicado: $(basename "$WALLPAPER")"
