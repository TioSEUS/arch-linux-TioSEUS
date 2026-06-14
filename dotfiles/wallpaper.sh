#!/bin/bash

# 1. Garante que nenhuma instância antiga está rodando
killall hyprpaper 2>/dev/null

# 2. Inicia o daemon do hyprpaper em background
hyprpaper &

# 3. Dá um tempo maior (2 segundos) para o motor do hyprpaper e as telas carregarem 100%
sleep 2

# 4. Injeta as imagens na marra usando o hyprctl
hyprctl hyprpaper preload "/home/seus/Imagens/Wallpapers/guts.png"
hyprctl hyprpaper preload "/home/seus/Imagens/Wallpapers/default.png"

hyprctl hyprpaper wallpaper "DP-3,/home/seus/Imagens/Wallpapers/guts.png"
hyprctl hyprpaper wallpaper "HDMI-A-1,/home/seus/Imagens/Wallpapers/default.png"
