## 📄 Descripción del cambio
Explica brevemente qué modifica este PR.

## 📝 Tipo de cambio
- [ ] Bug fix
- [ ] Nueva característica
- [ ] Mejora de documentación
- [ ] Refactorización
- [ ] Mejora de rendimiento

## 🔍 ¿Cómo probar?
Describe los pasos para revisar el cambio.

## 📎 Información adicional
Incluye enlaces o observaciones relevantes.

---

## ✅ Checklist

> **Nota**: Ver [Checklist Principal](/.github/checklist.md) y [Checklist de Agentes](/docs/checklist_agents.md) para referencia detallada de cada punto y tipos de agentes requeridos.

- [ ] He seguido las guías de estilo del repositorio.
- [ ] La descripción explica claramente la motivación y el alcance del cambio.
- [ ] He referenciado issues o tickets relacionados (si aplica).
- [ ] Mi código contiene comentarios para facilitar su comprensión.
- [ ] He probado los cambios localmente y todo funciona correctamente.
- [ ] No se generan errores ni advertencias nuevas al compilar o ejecutar.
- [ ] Todas las pruebas existentes pasan y he agregado pruebas para los cambios nuevos o corregidos.
- [ ] La documentación fue actualizada si el cambio lo requiere.
- [ ] Conflictos de merge resueltos antes de la revisión final.
- [ ] He verificado que el cambio no afecta negativamente a otras áreas del proyecto.

---

### Estándares internos y buenas prácticas (Flutter/Dart)

- [ ] He ejecutado `dart format .` antes de hacer commit para asegurar el formato correcto del código.
- [ ] El código sigue las buenas prácticas de Dart y las guías de estilo de Flutter.
- [ ] He ejecutado `flutter analyze` y no hay errores ni advertencias nuevas.
- [ ] El cambio respeta la estructura de carpetas y módulos definida en el repositorio.
- [ ] Se usó inyección de dependencias donde corresponde.
- [ ] Incluí pruebas unitarias/widget para nuevas funcionalidades.
- [ ] El código está documentado con comentarios Dart doc donde sea apropiado.
- [ ] Si agregué nuevas dependencias, actualicé `pubspec.yaml` con versiones compatibles.
- [ ] Si modifiqué la UI, incluí capturas de pantalla o videos del cambio.
- [ ] He verificado que no se exponen claves API o datos sensibles en el código.

---

### Verificación de Agentes (según tipo de cambio)

> **Referencia**: [Checklist de Agentes completo](/docs/checklist_agents.md)

Marca los que apliquen a tu PR e indica qué agentes/jobs se usaron (escribe "N/A" si no aplica):

- [ ] **Build y compilación** — Job: `___` (Ejemplo: GitHub Actions ubuntu-latest)
- [ ] **Tests unitarios/integración** — Job: `___` (Ejemplo: flutter test + emuladores)
- [ ] **Lint y formato** — Job: `___` (Ejemplo: dart analyze, dart format)
- [ ] **Seguridad y dependencias** — Scanner: `___` (Ejemplo: Dependabot, análisis manual)
- [ ] **Accesibilidad y localización** — Reviewer: `___` (o N/A)
- [ ] **Performance y tamaño** — Benchmark: `___` (o N/A)
- [ ] **Pruebas en dispositivos reales** — Device farm: `___` (o N/A)
- [ ] **Breaking changes** — Aprobación owner: `___` (o N/A)
- [ ] **Licencias** — Revisión legal: `___` (o N/A)
- [ ] **Documentación** — Actualizada: Sí/No

**Comandos ejecutados**:
```bash
# Ejemplo:
# flutter pub get
# flutter analyze
# flutter test
# flutter build apk --release
```

**Artefactos adjuntos**: (Capturas, APKs, logs, etc.)