#!/bin/bash
# Instala todos os pacotes necessários
# Lê: required.txt + AUR_PKGS (hardcoded, versões -bin) + drivers do hardware detectado

LOG_FILE="/tmp/tioseus_pacman.log"
AUR_LOG_FILE="/tmp/tioseus_aur.log"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

# === MICROCODE (CPU detectada) ===
MICROCODE_PKG=$(cat /tmp/.tioseus_microcode 2>/dev/null)
if [ -n "$MICROCODE_PKG" ]; then
    echo
    echo "→ Instalando microcode: $MICROCODE_PKG"
    sudo pacman -S --noconfirm --needed "$MICROCODE_PKG" >>"$LOG_FILE" 2>&1 \
        && echo "  [OK] $MICROCODE_PKG instalado"
fi

# === DRIVERS GPU (GPU detectada) ===
GPU_VENDOR=$(cat /tmp/.tioseus_gpu_vendor 2>/dev/null)
echo
echo "→ Instalando drivers GPU ($GPU_VENDOR)..."
if [ -f /tmp/.tioseus_gpu_drivers ]; then
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
fi

# === PACOTES OFICIAIS (lê de required.txt) ===
if [ ! -f "$REPO/required.txt" ]; then
    echo "  [ERR] required.txt não encontrado em $REPO"
    exit 1
fi

echo
echo "→ Instalando pacotes oficiais (de required.txt)..."
echo "  (log completo em $LOG_FILE)"
echo
FAILED_PACMAN=()
while IFS= read -r pkg; do
    pkg="${pkg%%#*}"
    pkg="$(echo "$pkg" | xargs)"
    [ -z "$pkg" ] && continue

    if pacman -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
    else
        printf "  [..]   %-35s " "$pkg"
        if sudo pacman -S --noconfirm --needed "$pkg" >>"$LOG_FILE" 2>&1 </dev/null; then
            echo -e "\r  [OK]   $pkg"
        else
            echo -e "\r  [FAIL] $pkg"
            FAILED_PACMAN+=("$pkg")
        fi
    fi
done < "$REPO/required.txt"

# === PACOTES AUR (versões -bin = pré-compiladas, super rápidas) ===
AUR_PKGS=(
    hyprpaper
    hyprshot-bin
    wallust-bin
    hyprshade-bin
    mpvpaper-bin
    ttf-cascadia-code-nerd
    ffmpegthumbs
    nwg-displays-git
    bibata-cursor-theme-bin
    matugen-bin
)

echo
echo "→ Instalando pacotes AUR (${#AUR_PKGS[@]} pacotes, versões -bin = rápidas)..."
echo "  (log completo em $AUR_LOG_FILE)"
echo
FAILED_AUR=()
for pkg in "${AUR_PKGS[@]}"; do
    if yay -Qi "$pkg" &>/dev/null; then
        echo "  [SKIP] $pkg já está instalado"
        continue
    fi

    printf "  [..]   %-35s " "$pkg"
    if YAY_NO_PROMPT=1 yay -S --noconfirm --needed --mflags --nocheck --cleanafter "$pkg" >>"$AUR_LOG_FILE" 2>&1 </dev/null; then
        echo -e "\r  [OK]   $pkg"
    else
        echo -e "\r  [FAIL] $pkg"
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
