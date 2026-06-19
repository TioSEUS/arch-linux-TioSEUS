#!/bin/bash
# Configura o hyprpaper (com substituição automática de SEU_USUARIO e $HOME)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do hyprpaper..."
mkdir -p ~/.config/hyprpaper
cp "$DOT/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Substitui SEU_USUARIO pelo usuário real
sed -i "s|SEU_USUARIO|$USER|g" ~/.config/hyprpaper/hyprpaper.conf

# Substitui também $HOME (caso use esse formato em vez de SEU_USUARIO)
sed -i "s|\$HOME|$HOME|g" ~/.config/hyprpaper/hyprpaper.conf

# Verifica se os wallpapers existem
WALL_DIR="$HOME/Pictures/Wallpapers"
if [ ! -d "$WALL_DIR" ]; then
    echo "  [WARN] Pasta $WALL_DIR não existe — wallpapers ainda não foram copiados"
    echo "         Rode o módulo 07-wallpapers.sh"
else
    WALL_COUNT=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | wc -l)
    echo "  [OK] $WALL_COUNT wallpapers disponíveis em $WALL_DIR"
fi

echo "  [OK] hyprpaper.conf instalado com caminho absoluto"
echo "    • Config: ~/.config/hyprpaper/hyprpaper.conf"
