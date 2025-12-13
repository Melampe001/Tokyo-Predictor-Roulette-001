# Instrucciones Fijas del Repositorio

Este documento centraliza todas las instrucciones y checklists del repositorio Tokyo-Predictor-Roulette-001.

## 📋 Checklists Principales

### Para Contribuidores
- **[Guía de Contribución](CONTRIBUTING.md)**: Proceso completo para contribuir al proyecto
- **[Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md)**: Plantilla obligatoria para PRs
- **[Checklist Principal](.github/checklist.md)**: Checklist de calidad para PRs

### Para Revisores
- **[Checklist de Agentes](docs/checklist_agents.md)**: Detalles sobre tipos de agentes requeridos por cada punto del checklist
- **[Guía de Seguridad](SECURITY.md)**: Políticas de seguridad y reporte de vulnerabilidades

## 🔧 Flujo de Trabajo

### 1. Antes de Crear un PR

1. **Lee la documentación relevante**:
   - [CONTRIBUTING.md](CONTRIBUTING.md)
   - [README.md](README.md)
   - [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

2. **Ejecuta los comandos básicos**:
   ```bash
   flutter pub get          # Instalar dependencias
   dart format .            # Formatear código
   flutter analyze          # Análisis estático
   flutter test             # Ejecutar tests
   ```

3. **Verifica tu código**:
   - No hay errores de compilación
   - Todos los tests pasan
   - El formato es correcto
   - No hay warnings nuevos

### 2. Al Crear el PR

1. **Usa el template**: El template de PR se aplicará automáticamente
2. **Completa todas las secciones**:
   - Descripción clara del cambio
   - Tipo de cambio
   - Pasos para probar
   - Checklist completo

3. **Marca los agentes usados**: Indica qué jobs/agentes ejecutaste o se requieren

### 3. Durante la Revisión

1. **Responde a comentarios** de manera oportuna
2. **Actualiza el PR** según feedback
3. **Re-ejecuta tests** después de cambios
4. **Resuelve conflictos** de merge si aparecen

### 4. Antes del Merge

1. **Todos los checks en verde**: CI/CD debe pasar
2. **Aprobación requerida**: Al menos un revisor debe aprobar
3. **Checklist completado**: Todos los items marcados
4. **Documentación actualizada**: Si el cambio lo requiere

## 📝 Tipos de Cambios y Agentes Requeridos

Ver [docs/checklist_agents.md](docs/checklist_agents.md) para detalles completos.

### Resumen Rápido:

| Tipo de Cambio | Agentes/Jobs Requeridos |
|----------------|-------------------------|
| **Build** | GitHub Actions runner (ubuntu-latest/macos-latest) |
| **Tests** | CI runner + emulador si es necesario |
| **Lint/Formato** | dart analyze, dart format |
| **Seguridad** | Dependabot + revisión manual |
| **UI/UX** | Capturas de pantalla + revisor humano |
| **Performance** | Benchmarks + revisor humano |
| **Breaking Changes** | Aprobación del owner |
| **Dependencias** | Scanner de licencias + revisor |
| **Documentación** | Revisor documental |

## 🚀 Comandos Esenciales

```bash
# Desarrollo
flutter pub get                    # Instalar/actualizar dependencias
flutter run                        # Ejecutar en desarrollo
flutter run -d chrome              # Ejecutar en navegador

# Calidad de código
dart format .                      # Formatear todo el código
flutter analyze                    # Análisis estático
flutter analyze --fatal-infos      # Análisis estricto

# Testing
flutter test                       # Ejecutar todos los tests
flutter test --coverage            # Con cobertura
flutter test test/specific_test.dart  # Test específico

# Build
flutter build apk --release        # APK de producción Android
flutter build ios --release        # Build de producción iOS
flutter build web                  # Build web

# Limpieza
flutter clean                      # Limpiar builds
flutter pub cache repair           # Reparar cache de paquetes
```

## 📚 Documentación Adicional

- **[Resumen del Proyecto](PROJECT_SUMMARY.md)**: Visión general del proyecto
- **[Guía de Usuario](docs/USER_GUIDE.md)**: Manual de uso de la aplicación
- **[Arquitectura Técnica](docs/ARCHITECTURE.md)**: Diseño del sistema
- **[Configuración Firebase](docs/FIREBASE_SETUP.md)**: Setup de Firebase (opcional)
- **[Changelog](CHANGELOG.md)**: Historial de versiones

## ⚠️ Puntos Importantes

### Seguridad
- **NUNCA** commits claves API o secrets
- **SIEMPRE** revisa el código antes de hacer commit
- **USA** variables de entorno para datos sensibles
- Lee [SECURITY.md](SECURITY.md) para políticas completas

### Calidad
- **Ejecuta** dart format antes de commit
- **Verifica** que flutter analyze no tenga errores
- **Asegura** que todos los tests pasen
- **Documenta** código complejo con comentarios

### Colaboración
- **Sé respetuoso** en comentarios y revisiones
- **Explica claramente** tus cambios en el PR
- **Responde** a feedback de manera constructiva
- **Ayuda** a otros contribuidores cuando sea posible

## 🆘 ¿Necesitas Ayuda?

1. **Revisa la documentación** en la carpeta `docs/`
2. **Lee los issues cerrados** por si tu pregunta ya fue respondida
3. **Abre un issue** nuevo con la etiqueta `question`
4. **Contacta** a los mantenedores del proyecto

---

**Última actualización**: Diciembre 2024  
**Versión del documento**: 1.0.0

> 💡 **Tip**: Marca este documento con una estrella en GitHub para encontrarlo fácilmente.
