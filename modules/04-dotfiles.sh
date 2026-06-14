#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Aplicando dotfiles..."

# Diretórios principais
mkdir -p ~/.config/{hypr,waybar,kitty,fish,btop,fastfetch,rofi,hyprpaper,fcitx5}
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.local/bin

# ==================== COPIAR DOTFILES ====================

# Hyprland + hyprpaper
[ -d "$ROOT_DIR/dotfiles/hypr" ] && cp -rf "$ROOT_DIR/dotfiles/hypr" ~/.config/
[ -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ] && cp -f "$ROOT_DIR/dotfiles/hyprpaper.conf" ~/.config/hyprpaper/hyprpaper.conf

# Outros configs
[ -d "$ROOT_DIR/dotfiles/waybar" ] && cp -rf "$ROOT_DIR/dotfiles/waybar" ~/.config/
[ -d "$ROOT_DIR/dotfiles/kitty" ] && cp -rf "$ROOT_DIR/dotfiles/kitty" ~/.config/
[ -d "$ROOT_DIR/dotfiles/fish" ] && cp -rf "$ROOT_DIR/dotfiles/fish" ~/.config/
[ -d "$ROOT_DIR/dotfiles/rofi" ] && cp -rf "$ROOT_DIR/dotfiles/rofi" ~/.config/

# Wallpapers
if [ -d "$ROOT_DIR/dotfiles/Wallpapers" ]; then
    cp -rf "$ROOT_DIR/dotfiles/Wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null || true
    echo "[OK] Wallpapers copiados"
fi

# Script de trocar wallpaper
if [ -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ]; then
    cp -f "$ROOT_DIR/dotfiles/scripts/muda_wallpaper.sh" ~/.local/bin/muda_wallpaper.sh
    chmod +x ~/.local/bin/muda_wallpaper.sh
    echo "[OK] muda_wallpaper.sh instalado"
fi

# ==================== SDDM THEME ====================
echo "[INFO] Configurando tema do SDDM (R1999_1)..."

THEME_SOURCE="$ROOT_DIR/dotfiles/sddm-theme"
THEME_NAME="R1999_1"
THEME_DEST="/usr/share/sddm/themes/$THEME_NAME"

if [ -d "$THEME_SOURCE" ]; then
    echo "[INFO] Copiando tema SDDM..."

    # Remove versão antiga se existir
    sudo rm -rf "$THEME_DEST" 2>/dev/null || true

    # Cria diretório e copia tudo
    sudo mkdir -p "$THEME_DEST"
    sudo cp -rf "$THEME_SOURCE/"* "$THEME_DEST/"

    echo "[OK] Tema SDDM copiado para $THEME_DEST"
else
    echo "[ERRO] Pasta sddm-theme não encontrada em $THEME_SOURCE"
fi

# Configuração do SDDM
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf > /dev/null <<EOF
[Theme]
Current=R1999_1
EOF

# Permissões corretas
sudo chmod -R 755 "$THEME_DEST"
sudo chown -R root:root "$THEME_DEST"

echo "[OK] SDDM configurado para usar tema R1999_1"

# ==================== FIM ====================
echo "[OK] Todos os dotfiles aplicados com sucesso."
