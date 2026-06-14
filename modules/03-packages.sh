
#!/usr/bin/env bash

set -e

sudo pacman -S --needed --noconfirm \
git \
base-devel \
curl \
flatpak \
hyprland \
waybar \
kitty \
fish \
rofi \
btop \
fastfetch \
hyprpaper \
networkmanager \
network-manager-applet \
pipewire \
pipewire-alsa \
pipewire-pulse \
pipewire-jack \
wireplumber \
pavucontrol \
blueman \
bluez \
bluez-utils \
brightnessctl \
pamixer \
grim \
slurp \
wl-clipboard \
sddm \
nwg-look \
ttf-font-awesome \
ttf-fira-code \
qt5-wayland \
qt6-wayland \
polkit-gnome \
xdg-desktop-portal-hyprland

if ! command -v paru >/dev/null; then

    cd /tmp

    rm -rf paru

    git clone https://aur.archlinux.org/paru.git

    cd paru

    makepkg -si --noconfirm

fi

paru -S --needed --noconfirm \
brave-bin \
visual-studio-code-bin \
darkman
