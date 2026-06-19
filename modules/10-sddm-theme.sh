#!/bin/bash
# Instala o tema do SDDM (requer sudo)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"
THEME_NAME="tioseus"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"

echo "→ Instalando tema do SDDM em $THEME_DIR..."
sudo mkdir -p "$THEME_DIR"
sudo cp -r "$DOT/sddm-theme/." "$THEME_DIR/"
sudo chown -R root:root "$THEME_DIR"
echo "  [OK] Tema copiado"

# Configura o SDDM para usar o tema
SDDM_CONF="/etc/sddm.conf"
if [ ! -f "$SDDM_CONF" ]; then
    sudo tee "$SDDM_CONF" > /dev/null << EOF
[Theme]
Current=$THEME_NAME

[Autologin]
# User=$USER
# Session=hyprland
EOF
    echo "  [OK] /etc/sddm.conf criado"
else
    # Se já existe, apenas troca o Current
    if grep -q '^\[Theme\]' "$SDDM_CONF"; then
        sudo sed -i "s|^Current=.*|Current=$THEME_NAME|" "$SDDM_CONF"
    else
        echo -e "\n[Theme]\nCurrent=$THEME_NAME" | sudo tee -a "$SDDM_CONF" > /dev/null
    fi
    echo "  [OK] /etc/sddm.conf atualizado"
fi

# Habilita o serviço do SDDM
sudo systemctl enable sddm.service
echo "  [OK] sddm.service habilitado"
