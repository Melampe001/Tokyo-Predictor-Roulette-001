## 📄 Descripción del cambio
Explica brevemente qué modifica este PR.

## 📝 Tipo de cambio
- [ ] Bug fix
- [ ] Nueva característica
- [ ] Mejora de documentación

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

### Estándares internos y buenas prácticas

- [ ] He corrido `make fmt` antes de hacer commit para asegurar el formato correcto del código.
- [ ] El cambio respeta la estructura de carpetas y módulos definida en el repositorio.
- [ ] El código sigue las buenas prácticas de Go y patrones idiomáticos.
- [ ] Se usó inyección de dependencias donde corresponde.
- [ ] Incluí pruebas unitarias para nuevas funcionalidades (se recomienda table-driven tests).
- [ ] El código está documentado, y la documentación relevante se sugiere para actualizar en el directorio `docs/`.
- [ ] Si se actualizó proto/, ejecuté `make proto`.
- [ ] Si se modificó ruby/, actualicé la versión en `ruby/lib/billing-platform/version.rb`.