
#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p ~/.config

mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/kitty
mkdir -p ~/.config/fish
mkdir -p ~/.config/btop
mkdir -p ~/.config/fastfetch

mkdir -p ~/Pictures/Wallpapers

cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/
cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/
cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/
cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/
cp -rf "$ROOT_DIR/dotfiles/btop" ~/.config/

cp -f "$ROOT_DIR/dotfiles/Fastfetch/config.jsonc" \
~/.config/fastfetch/config.jsonc

cp -rf "$ROOT_DIR/dotfiles/Wallpapers/"* \
~/Pictures/Wallpapers/

mkdir -p ~/.local/bin

cp -f "$ROOT_DIR/scripts/muda_wallpaper.sh" \
~/.local/bin/muda_wallpaper.sh

chmod +x ~/.local/bin/muda_wallpaper.sh

echo "Dotfiles aplicados."
