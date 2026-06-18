#!/bin/bash
# Pós-instalação: dicas finais e checagem

set -euo pipefail

echo "→ Pós-instalação..."

# Garante permissões
chmod +x ~/.config/hypr/wallpaper.sh 2>/dev/null || true
chmod +x ~/.config/scripts/*.sh 2>/dev/null || true

# Reporta status
echo
echo "  Status final:"
[ -f ~/.config/hypr/hyprland.conf ]   && echo "  [OK] Hyprland"      || echo "  [FALTA] Hyprland"
[ -f ~/.config/kitty/kitty.conf ]     && echo "  [OK] Kitty"         || echo "  [FALTA] Kitty"
[ -f ~/.config/rofi/config.rasi ]     && echo "  [OK] Rofi"          || echo "  [FALTA] Rofi"
[ -f ~/.config/fish/config.fish ]     && echo "  [OK] Fish"          || echo "  [FALTA] Fish"
[ -f ~/.config/hyprpaper/hyprpaper.conf ] && echo "  [OK] Hyprpaper" || echo "  [FALTA] Hyprpaper"
[ -d ~/Pictures/Wallpapers ]          && echo "  [OK] Wallpapers"    || echo "  [FALTA] Wallpapers"
[ -d /usr/share/sddm/themes/tioseus ] && echo "  [OK] SDDM theme"    || echo "  [FALTA] SDDM theme"
echo

echo "  [INFO] Não esqueça de:"
echo "         • Configurar seus monitores em ~/.config/hypr/hyprland.conf (linhas 'monitor =')"
echo "         • Adicionar configs próprias de waybar em ~/.config/waybar/"
echo "         • Adicionar configs próprias de swaync em ~/.config/swaync/"
echo "         • Rebootar antes de logar pela primeira vez"
