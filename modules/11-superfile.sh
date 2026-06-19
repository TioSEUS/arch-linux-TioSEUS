#!/bin/bash
# Configura o superfile (file manager TUI)

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do superfile..."
mkdir -p ~/.config/superfile
cp "$DOT/superfile/config.toml"  ~/.config/superfile/config.toml
cp "$DOT/superfile/hotkeys.toml" ~/.config/superfile/hotkeys.toml

# Temas
mkdir -p ~/.config/superfile/theme
cp -r "$DOT/superfile/theme/." ~/.config/superfile/theme/
echo "  [OK] superfile instalado (config + temas)"
