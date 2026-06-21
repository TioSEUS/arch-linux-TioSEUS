# Reinicia waybar e/ou swaync
# Uso:
#   restart.sh all       → reinicia os dois
#   restart.sh waybar    → só waybar
#   restart.sh swaync    → só swaync
# Atalhos: Super+N (all) / Super+Shift+N (waybar)

case "$1" in
    swaync)
        pkill swaync 2>/dev/null || true
        sleep 0.2
        swaync &
        ;;
    waybar)
        pkill waybar 2>/dev/null || true
        sleep 0.2
        waybar &
        ;;
    all|"")
        pkill swaync 2>/dev/null || true
        pkill waybar 2>/dev/null || true
        sleep 0.3
        waybar &
        swaync &
        ;;
    *)
        echo "Uso: $0 {all|waybar|swaync}"
        exit 1
        ;;
esac

# Notificação opcional (silenciosa se falhar)
notify-send -t 1000 "Restart" "$1 reiniciado" 2>/dev/null || true
