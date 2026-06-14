#!/usr/bin/env bash

# Sair imediatamente se algum comando falhar
set -e

clear
echo "================================================================="
echo "   INSTALADOR MODULAR - ARCH + HYPRLAND + TERMINAL ECOSYSTEM     "
echo "================================================================="
echo "   Carregando módulos sequenciais de configuração de sistema...  "
echo "================================================================="
echo ""

# Garante permissão de execução em todos os módulos antes de rodar
chmod +x ./modules/*.sh

# 1. Executa Módulo de Drivers e Hardware
source ./modules/01-drivers.sh

echo ""
read -p "Módulos validados. Deseja iniciar a instalação completa do sistema? (s/n): " CONFIRM
if [[ ! $CONFIRM =~ ^[Ss]$ ]]; then
    echo "Instalação cancelada."
    exit 0
fi

# Instalação dos drivers capturados pelo Módulo 1
sudo pacman -Syu --noconfirm --needed git base-devel curl $MICROCODE $GPU_PACKAGES

# 2. Executa Módulo de Instalação de Programas e AUR
source ./modules/02-packages.sh

# 3. Executa Módulo de Configuração de Temas Escuros GTK
source ./modules/03-themes.sh

# 4. Executa Módulo de Restauração de Dotfiles
source ./modules/04-dotfiles.sh

# 5. Configuração Final do Interpretador de Shell (Fish)
echo "--> Redefinindo shell padrão para o Fish Shell..."
if [ "$SHELL" != "/usr/bin/fish" ]; then
    chsh -s /usr/bin/fish
fi

echo ""
echo "================================================================="
echo "   SISTEMA MODULAR INSTALADO COM SUCESSO!                        "
echo "   Seu terminal avançado (Ghostty, Btop, Fastfetch) e as regras  "
echo "   de tema escuro unificado GTK 3/4 estão prontas.               "
echo "   Reinicie para subir o ambiente gráfico pelo SDDM.             "
echo "================================================================="
