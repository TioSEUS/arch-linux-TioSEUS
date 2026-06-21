#!/bin/bash
# Instala todos os pacotes necessários de uma vez
# Lê hardware detectado do módulo 00-check.sh

LOG_FILE="/tmp/tioseus_pacman.log"
AUR_LOG_FILE="/tmp/tioseus_aur.log"

echo "→ Verificando repositório multilib (necessário para lib32-*)..."
if ! grep -qE '^\[multilib\]' /etc/pacman.conf; then
    echo "  [INFO] Habilitando [multilib] em /etc/pacman.conf..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    if ! grep -qE '^\[multilib\]' /etc/pacman.conf; then
        echo "" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "[multilib]" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
    fi
    echo "  [OK] multilib habilitado"
else
    echo "  [OK] multilib já habilitado"
fi

echo "→ Sincronizando repositórios e atualizando sistema..."
sudo pacman -Syu --noconfirm 2>&1 | tee "$LOG_FILE" || {
    echo "  [WARN] pacman -Syu reportou erro, mas continuando..."
}

# === MICROCODE (baseado na CPU detectada) ===
MICROCODE_PKG=$(cat /tmp/.tioseus_microcode 2>/dev/null)
if [ -n "$MICROCODE_PKG" ]; then
    echo
    echo "→ Instalando microcode: $MICROCODE_PKG"
    sudo pacman -S --noconfirm --needed "$MICROCODE_PKG" >>"$LOG_FILE" 2>&1 && \
        echo "  [OK] $MICROCODE_PKG instalado"
fi

# === DRIVERS GPU (baseado na GPU detectada) ===
echo
echo "→ Instalando drivers GPU..."
while IFS= read -r drv; do
    [ -z "$drv" ] && continue
    if pacman -Qi "$drv" &>/dev/null; then
        echo "  [SKIP] $drv já está instalado"
    else
        if sudo pacman -S --noconfirm --needed "$drv" >>"$LOG_FILE" 2>&1 </dev/null; then
            echo "  [OK]   $drv"
        else
            echo "  [FAIL] $drv"
        fi
    fi
done < /tmp/.tioseus_gpu_drivers

# === PACOTES OFICIAIS ===
PACMAN_PKGS=(
    hyprland kitty fish rofi waybar swaync darkman
    swww mpvpaper
    sddm qt6-multimedia qt5compat
    fcitx5 fcitx5-configtool polkit-gnome
    qt6ct
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
    papirus-icon-theme adwaita-icon-theme
    gnome-keyring networkmanager
    fastfetch starship cava
    hyprlock hypridle hyprshade
    hyprshot wl-clipboard cliphist
    playerctl brightnessctl
    grim slurp
    wallust
    qt5-graphicaleffects qt5-quickcontrols2
    network-manager-applet
    xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    nwg-displays nwg-look
    code  # VS Code
    yazi ffmpegthumbs poppler
    python matugen
    gvfs
    thunar
)

echo
echo "→ Instalando pacotes oficiais (${#PACMAN_PKGS[@]} pacotes)..."
echo "  (log completo em $LOG_FILE)"
echo
FAILED_PACMAN=()
for pkg in "${PACMAN_PKGS[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
    else
        printf "  [..]   %-30s " "$pkg"
        if sudo pacman -S --noconfirm --needed "$pkg" >>"$LOG_FILE" 2>&1 </dev/null; then
            echo -e "\r  [OK]   $pkg"
        else
            echo -e "\r  [FAIL] $pkg"
            FAILED_PACMAN+=("$pkg")
        fi
    fi
done

# === PACOTES AUR ===
AUR_PKGS=(
    hyprpaper
    hyprshot-git
    wallust
    hyprshade
    mpvpaper
    ttf-cascadia-code-nerd
    ffmpegthumbs
    nwg-displays
    bibata-cursor-theme-bin
)

echo
echo "→ Instalando pacotes AUR (${#AUR_PKGS[@]} pacotes)..."
echo "  (log completo em $AUR_LOG_FILE)"
echo "  [INFO] Pacotes AUR são compilados do código-fonte — pode demorar!"
echo
FAILED_AUR=()
for pkg in "${AUR_PKGS[@]}"; do
    if yay -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
        continue
    fi

    printf "  [..]   %-30s (compilando...)\n" "$pkg"
    if YAY_NO_PROMPT=1 yay -S --noconfirm --needed --mflags --nocheck --cleanafter "$pkg" >>"$AUR_LOG_FILE" 2>&1 </dev/null; then
        echo -e "\r  [OK]   $pkg"
    else
        echo -e "\r  [FAIL] $pkg (ver log: $AUR_LOG_FILE)"
        FAILED_AUR+=("$pkg")
    fi
done

# Relatório final
echo
echo "═══════════════════════════════════════════════════════"
echo "→ Relatório de instalação:"
if [ ${#FAILED_PACMAN[@]} -eq 0 ] && [ ${#FAILED_AUR[@]} -eq 0 ]; then
    echo "  [OK] Todos os pacotes instalados com sucesso!"
else
    [ ${#FAILED_PACMAN[@]} -gt 0 ] && echo "  [WARN] Falhas no pacman: ${FAILED_PACMAN[*]}"
    [ ${#FAILED_AUR[@]} -gt 0 ]    && echo "  [WARN] Falhas no AUR:    ${FAILED_AUR[*]}"
    echo
    echo "  [INFO] Tente instalar manualmente depois com:"
    [ ${#FAILED_PACMAN[@]} -gt 0 ] && echo "         sudo pacman -S ${FAILED_PACMAN[*]}"
    [ ${#FAILED_AUR[@]} -gt 0 ]    && echo "         yay -S ${FAILED_AUR[*]}"
fi
echo "═══════════════════════════════════════════════════════"
echo "  [OK] Etapa de dependências finalizada"
