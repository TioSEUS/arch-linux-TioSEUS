#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles (Versão Corrigida - Caminho Absoluto)"
echo "-----------------------------------------------------------------"

# Caminho absoluto para a pasta dotfiles (independente de onde o script é chamado)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="$ROOT_DIR/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Pasta dotfiles não encontrada em: $DOTFILES_DIR"
    exit 1
fi

echo "--> Usando dotfiles em: $DOTFILES_DIR"

cd "$DOTFILES_DIR" || exit 1

echo "--> Copiando configurações..."

mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/waybar ~/.config/rofi \
         ~/.config/mangohud ~/.config/superfile ~/Pictures/Wallpapers

# Arquivos soltos na raiz
cp -f hyprland.conf ~/.config/hypr/hyprland.conf 2>/dev/null || true
cp -f hyprpaper.conf ~/.config/hyprpaper.conf 2>/dev/null || true
cp -f wallpaper.sh ~/.config/wallpaper.sh 2>/dev/null || true
cp -f config.fish ~/.config/fish/config.fish 2>/dev/null || true

# Pastas
cp -rf kitty ~/.config/ 2>/dev/null || true
cp -rf waybar ~/.config/ 2>/dev/null || true
cp -rf rofi ~/.config/ 2>/dev/null || true
cp -rf mangohud ~/.config/ 2>/dev/null || true
cp -rf superfile ~/.config/ 2>/dev/null || true
cp -rf Wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true

# Tema SDDM
echo "--> Aplicando tema do SDDM..."
if [ -d "sddm-theme" ]; then
    sudo rm -rf /usr/share/sddm/themes/tio-seus-theme 2>/dev/null || true
    sudo cp -rf sddm-theme /usr/share/sddm/themes/tio-seus-theme
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=tio-seus-theme" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
fi

chmod +x ~/.config/hypr/hyprland.conf ~/.config/wallpaper.sh 2>/dev/null || true
fc-cache -fv

echo "--> Definindo Fish como shell padrão..."
if command -v fish &> /dev/null; then
    echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which fish)" "$USER" || true
fi

echo "✅ Dotfiles aplicados com sucesso!"
echo "   Rode manualmente se necessário: sudo systemctl restart sddm"
