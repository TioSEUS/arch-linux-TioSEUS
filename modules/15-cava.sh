#!/bin/bash
# Configura o CAVA (visualizador de áudio)
# Inclui shaders GLSL para modo sdl_glsl

set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

echo "→ Copiando config do CAVA..."
mkdir -p ~/.config/cava/shaders
cp "$DOT/cava/config" ~/.config/cava/

# Shaders (genéricos, funcionam com qualquer paleta)
cp "$DOT/cava/shaders/bar_spectrum.frag"     ~/.config/cava/shaders/
cp "$DOT/cava/shaders/northern_lights.frag"  ~/.config/cava/shaders/
cp "$DOT/cava/shaders/pass_through.vert"     ~/.config/cava/shaders/

echo "  [OK] CAVA instalado com gradiente TioSEUS (dourado→azul→vermelho)"
echo "    • Config:  ~/.config/cava/config"
echo "    • Shaders: ~/.config/cava/shaders/"
echo
echo "  [INFO] Para usar modo gráfico com shaders, descomente no config:"
echo "         method = sdl_glsl"
echo "         vertex_shader = pass_through.vert"
echo "         fragment_shader = bar_spectrum.frag"
