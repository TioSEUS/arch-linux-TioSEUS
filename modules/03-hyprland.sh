#!/bin/bash
# Configura o Hyprland

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Hyprland..."
mkdir -p ~/.config/hypr
cp "$DOT/hypr/hyprland.conf" ~/.config/hypr/hyprland.conf
cp "$DOT/hypr/wallpaper.sh"  ~/.config/hypr/wallpaper.sh
chmod +x ~/.config/hypr/wallpaper.sh
echo "  [OK] hypr/ instalado"

# Validação básica da config
if command -v hyprland &>/dev/null; then
    echo "→ Validando config..."
    if Hyprland --config ~/.config/hypr/hyprland.conf -q >/dev/null 2>&1; then
        echo "  [OK] Config válida"
    else
        echo "  [WARN] Hyprland reportou warnings (normal em sessão sem wayland)"
    fi
fi
