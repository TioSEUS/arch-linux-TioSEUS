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

# --- 3. PACOTES OFICIAIS (PACMAN) ---
echo "📦 Instalando pacotes base, fontes e apps essenciais..."
sudo pacman -S --noconfirm --needed \
    $MICROCODE $GPU_PACKAGES \
    ttf-jetbrains-mono-nerd ttf-font-awesome opendesktop-fonts \
    swww waybar swaync kitty grim slurp jq nautilus discord sddm bluez bluez-utils networkmanager git fish

# --- 4. AUR HELPER (YAY) E APPS DO AUR ---
if ! command -v yay &> /dev/null; then
    echo "📥 Instalando o yay (AUR Helper)..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
fi

echo "📦 Instalando Walker, Matugen e Brave do AUR..."
yay -S --noconfirm walker-bin matugen-bin brave-bin

# --- 5. CONFIGURAÇÕES DINÂMICAS DA NVIDIA ---
if [ "$IS_NVIDIA" = true ]; then
    echo "⚙️ Aplicando correções para NVIDIA no hyprenv.conf..."
    sed -i 's/# env = GBM_BACKEND,nvidia-drm/env = GBM_BACKEND,nvidia-drm/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = __GLX_VENDOR_LIBRARY_NAME,nvidia/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = LIBVA_DRIVER_NAME,nvidia/env = LIBVA_DRIVER_NAME,nvidia/g' "$HYPR_DIR/hyprenv.conf"
    sed -i 's/# env = NVD_BACKEND,direct/env = NVD_BACKEND,direct/g' "$HYPR_DIR/hyprenv.conf"
fi

# --- 6. IMPLANTAÇÃO DOS DOTFILES ---
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
if [ -d "$HOME/.config" ]; then
    echo "🗄️ Realizando backup das configurações antigas..."
    mkdir -p "$BACKUP_DIR" && cp -r ~/.config/* "$BACKUP_DIR/"
fi

echo "📁 Criando diretórios e copiando novos arquivos..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/walker ~/Pictures/Wallpapers

cp -r $DOTFILES_DIR/hypr/* ~/.config/hypr/
cp -r $DOTFILES_DIR/waybar/* ~/.config/waybar/
cp -r $DOTFILES_DIR/walker/* ~/.config/walker/
cp -r $DOTFILES_DIR/fish ~/.config/ 2>/dev/null || true

chmod +x ~/.config/hypr/wallpaper.sh
echo "🐚 Mudando o shell padrão para Fish..."
chsh -s /usr/bin/fish

# --- 7. FINALIZAÇÃO ---
echo "🔄 Habilitando serviços do sistema..."
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

echo "🎉 Tudo instalado com sucesso (incluindo Brave e Discord)! Reinicie o sistema: systemctl reboot"
