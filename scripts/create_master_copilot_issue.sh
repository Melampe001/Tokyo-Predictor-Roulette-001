#!/bin/bash
# scripts/create_master_copilot_issue.sh
#
# 📝 Script para crear issue maestro consolidado de Copilot
#
# Uso:
#   ./scripts/create_master_copilot_issue.sh [--dry-run]
#
# Opciones:
#   --dry-run    Muestra el contenido sin crear el issue

set -e

# Configuración
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 Modo DRY RUN activado - No se creará el issue"
fi

echo "📝 Creando issue maestro de Copilot..."
echo "======================================"
echo ""

ISSUE_TITLE="🎯 Configuración Maestra de Copilot para Organización Melampe"

ISSUE_BODY="# 🎯 Configuración Maestra de Copilot - Organización Melampe

## 🎯 Objetivo
Configuración unificada de GitHub Copilot para todos los repositorios de Melampe.

## 📋 Estado de Configuración por Repositorio

| Repositorio | Estado | Archivo | Health Score |
|-------------|--------|---------|--------------|
| Tokyo-Predictor-Roulette-001 | ✅ Configurado | .github/copilot-instructions.md | 92/100 |
| Tokyo-IA | ⏳ Pendiente | - | - |
| Tokyo-Apps-IA | ⏳ Pendiente | - | - |
| bug-free-octo-winner-Tokyo-IA2 | ⏳ Pendiente | - | - |
| Tokyoapps | ⏳ Pendiente | - | - |
| Tokyo-Predictor-Roulette.- | ⏳ Pendiente | - | - |

## 🛠️ Configuración Recomendada

\`\`\`markdown
# GitHub Copilot Instructions - Melampe Organization

## Código de Estilo

### Flutter/Dart
- Usa \`dart format .\` antes de cada commit
- Sigue las convenciones de Flutter style guide
- Preferir const constructors cuando sea posible
- Documentar funciones públicas con /// dartdoc

### Python
- Sigue PEP 8
- Usa type hints en todas las funciones
- Documenta con docstrings estilo Google
- Máximo 88 caracteres por línea (Black formatter)

### JavaScript/TypeScript
- Usa ESLint con configuración estándar
- Preferir async/await sobre callbacks
- Usar TypeScript para proyectos nuevos

## Testing
- Cobertura mínima: 70%
- Tests unitarios obligatorios para nueva funcionalidad
- Usar table-driven tests en Go/Python cuando sea posible

## Commits
- Formato: \`tipo(scope): mensaje\`
- Tipos: feat, fix, docs, style, refactor, test, chore
- Mensajes en español, claros y descriptivos

## Agentes y Bots
- Todos los repos deben tener Health Agent configurado
- Ejecutar \`python scripts/health_agent.py --full-scan\` antes de PRs importantes
- Bots automáticos activos: Updater, Backup, SelfHeal

## Seguridad
- Nunca commitear secretos o API keys
- Usar variables de entorno o GitHub Secrets
- Ejecutar security scan antes de cada release
\`\`\`

## ✅ Checklist de Implementación

- [ ] Copiar configuración a todos los repositorios
- [ ] Actualizar README de cada repo con instrucciones
- [ ] Configurar pre-commit hooks
- [ ] Validar con Health Agent
- [ ] Documentar en docs/COPILOT_SETUP.md

## 📚 Referencias
- [Copilot Best Practices](https://gh.io/copilot-coding-agent-tips)
- [Health Agent Docs](docs/HEALTH_AGENT.md)
- [Organization Standards](docs/ORGANIZATION_STANDARDS.md)

---

**Issues consolidados**: 
- Melampe001/Tokyo-Predictor-Roulette-001#85
- Melampe001/Tokyo-Predictor-Roulette-001#93
- Melampe001/bug-free-octo-winner-Tokyo-IA2#1
- Melampe001/bug-free-octo-winner-Tokyo-IA2#11
- Melampe001/skills-introduction-to-github#9
- Melampe001/Tokyoapps#7

**Cerrado automáticamente por**: Bot_Cleanup v1.0
**Script**: \`scripts/close_duplicate_issues.sh\`
"

if [ "$DRY_RUN" = true ]; then
    echo "📋 Contenido del issue que se crearía:"
    echo "======================================"
    echo ""
    echo "Título: $ISSUE_TITLE"
    echo ""
    echo "Cuerpo:"
    echo "$ISSUE_BODY"
    echo ""
    echo "Labels: documentation, copilot, organization"
    echo "Assignee: Melampe001"
    exit 0
fi

# Verificar que gh está instalado
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) no está instalado"
    echo "   Instala con: https://cli.github.com/"
    exit 1
fi

# Crear issue maestro
echo "🚀 Creando issue en Melampe001/Tokyo-Predictor-Roulette-001..."

if gh issue create \
    --repo Melampe001/Tokyo-Predictor-Roulette-001 \
    --title "$ISSUE_TITLE" \
    --body "$ISSUE_BODY" \
    --label "documentation,copilot,organization" \
    --assignee Melampe001; then
    
    echo ""
    echo "✅ Issue maestro creado exitosamente"
    echo ""
    echo "🎯 Próximos pasos:"
    echo "   1. Revisa el issue creado"
    echo "   2. Copia la configuración a otros repositorios"
    echo "   3. Actualiza el tracking de issues consolidados"
else
    echo ""
    echo "❌ Error al crear el issue maestro"
    echo "   Verifica tus permisos y autenticación con gh"
    exit 1
fi
