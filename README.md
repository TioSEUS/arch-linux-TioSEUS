Arch Linux Dotfiles - TioSEUS
Instalador automatizado para Hyprland no Arch Linux.

Instalação
git clone https://github.com/TioSEUS/arch-linux-TioSEUS.gitcd arch-linux-TioSEUSchmod +x install.sh modules/*.sh./install.sh

Estrutura
arch-linux-TioSEUS/
├── install.sh              # Orquestrador principal
├── modules/                # Scripts modulares (executados em ordem)
│   ├── 00-check.sh         # Verificações (arch, yay, internet)
│   ├── 01-dependencies.sh  # Instala todos os pacotes
│   ├── 02-fish.sh          # Fish + config
│   ├── 03-hyprland.sh      # Hyprland + config
│   ├── 04-kitty.sh         # Kitty + config
│   ├── 05-rofi.sh          # Rofi + config
│   ├── 06-hyprpaper.sh     # Hyprpaper + config
│   ├── 07-waybar-swaync.sh # Waybar/SwayNC/Darkman
│   ├── 08-sddm-theme.sh    # Tema do SDDM (sudo)
│   ├── 09-superfile.sh     # Superfile + config
│   ├── 10-mangohud.sh      # MangoHud + config
│   ├── 11-scripts.sh       # Scripts auxiliares
│   ├── 12-wallpapers.sh    # Wallpapers
│   └── 13-final.sh         # Pós-instalação
├── dotfiles/               # Configs que serão copiadas
└── README.md

