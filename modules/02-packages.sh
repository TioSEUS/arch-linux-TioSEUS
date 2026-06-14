#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 2: Instalação de Pacotes, Utilitários de Terminal e AUR"
echo "-----------------------------------------------------------------"

echo "--> Atualizando base do sistema..."
sudo pacman -Syu --noconfirm --needed git base-devel curl flatpak

echo "--> Instalando o gerenciador de AUR (Paru)..."
if ! command -v paru &> /dev/null; then
    cd /tmp && git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin && makepkg -si --noconfirm && cd -
fi

echo "--> Instalando ferramentas nativas, de terminal e interface..."
# CORRIGIDO: Removido darkman daqui, pois ele pertence ao AUR
sudo pacman -S --noconfirm --needed \
    hyprland sddm waybar kitty fish rofi btop fastfetch \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol \
    bluez bluez-utils blueman networkmanager network-manager-applet \
    ttf-font-awesome ttf-fira-code ttf-nerd-fonts-symbols-common \
    qt5-wayland qt6-wayland xdg-desktop-portal-hyprland polkit-gnome \
    xdg-user-dirs brightnessctl pamixer wl-clipboard grim slurp mpv \
    obs-studio steam gnome-disk-utility hyprpaper mangohud discord

# Ativando daemons base
sudo systemctl enable --now NetworkManager bluetooth sddm.service

echo "--> Instalando pacotes do AUR via Paru..."
# CORRIGIDO: Incluído o 'darkman' aqui para ser instalado pelo AUR corretamente
paru -S --noconfirm --needed \
    ghostty-git brave-bin visual-studio-code-bin anydesk-bin \
    davinci-resolve heroic-games-launcher-bin prism-launcher-bin \
    lact nwg-look-bin xdg-desktop-portal-gtk darkman

sudo systemctl enable --now lactd

echo "--> Instalando gerenciador Superfile..."
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

echo "--> Ativando repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
