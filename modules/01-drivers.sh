#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 1: Configuração de Hardware e Drivers"
echo "-----------------------------------------------------------------"

# Menu de Microcode
echo "Selecione o fabricante do seu PROCESSADOR:"
echo "1) AMD"
echo "2) Intel"
read -p "Opção (1-2): " CPU_CHOICE

case $CPU_CHOICE in
    1) MICROCODE="amd-ucode" ;;
    2) MICROCODE="intel-ucode" ;;
    *) echo "Opção inválida. Abortando."; exit 1 ;;
esac

echo ""
# Menu de Vídeo
echo "Selecione o driver da sua PLACA DE VÍDEO (GPU):"
echo "1) NVIDIA (Proprietário)"
echo "2) AMD (Mesa open-source)"
echo "3) INTEL (Mesa open-source)"
read -p "Opção (1-3): " GPU_CHOICE

case $GPU_CHOICE in
    1) GPU_PACKAGES="nvidia nvidia-utils lib32-nvidia-utils nvidia-settings" ;;
    2) GPU_PACKAGES="xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon" ;;
    3) GPU_PACKAGES="xf86-video-intel mesa lib32-mesa intel-media-driver libva-intel-driver" ;;
    *) echo "Opção inválida. Abortando."; exit 1 ;;
esac

# Exporta as variáveis para o script principal conseguir ler
export MICROCODE
export GPU_PACKAGES
