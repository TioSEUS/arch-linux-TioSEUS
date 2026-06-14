# ==================== SDDM THEME ====================
echo "[INFO] Configurando tema do SDDM (R1999_1)..."

THEME_SOURCE="$ROOT_DIR/dotfiles/sddm-theme"
THEME_NAME="R1999_1"
THEME_DEST="/usr/share/sddm/themes/$THEME_NAME"

if [ -d "$THEME_SOURCE" ]; then
    echo "[INFO] Copiando tema SDDM..."

    # Remove versão antiga
    sudo rm -rf "$THEME_DEST" 2>/dev/null || true

    # Cria diretório e copia tudo (incluindo subpastas)
    sudo mkdir -p "$THEME_DEST"
    sudo cp -rf "$THEME_SOURCE/"* "$THEME_DEST/"

    echo "[OK] Tema copiado para $THEME_DEST"
else
    echo "[ERRO] Pasta sddm-theme não encontrada!"
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
