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

### Workflows y CI/CD automáticos

Los siguientes checks automáticos se ejecutarán al crear el PR:

- **Build APK** (`build-apk.yml`): Compila la APK de Android en modo release
- **Lint y Format** (`lint-and-format.yml`): Verifica formato y ejecuta análisis estático
- **Tests** (`test.yml`): Ejecuta pruebas unitarias y de widgets

Asegúrate de que todos los workflows pasen antes de solicitar revisión.

---

### Checklist detallado de agentes (opcional)

Para PRs complejos que requieren revisión exhaustiva, consulta:
- [Checklist principal](../.github/checklist.md) - Puntos de verificación por tipo de agente
- [Checklist de agentes](../docs/checklist_agents.md) - Detalles de configuración y activación

Puntos clave a considerar según el tipo de cambio:

- [ ] **Build y compilación** — CI runner automático (ubuntu-latest)
- [ ] **Tests** — CI runner con cobertura de código
- [ ] **Lint y formato** — Automático vía workflow
- [ ] **Seguridad y dependencias** — Revisar nuevas dependencias manualmente
- [ ] **Accesibilidad** — Validación manual si se modifica UI
- [ ] **Performance** — Revisar si el cambio afecta rendimiento
- [ ] **Breaking changes** — Documentar si se rompe compatibilidad
- [ ] **Documentación** — Actualizar README o docs/ si aplica