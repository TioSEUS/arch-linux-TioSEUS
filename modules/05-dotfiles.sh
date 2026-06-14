#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles (Adaptado à sua estrutura)"
echo "-----------------------------------------------------------------"

if [ ! -d "../dotfiles" ]; then
    echo "❌ Pasta '../dotfiles' não encontrada!"
    exit 0
fi

cd ../dotfiles || exit 1

echo "--> Copiando configurações..."

# Copia pastas completas
mkdir -p ~/.config
cp -rf kitty ~/.config/ 2>/dev/null || true
cp -rf waybar ~/.config/ 2>/dev/null || true
cp -rf rofi ~/.config/ 2>/dev/null || true
cp -rf mangohud ~/.config/ 2>/dev/null || true
cp -rf superfile ~/.config/ 2>/dev/null || true

# Copia arquivos da raiz do dotfiles
cp -f hyprland.conf ~/.config/hypr/ 2>/dev/null || true
cp -f hyprpaper.conf ~/.config/ 2>/dev/null || true
cp -f wallpaper.sh ~/.config/ 2>/dev/null || true
cp -f config.fish ~/.config/fish/config.fish 2>/dev/null || true

# Wallpapers
echo "--> Copiando Wallpapers..."
mkdir -p ~/Pictures/Wallpapers
cp -rf Wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true

# Tema do SDDM
echo "--> Aplicando tema do SDDM..."
if [ -d "sddm-theme" ]; then
    sudo rm -rf /usr/share/sddm/themes/tio-seus-theme 2>/dev/null || true
    sudo cp -rf sddm-theme /usr/share/sddm/themes/tio-seus-theme
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=tio-seus-theme" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
fi

# Atualiza fontes e cache
fc-cache -fv

# Garante permissões do Hyprland
chmod +x ~/.config/hypr/hyprland.conf 2>/dev/null || true
chmod +x ~/.config/wallpaper.sh 2>/dev/null || true

echo "--> Definindo Fish como shell padrão..."
if command -v fish &> /dev/null; then
    echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which fish)" "$USER" || true
fi

echo "✅ Dotfiles aplicados!"
echo "   → hyprland.conf, kitty, waybar, sddm-theme, wallpapers, etc."
