#!/bin/bash
# Detecta notebook vs desktop e escolhe o config da waybar certo
# - Notebook: usa config-notebook.jsonc (com bateria, sem GPU temp)
# - Desktop: usa config.jsonc (com GPU temp, sem bateria)

WAYBAR_DIR="$HOME/.config/waybar"

# Detecta bateria
HAS_BATTERY=false
ls /sys/class/power_supply/BAT* >/dev/null 2>&1 && HAS_BATTERY=true

if [ "$HAS_BATTERY" = "true" ]; then
    echo "[INFO] Notebook detectado → waybar com bateria"
    # Se config-notebook.jsonc existe, usa ele; senão mantém o padrão
    if [ -f "$WAYBAR_DIR/config-notebook.jsonc" ]; then
        ln -sf config-notebook.jsonc "$WAYBAR_DIR/config.jsonc"
    fi
else
    echo "[INFO] Desktop detectado → waybar completa (GPU temp)"
    if [ -f "$WAYBAR_DIR/config-desktop.jsonc" ]; then
        ln -sf config-desktop.jsonc "$WAYBAR_DIR/config.jsonc"
    fi
fi

# Reinicia waybar se estiver rodando
if pgrep waybar >/dev/null; then
    killall waybar 2>/dev/null
    sleep 1
    waybar &
fi
