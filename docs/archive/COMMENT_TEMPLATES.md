# 💬 Plantillas de Comentarios para Cierre Automático

Este documento contiene plantillas de comentarios reutilizables para el cierre automático de PRs e issues durante el mantenimiento del repositorio.

---

## 📋 Plantillas para PRs

### 1. PR Duplicado

```markdown
🤖 **Cierre Automático - PR Duplicado**

Este PR está siendo cerrado porque es un duplicado de #{{PR_NUMBER}}.

**Razón del cierre**:
- ✅ Existe otro PR con el mismo objetivo o cambios similares
- ✅ Para evitar confusión, mantenemos solo un PR por funcionalidad
- ✅ El PR #{{PR_NUMBER}} tiene más contexto/actividad/prioridad

**Si consideras que no es un duplicado**:
1. Revisa el PR #{{PR_NUMBER}} para confirmar
2. Si hay diferencias significativas, comenta explicándolas
3. Menciona @Melampe001 para que reconsidere

**Si quieres continuar este trabajo**:
- Contribuye al PR #{{PR_NUMBER}} en su lugar
- O explica por qué este PR debería permanecer abierto

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 2. PR Stale (Sin Actividad >30 días)

```markdown
🤖 **Cierre Automático - PR Stale**

Este PR está siendo cerrado debido a inactividad prolongada.

**Razón del cierre**:
- ⏰ Sin commits en >60 días
- ⏰ Sin comentarios en >30 días
- ⏰ Considerado obsoleto por falta de actividad

**Estado antes del cierre**:
- Último commit: {{LAST_COMMIT_DATE}}
- Último comentario: {{LAST_COMMENT_DATE}}
- Estado: {{DRAFT/OPEN}}

**Si quieres continuar este trabajo**:
1. Actualiza el PR con nuevos commits
2. Responde a los comentarios pendientes
3. Sincroniza con la rama main actual
4. Menciona @Melampe001 para reapertura

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 3. Draft Obsoleto

```markdown
🤖 **Cierre Automático - Draft Obsoleto**

Este draft PR está siendo cerrado por inactividad prolongada.

**Razón del cierre**:
- 📝 PR en estado draft por >90 días
- ⏰ Sin actividad reciente
- 🔄 Posiblemente supersedido por otros cambios

**Si quieres completar este trabajo**:
1. Revisa si los cambios siguen siendo relevantes
2. Actualiza el código con la base actual
3. Marca el PR como "Ready for review"
4. Menciona @Melampe001 para reapertura

**Alternativa**:
- Crea un nuevo PR más actualizado
- Referencias este PR cerrado en la descripción

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 4. PR Irrelevante

```markdown
🤖 **Cierre Automático - PR Irrelevante**

Este PR está siendo cerrado porque no es relevante para este proyecto.

**Razón del cierre**:
- ❌ Los cambios no aplican a este proyecto ({{REASON}})
- ❌ El proyecto usa {{TECH_STACK}}, no {{PR_TECH}}
- ❌ Funcionalidad no alineada con los objetivos del proyecto

**Si crees que este PR es relevante**:
1. Explica cómo estos cambios benefician al proyecto
2. Proporciona contexto adicional
3. Menciona @Melampe001 para reconsideración

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 5. PR Sin Respuesta a Comentarios

```markdown
🤖 **Cierre Automático - Sin Respuesta a Comentarios**

Este PR está siendo cerrado por falta de respuesta a comentarios de revisión.

**Razón del cierre**:
- 💬 {{COUNT}} comentarios sin respuesta
- ⏰ Última respuesta hace >30 días
- 🔍 Cambios solicitados no implementados

**Comentarios pendientes**:
{{LIST_OF_PENDING_COMMENTS}}

**Para reabrir este PR**:
1. Responde a TODOS los comentarios de revisión
2. Implementa los cambios solicitados
3. Solicita nueva revisión
4. Menciona @Melampe001 para reapertura

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 6. PR Supersedido

```markdown
🤖 **Cierre Automático - PR Supersedido**

Este PR está siendo cerrado porque fue supersedido por otro PR más reciente.

**Razón del cierre**:
- ✅ PR #{{NEW_PR_NUMBER}} implementa esta funcionalidad
- ✅ El nuevo PR tiene un enfoque más actualizado
- ✅ Cambios ya implementados o en proceso

**PR que lo reemplaza**: #{{NEW_PR_NUMBER}}

**Si hay diferencias importantes**:
1. Revisa el PR #{{NEW_PR_NUMBER}}
2. Comenta allí con sugerencias adicionales
3. O explica qué cambios de este PR faltan

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

## 📋 Plantillas para Issues

### 1. Issue Duplicado

```markdown
🤖 **Cierre Automático - Issue Duplicado**

Este issue está siendo cerrado porque es un duplicado de #{{ISSUE_NUMBER}}.

**Issue original**: #{{ISSUE_NUMBER}}

**Si crees que no es un duplicado**:
1. Revisa el issue #{{ISSUE_NUMBER}}
2. Explica las diferencias
3. Menciona @Melampe001 para reconsideración

**Para continuar la discusión**:
- Comenta en el issue #{{ISSUE_NUMBER}}
- O solicita reapertura con justificación

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 2. Issue Stale

```markdown
🤖 **Cierre Automático - Issue Stale**

Este issue está siendo cerrado debido a inactividad prolongada.

**Razón del cierre**:
- ⏰ Sin comentarios en >90 días
- ⏰ Sin asignación o actividad
- ⏰ Considerado obsoleto

**Si este issue sigue siendo relevante**:
1. Comenta explicando la situación actual
2. Proporciona información actualizada
3. Menciona @Melampe001 para reapertura

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

### 3. Issue Ya Implementado

```markdown
🤖 **Cierre Automático - Ya Implementado**

Este issue está siendo cerrado porque la funcionalidad ya fue implementada.

**Implementado en**: {{PR_OR_COMMIT}}

**Razón del cierre**:
- ✅ La funcionalidad solicitada ya existe
- ✅ Implementado en {{VERSION}}
- ✅ Disponible en la rama main

**Si falta algo**:
1. Verifica la implementación actual
2. Si falta algo, abre un nuevo issue específico
3. Referencia este issue cerrado

---
*Cerrado automáticamente por Bot de Limpieza - {{DATE}}*
```

---

## ⚠️ Advertencias Previas al Cierre

### Advertencia Stale (30 días antes del cierre)

```markdown
⚠️ **Advertencia: PR Marcado como Stale**

Este PR no ha tenido actividad en los últimos 30 días y será cerrado en 30 días si no hay respuesta.

**Acción requerida**:
- Actualiza el PR con nuevos commits, O
- Responde a los comentarios pendientes, O
- Indica si planeas continuar trabajando en esto

**Para mantener este PR abierto**:
- Simplemente comenta indicando que estás trabajando en ello
- El label `stale` será removido automáticamente

**Si no hay respuesta en 30 días**, este PR será cerrado automáticamente. Puedes solicitar reapertura en cualquier momento siguiendo el proceso documentado.

---
*Mensaje automático del Bot de Mantenimiento - {{DATE}}*
```

---

### Advertencia Stale para Issues (60 días antes del cierre)

```markdown
⚠️ **Advertencia: Issue Marcado como Stale**

Este issue no ha tenido actividad en los últimos 60 días y será cerrado en 30 días si no hay respuesta.

**Acción requerida**:
- Confirma si el issue sigue siendo relevante
- Proporciona información actualizada
- Indica si alguien está trabajando en esto

**Para mantener este issue abierto**:
- Simplemente comenta con una actualización
- El label `stale` será removido automáticamente

**Si no hay respuesta en 30 días**, este issue será cerrado automáticamente. Puedes solicitar reapertura en cualquier momento.

---
*Mensaje automático del Bot de Mantenimiento - {{DATE}}*
```

---

## 🔧 Variables de Plantilla

Al usar estas plantillas, reemplaza las siguientes variables:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `{{PR_NUMBER}}` | Número del PR relacionado | `42` |
| `{{ISSUE_NUMBER}}` | Número del issue relacionado | `13` |
| `{{DATE}}` | Fecha actual | `2024-12-14` |
| `{{LAST_COMMIT_DATE}}` | Fecha del último commit | `2024-10-15` |
| `{{LAST_COMMENT_DATE}}` | Fecha del último comentario | `2024-11-01` |
| `{{DRAFT/OPEN}}` | Estado del PR | `Draft` o `Open` |
| `{{REASON}}` | Razón específica | `Azure workflow en proyecto Flutter` |
| `{{TECH_STACK}}` | Stack técnico del proyecto | `Flutter/Dart` |
| `{{PR_TECH}}` | Tecnología del PR | `Node.js` |
| `{{COUNT}}` | Cantidad de comentarios | `5` |
| `{{LIST_OF_PENDING_COMMENTS}}` | Lista de comentarios | `- Comentario 1\n- Comentario 2` |
| `{{NEW_PR_NUMBER}}` | Número del PR que reemplaza | `57` |
| `{{PR_OR_COMMIT}}` | PR o commit que implementó | `PR #42` o `commit abc123` |
| `{{VERSION}}` | Versión donde se implementó | `v1.2.0` |

---

## 📝 Notas de Uso

### Personalización
- Estas plantillas son base, personalízalas según el contexto
- Mantén un tono amable y profesional
- Siempre ofrece un camino para reapertura

### Mejores Prácticas
1. ✅ Lee el PR/issue antes de usar una plantilla
2. ✅ Personaliza el mensaje con detalles específicos
3. ✅ Verifica que la razón de cierre sea precisa
4. ✅ Proporciona referencias útiles (números de PR/issue)
5. ✅ Ofrece alternativas constructivas

### Lo que NO hacer
1. ❌ No uses plantillas sin personalizarlas
2. ❌ No cierres sin comentar primero
3. ❌ No uses tono negativo o acusatorio
4. ❌ No cierres PRs con label `priority` o `critical`
5. ❌ No cierres sin verificar la información

---

**Última Actualización**: 2024-12-14  
**Versión**: 1.0  
**Mantenido por**: Bot de Limpieza / @Melampe001
