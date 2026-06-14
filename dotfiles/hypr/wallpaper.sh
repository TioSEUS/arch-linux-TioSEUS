#!/bin/bash

# Finaliza instâncias antigas
killall hyprpaper 2>/dev/null || true

WALL_DIR="$HOME/Pictures/Wallpapers"

# Inicia com configuração
if [ -f ~/.config/hyprpaper/hyprpaper.conf ]; then
    hyprpaper -c ~/.config/hyprpaper/hyprpaper.conf &
    echo "[INFO] hyprpaper iniciado com config"
else
    hyprpaper &
fi

sleep 2

# Pré-carrega
hyprctl hyprpaper preload "$WALL_DIR/guts.png" 2>/dev/null || true
hyprctl hyprpaper preload "$WALL_DIR/default.png" 2>/dev/null || true

# Aplica por monitor específico
hyprctl hyprpaper wallpaper "DP-3,$WALL_DIR/guts.png" 2>/dev/null && echo "[OK] DP-3 → guts.png"
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALL_DIR/default.png" 2>/dev/null && echo "[OK] HDMI-A-1 → default.png"

echo "[OK] Wallpaper inicial configurado!"
