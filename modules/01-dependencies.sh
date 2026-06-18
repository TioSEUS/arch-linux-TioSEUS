#!/bin/bash
# Instala todos os pacotes necessários de uma vez

set -euo pipefail

echo "→ Atualizando sistema..."
sudo pacman -Syu --noconfirm

echo "→ Instalando pacotes oficiais..."
sudo pacman -S --needed --noconfirm \
    hyprland kitty fish rofi waybar swaync darkman \
    hyprpaper sddm qt6-multimedia qt5compat \
    fcitx5 fcitx5-configtool polkit-gnome \
    grim slurp wl-clipboard qt6ct \
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
    papirus-icon-theme adwaita-icon-theme \
    gnome-keyring networkmanager \
    fastfetch starship

echo "→ Instalando pacotes AUR..."
yay -S --needed --noconfirm \
    swww \
    superfile \
    mangohud \
    qt6gtk2

echo "  [OK] Pacotes instalados"
