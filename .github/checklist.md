# Checklist principal del repositorio

Este archivo centraliza el checklist de calidad y referencia el detalle de agentes en docs/checklist_agents.md. Incluye los puntos mínimos que deben revisarse en los PRs y los tipos de agentes requeridos.

**Referencia completa y notas por agente:** [docs/checklist_agents.md](../docs/checklist_agents.md)

## Workflows automáticos configurados

Este repositorio tiene los siguientes workflows de CI/CD configurados en `.github/workflows/`:

- ✅ **build-apk.yml** - Compila la APK de Android automáticamente en cada PR
- ✅ **lint-and-format.yml** - Ejecuta `flutter analyze` y verifica formato con `dart format`
- ✅ **test.yml** - Ejecuta pruebas unitarias y de widgets con `flutter test`
- ⚠️  **azure-webapps-node.yml** - Workflow de Node.js (no aplica para este proyecto Flutter)

## Resumen rápido de puntos de verificación

Marcar los puntos aplicables en cada PR según el tipo de cambio:

### 1) Build y compilación
- **Workflow automático:** `build-apk.yml`
- **Agente requerido:** GitHub Actions (ubuntu-latest)
- **Estado:** ✅ Configurado y activo

### 2) Tests unitarios y de integración
- **Workflow automático:** `test.yml`
- **Agente requerido:** GitHub Actions + flutter test
- **Estado:** ✅ Configurado (unitarios), ⚠️ tests de integración pendientes

### 3) Lint y formato
- **Workflow automático:** `lint-and-format.yml`
- **Agente requerido:** GitHub Actions (flutter analyze, dart format)
- **Estado:** ✅ Configurado y activo

### 4) Seguridad y dependencias
- **Agente requerido:** Dependabot + revisor humano
- **Estado:** ⚠️ Pendiente configurar Dependabot
- **Acción:** Habilitar Dependabot en configuración del repositorio

### 5) Accesibilidad y localización
- **Agente requerido:** Revisor humano
- **Estado:** ⚠️ Manual (no automatizado)
- **Acción:** Revisar manualmente en PRs que modifiquen UI

### 6) Performance y tamaño
- **Agente requerido:** Revisor humano + medición manual
- **Estado:** ⚠️ Manual (no automatizado)
- **Acción:** Comparar tamaño de APK antes/después en PRs relevantes

### 7) Pruebas en dispositivos reales
- **Agente requerido:** Device farm o testing manual
- **Estado:** ⚠️ Manual (no automatizado)
- **Acción:** Configurar Firebase Test Lab o probar manualmente

### 8) Breaking changes y compatibilidad de API
- **Agente requerido:** Revisor humano (owner)
- **Estado:** ⚠️ Manual
- **Acción:** Documentar breaking changes en descripción del PR

### 9) Licencias y cumplimiento legal
- **Agente requerido:** Revisor humano
- **Estado:** ⚠️ Manual
- **Acción:** Revisar licencias de nuevas dependencias en pubspec.yaml

### 10) Documentación y PR template
- **Workflow automático:** Ninguno
- **Agente requerido:** Autor y revisor humano
- **Estado:** ✅ Template configurado
- **Plantilla:** [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md)

## Plantilla rápida para uso en PRs

Copiar esta plantilla en la descripción del PR y marcar los puntos aplicables:

```markdown
### Checklist de verificación

- [ ] Build automático (CI) — ✅ Verificado por build-apk.yml
- [ ] Lint y formato — ✅ Verificado por lint-and-format.yml
- [ ] Tests unitarios — ✅ Verificado por test.yml
- [ ] Seguridad: revisé nuevas dependencias y sus licencias
- [ ] Documentación: actualicé README o docs/ si el cambio lo requiere
- [ ] Breaking changes: documentados en esta descripción (si aplica)
- [ ] UI: incluí capturas de pantalla (si modifiqué interfaz)
- [ ] Performance: el cambio no afecta negativamente el rendimiento
```

## Recomendaciones para contribuidores

1. **Antes de abrir un PR:**
   - Ejecuta `dart format .` para formatear el código
   - Ejecuta `flutter analyze` para verificar errores
   - Ejecuta `flutter test` para verificar que las pruebas pasen
   - Compila localmente con `flutter build apk --release` si es posible

2. **Al crear el PR:**
   - Usa el template automático que aparecerá
   - Completa todos los campos requeridos
   - Marca los checkboxes aplicables

3. **Durante la revisión:**
   - Verifica que todos los workflows de CI pasen (verde)
   - Responde a comentarios de revisores
   - Actualiza la documentación si es necesario
