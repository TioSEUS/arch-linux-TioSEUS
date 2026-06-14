#!/bin/bash

# Finaliza instâncias antigas
killall hyprpaper 2>/dev/null

# Diretório padrão de wallpapers
WALL_DIR="$HOME/Pictures/Wallpapers"

# Inicia o daemon
hyprpaper &

# Aguarda inicialização
sleep 2

# Pré-carrega wallpapers
hyprctl hyprpaper preload "$WALL_DIR/guts.png"
hyprctl hyprpaper preload "$WALL_DIR/default.png"

# Detecta monitores conectados
MONITORS=$(hyprctl monitors -j | grep '"name"' | cut -d'"' -f4)

COUNT=0

for MONITOR in $MONITORS; do

    if [ "$COUNT" -eq 0 ]; then
        hyprctl hyprpaper wallpaper "$MONITOR,$WALL_DIR/guts.png"
    else
        hyprctl hyprpaper wallpaper "$MONITOR,$WALL_DIR/default.png"
    fi

    COUNT=$((COUNT + 1))

done
