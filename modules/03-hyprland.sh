# Configura o Hyprland completo (split em 8 arquivos + 3 scripts)
# Inclui otimizações da wiki oficial + windowrules para jogos + auto-config de monitores

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Hyprland (8 arquivos + 3 scripts)..."
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

# === SCRIPTS AUXILIARES ===
cp "$DOT/hypr/scripts/gamemode.sh"            ~/.config/hypr/scripts/
cp "$DOT/hypr/scripts/restart.sh"             ~/.config/hypr/scripts/
cp "$DOT/hypr/scripts/auto-config-monitors.sh" ~/.config/hypr/scripts/
chmod +x ~/.config/hypr/scripts/*.sh

echo "  [OK] Hyprland split em 8 arquivos + 3 scripts auxiliares instalado"
echo "    • hyprland.conf   (loader)"
echo "    • monitors.conf   (placeholder — gerado pelo auto-config)"
echo "    • workspaces.conf (workspaces por monitor)"
echo "    • hyprenv.conf    (variáveis de ambiente)"
echo "    • userconf.conf   (input + visual + animações)"
echo "    • autostart.conf  (autostart + xdg-portal fix + auto-config)"
echo "    • window.conf     (windowrules + otimizações pra jogos)"
echo "    • keybinds.conf   (atalhos + multimedia)"
echo "    • scripts/auto-config-monitors.sh  ⭐ detecta monitores no boot"
echo "    • scripts/gamemode.sh              (Super+Shift+G)"
echo "    • scripts/restart.sh               (Super+N)"
echo
echo "  [INFO] Otimizações aplicadas:"
echo "    • allow_tearing = true (master toggle)"
echo "    • vrr = 3 (só em jogos fullscreen)"
echo "    • blur xray (mais performance)"
echo "    • windowrules immediate + fullscreen + noblur pra Steam"
echo "    • XDG portal fix (file picker funciona)"
echo "    • AUTO-CONFIG de monitores (detecta no boot)"
