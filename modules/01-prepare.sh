#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 1: Preparação do Sistema"
echo "-----------------------------------------------------------------"

echo "--> Atualizando chaves..."
sudo pacman -Sy --noconfirm archlinux-keyring

echo "--> Otimizando mirrors..."
sudo pacman -S --noconfirm --needed reflector
sudo reflector --latest 12 --sort rate --save /etc/pacman.d/mirrorlist

echo "--> Sincronizando repositórios..."
sudo pacman -Syy
