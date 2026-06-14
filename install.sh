#!/usr/bin/env bash
# ================================================
# Arch Linux Dotfiles Installer - TioSEUS
# ================================================

set -euo pipefail

LOG_DIR="$HOME/.install-logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"

exec > >(tee -a "$LOGFILE") 2>&1

echo "================================================================="
echo "🚀 INICIANDO INSTALAÇÃO - TioSEUS Arch Setup"
echo "================================================================="

for script in modules/[0-9]*.sh; do
    if [ -f "$script" ]; then
        echo -e "\n📦 Executando $(basename "$script")..."
        if bash "$script"; then
            echo "✅ $(basename "$script") OK"
        else
            echo "❌ ERRO em $(basename "$script")" >&2
            exit 1
        fi
    fi
done

echo ""
echo "================================================================="
echo "🎉 INSTALAÇÃO CONCLUÍDA! $(date)"
echo "📋 Log: $LOGFILE"
echo "🔄 Reinicie o sistema: reboot"
echo "================================================================="
