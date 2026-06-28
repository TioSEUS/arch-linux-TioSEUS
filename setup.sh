#!/bin/bash
echo "🚀 Iniciando o Instalador Inteligente TioSEUS..."

DOTFILES_DIR="dotfiles"
HYPR_DIR="$DOTFILES_DIR/hypr"

# --- 1. DETECÇÃO DE CPU ---
echo "🔍 Detectando processador..."
CPU_VENDOR=$(grep -si "vendor_id" /proc/cpuinfo | head -n 1)
MICROCODE=""
if [[ "$CPU_VENDOR" =~ "GenuineIntel" ]]; then
    MICROCODE="intel-ucode"
elif [[ "$CPU_VENDOR" =~ "AuthenticAMD" ]]; then
    MICROCODE="amd-ucode"
fi

# --- 2. DETECÇÃO DE GPU ---
echo "🔍 Detectando placa de vídeo..."
GPU_INFO=$(lspci | grep -iE 'vga|3d')
GPU_PACKAGES=""
IS_NVIDIA=false
if [[ "$GPU_INFO" =~ "NVIDIA" ]]; then
    GPU_PACKAGES="nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings"
    IS_NVIDIA=true
elif [[ "$GPU_INFO" =~ "Advanced Micro Devices" || "$GPU_INFO" =~ "AMD/ATI" ]]; then
    GPU_PACKAGES="mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon"
elif [[ "$GPU_INFO" =~ "Intel Corporation" ]]; then
    GPU_PACKAGES="mesa lib32-mesa intel-media-driver vulkan-intel lib32-vulkan-intel"
fi

# --- 3. PACOTES OFICIAIS ---
echo "📦 Instalando pacotes base..."
sudo pacman -S --noconfirm --needed \
    $MICROCODE $GPU_PACKAGES \
    ttf-jetbrains-mono-nerd ttf-font-awesome opendesktop-fonts \
    swww waybar swaync kitty grim slurp jq nautilus discord sddm bluez bluez-utils networkmanager git fish \
    mangohud fastfetch

# --- 4. AUR ---
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
fi
yay -S --noconfirm walker-bin matugen-bin brave-bin

# --- 5. NVIDIA FIX ---
if [ "$IS_NVIDIA" = true ]; then
    sed -i 's/# env = GBM_BACKEND,nvidia-drm/env = GBM_BACKEND,nvidia-drm/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = __GLX_VENDOR_LIBRARY_NAME,nvidia/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = LIBVA_DRIVER_NAME,nvidia/env = LIBVA_DRIVER_NAME,nvidia/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = NVD_BACKEND,direct/env = NVD_BACKEND,direct/g' "$HYPR_DIR/hyprenv.conf"
fi

# --- 6. IMPLANTAÇÃO ---
echo "📁 Copiando arquivos..."
mkdir -p ~/.config/{hypr,waybar,walker,fish,fastfetch,MangoHud} ~/Pictures/Wallpapers

cp -r $DOTFILES_DIR/hypr/* ~/.config/hypr/
cp -r $DOTFILES_DIR/waybar/* ~/.config/waybar/
cp -r $DOTFILES_DIR/walker/* ~/.config/walker/
cp -r $DOTFILES_DIR/fish/* ~/.config/fish/ 2>/dev/null
cp -r $DOTFILES_DIR/fastfetch/* ~/.config/fastfetch/ 2>/dev/null
cp -r $DOTFILES_DIR/MangoHud/* ~/.config/MangoHud/ 2>/dev/null

chmod +x ~/.config/hypr/wallpaper.sh

# --- 7. FIX DO Ç (NATIVO) ---
echo "⌨️ Configurando o mapa nativo de caracteres para o 'ç'..."
printf "<dead_acute> <c> : \"ç\" U00E7\n<dead_acute> <C> : \"Ç\" U00C7\n" > "$HOME/.XCompose"

chsh -s /usr/bin/fish

# --- 8. SDDM E SERVIÇOS ---
echo "🚪 Configurando login e serviços..."
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Autologin]\nSession=hyprland" | sudo tee /etc/sddm.conf.d/hyprland.conf > /dev/null
sudo systemctl enable sddm NetworkManager bluetooth

echo "🎉 Pronto! Reinicie o sistema: systemctl reboot"
