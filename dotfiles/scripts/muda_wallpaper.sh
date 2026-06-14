#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"

# Reinicia hyprpaper
killall hyprpaper 2>/dev/null || true
hyprpaper -c ~/.config/hyprpaper/hyprpaper.conf & 2>/dev/null || hyprpaper &

sleep 1.5

MONITORS=$(hyprctl monitors -j | grep '"name"' | cut -d'"' -f4)

for MONITOR in $MONITORS; do
    NEXT=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n1)
    
    if [ -n "$NEXT" ]; then
        hyprctl hyprpaper preload "$NEXT" 2>/dev/null
        hyprctl hyprpaper wallpaper "$MONITOR,$NEXT" 2>/dev/null && \
        echo "[OK] $MONITOR ← $(basename "$NEXT")"
    fi
done

notify-send "🎨 Wallpaper Alterado" "Cada monitor com imagem aleatória" 2>/dev/null || true
echo "[OK] Wallpapers trocados com sucesso!"
