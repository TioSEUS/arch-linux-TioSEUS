```bash
#!/bin/bash
# Configura o Rofi completo: config base + launcher + powermenu + wifi menu
# Tudo num único módulo para evitar redundância
# Paleta TioSEUS (azul + dourado + escuro)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config completa do Rofi..."
mkdir -p ~/.config/rofi

# 1. Config base
cp "$DOT/rofi/config.rasi" ~/.config/rofi/config.rasi

# 2. Paleta TioSEUS
mkdir -p ~/.config/rofi/colors
cp "$DOT/rofi/colors/tioseus.rasi" ~/.config/rofi/colors/

# 3. Launcher type-3 (grid fullscreen 7x4 com ícones grandes)
mkdir -p ~/.config/rofi/launchers/type-3/shared
cp "$DOT/rofi/launchers/type-3/launcher.sh"        ~/.config/rofi/launchers/type-3/
cp "$DOT/rofi/launchers/type-3/style-3.rasi"       ~/.config/rofi/launchers/type-3/
cp "$DOT/rofi/launchers/type-3/shared/colors.rasi" ~/.config/rofi/launchers/type-3/shared/
cp "$DOT/rofi/launchers/type-3/shared/fonts.rasi"  ~/.config/rofi/launchers/type-3/shared/

# 4. Powermenu type-4 (5 botões circulares com avatar)
mkdir -p ~/.config/rofi/powermenu/type-4/shared
cp "$DOT/rofi/powermenu/type-4/powermenu.sh"        ~/.config/rofi/powermenu/type-4/
cp "$DOT/rofi/powermenu/type-4/style-5.rasi"        ~/.config/rofi/powermenu/type-4/
cp "$DOT/rofi/powermenu/type-4/shared/colors.rasi"  ~/.config/rofi/powermenu/type-4/shared/
cp "$DOT/rofi/powermenu/type-4/shared/fonts.rasi"   ~/.config/rofi/powermenu/type-4/shared/
cp "$DOT/rofi/powermenu/type-4/shared/confirm.rasi" ~/.config/rofi/powermenu/type-4/shared/

# 5. WiFi menu
cp "$DOT/rofi/rofi-wifi-menu.sh" ~/.config/rofi/

# 6. User image (placeholder para o powermenu) — opcional
mkdir -p ~/.config/rofi/images
if [ -f "$DOT/rofi/images/user.png" ]; then
    cp "$DOT/rofi/images/user.png" ~/.config/rofi/images/
    echo "  [OK] user.png instalado"
else
    echo "  [INFO] Sem user.png — powermenu mostra espaço vazio (não quebra)"
fi

# 7. Permissões de execução nos scripts
chmod +x ~/.config/rofi/launchers/type-3/launcher.sh
chmod +x ~/.config/rofi/powermenu/type-4/powermenu.sh
chmod +x ~/.config/rofi/rofi-wifi-menu.sh

echo "  [OK] Rofi completo instalado"
echo "    • Launcher:    ~/.config/rofi/launchers/type-3/launcher.sh"
echo "    • Power Menu:  ~/.config/rofi/powermenu/type-4/powermenu.sh"
echo "    • WiFi Menu:   ~/.config/rofi/rofi-wifi-menu.sh"
echo "    • Paleta:      ~/.config/rofi/colors/tioseus.rasi"
