#!/bin/bash
# Configura o hyprpaper (placeholder — config real é gerado pelo auto-config no boot)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do hyprpaper (placeholder)..."
mkdir -p ~/.config/hyprpaper
cp "$DOT/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Substitui SEU_USUARIO pelo usuário real (CRÍTICO!)
sed -i "s|SEU_USUARIO|$USER|g" ~/.config/hyprpaper/hyprpaper.conf

# Substitui $HOME (caso use esse formato)
sed -i "s|\$HOME|$HOME|g" ~/.config/hyprpaper/hyprpaper.conf

# Substitui ~ também (caso use)
sed -i "s|~/Pictures|$HOME/Pictures|g" ~/.config/hyprpaper/hyprpaper.conf

# Verifica se o wallpaper existe
WALL_DIR="$HOME/Pictures/Wallpapers"
if [ ! -d "$WALL_DIR" ]; then
    echo "  [WARN] Pasta $WALL_DIR não existe ainda"
else
    WALL_COUNT=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | wc -l)
    echo "  [OK] $WALL_COUNT wallpapers disponíveis em $WALL_DIR"
fi

echo "  [OK] hyprpaper.conf instalado com caminho absoluto: /home/$USER/Pictures/Wallpapers/..."
echo "  [INFO] Config final será gerada pelo auto-config-monitors.sh no boot"
