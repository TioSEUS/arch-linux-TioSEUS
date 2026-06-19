#!/bin/bash
# Configura o Rofi completo: launcher + powermenu + wifi menu
# Versão expandida com paleta TioSEUS

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do Rofi (versão completa)..."
mkdir -p ~/.config/rofi

# Config base
cp "$DOT/rofi/config.rasi" ~/.config/rofi/config.rasi

# Paleta TioSEUS
mkdir -p ~/.config/rofi/colors
cp "$DOT/rofi/colors/tioseus.rasi" ~/.config/rofi/colors/

# Launcher type-3 (grid fullscreen)
mkdir -p ~/.config/rofi/launchers/type-3/shared
cp "$DOT/rofi/launchers/type-3/launcher.sh"        ~/.config/rofi/launchers/type-3/
cp "$DOT/rofi/launchers/type-3/style-3.rasi"       ~/.config/rofi/launchers/type-3/
cp "$DOT/rofi/launchers/type-3/shared/colors.rasi" ~/.config/rofi/launchers/type-3/shared/
cp "$DOT/rofi/launchers/type-3/shared/fonts.rasi"  ~/.config/rofi/launchers/type-3/shared/

# Powermenu type-4 (5 botões circulares)
mkdir -p ~/.config/rofi/powermenu/type-4/shared
cp "$DOT/rofi/powermenu/type-4/powermenu.sh"        ~/.config/rofi/powermenu/type-4/
cp "$DOT/rofi/powermenu/type-4/style-5.rasi"        ~/.config/rofi/powermenu/type-4/
cp "$DOT/rofi/powermenu/type-4/shared/colors.rasi"  ~/.config/rofi/powermenu/type-4/shared/
cp "$DOT/rofi/powermenu/type-4/shared/fonts.rasi"   ~/.config/rofi/powermenu/type-4/shared/
cp "$DOT/rofi/powermenu/type-4/shared/confirm.rasi" ~/.config/rofi/powermenu/type-4/shared/

# WiFi menu
cp "$DOT/rofi/rofi-wifi-menu.sh" ~/.config/rofi/

# User image (placeholder se existir)
mkdir -p ~/.config/rofi/images
if [ -f "$DOT/rofi/images/user.png" ]; then
    cp "$DOT/rofi/images/user.png" ~/.config/rofi/images/
fi

# Permissões de execução
chmod +x ~/.config/rofi/launchers/type-3/launcher.sh
chmod +x ~/.config/rofi/powermenu/type-4/powermenu.sh
chmod +x ~/.config/rofi/rofi-wifi-menu.sh

echo "  [OK] Rofi completo instalado"
echo "    • Launcher:    ~/.config/rofi/launchers/type-3/launcher.sh"
echo "    • Power Menu:  ~/.config/rofi/powermenu/type-4/powermenu.sh"
echo "    • WiFi Menu:   ~/.config/rofi/rofi-wifi-menu.sh"
