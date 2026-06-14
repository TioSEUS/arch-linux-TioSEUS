#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Aplicando dotfiles..."

# Diretórios de configuração
mkdir -p ~/.config/{hypr,waybar,kitty,fish,btop,fastfetch,rofi,hyprpaper,fcitx5}

# Wallpapers
mkdir -p ~/Pictures/Wallpapers

# Scripts locais
mkdir -p ~/.local/bin

# Hyprland + hyprpaper
[ -d "$ROOT_DIR/dotfiles/hypr" ] && cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/
[ -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ] && cp -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Waybar, Kitty, Fish, etc.
[ -d "$ROOT_DIR/dotfiles/waybar" ] && cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/
[ -d "$ROOT_DIR/dotfiles/kitty" ] && cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/
[ -d "$ROOT_DIR/dotfiles/fish" ] && cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/
[ -d "$ROOT_DIR/dotfiles/rofi" ] && cp -rf "$ROOT_DIR/dotfiles/rofi" ~/.config/

# Wallpapers
if [ -d "$ROOT_DIR/dotfiles/Wallpapers" ]; then
    cp -rf "$ROOT_DIR/dotfiles/Wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null || true
    echo "[OK] Wallpapers copiados"
fi

# Script de mudar wallpaper
if [ -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ]; then
    cp -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ~/.local/bin/muda_wallpaper.sh
    chmod +x ~/.local/bin/muda_wallpaper.sh
    echo "[OK] Script muda_wallpaper instalado"
fi

echo "[OK] Dotfiles aplicados com sucesso."
