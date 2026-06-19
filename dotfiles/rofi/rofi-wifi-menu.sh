#!/usr/bin/env bash

## TioSEUS WiFi Menu
## Lista redes Wi-Fi e conecta via nmcli
## Adaptado de: adi1090x/rofi

# Caminho para configurações
conf="$HOME/.config/rofi/wifi.conf"

# Verifica se nmcli existe
if ! command -v nmcli &>/dev/null; then
    notify-send "❌ nmcli não encontrado" "Instale: sudo pacman -S networkmanager"
    exit 1
fi

# Pega lista de redes (com sinal)
get_networks() {
    active=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    nmcli -t -f ssid,signal,security dev wifi | \
        sort -t: -k2 -nr | \
        awk -F: -v active="$active" '{
            ssid=$1; signal=$2; sec=$3
            if (ssid == "") next
            if (ssid == active) mark="* "; else mark="  "
            printf "%s%-30s [%s%%] %s\n", mark, ssid, signal, sec
        }'
}

# Pergunta qual rede
chosen=$(get_networks | rofi -dmenu -i -p "WiFi:" -no-custom \
    -theme-str 'window {width: 600px; border-radius: 12px;}' \
    -theme-str 'listview {lines: 10;}' \
    -theme-str 'element {padding: 12px; border-radius: 8px;}' \
    -theme ~/.config/rofi/config.rasi 2>/dev/null || rofi -dmenu -i -p "WiFi:" -no-custom)

[ -z "$chosen" ] && exit 0

# Extrai o SSID (remove o marcador * e o [NN%])
ssid=$(echo "$chosen" | sed 's/^\*\?\s*//' | sed 's/\s*\[.*$//')

# Verifica se precisa de senha
security=$(nmcli -t -f ssid,security dev wifi | grep "^${ssid}:" | cut -d: -f2)

if echo "$security" | grep -qi "wpa\|wep"; then
    # Pede senha
    password=$(rofi -dmenu -password -i -p "Senha para '${ssid}':" \
        -theme-str 'window {width: 400px; border-radius: 12px;}' \
        -theme-str 'entry {padding: 12px;}' \
        -theme ~/.config/rofi/config.rasi 2>/dev/null || \
        rofi -dmenu -password -i -p "Senha para '${ssid}':")

    [ -z "$password" ] && exit 0
    nmcli dev wifi connect "$ssid" password "$password"
else
    nmcli dev wifi connect "$ssid"
fi

# Notifica resultado
if [ $? -eq 0 ]; then
    notify-send "🌐 WiFi Conectado" "$ssid"
else
    notify-send "❌ Erro" "Falha ao conectar em $ssid"
fi
