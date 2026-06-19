#!/bin/bash
# Instala scripts auxiliares em ~/.config/scripts e cria alias globais

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando scripts auxiliares..."
mkdir -p ~/.config/scripts
cp "$DOT/scripts/muda_wallpaper.sh" ~/.config/scripts/muda_wallpaper.sh
chmod +x ~/.config/scripts/muda_wallpaper.sh
echo "  [OK] scripts instalados"

# Cria symlink em /usr/local/bin para acesso global (requer sudo)
if ! command -v muda-wallpaper &>/dev/null; then
    sudo ln -sf ~/.config/scripts/muda_wallpaper.sh /usr/local/bin/muda-wallpaper
    echo "  [OK] Comando global 'muda-wallpaper' criado"
fi
