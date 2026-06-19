#!/bin/bash
# ============================================================
#  Arch Linux Hyprland Installer - TioSEUS
#  Orquestrador principal - chama os módulos em ordem
#  Versão: 2.0 (com backup automático + validação prévia)
# ============================================================

set -uo pipefail

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
BACKUP_DIR="$HOME/.config-backup-tioseus-$(date +%Y%m%d_%H%M%S)"

# --- Banner ---
cat << 'EOF'

  ╔═══════════════════════════════════════════════╗
  ║                                               ║
  ║    Arch Linux Hyprland Installer              ║
  ║    by TioSEUS - v2.0                          ║
  ║                                               ║
  ╚═══════════════════════════════════════════════╝

EOF

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

# === VALIDAÇÃO PRÉVIA (impede markdown colado por engano) ===
section "▶ Validação prévia dos arquivos"

VALIDATION_FAIL=0
for f in $(find "$SCRIPT_DIR/dotfiles" "$SCRIPT_DIR/modules" -type f \( \
    -name "*.sh" -o -name "*.rasi" -o -name "*.json" -o -name "*.css" \
    -o -name "*.jsonc" -o -name "*.conf" -o -name "*.toml" -o -name "*.qml" \
    -o -name "*.frag" -o -name "*.vert" -o -name "*.ini" -o -name "*.desktop" \
\) 2>/dev/null); do
    if grep -qE '^```|^## |^### |^\*\*Mudanças|^\*\*ANTES|^\*\*DEPOIS' "$f" 2>/dev/null; then
        echo "  [CORROMPIDO] ${f#$SCRIPT_DIR/}"
        VALIDATION_FAIL=1
    fi
done

if [ $VALIDATION_FAIL -eq 1 ]; then
    echo
    err "Arquivos corrompidos com markdown encontrados!"
    err "Abra cada um e remova as linhas começando com \\`\\`\\` ou ## que não pertencem ao código."
    exit 1
else
    ok "Todos os arquivos estão limpos (sem markdown acidental)"
fi

# === BACKUP AUTOMÁTICO DAS CONFIGS ATUAIS ===
section "▶ Backup automático das configs atuais"

if [ -d "$HOME/.config" ]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_DIRS=(hypr kitty fish rofi waybar swaync hyprpaper superfile MangoHud fastfetch cava darkman scripts)
    BACKED_UP=0
    for dir in "${BACKUP_DIRS[@]}"; do
        if [ -d "$HOME/.config/$dir" ]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null
            BACKED_UP=$((BACKED_UP + 1))
        fi
    done
    ok "Backup de $BACKED_UP diretórios salvo em: $BACKUP_DIR"
else
    warn "Pasta ~/.config não existe ainda — pulando backup"
fi

# --- Confirmação inicial ---
echo
echo -e "${YELLOW}Este script vai:${NC}"
echo "  • Validar todos os arquivos (✅ já feito)"
echo "  • Fazer backup das configs atuais (✅ já feito em $BACKUP_DIR)"
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
    "07-wallpapers.sh"
    "08-waybar.sh"
    "09-swaync.sh"
    "10-sddm-theme.sh"
    "11-superfile.sh"
    "12-mangohud.sh"
    "13-cava.sh"
    "14-fastfetch.sh"
    "15-scripts.sh"
    "16-final.sh"
)

START_TIME=$SECONDS
CURRENT_MODULE=""

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
ok "Backup das configs antigas: $BACKUP_DIR"
echo
echo -e "${YELLOW}Próximos passos:${NC}"
echo "  1. Reinicie o sistema: ${BOLD}systemctl reboot${NC}"
echo "  2. No login (SDDM), selecione a sessão 'Hyprland'"
echo "  3. Troque o wallpaper a qualquer hora com: ${BOLD}muda-wallpaper${NC}"
echo
echo -e "${YELLOW}Em caso de problema:${NC}"
echo "  • Restaurar configs antigas: cp -r $BACKUP_DIR/* ~/.config/"
echo "  • Ver log: less $LOG_FILE"
echo
warn "Se algo deu errado, revise o log acima ou restaure o backup."
echo
