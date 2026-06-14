#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Aplicando dotfiles..."

# Diretórios de configuração
mkdir -p ~/.config/{hypr,waybar,kitty,fish,btop,fastfetch}

# Wallpapers
mkdir -p ~/Pictures/Wallpapers

# Scripts locais
mkdir -p ~/.local/bin

# Hyprland
[ -d "$ROOT_DIR/dotfiles/hypr" ] && \
cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/

# Waybar
[ -d "$ROOT_DIR/dotfiles/waybar" ] && \
cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/

# Kitty
[ -d "$ROOT_DIR/dotfiles/kitty" ] && \
cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/

# Fish
[ -d "$ROOT_DIR/dotfiles/fish" ] && \
cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/

# Btop
[ -d "$ROOT_DIR/dotfiles/btop" ] && \
cp -rf "$ROOT_DIR/dotfiles/btop" ~/.config/

# Fastfetch
if [ -f "$ROOT_DIR/dotfiles/Fastfetch/config.jsonc" ]; then
    cp -f \
    "$ROOT_DIR/dotfiles/Fastfetch/config.jsonc" \
    ~/.config/fastfetch/config.jsonc
fi

# Wallpapers
if [ -d "$ROOT_DIR/dotfiles/Wallpapers" ]; then
    cp -rf \
    "$ROOT_DIR/dotfiles/Wallpapers/"* \
    ~/Pictures/Wallpapers/ 2>/dev/null || true
fi

# Script troca de wallpaper
if [ -f "$ROOT_DIR/scripts/muda_wallpaper.sh" ]; then

    cp -f \
    "$ROOT_DIR/scripts/muda_wallpaper.sh" \
    ~/.local/bin/muda_wallpaper.sh

    chmod +x ~/.local/bin/muda_wallpaper.sh

fi

# wallpaper.sh do Hyprland
if [ -f "$ROOT_DIR/dotfiles/hypr/wallpaper.sh" ]; then
    chmod +x ~/.config/hypr/wallpaper.sh
fi

echo "[OK] Dotfiles aplicados com sucesso."
