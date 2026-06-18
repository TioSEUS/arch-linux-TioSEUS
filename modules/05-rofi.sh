#!/bin/bash
# Configura o rofi

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do rofi..."
mkdir -p ~/.config/rofi
cp "$DOT/rofi/config.rasi" ~/.config/rofi/config.rasi
echo "  [OK] rofi instalado"

# Garante que o tema material existe
if [ ! -f /usr/share/rofi/themes/material.rasi ]; then
    echo "  [WARN] Tema material.rasi não encontrado. Rofi pode usar fallback."
fi
