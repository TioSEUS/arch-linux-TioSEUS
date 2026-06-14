#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 1: Preparação do Sistema"
echo "-----------------------------------------------------------------"

sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -S --noconfirm --needed reflector
sudo reflector --latest 12 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy
