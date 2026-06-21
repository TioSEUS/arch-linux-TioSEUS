#!/bin/bash
# Configura o hyprpaper (placeholder — config real é gerado pelo auto-config)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do hyprpaper (placeholder)..."
mkdir -p ~/.config/hyprpaper
cp "$DOT/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Substitui ~ por caminho absoluto
sed -i "s|~/Pictures|$HOME/Pictures|g" ~/.config/hyprpaper/hyprpaper.conf

echo "  [OK] hyprpaper.conf placeholder instalado"
echo "  [INFO] Config real será gerada automaticamente no primeiro boot"
echo "         pelo script ~/.config/hypr/scripts/auto-config-monitors.sh"
