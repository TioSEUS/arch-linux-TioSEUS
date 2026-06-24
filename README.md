# Arch Linux Dotfiles - TioSEUS

Um instalador automatizado e modular para o gerenciador de janelas Hyprland no Arch Linux.

## 🚀 Instalação

Para clonar o repositório e aplicar as configurações no seu sistema, execute os seguintes comandos no terminal:

```bash
Instalação
git clone https://github.com/TioSEUS/arch-linux-TioSEUS.gitcd arch-linux-TioSEUSchmod +x setup.sh./setup.sh

O que o setup.sh faz
Detecta CPU (Intel/AMD) e instala o microcode certo
Detecta GPU (AMD/NVIDIA/Intel) por vendor ID e instala drivers
Instala pacotes de packages.txt (pacman) e aur.txt (yay)
Faz backup das configs atuais em ~/.config-backup-*
Copia dotfiles para ~/.config/
Seta fish como shell padrão
Instala tema SDDM em /usr/share/sddm/themes/tioseus
Pós-instalação
Reinicie: systemctl reboot
No SDDM, escolha "Hyprland"
Edite ~/.config/hypr/monitors.conf com seu monitor
Se for notebook, descomente battery em ~/.config/waybar/config.jsonc
Atalhos do fish
conf-hypr → edita hyprland.conf
conf-waybar → edita waybar config
conf-rofi → edita rofi config
conf-swaync → edita swaync config

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
