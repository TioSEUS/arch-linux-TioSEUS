#!/bin/bash
# Configura o fish shell

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do fish..."
mkdir -p ~/.config/fish
cp "$DOT/fish/config.fish" ~/.config/fish/config.fish
echo "  [OK] config.fish instalado"

echo "→ Definindo fish como shell padrão..."
FISH_PATH=$(command -v fish)
if [ -n "$FISH_PATH" ]; then
    chsh -s "$FISH_PATH" "$USER"
    echo "  [OK] Shell padrão alterado para $FISH_PATH"
else
    echo "  [WARN] fish não encontrado no PATH"
fi
