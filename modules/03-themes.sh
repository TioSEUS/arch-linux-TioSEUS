#!/usr/bin/env bash
echo "-----------------------------------------------------------------"
echo "--> MÓDULO 3: Unificação de Tema Escuro (GTK 3.0 / GTK 4.0 / Darkman)"
echo "-----------------------------------------------------------------"

echo "--> Forçando preferência global por esquema Dark no ecossistema GNOME/GTK..."
# Criação manual das estruturas GTK locais para garantir modo escuro instantâneo
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

cat << 'EOF' > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name = Adwaita-dark
gtk-application-prefer-dark-theme = true
EOF

cat << 'EOF' > ~/.config/gtk-4.0/settings.ini
[Settings]
gtk-theme-name = Adwaita-dark
gtk-application-prefer-dark-theme = true
EOF

# Configuração do Darkman (Motor automático)
mkdir -p ~/.config/darkman/dark-mode.d
cat << 'EOF' > ~/.config/darkman/dark-mode.d/gtk-theme.sh
#!/bin/sh
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
EOF
chmod +x ~/.config/darkman/dark-mode.d/gtk-theme.sh
systemctl --user enable --now darkman.service || echo "Aviso: Darkman iniciará no ambiente gráfico."
