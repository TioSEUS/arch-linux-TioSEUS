#!/bin/bash
# Configura Waybar e Darkman
# (SwayNC é tratado pelo módulo 09-swaync.sh)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Waybar..."
mkdir -p ~/.config/waybar
if [ -f "$DOT/waybar/config.jsonc" ]; then
    cp "$DOT/waybar/config.jsonc" ~/.config/waybar/
fi
if [ -f "$DOT/waybar/style.css" ]; then
    cp "$DOT/waybar/style.css" ~/.config/waybar/
fi
echo "  [OK] Waybar instalado"

echo "→ Preparando Darkman..."
mkdir -p ~/.config/darkman

# Cria config mínima do darkman se não existir
if [ ! -f ~/.config/darkman/config.yml ]; then
    cat > ~/.config/darkman/config.yml << 'EOF'
threshold:
  latitude: -15.78
  longitude: -47.92
EOF
    echo "  [OK] darkman: config mínima criada"
else
    echo "  [OK] darkman: config já existia"
fi
