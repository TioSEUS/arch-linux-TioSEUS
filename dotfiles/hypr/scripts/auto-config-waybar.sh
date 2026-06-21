#!/bin/bash
# Auto-config da waybar: detecta notebook vs desktop e gera config apropriado
# - NOTEBOOK: bateria, bluetooth, rede, workspaces, programas, wallpaper, liga/reboot/sddm, memória, cpu
# - DESKTOP: copia config completa do repo (com GPU, temperatura GPU, etc)

set -uo pipefail

DOTFILES_HYPR="$HOME/.config/hypr"
WAYBAR_CONF="$HOME/.config/waybar/config.jsonc"
REPO_WAYBAR_CONF=""  # será preenchido abaixo

echo "→ Detectando tipo de sistema (notebook vs desktop)..."

# Detecta bateria (notebook tem /sys/class/power_supply/BAT*)
HAS_BATTERY=false
if [ -d /sys/class/power_supply ]; then
    if ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
        HAS_BATTERY=true
        BAT_NAME=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -1 | xargs basename)
        echo "  [OK] Bateria detectada: $BAT_NAME → modo NOTEBOOK"
    fi
fi

if [ "$HAS_BATTERY" = "false" ]; then
    echo "  [OK] Sem bateria → modo DESKTOP (mantém config atual)"
    # Garante que o config do repo está no lugar
    if [ ! -f "$WAYBAR_CONF" ]; then
        echo "  [WARN] Waybar config não existe — rodando módulo 08-waybar.sh"
        # Tenta achar o módulo no repo
        for path in "$HOME/arch-linux-TioSEUS" "$HOME/Projetos/arch-linux-TioSEUS" "$HOME/dotfiles/arch-linux-TioSEUS"; do
            if [ -f "$path/dotfiles/waybar/config.jsonc" ]; then
                mkdir -p "$HOME/.config/waybar"
                cp "$path/dotfiles/waybar/config.jsonc" "$WAYBAR_CONF"
                cp "$path/dotfiles/waybar/style.css" "$HOME/.config/waybar/style.css"
                echo "  [OK] Config copiada do repo: $path"
                break
            fi
        done
    fi
    exit 0
fi

# === MODO NOTEBOOK — gera config simplificado ===
echo "→ Gerando config da waybar para notebook..."

mkdir -p "$HOME/.config/waybar"

cat > "$WAYBAR_CONF" << 'WAYBAR_EOF'
{
    "layer": "top",
    "position": "top",
    "mode": "dock",
    "exclusive": true,
    "passthrough": false,
    "gtk-layer-shell": true,
    "height": 38,
    "margin-top": 8,
    "margin-left": 10,
    "margin-right": 10,

    "modules-left": [
        "custom/shutdown",
        "custom/reboot",
        "custom/sddm",
        "hyprland/window",
        "custom/wallpaper"
    ],
    "modules-center": [
        "hyprland/workspaces"
    ],
    "modules-right": [
        "cpu",
        "memory",
        "pulseaudio",
        "bluetooth",
        "network",
        "battery",
        "tray",
        "custom/notification",
        "clock"
    ],

    "custom/shutdown": {
        "format": "⏻ ",
        "tooltip": false,
        "on-click": "systemctl poweroff"
    },
    "custom/reboot": {
        "format": "⭮ ",
        "tooltip": false,
        "on-click": "systemctl reboot"
    },
    "custom/sddm": {
        "format": "󰈆 ",
        "tooltip": false,
        "on-click": "hyprctl dispatch exit"
    },

    "hyprland/window": {
        "format": " {} ",
        "separate-outputs": true,
        "max-length": 20
    },

    "custom/wallpaper": {
        "format": "󰋩 ",
        "on-click": "muda-wallpaper",
        "tooltip-format": "Trocar papel de parede"
    },

    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
    },

    "cpu": {
        "interval": 2,
        "format": " {usage}%",
        "max-length": 10
    },

    "memory": {
        "interval": 10,
        "format": "󰍛 {used:0.1f}GB / {total:0.0f}GB",
        "tooltip": true,
        "tooltip-format": "Usada: {used:0.1f}GB\nDisponível: {avail:0.1f}GB\nTotal: {total:0.1f}GB"
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "󰝟 Muted",
        "format-icons": {
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "pavucontrol",
        "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +5%",
        "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -5%",
        "scroll-step": 5
    },

    "bluetooth": {
        "format": " {status}",
        "format-disabled": "󰂲",
        "format-connected": "󰂱 {device_alias}",
        "tooltip-format": "{controller_alias}",
        "tooltip-format-connected": "{controller_alias}\n\n{device_enumerate}",
        "tooltip-format-enumerate-connected": "{device_alias}",
        "on-click": "exec blueman-manager"
    },

    "network": {
        "format-wifi": "󰤨 {signalStrength}%",
        "format-ethernet": "󰈀 ",
        "format-disconnected": "󰤮 ",
        "on-click": "kitty -e nmtui",
        "tooltip-format": "{ifname} via {gwaddr}"
    },

    "battery": {
        "interval": 30,
        "states": {
            "good": 95,
            "warning": 30,
            "critical": 20
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% 󰂄",
        "format-plugged": "{capacity}% 󰂄",
        "format-alt": "{time} {icon}",
        "format-icons": ["󰁻", "󰁼", "󰁾", "󰂀", "󰂂", "󰁹"]
    },

    "tray": {
        "icon-size": 16,
        "spacing": 10
    },

    "custom/notification": {
        "tooltip": false,
        "format": "{icon}",
        "format-icons": {
            "notification": "<span foreground='red'><sup>•</sup></span>",
            "none": "",
            "dnd-notification": "<span foreground='red'><sup>•</sup></span>",
            "dnd-none": ""
        },
        "return-type": "json",
        "exec-if": "which swaync-client",
        "exec": "swaync-client -swb",
        "on-click": "swaync-client -t -sw",
        "on-click-right": "swaync-client -d -sw",
        "escape": true
    },

    "clock": {
        "format": "{:%H:%M}"
    }
}
WAYBAR_EOF

# Garante que o style.css está no lugar (não muda entre notebook/desktop)
for path in "$HOME/arch-linux-TioSEUS" "$HOME/Projetos/arch-linux-TioSEUS" "$HOME/dotfiles/arch-linux-TioSEUS"; do
    if [ -f "$path/dotfiles/waybar/style.css" ] && [ ! -f "$HOME/.config/waybar/style.css" ]; then
        cp "$path/dotfiles/waybar/style.css" "$HOME/.config/waybar/style.css"
        break
    fi
done

echo "  [OK] Waybar configurada para notebook"
echo "    • Bateria ativa"
echo "    • Sem GPU/temp (não relevante em notebook)"

# Reinicia waybar
echo "→ Reiniciando waybar..."
killall waybar 2>/dev/null
sleep 1
waybar &

echo
echo "═══════════════════════════════════════════════════"
echo "  ✅ WAYBAR CONFIGURADA PARA NOTEBOOK!"
echo "═══════════════════════════════════════════════════"
