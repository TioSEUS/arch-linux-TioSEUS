# Finaliza instâncias antigas
killall hyprpaper 2>/dev/null
sleep 1

WALL_DIR="$HOME/Pictures/Wallpapers"
CONF="$HOME/.config/hyprpaper/hyprpaper.conf"

# Garante que o diretório existe
mkdir -p "$WALL_DIR"

# Inicia com configuração
if [ -f "$CONF" ]; then
    hyprpaper -c "$CONF" >/dev/null 2>&1 &
    echo "[INFO] hyprpaper iniciado com config: $CONF"
else
    hyprpaper >/dev/null 2>&1 &
    echo "[INFO] hyprpaper iniciado sem config (vai usar defaults)"
fi

echo "[OK] Wallpaper inicial configurado!"
