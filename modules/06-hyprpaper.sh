#!/bin/bash
# Configura o hyprpaper

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do hyprpaper..."
mkdir -p ~/.config/hyprpaper
cp "$DOT/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf
echo "  [OK] hyprpaper.conf instalado"

# Substitui $HOME pelo caminho real (algumas versões do hyprpaper não expandem)
sed -i "s|\$HOME|$HOME|g" ~/.config/hyprpaper/hyprpaper.conf
echo "  [OK] Caminhos absolutos aplicados"
