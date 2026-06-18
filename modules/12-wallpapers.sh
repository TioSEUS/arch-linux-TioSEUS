#!/bin/bash
# Copia todos os wallpapers para ~/Pictures/Wallpapers

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"
WALL_DIR="$HOME/Pictures/Wallpapers"

echo "→ Copiando wallpapers para $WALL_DIR..."
mkdir -p "$WALL_DIR"
cp -r "$DOT/Wallpapers/." "$WALL_DIR/"

COUNT=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | wc -l)
echo "  [OK] $COUNT wallpapers instalados"
