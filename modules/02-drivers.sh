#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 2: Drivers de Hardware"
echo "-----------------------------------------------------------------"

echo "Qual GPU você tem?"
select gpu in "AMD" "NVIDIA" "Intel" "Pular"; do
    case $gpu in
        AMD)
            sudo pacman -S --noconfirm --needed mesa vulkan-radeon libva-mesa-driver mesa-vdpau opencl-mesa amdvlk
            break ;;
        NVIDIA)
            sudo pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings lib32-nvidia-utils opencl-nvidia
            break ;;
        Intel)
            sudo pacman -S --noconfirm --needed mesa vulkan-intel intel-media-driver libva-intel-driver
            break ;;
        Pular) break ;;
    esac
done

echo "Qual CPU você tem?"
select cpu in "AMD" "Intel" "Pular"; do
    case $cpu in
        AMD) sudo pacman -S --noconfirm --needed amd-ucode; break ;;
        Intel) sudo pacman -S --noconfirm --needed intel-ucode; break ;;
        Pular) break ;;
    esac
done
