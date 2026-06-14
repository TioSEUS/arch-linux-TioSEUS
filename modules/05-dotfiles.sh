#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles"
echo "-----------------------------------------------------------------"

if [ ! -d "../dotfiles" ]; then
    echo "⚠️ Pasta '../dotfiles' não encontrada. Pulando..."
    exit 0
fi

cd ../dotfiles || exit 1

echo "--> Instalando stow..."
sudo pacman -S --noconfirm --needed stow 2>/dev/null || true

echo "--> Criando links simbólicos..."
stow -Rvt ~ */ 2>/dev/null || true

# Fallback
if [ $? -ne 0 ]; then
    echo "--> Usando fallback..."
    cp -r ./* ~/.config/ 2>/dev/null || true
fi

echo "--> Definindo Fish como shell padrão..."
if command -v fish &> /dev/null; then
    echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which fish)" "$USER" || true
fi

echo "✅ Dotfiles aplicados com sucesso!"
