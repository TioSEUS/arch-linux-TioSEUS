#!/bin/bash
# Configura Waybar + Darkman
# Preserva identidade visual do TioSEUS (pílulas + bordas azuis + hover dourado)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Waybar..."
mkdir -p ~/.config/waybar
cp "$DOT/waybar/config.jsonc" ~/.config/waybar/
cp "$DOT/waybar/style.css"  ~/.config/waybar/
echo "  [OK] Waybar instalado (pílulas azuis + hover dourado)"

echo "→ Preparando Darkman..."
mkdir -p ~/.config/darkman

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

echo
echo "  [INFO] Para reiniciar a waybar depois de editar:"
echo "         killall waybar; waybar &"
