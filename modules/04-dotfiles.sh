#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Aplicando dotfiles..."

# Diretórios
mkdir -p ~/.config/{hypr,waybar,kitty,fish,btop,fastfetch,rofi,hyprpaper}
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.local/bin

# Copia tudo do hypr (incluindo wallpaper.sh)
[ -d "$ROOT_DIR/dotfiles/hypr" ] && cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/

# hyprpaper.conf (corrigido)
if [ -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ]; then
    cp -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf
    echo "[OK] hyprpaper.conf copiado"
fi

# Outros dotfiles
[ -d "$ROOT_DIR/dotfiles/waybar" ] && cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/
[ -d "$ROOT_DIR/dotfiles/kitty" ] && cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/
[ -d "$ROOT_DIR/dotfiles/fish" ] && cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/
[ -d "$ROOT_DIR/dotfiles/rofi" ] && cp -rf "$ROOT_DIR/dotfiles/rofi" ~/.config/

# Wallpapers
if [ -d "$ROOT_DIR/dotfiles/Wallpapers" ]; then
    cp -rf "$ROOT_DIR/dotfiles/Wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null || true
    echo "[OK] Wallpapers copiados ($(ls ~/Pictures/Wallpapers/ | wc -l) arquivos)"
fi

# Script muda_wallpaper
if [ -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ]; then
    cp -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ~/.local/bin/muda_wallpaper.sh
    chmod +x ~/.local/bin/muda_wallpaper.sh
    echo "[OK] muda_wallpaper.sh instalado"
fi

echo "[OK] Dotfiles aplicados com sucesso."
