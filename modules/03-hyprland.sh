# Configura o Hyprland completo (split em 8 arquivos)
# Inclui otimizações da wiki oficial + windowrules para jogos

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Hyprland (8 arquivos)..."
mkdir -p ~/.config/hypr/scripts
mkdir -p ~/.config/hypr/wallust

# 8 arquivos da config split
cp "$DOT/hypr/hyprland.conf"    ~/.config/hypr/
cp "$DOT/hypr/monitors.conf"    ~/.config/hypr/
cp "$DOT/hypr/workspaces.conf"  ~/.config/hypr/
cp "$DOT/hypr/hyprenv.conf"     ~/.config/hypr/
cp "$DOT/hypr/userconf.conf"    ~/.config/hypr/
cp "$DOT/hypr/autostart.conf"   ~/.config/hypr/
cp "$DOT/hypr/window.conf"      ~/.config/hypr/
cp "$DOT/hypr/keybinds.conf"    ~/.config/hypr/

# Script de wallpaper
cp "$DOT/hypr/wallpaper.sh"     ~/.config/hypr/
chmod +x ~/.config/hypr/wallpaper.sh

echo "  [OK] Hyprland split em 8 arquivos instalado"
echo "    • hyprland.conf   (loader)"
echo "    • monitors.conf   (monitores)"
echo "    • workspaces.conf (workspaces por monitor)"
echo "    • hyprenv.conf    (variáveis de ambiente)"
echo "    • userconf.conf   (input + visual + animações)"
echo "    • autostart.conf  (autostart + xdg-portal fix)"
echo "    • window.conf     (windowrules + otimizações pra jogos)"
echo "    • keybinds.conf   (atalhos + scratchpad + multimedia)"
echo
echo "  [INFO] Otimizações aplicadas:"
echo "    • allow_tearing = true (master toggle)"
echo "    • vrr = 3 (só em jogos fullscreen)"
echo "    • blur xray (mais performance)"
echo "    • windowrules immediate + fullscreen + noblur pra Steam"
echo "    • XDG portal fix (file picker funciona)"
echo "    • SDL_VIDEODRIVER=wayland (jogos SDL2 nativos)"
