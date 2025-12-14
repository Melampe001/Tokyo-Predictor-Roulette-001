#!/bin/bash
# close_stale_prs.sh
# Script para cerrar PRs obsoletos y duplicados en el repositorio Tokyo-Predictor-Roulette-001
# 
# Uso: bash close_stale_prs.sh
# Requiere: gh CLI configurado con autenticación

set -e

REPO="Melampe001/Tokyo-Predictor-Roulette-001"
DATE=$(date +%Y-%m-%d)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para cerrar PR con comentario
close_pr() {
  local pr_number=$1
  local reason=$2
  local comment="🤖 **Cierre Automático - Limpieza de Repositorio**

Este PR está siendo cerrado como parte de una limpieza masiva porque: $reason

Si consideras que debe reabrirse, por favor:
1. Actualiza el contenido
2. Responde a comentarios pendientes
3. Menciona @Melampe001 para revisión

---
*Cerrado automáticamente por Bot de Limpieza - $DATE*"

  echo -e "${YELLOW}Cerrando PR #$pr_number: $reason${NC}"
  if gh pr close $pr_number --repo $REPO --comment "$comment"; then
    echo -e "${GREEN}✓ PR #$pr_number cerrado exitosamente${NC}"
  else
    echo -e "${RED}✗ Error cerrando PR #$pr_number${NC}"
  fi
}

# Función para cerrar issue con comentario
close_issue() {
  local issue_number=$1
  local reason=$2
  local comment="🤖 **Cierre Automático - Limpieza de Repositorio**

Este issue está siendo cerrado como parte de una limpieza masiva porque: $reason

Si consideras que debe reabrirse, por favor actualiza el contenido y menciona @Melampe001 para revisión.

---
*Cerrado automáticamente por Bot de Limpieza - $DATE*"

  echo -e "${YELLOW}Cerrando Issue #$issue_number: $reason${NC}"
  if gh issue close $issue_number --repo $REPO --comment "$comment"; then
    echo -e "${GREEN}✓ Issue #$issue_number cerrado exitosamente${NC}"
  else
    echo -e "${RED}✗ Error cerrando Issue #$issue_number${NC}"
  fi
}

# Banner
echo -e "${GREEN}"
echo "=============================================="
echo "  🧹 LIMPIEZA MASIVA DE PRs E ISSUES"
echo "  Repositorio: $REPO"
echo "  Fecha: $DATE"
echo "=============================================="
echo -e "${NC}"

# Verificar que gh está instalado y autenticado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: gh CLI no está instalado${NC}"
    echo "Instala gh CLI desde: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: gh CLI no está autenticado${NC}"
    echo "Ejecuta: gh auth login"
    exit 1
fi

echo -e "${GREEN}✓ gh CLI configurado correctamente${NC}"
echo ""

# Contador
PR_CLOSED=0
ISSUE_CLOSED=0

# PRs Duplicados - Grupo CI Fixes
echo -e "${YELLOW}=== GRUPO 1: CI Fixes Duplicados ===${NC}"
close_pr 37 "Es un duplicado de: #38"
((PR_CLOSED++))
close_pr 38 "Es un duplicado/obsoleto"
((PR_CLOSED++))
echo ""

# PRs Duplicados - Refactor
echo -e "${YELLOW}=== GRUPO 2: Refactor Terminology ===${NC}"
close_pr 27 "Es un duplicado de: #28"
((PR_CLOSED++))
echo ""

# PRs Duplicados - GitHub Actions
echo -e "${YELLOW}=== GRUPO 3: GitHub Actions APK ===${NC}"
close_pr 25 "Es un duplicado de: #26"
((PR_CLOSED++))
echo ""

# PRs Drafts Obsoletos
echo -e "${YELLOW}=== GRUPO 4: Drafts Obsoletos ===${NC}"
close_pr 22 "Es un draft obsoleto sin actividad reciente"
((PR_CLOSED++))
close_pr 23 "Es un draft que no fue fusionado"
((PR_CLOSED++))
echo ""

# PRs Duplicados - AAB Workflow
echo -e "${YELLOW}=== GRUPO 5: AAB Workflow Duplicados ===${NC}"
close_pr 19 "Es un duplicado de: #18, #17, #16"
((PR_CLOSED++))
close_pr 18 "Es un duplicado"
((PR_CLOSED++))
close_pr 17 "Es un duplicado"
((PR_CLOSED++))
close_pr 16 "Es un duplicado"
((PR_CLOSED++))
echo ""

# PRs Drafts Antiguos
echo -e "${YELLOW}=== GRUPO 6: Drafts Antiguos ===${NC}"
close_pr 11 "Es un draft obsoleto"
((PR_CLOSED++))
close_pr 9 "Sin resolución después de 10 comentarios"
((PR_CLOSED++))
close_pr 8 "Es un draft no crítico"
((PR_CLOSED++))
echo ""

# PRs Duplicados - Copilot
echo -e "${YELLOW}=== GRUPO 7: Copilot Instructions ===${NC}"
close_pr 5 "Es un duplicado de: #14"
((PR_CLOSED++))
echo ""

# PRs Drafts Antiguos - GameState
echo -e "${YELLOW}=== GRUPO 8: GameStateManager ===${NC}"
close_pr 3 "Es un draft que nunca fue mergeado"
((PR_CLOSED++))
echo ""

# PRs Irrelevantes
echo -e "${YELLOW}=== GRUPO 9: Azure Workflow (Irrelevante) ===${NC}"
close_pr 51 "Irrelevante para este proyecto Flutter"
((PR_CLOSED++))
echo ""

# PRs Duplicados - Magic Numbers
echo -e "${YELLOW}=== GRUPO 10: Extract Magic Numbers ===${NC}"
close_pr 52 "Es un duplicado de: #53"
((PR_CLOSED++))
echo ""

# Issues Duplicados
echo -e "${YELLOW}=== ISSUES DUPLICADOS ===${NC}"
close_issue 13 "Issue duplicado de #4"
((ISSUE_CLOSED++))
close_issue 4 "Issue duplicado de #13"
((ISSUE_CLOSED++))
echo ""

# Resumen Final
echo -e "${GREEN}"
echo "=============================================="
echo "  ✅ LIMPIEZA COMPLETADA"
echo "=============================================="
echo "  PRs cerrados: $PR_CLOSED"
echo "  Issues cerrados: $ISSUE_CLOSED"
echo "  Total: $((PR_CLOSED + ISSUE_CLOSED))"
echo "=============================================="
echo -e "${NC}"

echo ""
echo "📋 Próximos pasos:"
echo "  1. Verificar los cierres en GitHub"
echo "  2. Aplicar labels apropiados"
echo "  3. Crear issue de tracking"
echo "  4. Actualizar README con política de mantenimiento"
echo ""
echo "🎉 ¡Limpieza masiva completada exitosamente!"
