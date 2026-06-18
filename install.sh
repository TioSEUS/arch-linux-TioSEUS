#!/bin/bash
# ============================================================
#  Arch Linux Hyprland Installer - TioSEUS
#  Orquestrador principal - chama os módulos em ordem
# ============================================================

set -euo pipefail

# --- Cores ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Helpers ---
log()     { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} ${BOLD}$1${NC} ${2:-}"; }
ok()      { echo -e "${GREEN}  [OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}  [WARN]${NC} $1"; }
err()     { echo -e "${RED}  [ERR]${NC} $1"; }
section() { echo; echo -e "${CYAN}${BOLD}════════════════════════════════════════${NC}"; echo -e "${CYAN}${BOLD} $1${NC}"; echo -e "${CYAN}${BOLD}════════════════════════════════════════${NC}"; }

# --- Caminhos ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"
LOG_FILE="/tmp/tioseus_install_$(date +%Y%m%d_%H%M%S).log"

# --- Banner ---
cat << 'EOF'

  ╔═══════════════════════════════════════════════╗
  ║                                               ║
  ║    Arch Linux Hyprland Installer              ║
  ║    by TioSEUS                                 ║
  ║                                               ║
  ╚═══════════════════════════════════════════════╝

EOF

# --- Trap de erro ---
trap 'err "Falha na linha $LINENO do módulo $CURRENT_MODULE. Verifique: $LOG_FILE"; exit 1' ERR

# --- Verifica se é Arch ---
if ! command -v pacman &>/dev/null; then
    err "Este script só roda em Arch Linux (pacman não encontrado)."
    exit 1
fi

# --- Verifica se está rodando como usuário comum (não root) ---
if [ "$EUID" -eq 0 ]; then
    err "Rode como usuário comum, não como root. O script pedirá sudo quando necessário."
    exit 1
fi

# --- Verifica módulos ---
if [ ! -d "$MODULES_DIR" ]; then
    err "Pasta modules/ não encontrada em $MODULES_DIR"
    exit 1
fi

# --- Confirmação inicial ---
echo -e "${YELLOW}Este script vai:${NC}"
echo "  • Instalar todos os pacotes necessários (via pacman + yay)"
echo "  • Copiar suas configs para ~/.config/"
echo "  • Instalar o tema do SDDM (requer sudo)"
echo "  • Tornar o fish seu shell padrão"
echo
echo -e "${YELLOW}Log completo:${NC} $LOG_FILE"
echo
read -rp $'\033[1mContinuar? [s/N]: \033[0m' CONFIRM
[[ "$CONFIRM" =~ ^[sSyY]$ ]] || { warn "Instalação cancelada."; exit 0; }

# --- Executa módulos em ordem ---
MODULES=(
    "00-check.sh"
    "01-dependencies.sh"
    "02-fish.sh"
    "03-hyprland.sh"
    "04-kitty.sh"
    "05-rofi.sh"
    "06-hyprpaper.sh"
    "07-waybar-swaync.sh"
    "08-sddm-theme.sh"
    "09-superfile.sh"
    "10-mangohud.sh"
    "11-scripts.sh"
    "12-wallpapers.sh"
    "13-final.sh"
)

START_TIME=$SECONDS

for MOD in "${MODULES[@]}"; do
    CURRENT_MODULE="$MOD"
    MOD_PATH="$MODULES_DIR/$MOD"

    if [ ! -f "$MOD_PATH" ]; then
        warn "Módulo ausente, pulando: $MOD"
        continue
    fi

    section "▶ Executando: $MOD"
    chmod +x "$MOD_PATH"
    bash "$MOD_PATH" 2>&1 | tee -a "$LOG_FILE"
done

ELAPSED=$(( SECONDS - START_TIME ))

# --- Fim ---
section "INSTALAÇÃO CONCLUÍDA"
ok "Tempo total: ${ELAPSED}s"
ok "Log salvo em: $LOG_FILE"
echo
echo -e "${YELLOW}Próximos passos:${NC}"
echo "  1. Reinicie o sistema: ${BOLD}systemctl reboot${NC}"
echo "  2. No login (SDDM), selecione a sessão 'Hyprland'"
echo "  3. Troque o wallpaper a qualquer hora com: ${BOLD}muda-wallpaper${NC}"
echo
warn "Se algo deu errado, revise o log acima."
echo
