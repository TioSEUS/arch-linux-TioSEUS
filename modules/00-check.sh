#!/bin/bash
# Verificações iniciais + detecção de hardware
# Detecta: CPU vendor (Intel/AMD), GPU vendor (AMD/NVIDIA/Intel), microcode necessário

echo "→ Verificando sistema..."

# Arch Linux
if ! grep -q 'Arch Linux' /etc/os-release 2>/dev/null; then
    echo "  [WARN] /etc/os-release não confirma Arch Linux — prosseguindo mesmo assim"
fi

# Conexão com internet
if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
    echo "  [ERR] Sem conexão com a internet."
    exit 1
fi
echo "  [OK] Internet OK"

# === DETECÇÃO DE CPU ===
echo
echo "→ Detectando CPU..."
CPU_INFO=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [ "$CPU_INFO" = "GenuineIntel" ]; then
    CPU_VENDOR="intel"
    MICROCODE_PKG="intel-ucode"
    echo "  [OK] CPU: Intel → vai instalar $MICROCODE_PKG"
elif [ "$CPU_INFO" = "AuthenticAMD" ]; then
    CPU_VENDOR="amd"
    MICROCODE_PKG="amd-ucode"
    echo "  [OK] CPU: AMD → vai instalar $MICROCODE_PKG"
else
    CPU_VENDOR="unknown"
    MICROCODE_PKG=""
    echo "  [WARN] CPU vendor desconhecido: $CPU_INFO — sem microcode"
fi

# === DETECÇÃO DE GPU ===
echo
echo "→ Detectando GPU..."
# Tenta lspci, fallback pra /sys
if command -v lspci &>/dev/null; then
    GPU_INFO=$(lspci -nn | grep -iE 'vga|3d|display' | head -1)
else
    GPU_INFO=$(cat /sys/class/drm/card*/device/vendor 2>/dev/null | head -1)
fi

GPU_VENDOR="unknown"
GPU_DRIVERS=()
if echo "$GPU_INFO" | grep -qiE 'amd|ati|radeon|advanced micro devices'; then
    GPU_VENDOR="amd"
    GPU_DRIVERS=(
        mesa
        lib32-mesa
        vulkan-radv
        lib32-vulkan-radv
        libva-mesa-driver
        lib32-libva-mesa-driver
        mesa-vdpau
        lib32-mesa-vdpau
        vulkan-mesa-layers
        lib32-vulkan-mesa-layers
    )
    echo "  [OK] GPU: AMD → vai instalar drivers Mesa/RADV/VA-API"
elif echo "$GPU_INFO" | grep -qiE 'nvidia'; then
    GPU_VENDOR="nvidia"
    # NVIDIA drivers são instalados via nvidia.txt (não aqui)
    GPU_DRIVERS=()
    echo "  [OK] GPU: NVIDIA → vai instalar drivers do nvidia.txt"
elif echo "$GPU_INFO" | grep -qiE 'intel'; then
    GPU_VENDOR="intel"
    GPU_DRIVERS=(
        mesa
        lib32-mesa
        vulkan-intel
        lib32-vulkan-intel
        intel-media-driver
        libva-intel-driver
        libva-utils
    )
    echo "  [OK] GPU: Intel → vai instalar drivers Intel/Mesa"
else
    echo "  [WARN] GPU não detectada — instalando Mesa genérico"
    GPU_VENDOR="unknown"
    GPU_DRIVERS=(
        mesa
        lib32-mesa
    )
fi

# Exporta pros próximos módulos (instalador lê essas variáveis)
echo "$CPU_VENDOR" > /tmp/.tioseus_cpu_vendor
echo "$MICROCODE_PKG" > /tmp/.tioseus_microcode
echo "$GPU_VENDOR" > /tmp/.tioseus_gpu_vendor
printf '%s\n' "${GPU_DRIVERS[@]}" > /tmp/.tioseus_gpu_drivers

# yay
if ! command -v yay &>/dev/null; then
    echo "  [INFO] yay não encontrado. Instalando..."
    sudo pacman -S --needed --noconfirm base-devel git
    TMP_YAY="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$TMP_YAY"
    (cd "$TMP_YAY" && makepkg -si --noconfirm)
    rm -rf "$TMP_YAY"
fi
echo "  [OK] yay disponível"

# Espaço em disco
FREE_GB=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
if [ "$FREE_GB" -lt 8 ]; then
    echo "  [WARN] Pouco espaço em disco: ${FREE_GB}GB livre (recomendado: 8GB+)"
fi

echo
echo "→ Resumo do hardware detectado:"
echo "  • CPU:  $CPU_VENDOR"
echo "  • GPU:  $GPU_VENDOR"
echo "  • ucode: $MICROCODE_PKG"
echo "  • Drivers GPU: ${GPU_DRIVERS[*]}"
echo
echo "  [OK] Tudo pronto para instalar"
