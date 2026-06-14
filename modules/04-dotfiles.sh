#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 4: Migração de Configurações Locais e SDDM"
echo "-----------------------------------------------------------------"

xdg-user-dirs-update
mkdir -p ~/Imagens

echo "--> Estruturando diretórios internos na Home..."
# O script cria as pastas direto no seu PC para os programas novos usarem
mkdir -p ~/.config/{hypr,fish,kitty,rofi,mangohud,waybar,superfile,btop,fastfetch,ghostty}
mkdir -p ~/Wallpapers

if [ -d "./dotfiles" ]; then
    echo "--> Aplicando dotfiles do repositório para a Home..."
    [ -f "./dotfiles/hyprland.conf" ] && cp ./dotfiles/hyprland.conf ~/.config/hypr/hyprland.conf
    [ -f "./dotfiles/hyprpaper.conf" ] && cp ./dotfiles/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
    [ -f "./dotfiles/config.fish" ] && cp ./dotfiles/config.fish ~/.config/fish/config.fish
    [ -f "./dotfiles/wallpaper.sh" ] && cp ./dotfiles/wallpaper.sh ~/.config/hypr/wallpaper.sh
    
    # Só copia o que realmente existir na sua pasta do GitHub
    [ -d "./dotfiles/kitty" ] && cp -r ./dotfiles/kitty/* ~/.config/kitty/
    [ -d "./dotfiles/rofi" ] && cp -r ./dotfiles/rofi/* ~/.config/rofi/
    [ -d "./dotfiles/mangohud" ] && cp -r ./dotfiles/mangohud/* ~/.config/mangohud/
    [ -d "./dotfiles/waybar" ] && cp -r ./dotfiles/waybar/* ~/.config/waybar/
    [ -d "./dotfiles/superfile" ] && cp -r ./dotfiles/superfile/* ~/.config/superfile/
    [ -d "./dotfiles/Wallpapers" ] && cp -r ./dotfiles/Wallpapers/* ~/Wallpapers/
    
    # Se um dia você subir pastas Gtk customizadas, o script já aceita
    [ -d "./dotfiles/gtk-3.0" ] && cp -r ./dotfiles/gtk-3.0/* ~/.config/gtk-3.0/
    [ -d "./dotfiles/gtk-4.0" ] && cp -r ./dotfiles/gtk-4.0/* ~/.config/gtk-4.0/

    # Tema do SDDM
    if [ -d "./dotfiles/sddm-theme" ]; then
        echo "--> Injetando tema TioSEUS-Theme no SDDM global..."
        sudo mkdir -p /usr/share/sddm/themes/
        sudo cp -r ./dotfiles/sddm-theme /usr/share/sddm/themes/TioSEUS-Theme
        sudo mkdir -p /etc/sddm.conf.d
        sudo bash -c 'cat << EOF > /etc/sddm.conf.d/theme.conf
[Theme]
Current=TioSEUS-Theme
EOF'
    fi
else
    echo "[AVISO] Pasta dotfiles/ não encontrada localmente."
fi

# Geração do script dinâmico da Waybar
cat << 'EOF' > ~/.config/hypr/mudar_wallpaper.sh
#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_IMG="$HOME/.config/hypr/current_wallpaper.png"
if [ ! -d "$WALLPAPER_DIR" ] || [ ! "$(ls -A "$WALLPAPER_DIR")" ]; then exit 1; fi
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | shuf -n 1)
cp "$RANDOM_WALL" "$CACHE_IMG"
hyprctl hyprpaper preload "$RANDOM_WALL"
hyprctl hyprpaper wallpaper "HDMI-A-1,$RANDOM_WALL"
hyprctl hyprpaper wallpaper "DP-3,$RANDOM_WALL"
sleep 1
hyprctl hyprpaper unload all
EOF
chmod +x ~/.config/hypr/mudar_wallpaper.sh
[ -f "~/.config/hypr/wallpaper.sh" ] && chmod +x ~/.config/hypr/wallpaper.sh
