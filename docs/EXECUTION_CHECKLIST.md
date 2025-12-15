# ✅ Checklist de Ejecución de Limpieza Masiva

**Fecha de Ejecución**: _____________  
**Ejecutado por**: _____________  
**Versión del Script**: 1.0

---

## 📋 Pre-Ejecución

### Verificación de Herramientas
- [ ] gh CLI instalado (`gh --version`)
- [ ] gh CLI autenticado (`gh auth status`)
- [ ] Permisos de escritura verificados
- [ ] Repositorio clonado localmente

### Revisión de Documentación
- [ ] Leída [Guía Rápida](QUICK_START_CLEANUP.md)
- [ ] Revisado [Script de Limpieza](CLEANUP_SCRIPT.md)
- [ ] Comprendidas las [Políticas](MAINTENANCE_POLICY.md)
- [ ] Revisadas [Plantillas de Comentarios](COMMENT_TEMPLATES.md)

### Verificación de PRs
- [ ] Confirmado que #57 NO se cierra (EN PROGRESO - Agente 1)
- [ ] Confirmado que #46 NO se cierra (Alta prioridad)
- [ ] Confirmado que #32 NO se cierra (Crítico)
- [ ] Confirmado que #42 NO se cierra (Alta prioridad)
- [ ] Verificada lista de 16 PRs a cerrar
- [ ] Verificada lista de 2 issues a cerrar

---

## 🚀 Ejecución

### Opción A: Script Automatizado

```bash
cd /path/to/Tokyo-Predictor-Roulette-001
bash close_stale_prs.sh
```

- [ ] Script ejecutado sin errores
- [ ] Todos los PRs cerrados exitosamente (16)
- [ ] Todos los issues cerrados exitosamente (2)
- [ ] Comentarios agregados correctamente
- [ ] Output guardado para referencia

### Opción B: Comandos Manuales

Si prefieres ejecutar manualmente, usa los comandos en [QUICK_START_CLEANUP.md](QUICK_START_CLEANUP.md)

---

## 🔍 Verificación Post-Ejecución

### PRs Cerrados

#### Grupo 1: CI Fixes
- [ ] #37 cerrado con comentario
- [ ] #38 cerrado con comentario

#### Grupo 2: Refactor
- [ ] #27 cerrado con comentario

#### Grupo 3: GitHub Actions
- [ ] #25 cerrado con comentario

#### Grupo 4: Drafts Obsoletos
- [ ] #22 cerrado con comentario
- [ ] #23 cerrado con comentario

#### Grupo 5: AAB Workflow
- [ ] #19 cerrado con comentario
- [ ] #18 cerrado con comentario
- [ ] #17 cerrado con comentario
- [ ] #16 cerrado con comentario

#### Grupo 6: Drafts Antiguos
- [ ] #11 cerrado con comentario
- [ ] #9 cerrado con comentario
- [ ] #8 cerrado con comentario

#### Grupo 7: Copilot Instructions
- [ ] #5 cerrado con comentario

#### Grupo 8: GameStateManager
- [ ] #3 cerrado con comentario

#### Grupo 9: Azure Workflow
- [ ] #51 cerrado con comentario

#### Grupo 10: Magic Numbers
- [ ] #52 cerrado con comentario

### Issues Cerrados
- [ ] #13 cerrado con comentario
- [ ] #4 cerrado con comentario

### Verificación en GitHub Web
- [ ] Todos los PRs cerrados visibles en GitHub
- [ ] Todos los comentarios visibles
- [ ] Estados correctos (closed)

---

## 🏷️ Aplicación de Labels

### Labels de Estado (Opcional)

#### Duplicados
- [ ] #37 → `duplicate`
- [ ] #38 → `duplicate`
- [ ] #27 → `duplicate`
- [ ] #25 → `duplicate`
- [ ] #19, #18, #17, #16 → `duplicate`
- [ ] #5 → `duplicate`
- [ ] #52 → `duplicate`
- [ ] #13 → `duplicate`
- [ ] #4 → `duplicate`

#### Stale
- [ ] #22 → `stale`
- [ ] #23 → `stale`
- [ ] #11 → `stale`
- [ ] #8 → `stale`
- [ ] #3 → `stale`

#### Wontfix
- [ ] #51 → `wontfix`

#### Sin Resolución
- [ ] #9 → `wontfix` o `stale`

**Nota**: La aplicación de labels es opcional pero recomendada.

---

## 📊 Estadísticas

### Antes de la Limpieza
- PRs Abiertos: _______ (esperado: ~30)
- Issues Abiertos: _______ (esperado: ~45)
- PRs en Draft: _______ (esperado: ~20)

### Después de la Limpieza
- PRs Abiertos: _______ (esperado: ~14-16)
- Issues Abiertos: _______ (esperado: ~43)
- PRs en Draft: _______ (esperado: ~8-10)

### Resumen
- PRs Cerrados: _______ (esperado: 16)
- Issues Cerrados: _______ (esperado: 2)
- Total Cerrados: _______ (esperado: 18)
- Reducción %: _______ (esperado: ~53%)

Comando para verificar:
```bash
gh pr list --repo Melampe001/Tokyo-Predictor-Roulette-001 --state open --json number --jq 'length'
gh issue list --repo Melampe001/Tokyo-Predictor-Roulette-001 --state open --json number --jq 'length'
```

---

## 📝 Documentación

### Actualizar Documentos
- [ ] [POST_CLEANUP_TRACKING.md](POST_CLEANUP_TRACKING.md) actualizado con fechas reales
- [ ] [README.md](../README.md) verificado (sección de mantenimiento)
- [ ] Estadísticas actualizadas con números reales

### Generar Reporte
- [ ] Reporte de cierres generado (comandos en QUICK_START_CLEANUP.md)
- [ ] Screenshots tomados (opcional)
- [ ] Log de output guardado

---

## 💬 Comunicación

### Notificación al Equipo
- [ ] Issue de tracking creado (opcional)
- [ ] Email/mensaje al equipo enviado
- [ ] @Melampe001 notificado
- [ ] Cambios explicados

### Contenido de la Notificación
```markdown
🧹 **Limpieza Masiva Completada**

Hemos completado una limpieza masiva del repositorio:
- ❌ 16 PRs cerrados (duplicados/obsoletos)
- ❌ 2 issues cerrados (duplicados)
- ✅ Reducción del 53% en PRs abiertos

**PRs Priorizados**:
- #57 (Android APK - EN PROGRESO)
- #46, #32, #42 (Alta prioridad)

**Documentación**:
- [Estado Post-Limpieza](docs/POST_CLEANUP_TRACKING.md)
- [Políticas de Mantenimiento](docs/MAINTENANCE_POLICY.md)

Para más detalles, ver: docs/README_CLEANUP.md
```

---

## 🔄 Próximos Pasos

### Inmediato (Esta Semana)
- [ ] Revisar PR #46 (3 comentarios pendientes)
- [ ] Decisión sobre PR #32 (21 comentarios)
- [ ] Revisar PR #42 (extract widgets)
- [ ] Verificar si #48 es duplicado de #57

### Corto Plazo (2 Semanas)
- [ ] Mergear PR #57 cuando Agente 1 termine
- [ ] Revisar PR #56 (algoritmo licuado)
- [ ] Decisión sobre PR #28 (34 comentarios)
- [ ] Revisar PR #30 (11 comentarios)

### Medio Plazo (1 Mes)
- [ ] Evaluar todos los drafts restantes
- [ ] Establecer calendario de limpieza mensual
- [ ] Primera limpieza mensual programada
- [ ] Revisión de políticas

---

## 🎯 Métricas de Éxito

### Objetivos Completados
- [ ] ✅ 16+ PRs duplicados cerrados
- [ ] ✅ 2+ issues duplicados cerrados
- [ ] ✅ Labels aplicados consistentemente (opcional)
- [ ] ✅ README actualizado con política
- [ ] ✅ Documentación completa creada
- [ ] ✅ Comentarios explicativos en todos los cierres

### Restricciones Respetadas
- [ ] ✅ NO cerrados PRs con actividad en últimos 7 días
- [ ] ✅ NO cerrados PRs con label "priority"
- [ ] ✅ PRESERVADOS PRs marcados como "critical"
- [ ] ✅ COMENTADO SIEMPRE antes de cerrar

---

## 🐛 Problemas Encontrados

Documenta cualquier problema encontrado durante la ejecución:

### Problema 1
- **Descripción**: _______________________________
- **Solución**: _______________________________
- **Estado**: [ ] Resuelto [ ] Pendiente

### Problema 2
- **Descripción**: _______________________________
- **Solución**: _______________________________
- **Estado**: [ ] Resuelto [ ] Pendiente

### Problema 3
- **Descripción**: _______________________________
- **Solución**: _______________________________
- **Estado**: [ ] Resuelto [ ] Pendiente

---

## 📚 Lecciones Aprendidas

### Qué Funcionó Bien
1. _______________________________
2. _______________________________
3. _______________________________

### Qué Mejorar
1. _______________________________
2. _______________________________
3. _______________________________

### Recomendaciones Futuras
1. _______________________________
2. _______________________________
3. _______________________________

---

## ✅ Firma de Completado

- **Ejecutado por**: _______________________________
- **Fecha**: _______________________________
- **Hora inicio**: _______________________________
- **Hora fin**: _______________________________
- **Duración total**: _______________________________
- **Resultado**: [ ] Exitoso [ ] Parcial [ ] Fallido

### Notas Adicionales
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

**Archivo de Referencia**: docs/EXECUTION_CHECKLIST.md  
**Versión**: 1.0  
**Fecha de Creación**: 2024-12-14  
**Última Actualización**: 2024-12-14
