#!/bin/bash
# Instala todos os pacotes necessários de uma vez
# Versão robusta: não aborta em pacote individual

# IMPORTANTE: sem "set -e" para que um pacote que falhe não derrube todo o script

echo "→ Verificando repositório multilib (necessário para mangohud/lib32)..."
if ! grep -qE '^\[multilib\]' /etc/pacman.conf; then
    echo "  [INFO] Habilitando [multilib] em /etc/pacman.conf..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    if ! grep -qE '^\[multilib\]' /etc/pacman.conf; then
        # Fallback: adiciona manualmente
        echo "" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "[multilib]" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
    fi
    echo "  [OK] multilib habilitado"
else
    echo "  [OK] multilib já habilitado"
fi

echo "→ Sincronizando repositórios e atualizando sistema..."
sudo pacman -Syu --noconfirm || {
    echo "  [WARN] pacman -Syu reportou erro, mas continuando..."
}

# Lista de pacotes oficiais (pacman)
PACMAN_PKGS=(
    hyprland
    kitty
    fish
    rofi
    waybar
    swaync
    darkman
    hyprpaper
    sddm
    qt6-multimedia
    qt5compat
    fcitx5
    fcitx5-configtool
    polkit-gnome
    grim
    slurp
    wl-clipboard
    qt6ct
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols
    papirus-icon-theme
    adwaita-icon-theme
    gnome-keyring
    networkmanager
    fastfetch
    starship
    mangohud
    lib32-mangohud
)

echo "→ Instalando pacotes oficiais (${#PACMAN_PKGS[@]} pacotes)..."
FAILED_PACMAN=()
for pkg in "${PACMAN_PKGS[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
    else
        if sudo pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1; then
            echo "  [OK]   $pkg"
        else
            echo "  [FAIL] $pkg"
            FAILED_PACMAN+=("$pkg")
        fi
    fi
done

# Lista de pacotes AUR (via yay)
AUR_PKGS=(
    swww
    superfile
    qt6gtk2
)

echo
echo "→ Instalando pacotes AUR (${#AUR_PKGS[@]} pacotes)..."
FAILED_AUR=()
for pkg in "${AUR_PKGS[@]}"; do
    if yay -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
    else
        if yay -S --noconfirm --needed "$pkg" >/dev/null 2>&1; then
            echo "  [OK]   $pkg"
        else
            echo "  [FAIL] $pkg"
            FAILED_AUR+=("$pkg")
        fi
    fi
done

# Relatório final
echo
echo "→ Relatório de instalação:"
if [ ${#FAILED_PACMAN[@]} -eq 0 ] && [ ${#FAILED_AUR[@]} -eq 0 ]; then
    echo "  [OK] Todos os pacotes instalados com sucesso!"
else
    if [ ${#FAILED_PACMAN[@]} -gt 0 ]; then
        echo "  [WARN] Falhas no pacman: ${FAILED_PACMAN[*]}"
    fi
    if [ ${#FAILED_AUR[@]} -gt 0 ]; then
        echo "  [WARN] Falhas no AUR: ${FAILED_AUR[*]}"
    fi
    echo "  [INFO] Você pode tentar instalar manualmente depois com:"
    echo "         sudo pacman -S ${FAILED_PACMAN[*]}"
    echo "         yay -S ${FAILED_AUR[*]}"
fi

# Não usar exit 1 mesmo com falhas — deixa o install.sh continuar nos próximos módulos
echo "  [OK] Etapa de dependências finalizada"
