# 🚀 Arch Linux TioSEUS

Este repositório contém meus dotfiles pessoais e scripts de automação para um ambiente **Hyprland** de alta performance, minimalista e com transições dinâmicas de cores.

## 🛠️ Estrutura do Projeto

```text
arch-linux-TioSEUS/
├── dotfiles/
│   ├── hypr/
│   │   ├── hyprland.conf
│   │   ├── hyprenv.conf
│   │   ├── autostart.conf
│   │   ├── userconf.conf
│   │   ├── window.conf
│   │   └── wallpaper.sh
│   ├── waybar/
│   │   ├── config
│   │   └── style.css
│   ├── walker/
│   │   └── config.json
│   ├── fish/
│   │   └── config.fish
│   ├── fastfetch/
│   │   └── config.jsonc
│   └── MangoHud/
│       └── MangoHud.conf
├── install.sh
├── setup.sh
└── README.md

---

## 📦 Instalação (Automática)

Para instalar tudo em um Arch Linux recém-formatado, basta rodar o comando abaixo no terminal:

```bash
curl -O [https://raw.githubusercontent.com/TioSEUS/arch-linux-TioSEUS/main/install.sh](https://raw.githubusercontent.com/TioSEUS/arch-linux-TioSEUS/main/install.sh) && bash install.sh
