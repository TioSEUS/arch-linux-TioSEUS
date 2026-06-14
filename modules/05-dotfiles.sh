#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles (Adaptado à sua estrutura)"
echo "-----------------------------------------------------------------"

if [ ! -d "../dotfiles" ]; then
    echo "❌ Pasta '../dotfiles' não encontrada!"
    exit 0
fi

cd ../dotfiles || exit 1

echo "--> Copiando configurações..."

# Copia pastas completas
mkdir -p ~/.config
cp -rf kitty ~/.config/ 2>/dev/null || true
cp -rf waybar ~/.config/ 2>/dev/null || true
cp -rf rofi ~/.config/ 2>/dev/null || true
cp -rf mangohud ~/.config/ 2>/dev/null || true
cp -rf superfile ~/.config/ 2>/dev/null ||
