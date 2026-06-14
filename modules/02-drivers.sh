#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 2: Drivers de Hardware (GPU + Microcode)"
echo "-----------------------------------------------------------------"

# Seleção de GPU
echo "Qual GPU você possui?"
select gpu in "AMD" "NVIDIA" "Intel" "Pular"; do
    case $gpu in
        AMD)
            echo "--> Instalando drivers AMD..."
            sudo pacman -S --noconfirm --needed \
                mesa vulkan-radeon libva-mesa-driver mesa-vdpau \
                opencl-mesa amdvlk
            break
            ;;
        NVIDIA)
            echo "--> Instalando drivers NVIDIA..."
            sudo pacman -S --noconfirm --needed \
                nvidia nvidia-utils nvidia-settings lib32-nvidia-utils \
                opencl-nvidia
            break
            ;;
        Intel)
            echo "--> Instalando drivers Intel..."
            sudo pacman -S --noconfirm --needed \
                mesa vulkan-intel intel-media-driver libva-intel-driver
            break
            ;;
        Pular)
            echo "--> Pulando instalação de drivers de GPU."
            break
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done

# Seleção de Microcode
echo "Qual processador (CPU) você possui?"
select cpu in "AMD" "Intel" "Pular"; do
    case $cpu in
        AMD)
            echo "--> Instalando microcode AMD..."
            sudo pacman -S --noconfirm --needed amd-ucode
            break
            ;;
        Intel)
            echo "--> Instalando microcode Intel..."
            sudo pacman -S --noconfirm --needed intel-ucode
            break
            ;;
        Pular)
            echo "--> Pulando microcode."
            break
            ;;
        *)
            echo "Opção inválida."
            ;;
    esac
done

echo "--> Drivers e microcode configurados!"
