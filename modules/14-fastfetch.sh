#!/bin/bash
# Configura o Fastfetch (substituto moderno do neofetch)
# Tema TioSEUS com ícones Nerd Font

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Fastfetch..."
mkdir -p ~/.config/fastfetch
cp "$DOT/fastfetch/config.jsonc" ~/.config/fastfetch/

echo "  [OK] Fastfetch instalado"
echo "    • Config: ~/.config/fastfetch/config.jsonc"
echo
echo "  [INFO] Para testar:"
echo "         fastfetch"
