#!/bin/bash
# Garante waybar, swaync e darkman (já instalados no módulo 01)
# Cria diretórios base se configs próprias forem adicionadas depois

set -euo pipefail

echo "→ Preparando diretórios para waybar/swaync/darkman..."
mkdir -p ~/.config/waybar
mkdir -p ~/.config/swaync
mkdir -p ~/.config/darkman

# Cria config mínima do darkman se não existir
if [ ! -f ~/.config/darkman/config.yml ]; then
    cat > ~/.config/darkman/config.yml << 'EOF'
threshold:
  latitude: -15.78
  longitude: -47.92
EOF
    echo "  [OK] darkman: config mínima criada"
fi

echo "  [OK] Diretórios prontos (adicione suas configs depois se quiser)"
