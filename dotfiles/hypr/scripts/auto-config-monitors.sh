#!/bin/bash
# Auto-detecção de monitores + geração dinâmica de config
# Resolve problema de monitores com nomes diferentes (DP-1, HDMI-A-2, eDP-1, etc)

set -uo pipefail

HYPRLAND_CONF_DIR="$HOME/.config/hypr"
HYPRLPAPER_CONF="$HOME/.config/hyprpaper/hyprpaper.conf"
WAYBAR_CONF="$HOME/.config/waybar/config.jsonc"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LOG_FILE="/tmp/tioseus-auto-config-monitors.log"

# Log tudo pra debug
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "  AUTO-CONFIG MONITORES — $(date)"
echo "=========================================="

echo "→ Detectando monitores..."

if ! command -v hyprctl &>/dev/null; then
    echo "  [WARN] hyprctl não disponível — usando config padrão"
    exit 0
fi

MONITORS_JSON=$(hyprctl monitors -j 2>/dev/null)
if [ -z "$MONITORS_JSON" ]; then
    echo "  [ERR] Não foi possível detectar monitores"
    exit 1
fi

echo "  [INFO] JSON dos monitores:"
echo "$MONITORS_JSON" | python3 -m json.tool 2>/dev/null | sed 's/^/    /' || echo "$MONITORS_JSON" | sed 's/^/    /'

# Extrai info dos monitores
MONITORS_INFO=$(echo "$MONITORS_JSON" | python3 -c "
import json, sys
data = json.load(sys.stdin)
data.sort(key=lambda m: m.get('id', 0))
for m in data:
    name = m.get('name', 'unknown')
    w = m.get('width', 1920)
    h = m.get('height', 1080)
    rr = m.get('refreshRate', 60)
    scale = m.get('scale', 1.0)
    rr_int = round(rr)
    print(f'{name}|{w}x{h}@{rr_int}|{scale}')
" 2>/dev/null)

if [ -z "$MONITORS_INFO" ]; then
    echo "  [ERR] Falha ao parsear monitores (python3 não disponível?)"
    exit 1
fi

echo "  [INFO] Monitores parseados:"
echo "$MONITORS_INFO" | sed 's/^/    /'

# === 1. GERA monitors.conf ===
echo "→ Gerando monitors.conf..."

MONITOR_LINES=""
WORKSPACE_LINES=""
PRIMARY_MONITOR=""
X_OFFSET=0

while IFS='|' read -r name res scale; do
    [ -z "$name" ] && continue
    
    if [ -z "$PRIMARY_MONITOR" ]; then
        PRIMARY_MONITOR="$name"
        MONITOR_LINES="${MONITOR_LINES}monitor = $name, $res, 0x0, $scale\n"
        echo "  [OK] Monitor primário: $name ($res, scale=$scale)"
        WIDTH=$(echo "$res" | cut -dx -f1)
        X_OFFSET=$WIDTH
    else
        MONITOR_LINES="${MONITOR_LINES}monitor = $name, $res, ${X_OFFSET}x0, $scale\n"
        echo "  [OK] Monitor secundário: $name ($res, offset=${X_OFFSET}x0)"
        WIDTH=$(echo "$res" | cut -dx -f1)
        X_OFFSET=$((X_OFFSET + WIDTH))
    fi
done <<< "$MONITORS_INFO"

# Gera workspaces
while IFS='|' read -r name res scale; do
    [ -z "$name" ] && continue
    if [ "$name" = "$PRIMARY_MONITOR" ]; then
        for ws in 1 2 3 4 5; do
            WORKSPACE_LINES="${WORKSPACE_LINES}workspace = $ws, monitor:$name\n"
        done
    else
        for ws in 6 7 8 9 10; do
            WORKSPACE_LINES="${WORKSPACE_LINES}workspace = $ws, monitor:$name\n"
        done
    fi
done <<< "$MONITORS_INFO"

# Escreve o arquivo (SÓ config, sem echo de log)
{
    printf "# === MONITORES (gerado automaticamente em %s) ===\n" "$(date)"
    printf "# Edite manualmente se quiser ajustar posições\n\n"
    printf "$MONITOR_LINES\n"
    printf "# === WORKSPACES POR MONITOR ===\n"
    printf "$WORKSPACE_LINES"
} > "$HYPRLAND_CONF_DIR/monitors.conf"

echo "  [OK] monitors.conf gerado em $HYPRLAND_CONF_DIR/monitors.conf"

# === 2. GERA hyprpaper.conf ===
echo "→ Gerando hyprpaper.conf..."

WALLPAPER=""
if [ -d "$WALLPAPER_DIR" ]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | head -1)
fi

if [ -z "$WALLPAPER" ]; then
    echo "  [WARN] Nenhum wallpaper encontrado em $WALLPAPER_DIR"
    WALLPAPER="$HOME/Pictures/Wallpapers/default.png"
else
    echo "  [OK] Wallpaper encontrado: $WALLPAPER"
fi

# Escreve o arquivo (SÓ config, sem echo de log)
cat > "$HYPRLPAPER_CONF" << EOF
# === HYPRLPAPER (gerado automaticamente em $(date)) ===
# Aplica o mesmo wallpaper em TODOS os monitores (curinga ,)
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
splash = false
ipc = on
EOF

echo "  [OK] hyprpaper.conf gerado"

# === 3. ATUALIZA waybar com monitor primário ===
if [ -f "$WAYBAR_CONF" ]; then
    echo "→ Atualizando waybar com monitor primário: $PRIMARY_MONITOR..."
    python3 -c "
import re
with open('$WAYBAR_CONF', 'r') as f:
    content = f.read()
new_content = re.sub(r'\"output\"\s*:\s*\"[^\"]*\"', '\"output\": \"$PRIMARY_MONITOR\"', content)
with open('$WAYBAR_CONF', 'w') as f:
    f.write(new_content)
" 2>/dev/null
    echo "  [OK] Waybar agora usa monitor: $PRIMARY_MONITOR"
fi

# === 4. RECARREGA ===
echo "→ Recarregando Hyprland..."
hyprctl reload 2>/dev/null

echo "→ Reiniciando hyprpaper..."
killall hyprpaper 2>/dev/null
sleep 1
if [ -f "$HYPRLPAPER_CONF" ]; then
    hyprpaper -c "$HYPRLPAPER_CONF" >/dev/null 2>&1 &
    echo "  [OK] Hyprpaper reiniciado com config dinâmica"
fi

echo
echo "═══════════════════════════════════════════════════"
echo "  ✅ AUTO-CONFIG DE MONITORES CONCLUÍDO!"
echo "  • Monitor primário: $PRIMARY_MONITOR"
echo "  • Wallpaper: $(basename "$WALLPAPER")"
echo "═══════════════════════════════════════════════════"
