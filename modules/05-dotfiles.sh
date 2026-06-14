#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles + Correções"
echo "-----------------------------------------------------------------"

cd ../dotfiles || { echo "❌ dotfiles não encontrado"; exit 1; }

echo "--> Instalando dependências do tema SDDM (Qt)..."
sudo pacman -S --noconfirm --needed qt6-multimedia qt5-compat

echo "--> Copiando configurações..."

mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/waybar ~/.config/rofi \
         ~/.config/mangohud ~/.config/superfile ~/Pictures/Wallpapers

# Arquivos principais
cp -f hyprland.conf ~/.config/hypr/hyprland.conf
cp -f hyprpaper.conf ~/.config/hyprpaper.conf
cp -f wallpaper.sh ~/.config/wallpaper.sh
cp -f config.fish ~/.config/fish/config.fish 2>/dev/null || true

# Pastas
cp -rf kitty ~/.config/ 2>/dev/null || true
cp -rf waybar ~/.config/ 2>/dev/null || true
cp -rf rofi ~/.config/ 2>/dev/null || true
cp -rf mangohud ~/.config/ 2>/dev/null || true
cp -rf superfile ~/.config/ 2>/dev/null || true
cp -rf Wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true

# Tema SDDM
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
command -v fish && echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null && chsh -s "$(which fish)" "$USER" || true

echo "✅ Dotfiles aplicados!"
echo "   Reinicie o SDDM: sudo systemctl restart sddm"
