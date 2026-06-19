# Arch Linux Dotfiles - TioSEUS

Um instalador automatizado e modular para o gerenciador de janelas Hyprland no Arch Linux.

## 🚀 Instalação

Para clonar o repositório e aplicar as configurações no seu sistema, execute os seguintes comandos no terminal:

```bash
git clone [https://github.com/TioSEUS/arch-linux-TioSEUS.git](https://github.com/TioSEUS/arch-linux-TioSEUS.git)
cd arch-linux-TioSEUS
chmod +x install.sh validate.sh modules/*.sh
./install.sh

arch-linux-TioSEUS/
├── install.sh              # Orquestrador principal (com backup + validação)
├── validate.sh             # Validação pré-commit (rode antes de commitar as alterações)
├── modules/                # Scripts modulares (executados em ordem numérica)
│   ├── 00-check.sh         # Verificações do sistema (Arch Linux, yay/paru, internet)
│   ├── 01-dependencies.sh  # Instalação de todos os pacotes essenciais do sistema
│   ├── 02-fish.sh          # Configuração e otimização do Fish Shell
│   ├── 03-hyprland.sh      # Instalação e ajustes do gerenciador de janelas Hyprland
│   ├── 04-kitty.sh         # Configuração do emulador de terminal Kitty
│   ├── 05-rofi.sh          # Configuração completa do Rofi (Launcher + Powermenu + Wi-Fi)
│   ├── 06-hyprpaper.sh     # Inicialização do Hyprpaper com caminhos absolutos
│   ├── 07-wallpapers.sh    # Implantação da coleção de papéis de parede
│   ├── 08-waybar.sh        # Configuração da barra de status Waybar + integração Darkman
│   ├── 09-swaync.sh        # Central de notificações SwayNC + estilo personalizado
│   ├── 10-sddm-theme.sh    # Aplicação do tema para a tela de login SDDM (requer sudo)
│   ├── 11-superfile.sh     # Gerenciador de arquivos para terminal Superfile + configs
│   ├── 12-mangohud.sh      # Menu de monitoramento de jogos MangoHud + perfil pronto
│   ├── 13-cava.sh          # Visualizador de áudio CAVA + shaders de efeito
│   ├── 14-fastfetch.sh     # Personalização das informações do sistema com Fastfetch
│   ├── 15-scripts.sh       # Scripts utilitários e auxiliares do ambiente gráfico
│   └── 16-final.sh         # Tarefas pós-instalação e limpeza de arquivos temporários
├── dotfiles/               # Arquivos de configuração originais que serão copiados para ~/.config
└── README.md               # Documentação do projeto
