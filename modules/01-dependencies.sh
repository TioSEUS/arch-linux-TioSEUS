#!/bin/bash
# Instala todos os pacotes necessários de uma vez
# Versão robusta: mostra progresso, não trava, tem fallback

# Não usar "set -e" para que um pacote que falhe não derrube todo o script

LOG_FILE="/tmp/tioseus_pacman.log"
AUR_LOG_FILE="/tmp/tioseus_aur.log"

echo "→ Verificando repositório multilib (necessário para mangohud/lib32)..."
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
    cava
    fastfetch
    network-manager-applet
    hyprshade
    playerctl
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

# Lista de pacotes AUR (via yay)
AUR_PKGS=(
    swww
    superfile
    qt6gtk2
    hyprlock
    hypridle
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
    # Mostra progresso: log vai pro arquivo, mas user vê que tá rodando
    # </dev/null garante EOF em qualquer prompt
    # --mflags --nocheck pula testes longos
    # YAY_NO_PROMPT=1 desabilita TODOS os prompts interativos
    if YAY_NO_PROMPT=1 yay -S --noconfirm --needed --mflags --nocheck --cleanafter "$pkg" >>"$AUR_LOG_FILE" 2>&1 </dev/null; then
        echo -e "\r  [OK]   $pkg"
    else
        echo -e "\r  [FAIL] $pkg (ver log: $AUR_LOG_FILE)"
        FAILED_AUR+=("$pkg")
    fi
done

# Fallback: se superfile falhou, instala via script oficial
if [[ " ${FAILED_AUR[@]} " =~ " superfile " ]]; then
    echo
    echo "→ [FALLBACK] Instalando superfile via instalador oficial..."
    if command -v curl &>/dev/null; then
        if curl -fsSL https://superfile.netlify.app/install/install.sh | bash >>"$AUR_LOG_FILE" 2>&1; then
            echo "  [OK]   superfile (via script oficial)"
            # remove da lista de falhas
            FAILED_AUR=("${FAILED_AUR[@]/superfile/}")
            FAILED_AUR=("${FAILED_AUR[@]/ /}")
        else
            echo "  [FAIL] superfile (fallback também falhou)"
        fi
    fi
fi

# Fallback: se qt6gtk2 falhou, tenta qt6-gtk2 (nome alternativo)
if [[ " ${FAILED_AUR[@]} " =~ " qt6gtk2 " ]]; then
    echo
    echo "→ [FALLBACK] Tentando qt6-gtk2 como alternativa..."
    if YAY_NO_PROMPT=1 yay -S --noconfirm --needed qt6-gtk2 >>"$AUR_LOG_FILE" 2>&1 </dev/null; then
        echo "  [OK]   qt6-gtk2 (alternativa)"
        FAILED_AUR=("${FAILED_AUR[@]/qt6gtk2/}")
    else
        echo "  [WARN] qt6gtk2 não disponível — apps Qt6 podem usar theme fallback"
    fi
fi

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
