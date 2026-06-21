# Instala scripts auxiliares do Hyprland (gamemode + restart)
# (O módulo 03-hyprland.sh já copia esses scripts, mas este módulo garante
#  permissões e cria symlinks globais pra uso fora do Hyprland)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Verificando scripts auxiliares do Hyprland..."
mkdir -p ~/.config/hypr/scripts

# Garante que os scripts estão presentes (caso 03-hyprland.sh rode antes)
if [ -f "$DOT/hypr/scripts/gamemode.sh" ]; then
    cp "$DOT/hypr/scripts/gamemode.sh" ~/.config/hypr/scripts/
    chmod +x ~/.config/hypr/scripts/gamemode.sh
    echo "  [OK] gamemode.sh"
else
    echo "  [WARN] dotfiles/hypr/scripts/gamemode.sh não encontrado"
fi

if [ -f "$DOT/hypr/scripts/restart.sh" ]; then
    cp "$DOT/hypr/scripts/restart.sh" ~/.config/hypr/scripts/
    chmod +x ~/.config/hypr/scripts/restart.sh
    echo "  [OK] restart.sh"
else
    echo "  [WARN] dotfiles/hypr/scripts/restart.sh não encontrado"
fi

echo
echo "  [INFO] Atalhos que usam esses scripts:"
echo "    • Super+Shift+G → liga/desliga gamemode"
echo "    • Super+N       → reinicia waybar + swaync"
echo "    • Super+Shift+N → reinicia só waybar"
