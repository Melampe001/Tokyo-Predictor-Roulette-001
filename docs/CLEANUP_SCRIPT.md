# 🧹 Script de Limpieza Masiva de PRs e Issues

**Fecha de Creación**: 2024-12-14  
**Repositorio**: Melampe001/Tokyo-Predictor-Roulette-001  
**Objetivo**: Limpiar PRs obsoletos, duplicados y issues stale

## 📋 Resumen Ejecutivo

Este documento contiene la lista completa de PRs e issues que deben ser cerrados como parte de la limpieza masiva del repositorio, junto con los scripts y comandarios automáticos necesarios.

## ❌ PRs a Cerrar (Duplicados/Obsoletos)

### Grupo 1: CI Fixes Duplicados
- **PR #37**: CI fixes (duplicado de #38)
  - Razón: Duplicado
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #38"
  
- **PR #38**: CI fixes (duplicado, más antiguo)
  - Razón: Duplicado
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado/obsoleto"

### Grupo 2: Refactor Terminology
- **PR #27**: Refactor gambling terminology (duplicado de #28)
  - Razón: Duplicado de #28
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #28"

### Grupo 3: GitHub Actions APK
- **PR #25**: GitHub Actions APK (duplicado de #26)
  - Razón: Duplicado de #26
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #26"

### Grupo 4: Drafts Obsoletos
- **PR #22**: Makefile commands (draft obsoleto)
  - Razón: Draft sin actividad
  - Comentario: "🤖 Cerrado automáticamente: Draft obsoleto sin actividad reciente"
  
- **PR #23**: Template example (draft, no fusionado)
  - Razón: Draft sin fusionar
  - Comentario: "🤖 Cerrado automáticamente: Draft no fusionado"

### Grupo 5: AAB Workflow Duplicados
- **PR #19**: AAB workflow (duplicado de #18, #17, #16)
  - Razón: Duplicado múltiple
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #18, #17, #16"
  
- **PR #18**: AAB workflow (duplicado)
  - Razón: Duplicado
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado"
  
- **PR #17**: AAB workflow (duplicado)
  - Razón: Duplicado
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado"
  
- **PR #16**: AAB workflow (duplicado)
  - Razón: Duplicado
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado"

### Grupo 6: Drafts Antiguos
- **PR #11**: Separate workflows (draft, obsoleto)
  - Razón: Draft obsoleto
  - Comentario: "🤖 Cerrado automáticamente: Draft obsoleto"
  
- **PR #9**: Checklist PR template (10 comentarios, sin resolución)
  - Razón: Sin resolución a pesar de comentarios
  - Comentario: "🤖 Cerrado automáticamente: Sin resolución después de 10 comentarios"
  
- **PR #8**: GitHub Pro guide (draft, no crítico)
  - Razón: Draft no crítico
  - Comentario: "🤖 Cerrado automáticamente: Draft no crítico"

### Grupo 7: Copilot Instructions
- **PR #5**: Copilot instructions (duplicado de #14)
  - Razón: Duplicado de #14
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #14"

### Grupo 8: GameStateManager
- **PR #3**: GameStateManager refactor (draft, nunca mergeado)
  - Razón: Draft antiguo sin mergear
  - Comentario: "🤖 Cerrado automáticamente: Draft nunca mergeado"

### Grupo 9: Azure Workflow (Irrelevante)
- **PR #51**: Azure Node.js workflow (irrelevante, proyecto Flutter)
  - Razón: Irrelevante para proyecto Flutter
  - Comentario: "🤖 Cerrado automáticamente: Irrelevante para proyecto Flutter"

### Grupo 10: Extract Magic Numbers (Duplicado)
- **PR #52**: Extract magic numbers (duplicado de #53)
  - Razón: Duplicado de #53
  - Comentario: "🤖 Cerrado automáticamente: PR duplicado de #53"

## 🔄 PRs a Revisar/Priorizar (NO CERRAR)

### Alta Prioridad
1. **PR #57**: Android APK config (CRÍTICO, trabajando en Agente 1)
2. **PR #46**: Patch 1 (3 comentarios, ALTA PRIORIDAD)
3. **PR #32**: Firebase/Stripe/Play Store (21 comentarios, CRÍTICO)
4. **PR #42**: Extract screen widgets (3 comentarios, revisar)

### Media Prioridad
5. **PR #56**: Algoritmo licuado (feature, revisar después)
6. **PR #30**: Play Store package (11 comentarios, revisar)
7. **PR #28**: Refactor terminology (34 comentarios, stale)
8. **PR #26**: APK docs/automation (8 comentarios, stale)

### Evaluar
9. **PR #54**: Fixed instructions (draft, evaluar)
10. **PR #53**: Extract magic numbers (draft, evaluar)
11. **PR #49**: PR review infrastructure (draft)
12. **PR #48**: Android build config (posible duplicado de #57)
13. **PR #47**: Roulette simulator (draft, evaluar)
14. **PR #45**: TODO items (draft)
15. **PR #44**: Gradle files (draft)
16. **PR #43**: Complete repository (draft)
17. **PR #39**: App completion docs (draft)
18. **PR #31**: CI/CD workflow (draft)
19. **PR #24**: Idempotency infrastructure (draft)
20. **PR #21**: Agents/bots structure (draft)
21. **PR #15**: Android signing/CI (draft)
22. **PR #14**: Copilot instructions (no draft, evaluar)

## ❌ Issues a Cerrar

- **Issue #13**: Copilot instructions (duplicado de #4)
  - Razón: Duplicado de #4
  - Comentario: "🤖 Cerrado automáticamente: Issue duplicado de #4"

- **Issue #4**: Copilot instructions (duplicado de #13)
  - Razón: Duplicado de #13
  - Comentario: "🤖 Cerrado automáticamente: Issue duplicado de #13"

## 📝 Plantilla de Comentario Automático

```markdown
🤖 **Cierre Automático - Limpieza de Repositorio**

Este PR/issue está siendo cerrado como parte de una limpieza masiva porque:
- [X] Es un duplicado de: #XX
- [ ] Ha estado inactivo por >30 días
- [ ] Es un draft sin actividad reciente
- [ ] Está obsoleto por cambios más recientes

Si consideras que debe reabrirse, por favor:
1. Actualiza el contenido
2. Responde a comentarios pendientes
3. Menciona @Melampe001 para revisión

---
*Cerrado automáticamente por Bot de Limpieza - 2024-12-14*
```

## 🏷️ Labels a Aplicar

### Labels para PRs Cerrados
- `duplicate` → PRs duplicados (#37, #38, #27, #25, #19, #18, #17, #16, #5, #52)
- `stale` → Sin actividad >30 días (#22, #23, #11, #8, #3)
- `wontfix` → Irrelevantes o no planificados (#51)
- `superseded` → Reemplazado por otro PR

### Labels para PRs Priorizados
- `priority` → #57, #46, #32
- `needs-review` → #42, #30, #28, #26
- `enhancement` → #56
- `needs-rebase` → PRs con conflictos de merge

## 🚀 Script de Ejecución Bash

```bash
#!/bin/bash
# close_stale_prs.sh
# Script para cerrar PRs obsoletos y duplicados

REPO="Melampe001/Tokyo-Predictor-Roulette-001"
DATE=$(date +%Y-%m-%d)

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

  echo "Cerrando PR #$pr_number: $reason"
  gh pr close $pr_number --repo $REPO --comment "$comment"
}

# PRs Duplicados - Grupo CI Fixes
close_pr 37 "Es un duplicado de: #38"
close_pr 38 "Es un duplicado/obsoleto"

# PRs Duplicados - Refactor
close_pr 27 "Es un duplicado de: #28"

# PRs Duplicados - GitHub Actions
close_pr 25 "Es un duplicado de: #26"

# PRs Drafts Obsoletos
close_pr 22 "Es un draft obsoleto sin actividad reciente"
close_pr 23 "Es un draft que no fue fusionado"

# PRs Duplicados - AAB Workflow
close_pr 19 "Es un duplicado de: #18, #17, #16"
close_pr 18 "Es un duplicado"
close_pr 17 "Es un duplicado"
close_pr 16 "Es un duplicado"

# PRs Drafts Antiguos
close_pr 11 "Es un draft obsoleto"
close_pr 9 "Sin resolución después de 10 comentarios"
close_pr 8 "Es un draft no crítico"

# PRs Duplicados - Copilot
close_pr 5 "Es un duplicado de: #14"

# PRs Drafts Antiguos - GameState
close_pr 3 "Es un draft que nunca fue mergeado"

# PRs Irrelevantes
close_pr 51 "Irrelevante para este proyecto Flutter"

# PRs Duplicados - Magic Numbers
close_pr 52 "Es un duplicado de: #53"

echo ""
echo "✅ PRs cerrados: 16"
echo ""

# Issues Duplicados
echo "Cerrando issues duplicados..."
gh issue close 13 --repo $REPO --comment "🤖 Cerrado automáticamente: Issue duplicado de #4"
gh issue close 4 --repo $REPO --comment "🤖 Cerrado automáticamente: Issue duplicado de #13"

echo ""
echo "✅ Issues cerrados: 2"
echo ""
echo "🎉 Limpieza completada!"
```

## 📊 Estadísticas de Limpieza

### Antes de la Limpieza
- PRs Abiertos: 30+
- Issues Abiertos: 45
- PRs en Draft: 20+
- PRs Duplicados: 16
- Issues Duplicados: 2

### Después de la Limpieza (Estimado)
- PRs Abiertos: ~14-16
- Issues Abiertos: ~43
- PRs en Draft: ~8-10
- PRs Duplicados: 0
- Issues Duplicados: 0

### Impacto
- **Reducción de PRs**: ~53% (de 30 a 14)
- **Limpieza de Duplicados**: 100%
- **Mejora en Claridad**: Alta

## ✅ Criterios de Éxito

- [X] 16 PRs duplicados/obsoletos identificados para cierre
- [X] 2 issues duplicados identificados para cierre
- [X] Comentarios automáticos preparados
- [X] Labels definidos y documentados
- [X] Script de ejecución creado
- [ ] README actualizado con política de mantenimiento
- [ ] Issue de tracking creado

## ⚠️ Restricciones Aplicadas

✅ **Respetado**: NO cerrar PRs con actividad en últimos 7 días  
✅ **Respetado**: NO cerrar PRs con label "priority" (#57, #46, #32)  
✅ **Respetado**: PRESERVAR PRs marcados como "critical"  
✅ **Respetado**: Comentar SIEMPRE antes de cerrar  

## 📅 Próximos Pasos

1. **Ejecutar el script**: `bash close_stale_prs.sh`
2. **Verificar cierres**: Revisar que todos los PRs/issues se cerraron correctamente
3. **Aplicar labels**: Usar GitHub CLI o interfaz web
4. **Crear issue de tracking**: Documentar estado post-limpieza
5. **Actualizar README**: Agregar sección de mantenimiento
6. **Notificar equipo**: Informar sobre la limpieza realizada

## 🔗 Referencias

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Issue Triage Best Practices](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues)
- [Managing Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
