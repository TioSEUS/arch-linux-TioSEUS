#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"
CONF="$HOME/.config/hyprpaper/hyprpaper.conf"

# Coleta wallpapers disponíveis
mapfile -t WALLS < <(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null)

if [ ${#WALLS[@]} -eq 0 ]; then
    echo "[ERRO] Nenhum wallpaper encontrado em $WALL_DIR"
    notify-send "❌ Erro" "Nenhum wallpaper encontrado em $WALL_DIR" 2>/dev/null
    exit 1
fi

# Detecta monitores ativos
MONITORS=$(hyprctl monitors -j 2>/dev/null | grep '"name"' | cut -d'"' -f4)

if [ -z "$MONITORS" ]; then
    echo "[ERRO] Não foi possível detectar monitores"
    exit 1
fi

# Reinicia o hyprpaper
killall hyprpaper 2>/dev/null
sleep 1

# Gera novo hyprpaper.conf com um wallpaper aleatório por monitor
{
    echo "splash = false"
    echo "ipc = on"
    echo ""
    for MONITOR in $MONITORS; do
        NEXT="${WALLS[$RANDOM % ${#WALLS[@]}]}"
        echo "preload = $NEXT"
        echo "wallpaper = $MONITOR,$NEXT"
        echo ""
        echo "[OK] $MONITOR ← $(basename "$NEXT")"
    done
} > "$CONF"

# Inicia hyprpaper com a nova config
hyprpaper -c "$CONF" >/dev/null 2>&1 &
sleep 1

notify-send "🎨 Wallpaper Alterado" "Cada monitor com imagem aleatória" 2>/dev/null || true
echo "[OK] Wallpapers trocados com sucesso!"
