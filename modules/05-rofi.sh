#!/usr/bin/env bash

# Para o script se encontrar algum erro
set -e

echo "[INFO] Configurando o Rofi para o Hyprland..."

# 1. Garante que o Rofi correto (Wayland) está instalado
# O rofi comum do X11 costuma dar erro de foco ou não abrir no Hyprland
sudo pacman -S --needed --noconfirm rofi-wayland

# 2. Cria as pastas de configuração se elas não existirem
mkdir -p ~/.config/rofi

# 3. Cria o arquivo de configuração básica limpo
# ATENÇÃO: O EOF no final tem que estar totalmente encostado na esquerda!
cat << 'EOF' > ~/.config/rofi/config.rasi
configuration {
    modi: "run,drun,window";
    icon-theme: "Oranchelo";
    show-icons: true;
    terminal: "kitty";
    drun-display-format: "{icon} {name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "   Apps ";
    display-run: "   Run ";
    display-window: " 󰕰  Window ";
    sidebar-mode: true;
}

@theme "default"
EOF

echo "[OK] Rofi configurado com sucesso!"
