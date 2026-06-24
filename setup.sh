#!/bin/bash
# ============================================================
#  TioSEUS Arch Linux Hyprland Installer
#  Faz: detecção de hardware + instala pacotes + copia configs
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$REPO_DIR/dotfiles"

G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; N='\033[0m'
ok()   { echo -e "${G}[OK]${N} $1"; }
info() { echo -e "${Y}[INFO]${N} $1"; }
err()  { echo -e "${R}[ERR]${N} $1"; }

[ "$EUID" -eq 0 ] && { err "Rode como usuário comum, não root."; exit 1; }
command -v pacman >/dev/null || { err "Não é Arch Linux."; exit 1; }

echo "╔═══════════════════════════════════════════════╗"
echo "║   TioSEUS Hyprland Installer                          ║"
echo "╚═══════════════════════════════════════════════╝"
echo

# === 1. DETECÇÃO DE HARDWARE ===
echo "=== DETECÇÃO DE HARDWARE ==="

CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [ "$CPU_VENDOR" = "GenuineIntel" ]; then
    MICROCODE="intel-ucode"; ok "CPU: Intel → $MICROCODE"
elif [ "$CPU_VENDOR" = "AuthenticAMD" ]; then
    MICROCODE="amd-ucode"; ok "CPU: AMD → $MICROCODE"
else
    MICROCODE=""; info "CPU: desconhecido"
fi

GPU_DRIVERS=()
if command -v lspci >/dev/null; then
    GPU_LINE=$(lspci -nn | grep -iE '\[(0300|0302|0380)\]' | head -1)
    GPU_ID=$(echo "$GPU_LINE" | grep -oE '\[[0-9a-f]{4}:' | head -1 | tr -d '[:[')
    case "$GPU_ID" in
        1002) GPU_DRIVERS=(mesa lib32-mesa vulkan-radv lib32-vulkan-radv libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau); ok "GPU: AMD (1002)" ;;
        10de) GPU_DRIVERS=(nvidia nvidia-utils lib32-nvidia-utils); ok "GPU: NVIDIA (10de)" ;;
        8086) GPU_DRIVERS=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver libva-utils); ok "GPU: Intel (8086)" ;;
        *)    GPU_DRIVERS=(mesa lib32-mesa); info "GPU: não identificada" ;;
    esac
fi

if ! grep -qE '^\[multilib\]' /etc/pacman.conf; then
    info "Habilitando multilib..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
fi

# === 2. INSTALAÇÃO DE PACOTES ===
echo
echo "=== INSTALAÇÃO DE PACOTES ==="

sudo pacman -Syu --noconfirm || true

if ! command -v yay >/dev/null; then
    info "Instalando yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

[ -n "$MICROCODE" ] && sudo pacman -S --needed --noconfirm "$MICROCODE"

for drv in "${GPU_DRIVERS[@]}"; do
    sudo pacman -S --needed --noconfirm "$drv" 2>/dev/null && ok "$drv" || true
done

if [ -f "$REPO_DIR/packages.txt" ]; then
    info "Instalando pacotes oficiais (de packages.txt)..."
    while IFS= read -r pkg; do
        pkg="${pkg%%#*}"; pkg="$(echo "$pkg" | xargs)"
        [ -z "$pkg" ] && continue
        pacman -Qi "$pkg" >/dev/null 2>&1 && continue
        sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null && ok "$pkg" || err "FAIL: $pkg"
    done < "$REPO_DIR/packages.txt"
fi

if [ -f "$REPO_DIR/aur.txt" ]; then
    info "Instalando pacotes AUR (de aur.txt)..."
    while IFS= read -r pkg; do
        pkg="${pkg%%#*}"; pkg="$(echo "$pkg" | xargs)"
        [ -z "$pkg" ] && continue
        yay -Qi "$pkg" >/dev/null 2>&1 && continue
        yay -S --noconfirm --needed --mflags --nocheck "$pkg" 2>/dev/null </dev/null && ok "$pkg" || err "FAIL: $pkg"
    done < "$REPO_DIR/aur.txt"
fi

# === 3. COPIA CONFIGS ===
echo
echo "=== COPIANDO CONFIGS ==="

BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
for dir in hypr kitty fish rofi waybar swaync hyprpaper superfile MangoHud fastfetch cava darkman scripts; do
    [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP/"
done
ok "Backup em: $BACKUP"

for dir in hypr kitty fish rofi waybar swaync superfile mangohud fastfetch cava scripts; do
    [ -d "$DOTFILES/$dir" ] && cp -r "$DOTFILES/$dir" "$HOME/.config/"
done

mkdir -p "$HOME/.config/hyprpaper"
cp "$DOTFILES/hyprpaper.conf" "$HOME/.config/hyprpaper/" 2>/dev/null
sed -i "s|SEU_USUARIO|$USER|g" "$HOME/.config/hyprpaper/hyprpaper.conf" 2>/dev/null
sed -i "s|\$HOME|$HOME|g" "$HOME/.config/hyprpaper/hyprpaper.conf" 2>/dev/null

mkdir -p "$HOME/Pictures/Wallpapers"
cp -r "$DOTFILES/Wallpapers/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null

find "$HOME/.config/hypr/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null
find "$HOME/.config/rofi" -name "*.sh" -exec chmod +x {} \; 2>/dev/null
find "$HOME/.config/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null

ok "Configs copiadas"

# === 4. SHELL + SDDM ===
echo
echo "=== SHELL + SDDM ==="

FISH=$(command -v fish)
[ -n "$FISH" ] && chsh -s "$FISH" "$USER" && ok "Fish como shell padrão"

if [ -d "$DOTFILES/sddm-theme" ]; then
    info "Instalando tema SDDM..."
    sudo cp -r "$DOTFILES/sddm-theme" /usr/share/sddm/themes/tioseus
    sudo chown -R root:root /usr/share/sddm/themes/tioseus
    if [ -f /etc/sddm.conf ]; then
        sudo sed -i 's|^Current=.*|Current=tioseus|' /etc/sddm.conf
    else
        echo -e "[Theme]\nCurrent=tioseus" | sudo tee /etc/sddm.conf >/dev/null
    fi
    sudo systemctl enable sddm.service
    ok "Tema SDDM instalado"
fi

[ -f "$HOME/.config/scripts/muda_wallpaper.sh" ] && sudo ln -sf "$HOME/.config/scripts/muda_wallpaper.sh" /usr/local/bin/muda-wallpaper

# === 5. FIM ===
echo
echo "╔═══════════════════════════════════════════════╗"
echo "║   INSTALAÇÃO CONCLUÍDA                        ║"
echo "╚═══════════════════════════════════════════════╝"
echo
ok "Backup: $BACKUP"
echo
echo -e "${Y}Próximos passos:${N}"
echo "  1. Reinicie: systemctl reboot"
echo "  2. No SDDM, escolha 'Hyprland'"
echo "  3. Se waybar não aparecer, edite:"
echo "     nano ~/.config/waybar/config.jsonc"
echo "     (troque 'output': 'DP-3' pelo seu monitor)"
echo "  4. Se for notebook, descomente 'battery' na waybar"
echo
echo -e "${Y}Em caso de problema:${N}"
echo "  Restaure backup: cp -r $BACKUP/* ~/.config/"
