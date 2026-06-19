#!/bin/bash
# Configura o SwayNC (notification center)
# Substitui o antigo módulo 07-waybar-swaync.sh que só criava dirs vazios

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do SwayNC..."
mkdir -p ~/.config/swaync
cp "$DOT/swaync/config.json" ~/.config/swaync/
cp "$DOT/swaync/style.css"  ~/.config/swaync/

# Garante que swaync está habilitado no hyprland.conf
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPRLAND_CONF" ]; then
    if ! grep -q "^exec-once = swaync" "$HYPRLAND_CONF"; then
        echo "→ Adicionando 'exec-once = swaync' ao hyprland.conf..."
        echo "exec-once = swaync" >> "$HYPRLAND_CONF"
        echo "  [OK] swaync adicionado ao autostart do Hyprland"
    else
        echo "  [OK] swaync já estava no autostart"
    fi
fi

echo "  [OK] SwayNC instalado com tema TioSEUS"
echo "    • Config: ~/.config/swaync/config.json"
echo "    • Style:  ~/.config/swaync/style.css"
echo
echo "  [INFO] Controles:"
echo "         • Abrir painel:    swaync-client -t -sw"
echo "         • Fechar painel:   swaync-client -d -sw"
echo "         • Limpar notifs:   swaync-client -C"
echo "         • Toggle DND:      swaync-client -D"
