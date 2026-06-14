#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Aplicando dotfiles..."

# Diretórios
mkdir -p ~/.config/{hypr,waybar,kitty,fish,btop,fastfetch,rofi,hyprpaper}
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.local/bin

# Hyprland + hyprpaper
[ -d "$ROOT_DIR/dotfiles/hypr" ] && cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/
[ -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ] && cp -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Outros dotfiles
[ -d "$ROOT_DIR/dotfiles/waybar" ] && cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/
[ -d "$ROOT_DIR/dotfiles/kitty" ] && cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/
[ -d "$ROOT_DIR/dotfiles/fish" ] && cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/
[ -d "$ROOT_DIR/dotfiles/rofi" ] && cp -rf "$ROOT_DIR/dotfiles/rofi" ~/.config/

# Wallpapers
if [ -d "$ROOT_DIR/dotfiles/Wallpapers" ]; then
    cp -rf "$ROOT_DIR/dotfiles/Wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null || true
    echo "[OK] Wallpapers copiados"
fi

# Script muda_wallpaper
if [ -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ]; then
    cp -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ~/.local/bin/muda_wallpaper.sh
    chmod +x ~/.local/bin/muda_wallpaper.sh
    echo "[OK] muda_wallpaper.sh instalado"
fi

echo "[OK] Dotfiles aplicados com sucesso."
