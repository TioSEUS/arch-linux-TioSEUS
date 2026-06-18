#!/bin/bash
# Configura o kitty

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do kitty..."
mkdir -p ~/.config/kitty
cp "$DOT/kitty/kitty.conf" ~/.config/kitty/kitty.conf
echo "  [OK] kitty instalado"
