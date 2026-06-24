#!/bin/bash
set -euo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Waybar..."
mkdir -p ~/.config/waybar
cp "$DOT/waybar/config-desktop.jsonc"  ~/.config/waybar/
cp "$DOT/waybar/config-notebook.jsonc" ~/.config/waybar/
cp "$DOT/waybar/style.css"             ~/.config/waybar/

# Por padrão, usa desktop (o waybar-mode.sh troca pra notebook se preciso)
ln -sf config-desktop.jsonc ~/.config/waybar/config.jsonc

echo "  [OK] Waybar instalado (desktop + notebook configs)"
