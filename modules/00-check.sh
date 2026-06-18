#!/bin/bash
# Verificações iniciais antes de instalar qualquer coisa

set -euo pipefail

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
if [ "$FREE_GB" -lt 5 ]; then
    echo "  [WARN] Pouco espaço em disco: ${FREE_GB}GB livre (recomendado: 5GB+)"
fi

echo "  [OK] Tudo pronto para instalar"
