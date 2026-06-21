# Game Mode — Liga/desliga otimizações pra jogos
# Inspirado no daigonstar/hyprdots
# Atalho: Super+Shift+G

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = 1 ]; then
    # === DESLIGA performance (entra em gamemode) ===
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"

    # Tira opacity override de todas as janelas (mais FPS)
    hyprctl keyword "windowrule opacity 1 override 1 override 1 override, ^(.*)$"

    notify-send -e -u low -i "$notif" "Gamemode:" "ativado" 2>/dev/null || \
        notify-send -e -u low "Gamemode" "ativado"
else
    # === LIGA visual de volta (sai do gamemode) ===
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:shadow:enabled 1;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 4;\
        keyword general:gaps_out 10;\
        keyword general:border_size 2;\
        keyword decoration:rounding 12"

    # Remove a windowrule de opacity que foi adicionada
    hyprctl keyword "windowrule remove, ^(.*)$" 2>/dev/null

    notify-send -e -u normal -i "$notif" "Gamemode:" "desativado" 2>/dev/null || \
        notify-send -e -u normal "Gamemode" "desativado"
fi

hyprctl reload
