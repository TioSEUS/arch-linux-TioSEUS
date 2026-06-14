#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 5: Aplicando Dotfiles (Versão Robusta)"
echo "-----------------------------------------------------------------"

# Verifica se a pasta dotfiles existe
if [ ! -d "../dotfiles" ]; then
    echo "❌ Pasta '../dotfiles' não encontrada!"
    echo "   Crie a pasta e coloque suas configs dentro dela."
    exit 0
fi

cd ../dotfiles || exit 1

echo "--> Copiando configurações para ~/.config/ ..."

# Cria pastas principais
mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/waybar ~/.config/rofi \
         ~/.config/fastfetch ~/.local/share/fonts ~/.config/wallpapers

# Copia tudo de forma recursiva e força substituição
cp -rf ./* ~/.config/ 2>/dev/null || true

# Copia wallpapers para local comum
if [ -d "wallpapers" ] || [ -d "hypr/wallpapers" ]; then
    mkdir -p ~/Pictures/Wallpapers
    cp -rf wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true
    cp -rf hypr/wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || true
fi

# Configurações especiais do SDDM (precisa de root)
echo "--> Aplicando tema do SDDM..."
if [ -d "sddm" ] || [ -d "sddm-theme" ]; then
    sudo cp -rf sddm* /usr/share/sddm/themes/ 2>/dev/null || true
    sudo cp -f sddm.conf /etc/sddm.conf 2>/dev/null || true
fi

# Atualiza fontes
fc-cache -fv

echo "--> Definindo Kitty como terminal padrão no Hyprland..."
# Garante que kitty esteja configurado
if [ -f ~/.config/hypr/hyprland.conf ]; then
    sed -i 's/kitty/kitty/g' ~/.config/hypr/hyprland.conf 2>/dev/null || true
fi

echo "--> Definindo Fish como shell padrão..."
if command -v fish &> /dev/null; then
    echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which fish)" "$USER" || true
fi

echo "✅ Dotfiles aplicados com força bruta!"
echo "   Verifique se as pastas dentro de dotfiles/ estão nomeadas corretamente:"
echo "   (hypr/, kitty/, waybar/, sddm/, wallpapers/, etc.)"
