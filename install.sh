#!/bin/bash
set -e

DOTFILES_DIR="$HOME/arch-linux-TioSEUS"
REPO_URL="https://github.com/TioSEUS/arch-linux-TioSEUS.git"

echo "======================================="
echo "  🚀 Instalador Dotfiles do TioSEUS 🚀 "
echo "======================================="
echo

if [ -d "$DOTFILES_DIR" ]; then
    echo "⚠️ A pasta $DOTFILES_DIR já existe!"
    echo "Faça um backup antes: mv ~/arch-linux-TioSEUS ~/arch-linux-TioSEUS-backup"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "📦 Instalando git..."
    sudo pacman -S --noconfirm git
fi

mkdir -p "$HOME/.config"
echo "📥 Clonando o repositório..."
git clone "$REPO_URL" "$DOTFILES_DIR"

cd "$DOTFILES_DIR"
chmod +x setup.sh
./setup.sh
