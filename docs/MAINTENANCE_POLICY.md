# 📋 Política de Mantenimiento del Repositorio

**Repositorio**: Tokyo-Predictor-Roulette-001  
**Propietario**: Melampe001  
**Última Actualización**: 2024-12-14  
**Versión**: 1.0

---

## 🎯 Objetivo

Mantener el repositorio limpio, organizado y fácil de gestionar mediante políticas claras de mantenimiento de PRs e issues.

---

## 📏 Políticas de Pull Requests

### Estados de PR

#### ✅ PRs Activos
**Definición**: PRs con actividad reciente (commits, comentarios, revisiones)

**Criterios**:
- Al menos 1 commit en los últimos 30 días, O
- Al menos 1 comentario/revisión en los últimos 14 días, O
- Marcado con label `priority` o `critical`

**Acción**: Ninguna - mantener abierto

---

#### ⏸️ PRs Stale
**Definición**: PRs sin actividad reciente pero potencialmente útiles

**Criterios**:
- Sin commits en 30-60 días
- Sin comentarios en 14-30 días
- No marcado como `priority` o `critical`

**Acción**:
1. Aplicar label `stale`
2. Comentar: "⚠️ Este PR no ha tenido actividad en 30 días. Será cerrado en 30 días si no hay respuesta."
3. Esperar 30 días
4. Si no hay respuesta, cerrar con `not_planned`

---

#### ❌ PRs a Cerrar
**Definición**: PRs que deben cerrarse inmediatamente

**Criterios para cierre inmediato**:
- **Duplicados**: PR duplicado de otro PR existente
- **Obsoletos**: Código ya implementado de otra forma
- **Irrelevantes**: No relacionado con el proyecto
- **Drafts antiguos**: Draft sin actividad >90 días
- **Sin respuesta**: Sin respuesta a comentarios críticos >30 días

**Acción**:
1. Comentar razón de cierre con plantilla automática
2. Aplicar label apropiado (`duplicate`, `wontfix`, `superseded`)
3. Cerrar con razón apropiada (`not_planned`, `completed`)

---

### Plantillas de Comentarios

#### Comentario para PR Stale
```markdown
⚠️ **PR Marcado como Stale**

Este PR no ha tenido actividad en los últimos 30 días.

**Acción requerida**:
- Actualiza el PR con nuevos commits, o
- Responde a los comentarios pendientes, o
- Indica si planeas continuar trabajando en esto

Este PR será cerrado automáticamente en 30 días si no hay respuesta.

Si necesitas más tiempo, simplemente comenta en este PR y será removido del estado stale.

---
*Mensaje automático del Bot de Mantenimiento*
```

#### Comentario para Cierre Automático
```markdown
🤖 **Cierre Automático - Limpieza de Repositorio**

Este PR está siendo cerrado como parte del mantenimiento del repositorio porque:
- [ ] Es un duplicado de: #XX
- [ ] Ha estado inactivo por >60 días
- [ ] Es un draft sin actividad reciente (>90 días)
- [ ] Está obsoleto por cambios más recientes
- [ ] Es irrelevante para este proyecto
- [ ] Sin respuesta a comentarios críticos >30 días

**Si consideras que debe reabrirse**, por favor:
1. Actualiza el contenido del PR
2. Responde a todos los comentarios pendientes
3. Menciona @Melampe001 para revisión
4. Explica por qué debería reabrirse

---
*Cerrado automáticamente por Bot de Mantenimiento - {{DATE}}*
```

---

## 🏷️ Sistema de Labels

### Labels de Estado

#### `stale`
- **Color**: `#fef2c0` (amarillo claro)
- **Descripción**: Sin actividad en 30+ días
- **Acción**: Monitorear, cerrar si no hay respuesta en 30 días

#### `duplicate`
- **Color**: `#cfd3d7` (gris)
- **Descripción**: PR/issue duplicado de otro existente
- **Acción**: Cerrar inmediatamente con referencia al original

#### `wontfix`
- **Color**: `#ffffff` (blanco)
- **Descripción**: No se implementará por decisión del equipo
- **Acción**: Cerrar con explicación

#### `superseded`
- **Color**: `#d4c5f9` (púrpura claro)
- **Descripción**: Reemplazado por otro PR más reciente
- **Acción**: Cerrar con referencia al PR que lo reemplaza

#### `needs-rebase`
- **Color**: `#fbca04` (amarillo)
- **Descripción**: Tiene conflictos de merge con main
- **Acción**: Solicitar rebase al autor

---

### Labels de Prioridad

#### `priority`
- **Color**: `#d73a4a` (rojo)
- **Descripción**: Alta prioridad, debe revisarse pronto
- **Acción**: Revisar en <7 días
- **Protección**: No cerrar automáticamente

#### `critical`
- **Color**: `#b60205` (rojo oscuro)
- **Descripción**: Crítico para el proyecto, bloquea otros trabajos
- **Acción**: Revisar en <3 días
- **Protección**: NUNCA cerrar automáticamente

#### `enhancement`
- **Color**: `#a2eeef` (azul claro)
- **Descripción**: Nueva característica o mejora
- **Acción**: Revisar según roadmap

#### `needs-review`
- **Color**: `#0075ca` (azul)
- **Descripción**: Esperando revisión de código
- **Acción**: Asignar revisor, revisar en <14 días

---

## 📊 Políticas de Issues

### Estados de Issue

#### Abierto y Activo
**Criterios**:
- Al menos 1 comentario en últimos 60 días, O
- Marcado como `bug`, `priority`, o `critical`

**Acción**: Ninguna - mantener abierto

---

#### Stale
**Criterios**:
- Sin comentarios en 60-90 días
- No marcado como `priority` o `critical`

**Acción**:
1. Aplicar label `stale`
2. Comentar solicitando actualización
3. Cerrar después de 30 días sin respuesta

---

#### Duplicado
**Criterios**:
- Issue duplicado de otro existente

**Acción**:
1. Aplicar label `duplicate`
2. Comentar con referencia al issue original
3. Cerrar inmediatamente

---

## ⏰ Frecuencia de Limpieza

### Limpieza Automática Semanal
**Día**: Lunes a las 00:00 UTC  
**Acciones**:
- Identificar PRs/issues sin actividad >30 días
- Aplicar label `stale`
- Comentar en PRs/issues recién marcados como stale

### Limpieza Manual Mensual
**Día**: Primer lunes de cada mes  
**Acciones**:
- Revisar todos los PRs/issues con label `stale` >30 días
- Cerrar los que no han tenido respuesta
- Generar reporte de limpieza
- Actualizar estadísticas en README

### Limpieza Profunda Trimestral
**Frecuencia**: Cada 3 meses (Enero, Abril, Julio, Octubre)  
**Acciones**:
- Revisar TODOS los PRs abiertos
- Identificar duplicados no detectados
- Evaluar drafts antiguos
- Actualizar políticas de mantenimiento
- Generar reporte ejecutivo

---

## 🚫 Excepciones a las Políticas

### PRs que NUNCA se cierran automáticamente
1. PRs con label `critical`
2. PRs con label `priority`
3. PRs con actividad en últimos 7 días
4. PRs en revisión activa (con reviewers asignados)
5. PRs relacionados con security fixes

### Issues que NUNCA se cierran automáticamente
1. Issues con label `critical`
2. Issues con label `bug` y severity `high`
3. Issues con label `security`
4. Issues en milestones activos
5. Issues asignados a alguien activamente

---

## 📈 Métricas de Salud

### KPIs del Repositorio

#### Tiempo de Respuesta
- **Target**: <7 días para primer comentario en PR
- **Critical**: <3 días para PRs con label `priority`
- **Medición**: Tiempo entre apertura de PR y primer comentario

#### Tiempo de Merge
- **Target**: <14 días desde apertura hasta merge
- **Critical**: <7 días para PRs con label `priority`
- **Medición**: Tiempo entre apertura y merge del PR

#### PRs Stale
- **Target**: <10% de PRs abiertos marcados como stale
- **Medición**: (PRs stale / PRs abiertos) * 100

#### Duplicados
- **Target**: 0 duplicados en PRs abiertos
- **Medición**: Conteo de PRs con label `duplicate` abiertos

---

## 🔄 Proceso de Reapertura

### Criterios para Reabrir
Un PR/issue cerrado puede reabrirse si:
1. El autor actualiza el contenido significativamente
2. El autor responde a todos los comentarios pendientes
3. Las circunstancias han cambiado (ej: feature ahora es relevante)
4. Se cerró por error (bug en el proceso)

### Proceso
1. Autor comenta en el PR/issue cerrado explicando:
   - Por qué debería reabrirse
   - Qué ha cambiado
   - Qué acciones ha tomado
2. Autor menciona @Melampe001 para revisión
3. Maintainer revisa y decide:
   - Reabrir si cumple criterios
   - Mantener cerrado si no cumple criterios
4. Si se reabre, se remueven labels `stale`, `wontfix`, etc.

---

## 🛠️ Herramientas de Automatización

### Scripts Disponibles

#### `close_stale_prs.sh`
**Ubicación**: Raíz del repositorio  
**Propósito**: Cerrar PRs obsoletos y duplicados en masa  
**Uso**: `bash close_stale_prs.sh`  
**Requiere**: gh CLI configurado

#### Futuros Scripts (Planificados)
- `mark_stale_prs.sh` - Marcar PRs como stale automáticamente
- `generate_cleanup_report.sh` - Generar reporte de limpieza
- `check_duplicates.sh` - Detectar PRs/issues duplicados

---

## 📚 Referencias

- [Documentación de Limpieza](CLEANUP_SCRIPT.md)
- [Estado Post-Limpieza](POST_CLEANUP_TRACKING.md)
- [GitHub Best Practices](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/about-community-profiles-for-public-repositories)
- [Managing Stale Issues](https://docs.github.com/en/communities/moderating-comments-and-conversations/managing-disruptive-comments)

---

## 📞 Contacto

Para preguntas sobre estas políticas:
- Crear issue con label `question`
- Mencionar @Melampe001
- Email: [Ver perfil de GitHub]

Para sugerir cambios a estas políticas:
- Crear issue con label `policy-change`
- Explicar el cambio propuesto y la justificación
- Esperar revisión del equipo

---

**Aprobado por**: @Melampe001  
**Fecha de Aprobación**: 2024-12-14  
**Próxima Revisión**: 2025-03-14  
**Versión**: 1.0
