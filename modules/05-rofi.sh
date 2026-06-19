#!/bin/bash
# Configura o Rofi completo: config base + launcher + powermenu + wifi menu
# Versão robusta: avisa sobre arquivos faltantes mas NÃO aborta o install.sh

# Sem "set -e" para que um cp que falhe não derrube o install.sh inteiro

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config completa do Rofi..."
mkdir -p ~/.config/rofi

# Helper: copia arquivo se existir, senão avisa
copy_if_exists() {
    local src="$1"
    local dst="$2"
    if [ -f "$src" ]; then
        cp "$src" "$dst" && echo "  [OK]   $(basename "$src")"
    else
        echo "  [FAIL] $src (arquivo não existe no repo)"
        return 0  # não aborta
    fi
}

# Helper: copia diretório se existir
mkdir_copy() {
    local src_dir="$1"
    local dst_dir="$2"
    mkdir -p "$dst_dir"
    if [ -d "$src_dir" ]; then
        cp -r "$src_dir/." "$dst_dir/" 2>/dev/null
        echo "  [OK]   $dst_dir (copiado)"
    else
        echo "  [FAIL] $src_dir (pasta não existe no repo)"
    fi
}

# 1. Config base
copy_if_exists "$DOT/rofi/config.rasi" ~/.config/rofi/config.rasi

# 2. Paleta TioSEUS
mkdir -p ~/.config/rofi/colors
copy_if_exists "$DOT/rofi/colors/tioseus.rasi" ~/.config/rofi/colors/tioseus.rasi

# 3. Launcher type-3
mkdir -p ~/.config/rofi/launchers/type-3/shared
copy_if_exists "$DOT/rofi/launchers/type-3/launcher.sh"        ~/.config/rofi/launchers/type-3/launcher.sh
copy_if_exists "$DOT/rofi/launchers/type-3/style-3.rasi"       ~/.config/rofi/launchers/type-3/style-3.rasi
copy_if_exists "$DOT/rofi/launchers/type-3/shared/colors.rasi" ~/.config/rofi/launchers/type-3/shared/colors.rasi
copy_if_exists "$DOT/rofi/launchers/type-3/shared/fonts.rasi"  ~/.config/rofi/launchers/type-3/shared/fonts.rasi

# 4. Powermenu type-4
mkdir -p ~/.config/rofi/powermenu/type-4/shared
copy_if_exists "$DOT/rofi/powermenu/type-4/powermenu.sh"        ~/.config/rofi/powermenu/type-4/powermenu.sh
copy_if_exists "$DOT/rofi/powermenu/type-4/style-5.rasi"        ~/.config/rofi/powermenu/type-4/style-5.rasi
copy_if_exists "$DOT/rofi/powermenu/type-4/shared/colors.rasi"  ~/.config/rofi/powermenu/type-4/shared/colors.rasi
copy_if_exists "$DOT/rofi/powermenu/type-4/shared/fonts.rasi"   ~/.config/rofi/powermenu/type-4/shared/fonts.rasi
copy_if_exists "$DOT/rofi/powermenu/type-4/shared/confirm.rasi" ~/.config/rofi/powermenu/type-4/shared/confirm.rasi

# 5. WiFi menu
copy_if_exists "$DOT/rofi/rofi-wifi-menu.sh" ~/.config/rofi/rofi-wifi-menu.sh

# 6. User image (opcional)
mkdir -p ~/.config/rofi/images
if [ -f "$DOT/rofi/images/user.png" ]; then
    cp "$DOT/rofi/images/user.png" ~/.config/rofi/images/
    echo "  [OK]   user.png"
else
    echo "  [INFO] Sem user.png — powermenu mostra espaço vazio"
fi

# 7. Permissões de execução nos scripts (só nos que existem)
[ -f ~/.config/rofi/launchers/type-3/launcher.sh ]    && chmod +x ~/.config/rofi/launchers/type-3/launcher.sh
[ -f ~/.config/rofi/powermenu/type-4/powermenu.sh ]   && chmod +x ~/.config/rofi/powermenu/type-4/powermenu.sh
[ -f ~/.config/rofi/rofi-wifi-menu.sh ]               && chmod +x ~/.config/rofi/rofi-wifi-menu.sh

echo
echo "  [OK] Etapa Rofi finalizada"
echo "  [INFO] Se algum [FAIL] apareceu acima, crie o arquivo faltante no repo"
echo "         e rode 'install.sh' de novo."
