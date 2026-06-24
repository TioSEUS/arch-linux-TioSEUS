# === DETECÇÃO DE GPU (por vendor ID — 100% confiável) ===
echo
echo "→ Detectando GPU..."

GPU_VENDOR="unknown"
GPU_DRIVERS=()

# Método 1: vendor ID do lspci (mais confiável)
# 1002 = AMD, 10de = NVIDIA, 8086 = Intel
if command -v lspci &>/dev/null; then
    # Pega só linhas de VGA/3D/Display (classes 0300, 0302, 0380)
    GPU_LINE=$(lspci -nn | grep -iE '\[(0300|0302|0380)\]' | head -1)
    # Extrai o vendor ID (4 hex antes do ":")
    GPU_VENDOR_ID=$(echo "$GPU_LINE" | grep -oE '\[[0-9a-f]{4}:[0-9a-f]{4}\]' | head -1 | cut -d: -f1 | tr -d '[]')

    case "$GPU_VENDOR_ID" in
        1002)
            GPU_VENDOR="amd"
            GPU_DRIVERS=(mesa lib32-mesa vulkan-radv lib32-vulkan-radv libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau)
            echo "  [OK] GPU: AMD (vendor 1002) → drivers Mesa/RADV"
            ;;
        10de)
            GPU_VENDOR="nvidia"
            echo "  [OK] GPU: NVIDIA (vendor 10de) → drivers do nvidia.txt"
            ;;
        8086)
            GPU_VENDOR="intel"
            GPU_DRIVERS=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-intel-driver libva-utils)
            echo "  [OK] GPU: Intel (vendor 8086) → drivers Intel/Mesa"
            ;;
        *)
            # Fallback: tenta pelo nome
            if echo "$GPU_LINE" | grep -qiE 'amd|ati|radeon'; then
                GPU_VENDOR="amd"
                GPU_DRIVERS=(mesa lib32-mesa vulkan-radv lib32-vulkan-radv)
                echo "  [OK] GPU: AMD (por nome) → drivers Mesa/RADV"
            elif echo "$GPU_LINE" | grep -qi 'nvidia'; then
                GPU_VENDOR="nvidia"
                echo "  [OK] GPU: NVIDIA (por nome)"
            elif echo "$GPU_LINE" | grep -qi 'intel'; then
                GPU_VENDOR="intel"
                GPU_DRIVERS=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver)
                echo "  [OK] GPU: Intel (por nome) → drivers Intel/Mesa"
            else
                echo "  [WARN] GPU não identificada (vendor=$GPU_VENDOR_ID, linha=$GPU_LINE)"
                GPU_DRIVERS=(mesa lib32-mesa)
            fi
            ;;
    esac
else
    # Fallback sem lspci: lê /sys/class/drm
    for vendor_file in /sys/class/drm/card*/device/vendor; do
        [ -f "$vendor_file" ] || continue
        VENDOR_DEC=$(cat "$vendor_file" 2>/dev/null)
        case "$VENDOR_DEC" in
            4098)  GPU_VENDOR="amd";   GPU_DRIVERS=(mesa lib32-mesa vulkan-radv lib32-vulkan-radv); break ;;
            4318)  GPU_VENDOR="nvidia"; break ;;
            32902) GPU_VENDOR="intel"; GPU_DRIVERS=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver); break ;;
        esac
    done
    echo "  [OK] GPU: $GPU_VENDOR (via /sys/class/drm)"
fi
