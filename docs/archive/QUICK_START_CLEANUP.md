# 🚀 Guía Rápida de Ejecución de Limpieza

Esta es una guía rápida para ejecutar la limpieza masiva de PRs e issues.

---

## ⚡ Ejecución Rápida

### Opción 1: Script Automatizado (Recomendado)

```bash
# 1. Asegúrate de tener gh CLI instalado y autenticado
gh auth status

# 2. Navega al directorio del repositorio
cd /path/to/Tokyo-Predictor-Roulette-001

# 3. Ejecuta el script de limpieza
bash close_stale_prs.sh

# 4. Revisa el output para confirmar cierres exitosos
```

---

### Opción 2: Comandos Manuales

Si prefieres ejecutar comandos uno por uno para mayor control:

```bash
REPO="Melampe001/Tokyo-Predictor-Roulette-001"

# PRs Duplicados - CI Fixes
gh pr close 37 --repo $REPO --comment "🤖 Cerrado: Duplicado de #38"
gh pr close 38 --repo $REPO --comment "🤖 Cerrado: Duplicado/obsoleto"

# PRs Duplicados - Refactor
gh pr close 27 --repo $REPO --comment "🤖 Cerrado: Duplicado de #28"

# PRs Duplicados - GitHub Actions
gh pr close 25 --repo $REPO --comment "🤖 Cerrado: Duplicado de #26"

# Drafts Obsoletos
gh pr close 22 --repo $REPO --comment "🤖 Cerrado: Draft obsoleto"
gh pr close 23 --repo $REPO --comment "🤖 Cerrado: Draft no fusionado"

# AAB Workflow Duplicados
gh pr close 19 --repo $REPO --comment "🤖 Cerrado: Duplicado de #18, #17, #16"
gh pr close 18 --repo $REPO --comment "🤖 Cerrado: Duplicado"
gh pr close 17 --repo $REPO --comment "🤖 Cerrado: Duplicado"
gh pr close 16 --repo $REPO --comment "🤖 Cerrado: Duplicado"

# Drafts Antiguos
gh pr close 11 --repo $REPO --comment "🤖 Cerrado: Draft obsoleto"
gh pr close 9 --repo $REPO --comment "🤖 Cerrado: Sin resolución (10 comentarios)"
gh pr close 8 --repo $REPO --comment "🤖 Cerrado: Draft no crítico"

# Copilot Instructions
gh pr close 5 --repo $REPO --comment "🤖 Cerrado: Duplicado de #14"

# GameStateManager
gh pr close 3 --repo $REPO --comment "🤖 Cerrado: Draft nunca mergeado"

# Azure Workflow
gh pr close 51 --repo $REPO --comment "🤖 Cerrado: Irrelevante (proyecto Flutter)"

# Extract Magic Numbers
gh pr close 52 --repo $REPO --comment "🤖 Cerrado: Duplicado de #53"

# Issues Duplicados
gh issue close 13 --repo $REPO --comment "🤖 Cerrado: Duplicado de #4"
gh issue close 4 --repo $REPO --comment "🤖 Cerrado: Duplicado de #13"
```

---

## 📋 Pre-requisitos

### Verificar gh CLI

```bash
# Verificar instalación
gh --version

# Verificar autenticación
gh auth status

# Si no está autenticado
gh auth login
```

### Verificar Permisos

Necesitas permisos para:
- Cerrar PRs en el repositorio
- Cerrar issues en el repositorio
- Comentar en PRs e issues

---

## ✅ Checklist de Ejecución

### Antes de Ejecutar

- [ ] Verificar que gh CLI está instalado
- [ ] Verificar que estás autenticado con gh
- [ ] Verificar que tienes permisos de escritura en el repo
- [ ] Revisar la lista de PRs/issues a cerrar
- [ ] Confirmar que ningún PR crítico será cerrado por error

### Durante la Ejecución

- [ ] Ejecutar el script o comandos manuales
- [ ] Monitorear el output para errores
- [ ] Tomar nota de cualquier fallo

### Después de Ejecutar

- [ ] Verificar cierres en GitHub web
- [ ] Revisar que los comentarios se agregaron correctamente
- [ ] Aplicar labels apropiados (si no se hizo automáticamente)
- [ ] Actualizar documentación de tracking
- [ ] Notificar al equipo sobre la limpieza

---

## 🎯 PRs/Issues a Cerrar

### PRs Duplicados (10)
- #37, #38 (CI fixes)
- #27 (Refactor terminology)
- #25 (GitHub Actions APK)
- #19, #18, #17, #16 (AAB workflow)
- #5 (Copilot instructions)
- #52 (Extract magic numbers)

### PRs Drafts Obsoletos (5)
- #22 (Makefile commands)
- #23 (Template example)
- #11 (Separate workflows)
- #8 (GitHub Pro guide)
- #3 (GameStateManager refactor)

### PRs Sin Resolución (1)
- #9 (Checklist PR template - 10 comentarios)

### PRs Irrelevantes (1)
- #51 (Azure Node.js workflow)

### Issues Duplicados (2)
- #13, #4 (Copilot instructions)

**Total: 18 cierres (16 PRs + 2 Issues)**

---

## 🚨 PRs que NO Deben Cerrarse

### Críticos / Alta Prioridad
- #57 (Android APK config - EN PROGRESO)
- #46 (Patch 1 - 3 comentarios)
- #32 (Firebase/Stripe/Play Store - 21 comentarios)
- #42 (Extract screen widgets - 3 comentarios)

### Media Prioridad
- #56 (Algoritmo licuado)
- #30 (Play Store package - 11 comentarios)
- #28 (Refactor terminology - 34 comentarios)
- #26 (APK docs/automation - 8 comentarios)

### A Evaluar
- #54, #53, #49, #48, #47, #45, #44, #43, #39, #31, #24, #21, #15, #14

---

## 🔍 Verificación Post-Cierre

### Comando para Listar PRs Abiertos

```bash
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 --state open --limit 50
```

### Comando para Listar Issues Abiertos

```bash
gh issue list --repo Melampe001/Tokyo-Predictor-Roulette-001 --state open --limit 50
```

### Verificar PRs Cerrados Recientemente

```bash
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 --state closed --limit 20
```

---

## 🏷️ Aplicar Labels (Post-Cierre)

Si necesitas aplicar labels después del cierre:

```bash
REPO="Melampe001/Tokyo-Predictor-Roulette-001"

# Aplicar label "duplicate" a PRs duplicados
gh pr edit 37 --repo $REPO --add-label "duplicate"
gh pr edit 38 --repo $REPO --add-label "duplicate"
# ... etc

# Aplicar label "stale" a drafts obsoletos
gh pr edit 22 --repo $REPO --add-label "stale"
gh pr edit 23 --repo $REPO --add-label "stale"
# ... etc

# Aplicar label "wontfix" a PRs irrelevantes
gh pr edit 51 --repo $REPO --add-label "wontfix"
```

---

## 🐛 Solución de Problemas

### Error: "gh: command not found"

```bash
# macOS
brew install gh

# Linux (Debian/Ubuntu)
sudo apt install gh

# Windows (con winget)
winget install GitHub.cli
```

### Error: "authentication required"

```bash
gh auth login
# Sigue las instrucciones en pantalla
```

### Error: "permission denied"

- Verifica que tienes permisos de escritura en el repositorio
- Verifica que estás autenticado con la cuenta correcta: `gh auth status`

### Error: "PR not found"

- El PR puede ya estar cerrado
- Verifica el número del PR: `gh pr view <number> --repo $REPO`

---

## 📊 Generar Reporte Post-Limpieza

```bash
# Contar PRs cerrados hoy
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 \
  --state closed \
  --search "closed:$(date +%Y-%m-%d)" \
  --json number,title \
  --jq 'length'

# Listar PRs cerrados hoy
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 \
  --state closed \
  --search "closed:$(date +%Y-%m-%d)" \
  --json number,title,closedAt

# Contar PRs abiertos ahora
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 \
  --state open \
  --json number \
  --jq 'length'
```

---

## 📝 Crear Issue de Tracking

Después de completar la limpieza, crea un issue de tracking:

```bash
gh issue create \
  --repo Melampe001/Tokyo-Predictor-Roulette-001 \
  --title "📊 Limpieza Masiva Completada - $(date +%Y-%m-%d)" \
  --body-file docs/POST_CLEANUP_TRACKING.md \
  --label "maintenance,documentation"
```

---

## 🔗 Enlaces Rápidos

- [Script de Limpieza](../close_stale_prs.sh)
- [Documentación Completa](CLEANUP_SCRIPT.md)
- [Plantillas de Comentarios](COMMENT_TEMPLATES.md)
- [Política de Mantenimiento](MAINTENANCE_POLICY.md)
- [Estado Post-Limpieza](POST_CLEANUP_TRACKING.md)

---

## ⏱️ Tiempo Estimado

- **Script automatizado**: 5-10 minutos
- **Comandos manuales**: 15-20 minutos
- **Verificación post-cierre**: 5 minutos
- **Aplicación de labels**: 5-10 minutos
- **Documentación**: 5 minutos

**Total**: ~20-30 minutos

---

**Última Actualización**: 2024-12-14  
**Versión**: 1.0  
**Mantenido por**: @Melampe001
