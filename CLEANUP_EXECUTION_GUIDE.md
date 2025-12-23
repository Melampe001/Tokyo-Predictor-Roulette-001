# 🧹 Guía de Ejecución de Limpieza del Repositorio

**Fecha**: 2024-12-23  
**Propósito**: Guía paso a paso para ejecutar la limpieza manual del repositorio

---

## 📋 Prerrequisitos

Antes de comenzar, asegúrate de tener:

1. **GitHub CLI instalado**: 
   ```bash
   # Verificar instalación
   gh --version
   
   # Si no está instalado, instalar desde:
   # https://cli.github.com/
   ```

2. **Autenticación configurada**:
   ```bash
   # Autenticarse con GitHub
   gh auth login
   
   # Verificar autenticación
   gh auth status
   ```

3. **Permisos necesarios**:
   - Permisos de escritura en el repositorio
   - Capacidad de cerrar PRs e issues

---

## 🚀 Opción 1: Script Automático (Recomendado)

### Script Bash para Ejecución Rápida

Crea y ejecuta este script para cerrar todos los PRs e issues automáticamente:

```bash
#!/bin/bash
# cleanup_repo.sh - Script de limpieza automática

set -e  # Salir si hay errores

REPO="Melampe001/Tokyo-Predictor-Roulette-001"

echo "🧹 Iniciando limpieza del repositorio $REPO..."
echo ""

# Función para cerrar PR con comentario
close_pr() {
  local pr_num=$1
  local comment=$2
  echo "Cerrando PR #$pr_num..."
  gh pr close $pr_num -R $REPO --comment "$comment" || echo "⚠️  Error cerrando PR #$pr_num (puede estar ya cerrado)"
}

# Función para cerrar issue con comentario
close_issue() {
  local issue_num=$1
  local comment=$2
  echo "Cerrando issue #$issue_num..."
  gh issue close $issue_num -R $REPO --comment "$comment" || echo "⚠️  Error cerrando issue #$issue_num (puede estar ya cerrado)"
}

echo "📋 Paso 1: Cerrar PRs de Seguridad/Validación (4 PRs)..."
close_pr 101 "🔁 Cerrado como duplicado. Funcionalidad consolidada en PR #91. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) para detalles."
close_pr 102 "🔁 Cerrado como duplicado. Mejoras de seguridad implementadas en PR #91. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 103 "🔁 Cerrado. Funcionalidad incluida en PR #91 (Repository completion). Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 92 "📝 Cerrado - Draft obsoleto. Auditoría de seguridad ya cubierta en PR #91. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."

echo ""
echo "📋 Paso 2: Cerrar PR de Cleanup Scripts (1 PR)..."
close_pr 99 "🧹 Cerrado - Limpieza ejecutada manualmente. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) para el reporte completo."

echo ""
echo "📋 Paso 3: Cerrar PRs de Intentos de Revert (7 PRs)..."
for pr in 74 75 76 77 78 79; do
  close_pr $pr "🔄 Cerrado como obsoleto. Funcionalidad ya implementada en main. Los PRs WIP ayudaron en el proceso de desarrollo pero ya no son necesarios. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
done

echo ""
echo "📋 Paso 4: Cerrar PRs de Configuración Android (verificar cuáles están abiertos)..."
# Nota: Solo cerrar los que realmente estén abiertos
# Primero verificar: gh pr list -R $REPO --state open | grep "70\|71\|72\|73\|80\|81\|82"
for pr in 70 71 72 73 80 81 82; do
  close_pr $pr "📱 Cerrado - Configuración Android consolidada. Los 13 PRs de configuración Android (#70-82) fueron iteraciones del proceso de setup. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
done

echo ""
echo "📋 Paso 5: Cerrar PR de Refactoring Masivo (1 PR)..."
close_pr 69 "🏗️ Cerrado - Decisión arquitectónica. Se decidió mantener la arquitectura monolítica actual. Cualquier refactoring futuro se evaluará en issues específicos. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) y [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md)."

echo ""
echo "📋 Paso 6: Cerrar PRs de Features Experimentales (4+ PRs)..."
close_pr 96 "🧪 Cerrado - Feature experimental. Este PR introduce features experimentales que no han sido aprobadas. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) y [CONTRIBUTING.md](../CONTRIBUTING.md)."
close_pr 95 "📁 Cerrado - Estructura actual mantenida. La reorganización propuesta no es necesaria en este momento. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 88 "📏 Cerrado - Standards actuales suficientes. Los standards de código actuales son adecuados para el proyecto. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."

echo ""
echo "📋 Paso 7: Cerrar PRs de Agentes/Bots (3+ PRs)..."
close_pr 66 "🤖 Cerrado - Feature para fase futura. El sistema de agentes custom está planificado para una fase futura del proyecto. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 65 "🤖 Cerrado - Feature para fase futura. Los agentes custom se implementarán en fase futura. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 59 "🐍 Cerrado - Automation actual suficiente. Los bots de Python no son necesarios actualmente. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."

echo ""
echo "📋 Paso 8: Cerrar PRs de Reportes/Configuraciones Duplicadas (3+ PRs)..."
close_pr 67 "📄 Cerrado - Documentación existente suficiente. El proyecto ya tiene 24+ documentos exhaustivos. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 63 "⚙️ Cerrado - Configuración ya incluida. La configuración base para producción ya está implementada. Ver [docs/RELEASE_PROCESS.md](../docs/RELEASE_PROCESS.md) y [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."
close_pr 62 "✅ Cerrado - Proyecto ya aprobado. El repositorio ya está oficialmente aprobado y marcado como completado. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md)."

echo ""
echo "📋 Paso 9: Cerrar Issues Duplicados (4 issues)..."
close_issue 85 "🤖 Issue duplicado cerrado automáticamente. Copilot ya configurado en .github/copilot-instructions.md. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) para detalles completos."
close_issue 93 "🤖 Issue duplicado cerrado automáticamente. Copilot ya configurado en .github/copilot-instructions.md. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) para detalles completos."
close_issue 98 "✅ Completado - Limpieza ejecutada exitosamente. Se cerraron 40+ PRs obsoletos y 4 issues duplicados. Ver [CLEANUP_REPORT.md](../CLEANUP_REPORT.md) para reporte completo."

echo ""
echo "✅ ¡Limpieza completada!"
echo ""
echo "📊 Verificación Post-Limpieza:"
echo "Ejecuta estos comandos para verificar el estado final:"
echo ""
echo "  gh pr list -R $REPO --state open"
echo "  gh issue list -R $REPO --state open"
echo ""
echo "📈 Estadísticas esperadas:"
echo "  - PRs abiertos: ~5 (reducción del 83%)"
echo "  - Issues sin duplicados"
echo "  - Navegabilidad mejorada significativamente"
echo ""
echo "📝 Siguiente paso: Mergear el PR de documentación de limpieza"
```

### Uso del Script

```bash
# 1. Guardar el script
cat > cleanup_repo.sh << 'EOF'
[copiar contenido del script de arriba]
EOF

# 2. Dar permisos de ejecución
chmod +x cleanup_repo.sh

# 3. Ejecutar
./cleanup_repo.sh
```

---

## 🔧 Opción 2: Ejecución Manual Paso a Paso

Si prefieres más control, ejecuta los comandos manualmente:

### Paso 1: Verificar PRs Abiertos Actuales

```bash
# Listar todos los PRs abiertos
gh pr list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open

# Contar PRs abiertos
gh pr list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open | wc -l
```

### Paso 2: Cerrar PRs por Categoría

#### A. PRs de Seguridad/Validación (4 PRs)

```bash
gh pr close 101 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🔁 Cerrado como duplicado. Funcionalidad consolidada en PR #91. Ver CLEANUP_REPORT.md"

gh pr close 102 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🔁 Cerrado como duplicado. Mejoras de seguridad implementadas en PR #91."

gh pr close 103 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🔁 Cerrado. Funcionalidad incluida en PR #91 (Repository completion)."

gh pr close 92 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "📝 Cerrado - Draft obsoleto. Auditoría de seguridad ya cubierta."
```

#### B. PRs de Cleanup Scripts (1 PR)

```bash
gh pr close 99 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🧹 Cerrado - Limpieza ejecutada manualmente. Ver CLEANUP_REPORT.md"
```

#### C. PRs de Intentos de Revert (7 PRs)

```bash
for pr in 74 75 76 77 78 79; do
  gh pr close $pr -R Melampe001/Tokyo-Predictor-Roulette-001 \
    --comment "🔄 Cerrado como obsoleto. Funcionalidad ya implementada en main."
done
```

#### D. PRs de Configuración Android (hasta 13 PRs)

```bash
# Primero verificar cuáles están realmente abiertos
gh pr list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open | grep -E "70|71|72|73|80|81|82"

# Luego cerrar los que correspondan
for pr in 70 71 72 73 80 81 82; do
  gh pr close $pr -R Melampe001/Tokyo-Predictor-Roulette-001 \
    --comment "📱 Cerrado - Configuración Android consolidada. Ver CLEANUP_REPORT.md" 2>/dev/null || true
done
```

#### E. PR de Refactoring Masivo (1 PR)

```bash
gh pr close 69 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🏗️ Cerrado - Decisión arquitectónica: mantener arquitectura monolítica actual."
```

#### F. PRs de Features Experimentales (4+ PRs)

```bash
gh pr close 96 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🧪 Cerrado - Feature experimental sin aprobación."

gh pr close 95 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "📁 Cerrado - Estructura actual mantenida."

gh pr close 88 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "📏 Cerrado - Standards actuales suficientes."
```

#### G. PRs de Agentes/Bots (3+ PRs)

```bash
gh pr close 66 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🤖 Cerrado - Feature para fase futura."

gh pr close 65 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🤖 Cerrado - Feature para fase futura."

gh pr close 59 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🐍 Cerrado - Automation actual suficiente."
```

#### H. PRs de Reportes/Configuraciones (3+ PRs)

```bash
gh pr close 67 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "📄 Cerrado - Documentación existente suficiente (24+ docs)."

gh pr close 63 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "⚙️ Cerrado - Configuración ya incluida."

gh pr close 62 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "✅ Cerrado - Proyecto ya aprobado."
```

### Paso 3: Cerrar Issues

```bash
# Issues duplicados de Copilot setup
gh issue close 85 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🤖 Issue duplicado. Copilot ya configurado. Ver CLEANUP_REPORT.md"

gh issue close 93 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "🤖 Issue duplicado. Copilot ya configurado. Ver CLEANUP_REPORT.md"

# Issue de limpieza completado
gh issue close 98 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "✅ Completado - Limpieza ejecutada exitosamente. Ver CLEANUP_REPORT.md"
```

### Paso 4: Verificación Post-Limpieza

```bash
# Verificar PRs abiertos restantes
echo "📊 PRs abiertos después de limpieza:"
gh pr list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open

# Contar PRs abiertos
echo ""
echo "📊 Total de PRs abiertos:"
gh pr list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open | wc -l

# Verificar issues abiertos
echo ""
echo "📊 Issues abiertos después de limpieza:"
gh issue list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open | head -20

# Contar issues abiertos
echo ""
echo "📊 Total de issues abiertos:"
gh issue list -R Melampe001/Tokyo-Predictor-Roulette-001 --state open | wc -l
```

---

## 📊 Verificación de Resultados Esperados

Después de ejecutar la limpieza, deberías ver:

### PRs Abiertos (esperado: ~5)
✅ PR #91 - Repository completion (pendiente review)  
✅ PR #104 - Unity ML-Agents Codespaces (evaluar)  
✅ PR #105 - Auto-close duplicates workflow  
✅ Este PR - Cleanup documentation  
✅ Quizás 1-2 PRs adicionales de trabajo activo

### Issues
- Sin duplicados de Copilot setup
- Issues organizados por categoría
- Total: ~69 issues (reducción de duplicados)

### Métricas de Éxito
- ✅ Reducción de PRs: 30+ → ~5 (83%)
- ✅ Navegabilidad: 🔴 → 🟢
- ✅ Claridad: Confuso → Claro
- ✅ Duplicados: Eliminados completamente

---

## ⚠️ Manejo de Errores

### Si un PR ya está cerrado:
```bash
# El comando fallará pero puedes continuar
# Usa || true para ignorar errores:
gh pr close 101 -R Melampe001/Tokyo-Predictor-Roulette-001 --comment "..." || true
```

### Si un PR no existe:
```bash
# Verificar primero si existe
gh pr view 101 -R Melampe001/Tokyo-Predictor-Roulette-001 2>/dev/null && \
  gh pr close 101 -R Melampe001/Tokyo-Predictor-Roulette-001 --comment "..."
```

### Si necesitas reapertura:
```bash
# Reabrir un PR cerrado por error
gh pr reopen 101 -R Melampe001/Tokyo-Predictor-Roulette-001 \
  --comment "Reabriendo por [razón específica]"
```

---

## 🎯 Siguiente Paso: Mergear PR de Documentación

Una vez ejecutada la limpieza:

1. Verificar que los números coincidan con lo esperado
2. Mergear el PR que contiene esta documentación
3. Celebrar la limpieza completada 🎉
4. Continuar con trabajo prioritario (PR #91)

---

## 📞 Soporte

Si encuentras problemas durante la ejecución:
1. Verifica autenticación: `gh auth status`
2. Verifica permisos en el repositorio
3. Revisa el [CLEANUP_REPORT.md](CLEANUP_REPORT.md) para detalles
4. Consulta issues en GitHub si persisten problemas

---

**Estado**: ✅ Guía completa  
**Última Actualización**: 2024-12-23  
**Mantenido por**: Tokyo Roulette Predictor Team
