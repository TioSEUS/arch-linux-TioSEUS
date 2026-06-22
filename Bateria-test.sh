echo "=== DIAGNÓSTICO NOTEBOOK ==="
echo
echo "--- 1. Power supplies disponíveis ---"
ls -la /sys/class/power_supply/ 2>/dev/null

echo
echo "--- 2. Tipos de cada power supply ---"
for dev in /sys/class/power_supply/*/; do
    name=$(basename "$dev")
    type=$(cat "${dev}type" 2>/dev/null || echo "unknown")
    echo "  $name → type=$type"
done

echo
echo "--- 3. Script auto-config-waybar.sh roda? ---"
~/.config/hypr/scripts/auto-config-waybar.sh 2>&1

echo
echo "--- 4. Waybar config atual tem bateria? ---"
grep -c "battery" ~/.config/waybar/config.jsonc 2>/dev/null

echo
echo "--- 5. Log do auto-config (se rodou) ---"
tail -20 /tmp/tioseus-auto-config-waybar.log 2>/dev/null
