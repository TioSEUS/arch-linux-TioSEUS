#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 3: Pacotes Essenciais"
echo "-----------------------------------------------------------------"

export CHROOT="$HOME/.cache/paru/build"
mkdir -p "$CHROOT"

# Limpeza Java
sudo pacman -Rdd --noconfirm jdk21-openjdk jre21-openjdk jre21-openjdk-headless 2>/dev/null || true

sudo pacman -S --noconfirm --needed git base-devel curl flatpak

if ! command -v paru &> /dev/null; then
    cd /tmp && rm -rf paru
    git clone https://aur.archlinux.org/paru.git
    cd paru && makepkg -si --noconfirm --needed && cd .. && rm -rf paru
fi

sudo pacman -S --noconfirm --needed \
    hyprland sddm waybar kitty fish rofi btop fastfetch \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol \
    bluez bluez-utils blueman networkmanager network-manager-applet \
    ttf-font-awesome ttf-fira-code ttf-nerd-fonts-symbols-common \
    qt5-wayland qt6-wayland xdg-desktop-portal-hyprland polkit-gnome \
    xdg-user-dirs brightnessctl pamixer wl-clipboard grim slurp mpv \
    obs-studio steam gnome-disk-utility hyprpaper mangohud discord \
    opencl-mesa prism-launcher nwg-look

paru -S --noconfirm --needed \
    ghostty-bin brave-bin visual-studio-code-bin anydesk-bin \
    lact darkman xdg-desktop-portal-gtk

sudo systemctl enable --now NetworkManager bluetooth sddm lactd 2>/dev/null || true

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
bash -c "$(curl -sLo- https://superfile.dev/install.sh)" || true
