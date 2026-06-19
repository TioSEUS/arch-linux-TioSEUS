#!/bin/bash
# Configura o MangoHud

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do MangoHud..."
mkdir -p ~/.config/MangoHud
cp "$DOT/mangohud/mangohud.conf" ~/.config/MangoHud/MangoHud.conf
echo "  [OK] MangoHud instalado"
