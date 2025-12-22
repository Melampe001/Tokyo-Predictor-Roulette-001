#!/bin/bash
# scripts/close_duplicate_issues.sh
#
# 🧹 Script automático para cerrar issues duplicados de Copilot setup
# 
# Uso:
#   ./scripts/close_duplicate_issues.sh [--dry-run]
#
# Opciones:
#   --dry-run    Simula el cierre sin ejecutarlo realmente
#
# Requisitos:
#   - GitHub CLI (gh) instalado y autenticado
#   - Permisos de escritura en los repositorios

set -e

# Configuración
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 Modo DRY RUN activado - No se realizarán cambios reales"
fi

echo "🧹 Iniciando limpieza de issues duplicados..."
echo "================================================"
echo ""

# Mensaje de cierre consolidado
CLOSE_MESSAGE="🤖 Cerrando issue duplicado automáticamente.

Este issue es un duplicado de la configuración de Copilot setup. La configuración consolidada se encuentra en:
- **Tokyo-Predictor-Roulette-001**: \`.github/copilot-instructions.md\`
- **Documentación**: \`docs/COPILOT_SETUP.md\`

**Sistema automatizado**: Este issue fue cerrado por Bot_Cleanup como parte de la limpieza automática de duplicados.

Para reabrir este issue, menciona a @Melampe001 con justificación."

# Función para cerrar issue
close_issue() {
    local repo=$1
    local issue=$2
    
    echo "  🔄 Procesando $repo#$issue..."
    
    if [ "$DRY_RUN" = true ]; then
        echo "  [DRY RUN] Se cerraría $repo#$issue"
        return 0
    fi
    
    # Verificar que gh está instalado
    if ! command -v gh &> /dev/null; then
        echo "  ❌ Error: GitHub CLI (gh) no está instalado"
        echo "     Instala con: https://cli.github.com/"
        return 1
    fi
    
    # Intentar cerrar el issue
    if gh issue close $issue \
        --repo "$repo" \
        --comment "$CLOSE_MESSAGE" \
        --reason "not planned" 2>/dev/null; then
        echo "  ✅ $repo#$issue cerrado exitosamente"
        return 0
    else
        echo "  ⚠️  No se pudo cerrar $repo#$issue (puede estar ya cerrado o no existir)"
        return 1
    fi
}

# Contador de resultados
TOTAL=0
CLOSED=0
FAILED=0

# Cerrar issues en Tokyo-Predictor-Roulette-001
echo "📦 Repositorio: Tokyo-Predictor-Roulette-001"
echo "-------------------------------------------"
for issue in 85 93; do
    TOTAL=$((TOTAL + 1))
    if close_issue "Melampe001/Tokyo-Predictor-Roulette-001" $issue; then
        CLOSED=$((CLOSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
done
echo ""

# Cerrar issues en bug-free-octo-winner-Tokyo-IA2
echo "📦 Repositorio: bug-free-octo-winner-Tokyo-IA2"
echo "-------------------------------------------"
for issue in 1 11; do
    TOTAL=$((TOTAL + 1))
    if close_issue "Melampe001/bug-free-octo-winner-Tokyo-IA2" $issue; then
        CLOSED=$((CLOSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
done
echo ""

# Cerrar issues en skills-introduction-to-github
echo "📦 Repositorio: skills-introduction-to-github"
echo "-------------------------------------------"
TOTAL=$((TOTAL + 1))
if close_issue "Melampe001/skills-introduction-to-github" 9; then
    CLOSED=$((CLOSED + 1))
else
    FAILED=$((FAILED + 1))
fi
echo ""

# Cerrar issues en Tokyoapps
echo "📦 Repositorio: Tokyoapps"
echo "-------------------------------------------"
TOTAL=$((TOTAL + 1))
if close_issue "Melampe001/Tokyoapps" 7; then
    CLOSED=$((CLOSED + 1))
else
    FAILED=$((FAILED + 1))
fi
echo ""

# Resumen final
echo "================================================"
echo "✅ Limpieza completada"
echo ""
echo "📊 Estadísticas:"
echo "   Total de issues procesados: $TOTAL"
echo "   Issues cerrados: $CLOSED"
echo "   Fallos/Ya cerrados: $FAILED"
echo ""

if [ "$DRY_RUN" = false ]; then
    echo "🎯 Siguiente paso: Ejecutar create_master_copilot_issue.sh"
    echo "   ./scripts/create_master_copilot_issue.sh"
else
    echo "🔍 Modo DRY RUN - Para ejecutar realmente, quita el flag --dry-run"
fi

exit 0
