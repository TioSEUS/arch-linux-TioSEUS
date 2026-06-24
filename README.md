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
├── setup.sh                          ← 1 script que faz tudo
├── packages.txt                      ← pacotes oficiais (pacman)
├── aur.txt                           ← pacotes AUR (yay)
├── README.md
└── dotfiles/
    ├── hypr/
    │   ├── hyprland.conf             ← loader (faz source dos outros)
    │   ├── monitors.conf             ← placeholder
    │   ├── workspaces.conf
    │   ├── hyprenv.conf
    │   ├── userconf.conf             ← blur OFF pra Intel antiga
    │   ├── autostart.conf            ← LIMPO sem duplicatas
    │   ├── window.conf               ← sintaxe blocos v0.46+
    │   ├── keybinds.conf
    │   ├── wallpaper.sh              ← com fallback (swww/hyprpaper/swaybg)
    │   └── scripts/
    │       ├── gamemode.sh
    │       └── restart.sh
    ├── fish/config.fish              ← editor fallback + start-hyprland
    ├── kitty/kitty.conf
    ├── rofi/
    │   ├── config.rasi               ← LIMPO
    │   ├── colors/tioseus.rasi
    │   ├── launchers/type-3/...
    │   ├── powermenu/type-4/...
    │   └── rofi-wifi-menu.sh
    ├── waybar/
    │   ├── config.jsonc              ← ÚNICO (sem symlinks)
    │   └── style.css
    ├── swaync/
    │   ├── config.json
    │   └── style.css
    ├── hyprpaper.conf                ← placeholder
    ├── mangohud/mangohud.conf
    ├── cava/
    │   ├── config
    │   └── shaders/
    ├── fastfetch/config.jsonc
    ├── scripts/muda_wallpaper.sh
    └── sddm-theme/
