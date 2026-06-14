
#!/usr/bin/env bash

set -e

echo "Detectando hardware..."

if lspci | grep -qi nvidia; then

    sudo pacman -S --needed --noconfirm \
    nvidia \
    nvidia-utils \
    nvidia-settings

fi

if lspci | grep -qi amd; then

    sudo pacman -S --needed --noconfirm \
    mesa \
    vulkan-radeon \
    lib32-vulkan-radeon

fi

if lspci | grep -qi intel; then

    sudo pacman -S --needed --noconfirm \
    mesa \
    vulkan-intel

fi
