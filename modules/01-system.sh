#!/usr/bin/env bash

set -e

echo "Atualizando keyring..."

sudo pacman -Sy --noconfirm archlinux-keyring

echo "Atualizando bancos..."

sudo pacman -Syy --noconfirm

echo "Atualizando sistema..."

sudo pacman -Syu --noconfirm
