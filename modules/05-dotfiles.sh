#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles (Adaptado à sua estrutura)"
echo "-----------------------------------------------------------------"

cd ../dotfiles || { echo "❌ dotfiles não encontrado"; exit 1; }

echo "--> Copiando configurações..."

mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/waybar ~/.config/rofi \
         ~/.config/mangohud ~/.config/superfile ~/Pictures/Wallpapers

# Arquivos soltos
cp -f hyprland.conf ~/.config/hypr/hyprland.conf
cp -f hyprpaper.conf ~/.config/hyprpaper.conf
cp -f wallpaper.sh ~/.config/wallpaper.sh
cp -f config.fish ~/.config/fish/config.fish 2>/dev/null || true

# Pastas
cp -rf kitty/* ~/.config/kitty/ 2>/dev/null || true
cp -rf waybar/* ~/.config/waybar/ 2>/dev/null || true
cp -rf rofi/* ~/.config/rofi/ 2>/dev/null || true
cp -rf mangohud/* ~/.config/mangohud/ 2>/dev/null || true
cp -rf superfile/* ~/.config/superfile/ 2>/dev/null || true
cp -rf Wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true

# SDDM Theme
echo "--> Aplicando tema SDDM..."
if [ -d "sddm-theme" ]; then
    sudo rm -rf /usr/share/sddm/themes/tio-seus-theme 2>/dev/null || true
    sudo cp -rf sddm-theme /usr/share/sddm/themes/tio-seus-theme
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=tio-seus-theme" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
fi

chmod +x ~/.config/hypr/hyprland.conf ~/.config/wallpaper.sh 2>/dev/null || true
fc-cache -fv

echo "--> Fish como shell padrão..."
if command -v fish &> /dev/null; then
    echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which fish)" "$USER" || true
fi

echo "✅ Dotfiles aplicados!"
echo "   Rode: sudo systemctl restart sddm"
