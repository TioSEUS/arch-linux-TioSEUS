# Auto-detecção de monitores + geração dinâmica de config
# Resolve problema de monitores com nomes diferentes (DP-1, HDMI-A-2, eDP-1, etc)
# Roda automaticamente no primeiro boot do Hyprland

set -uo pipefail

HYPRLAND_CONF_DIR="$HOME/.config/hypr"
HYPRLPAPER_CONF="$HOME/.config/hyprpaper/hyprpaper.conf"
WAYBAR_CONF="$HOME/.config/waybar/config.jsonc"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

echo "→ Detectando monitores..."

# Verifica se hyprctl está disponível (só roda dentro do Hyprland)
if ! command -v hyprctl &>/dev/null; then
    echo "  [WARN] hyprctl não disponível — usando config padrão"
    exit 0
fi

# Pega lista de monitores em JSON
MONITORS_JSON=$(hyprctl monitors -j 2>/dev/null)
if [ -z "$MONITORS_JSON" ]; then
    echo "  [ERR] Não foi possível detectar monitores"
    exit 1
fi

# Extrai info dos monitores (id, name, width, height, refreshRate, scale)
# Usa python3 pra parsear JSON (mais confiável que grep+awk)
MONITORS_INFO=$(echo "$MONITORS_JSON" | python3 -c "
import json, sys
data = json.load(sys.stdin)
# Ordena por ID (menor ID = principal)
data.sort(key=lambda m: m.get('id', 0))
for m in data:
    name = m.get('name', 'unknown')
    w = m.get('width', 1920)
    h = m.get('height', 1080)
    rr = m.get('refreshRate', 60)
    scale = m.get('scale', 1.0)
    # Arredonda refresh rate
    rr_int = round(rr)
    print(f'{name}|{w}x{h}@{rr_int}|{scale}')
" 2>/dev/null)

if [ -z "$MONITORS_INFO" ]; then
    echo "  [ERR] Falha ao parsear monitores"
    exit 1
fi

# === 1. GERA monitors.conf ===
echo "→ Gerando monitors.conf..."
{
    echo "# === MONITORES (gerado automaticamente em $(date)) ==="
    echo "# Edite manualmente se quiser ajustar posições"
    echo ""
    
    X_OFFSET=0
    PRIMARY_MONITOR=""
    
    while IFS='|' read -r name res scale; do
        if [ -z "$name" ]; then continue; fi
        
        # Primeiro monitor = principal (X=0), próximos vêm ao lado
        if [ -z "$PRIMARY_MONITOR" ]; then
            PRIMARY_MONITOR="$name"
            echo "monitor = $name, $res, 0x0, $scale"
            echo "  [OK] Monitor primário: $name ($res, scale=$scale)"
            # Atualiza X offset pro próximo (largura do monitor atual)
            WIDTH=$(echo "$res" | cut -dx -f1)
            X_OFFSET=$WIDTH
        else
            echo "monitor = $name, $res, ${X_OFFSET}x0, $scale"
            echo "  [OK] Monitor secundário: $name ($res, offset=${X_OFFSET}x0)"
            WIDTH=$(echo "$res" | cut -dx -f1)
            X_OFFSET=$((X_OFFSET + WIDTH))
        fi
    done <<< "$MONITORS_INFO"
    
    echo ""
    echo "# === WORKSPACES POR MONITOR ==="
    echo "# Workspace 1-5 no primário, 6-10 no secundário"
    WS_PRIMARY=1
    WS_SECONDARY=6
    while IFS='|' read -r name res scale; do
        if [ -z "$name" ]; then continue; fi
        if [ "$name" = "$PRIMARY_MONITOR" ]; then
            for ws in 1 2 3 4 5; do
                echo "workspace = $ws, monitor:$name"
            done
        else
            for ws in 6 7 8 9 10; do
                echo "workspace = $ws, monitor:$name"
            done
        fi
    done <<< "$MONITORS_INFO"
} > "$HYPRLAND_CONF_DIR/monitors.conf"

echo "  [OK] monitors.conf gerado em $HYPRLAND_CONF_DIR/monitors.conf"

# === 2. GERA hyprpaper.conf (aplica MESMO wallpaper em TODOS os monitores) ===
echo "→ Gerando hyprpaper.conf..."

# Pega um wallpaper aleatório (ou o primeiro disponível)
if [ -d "$WALLPAPER_DIR" ]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | head -1)
fi

if [ -z "$WALLPAPER" ]; then
    echo "  [WARN] Nenhum wallpaper encontrado em $WALLPAPER_DIR"
    WALLPAPER="$HOME/Pictures/Wallpapers/default.png"
fi

{
    echo "# === HYPRLPAPER (gerado automaticamente em $(date)) ==="
    echo "# Aplica o mesmo wallpaper em TODOS os monitores (curinga ,)"
    echo ""
    echo "preload = $WALLPAPER"
    echo ""
    # A vírgula vazia no início = "aplica em qualquer monitor"
    echo "wallpaper = ,$WALLPAPER"
    echo ""
    echo "splash = false"
    echo "ipc = on"
} > "$HYPRLPAPER_CONF"

echo "  [OK] hyprpaper.conf gerado com wallpaper: $(basename "$WALLPAPER")"

# === 3. ATUALIZA waybar/config.jsonc (monitor primário) ===
if [ -f "$WAYBAR_CONF" ]; then
    echo "→ Atualizando waybar/config.jsonc com monitor primário: $PRIMARY_MONITOR..."
    
    # Troca a linha "output": "DP-3" (ou qualquer outro) pelo monitor detectado
    # Usa python pra editar JSON com segurança
    python3 -c "
import json
with open('$WAYBAR_CONF', 'r') as f:
    content = f.read()
# jsonc pode ter comentários, mas a linha 'output' é simples — faz sed
import re
# Troca '\"output\": \"qualquer-coisa\"' por '\"output\": \"$PRIMARY_MONITOR\"'
new_content = re.sub(r'\"output\"\s*:\s*\"[^\"]*\"', '\"output\": \"$PRIMARY_MONITOR\"', content)
with open('$WAYBAR_CONF', 'w') as f:
    f.write(new_content)
" 2>/dev/null
    
    echo "  [OK] Waybar agora usa monitor: $PRIMARY_MONITOR"
fi

# === 4. RECARREGA CONFIGS ===
echo "→ Recarregando Hyprland..."
hyprctl reload 2>/dev/null

echo "→ Reiniciando hyprpaper..."
killall hyprpaper 2>/dev/null
sleep 1
if [ -f "$HYPRLPAPER_CONF" ]; then
    hyprpaper -c "$HYPRLPAPER_CONF" >/dev/null 2>&1 &
    echo "  [OK] Hyprpaper reiniciado"
fi

echo "→ Reiniciando waybar..."
killall waybar 2>/dev/null
sleep 1
waybar &

echo
echo "═══════════════════════════════════════════════════"
echo "  ✅ AUTO-CONFIG CONCLUÍDO!"
echo "═══════════════════════════════════════════════════"
echo "  • Monitor primário: $PRIMARY_MONITOR"
echo "  • Wallpaper: $(basename "$WALLPAPER")"
echo "  • Configs regeneradas:"
echo "    - $HYPRLAND_CONF_DIR/monitors.conf"
echo "    - $HYPRLPAPER_CONF"
echo "    - $WAYBAR_CONF"
echo "═══════════════════════════════════════════════════"
