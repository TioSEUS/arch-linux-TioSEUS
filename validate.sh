#!/bin/bash
# validate.sh — verifica se os arquivos estão limpos (sem markdown colado)
# Rode SEMPRE antes de commitar: ./validate.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAIL=0

echo "→ Verificando arquivos corrompidos com markdown..."

for f in $(find "$SCRIPT_DIR/dotfiles" "$SCRIPT_DIR/modules" -type f \( \
    -name "*.sh" -o -name "*.rasi" -o -name "*.json" -o -name "*.css" \
    -o -name "*.jsonc" -o -name "*.conf" -o -name "*.toml" -o -name "*.qml" \
    -o -name "*.frag" -o -name "*.vert" -o -name "*.ini" -o -name "*.desktop" \
\) 2>/dev/null); do
    if grep -qE '^```|^## |^### |^\*\*Mudanças|^\*\*ANTES|^\*\*DEPOIS' "$f" 2>/dev/null; then
        rel_path="${f#$SCRIPT_DIR/}"
        echo -e "  ${RED}[CORROMPIDO]${NC} $rel_path"
        grep -nE '^```|^## |^### |^\*\*Mudanças|^\*\*ANTES|^\*\*DEPOIS' "$f" | head -3 | sed 's/^/    /'
        FAIL=1
    fi
done

if [ $FAIL -eq 1 ]; then
    echo
    echo -e "${RED}❌ Arquivos corrompidos encontrados!${NC}"
    echo "   Abra cada um e remova as linhas com 3 backticks (cercas de codigo) ou ## que nao pertencem ao codigo."
    exit 1
fi

echo -e "${GREEN}✅ Todos os arquivos estão limpos.${NC}"

# Valida sintaxe bash dos módulos
echo
echo "→ Validando sintaxe bash dos módulos..."
BASH_FAIL=0
for f in "$SCRIPT_DIR"/modules/*.sh "$SCRIPT_DIR"/install.sh "$SCRIPT_DIR"/validate.sh; do
    if [ -f "$f" ]; then
        if ! bash -n "$f" 2>/dev/null; then
            echo -e "  ${RED}[SYNTAX ERROR]${NC} $(basename "$f")"
            bash -n "$f" 2>&1 | head -3 | sed 's/^/    /'
            BASH_FAIL=1
        fi
    fi
done

if [ $BASH_FAIL -eq 1 ]; then
    echo
    echo -e "${RED}❌ Erros de sintaxe bash encontrados!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Sintaxe bash OK${NC}"

# Verifica permissões de execução
echo
echo "→ Verificando permissões de execução..."
PERM_FAIL=0
for f in "$SCRIPT_DIR"/modules/*.sh; do
    if [ ! -x "$f" ]; then
        echo -e "  ${YELLOW}[SEM +x]${NC} $(basename "$f")"
        PERM_FAIL=1
    fi
done

if [ $PERM_FAIL -eq 1 ]; then
    echo
    echo -e "${YELLOW}⚠️  Alguns módulos não têm permissão de execução.${NC}"
    echo "   Rode: chmod +x modules/*.sh"
else
    echo -e "${GREEN}✅ Permissões OK${NC}"
fi

echo
echo -e "${GREEN}✅ Tudo validado! Pode commitar.${NC}"
