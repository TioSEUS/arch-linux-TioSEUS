
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
xdg-desktop-portal-hyprland \ 
xdg-user-dirs

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
darkman \ 
hyprpaper

echo "[INFO] Instalando Superfile..."

if ! command -v spf >/dev/null 2>&1; then
    bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
fi

if command -v spf >/dev/null 2>&1; then
    echo "[OK] Superfile instalado."
else
    echo "[ERRO] Superfile não encontrado."
fi

#Criar diretorios padroes
xdg-user-dirs-update

# Fcitx5 (cedilha e input method)
sudo pacman -S --needed --noconfirm \
    fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-im

# Cria .XCompose para cedilha
mkdir -p ~/.config/fcitx5
cat > ~/.XCompose << 'EOF'
include "%L"
<dead_acute> <c> : "ç" U00E7
<dead_acute> <C> : "Ç" U00C7
EOF
