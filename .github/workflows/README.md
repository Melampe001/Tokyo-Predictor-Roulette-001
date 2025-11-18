# CI/CD Workflows

Este directorio contiene los workflows de GitHub Actions para CI/CD del proyecto Tokyo Roulette Predicciones.

## Workflows Disponibles

### 1. CI (Integración Continua Principal)
**Archivo:** `ci.yml`  
**Trigger:** Push y Pull Requests a `main`, `develop`, y branches `copilot/**`

Pipeline completo que ejecuta:
1. **Análisis rápido** - Flutter analyze y format check
2. **Tests** - Suite completa de tests con cobertura
3. **Build Android** - Compilación de APK debug
4. **Status check** - Confirmación de que todo pasó

### 2. Build
**Archivo:** `build.yml`  
**Trigger:** Push y Pull Requests a `main`, `develop`, y branches `copilot/**`

Builds en múltiples plataformas:
- **Android APK** (ubuntu-latest, Java 17)
- **iOS** (macos-latest, sin codesign para CI)
- **Web** (ubuntu-latest)

Artefactos generados se guardan por 7 días.

### 3. Test
**Archivo:** `test.yml`  
**Trigger:** Push y Pull Requests a `main`, `develop`, y branches `copilot/**`

Suite de tests completa:
- **Unit tests** - Tests unitarios con cobertura
- **Widget tests** - Tests de widgets de Flutter
- **Performance tests** - Benchmarks de rendimiento (roulette_logic_test.dart)

Genera reportes de cobertura y los sube a Codecov.

### 4. Lint
**Archivo:** `lint.yml`  
**Trigger:** Push y Pull Requests a `main`, `develop`, y branches `copilot/**`

Validaciones de calidad de código:
- **Dart Analyze** - Análisis estático del código
- **Dart Format** - Verificación de formato
- **Pub Check** - Revisión de dependencias

## Badges de Estado

Agrega estos badges a tu README.md:

```markdown
![CI](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/CI/badge.svg)
![Build](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Build/badge.svg)
![Test](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Test/badge.svg)
![Lint](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Lint/badge.svg)
```

## Uso Local

### Ejecutar análisis
```bash
flutter analyze
dart format --set-exit-if-changed .
```

### Ejecutar tests
```bash
# Todos los tests
flutter test --coverage

# Solo tests de performance
flutter test test/roulette_logic_test.dart

# Widget tests
flutter test test/widget_test.dart
```

### Build local
```bash
# Android
flutter build apk --debug

# iOS (requiere macOS)
flutter build ios --release --no-codesign

# Web
flutter build web --release
```

## Configuración de Secretos

Para deployment completo, configura estos secretos en GitHub:
- `CODECOV_TOKEN` - Token de Codecov para reportes de cobertura
- Otros secretos según necesites para Firebase, Stripe, etc.

## Requisitos del Workflow

- **Flutter SDK:** 3.16.0 (stable)
- **Java:** 17 (Zulu distribution) para builds Android
- **Runners:**
  - ubuntu-latest (Android, Web, Tests)
  - macos-latest (iOS)

## Artefactos

Los workflows generan artefactos que se pueden descargar:
- `android-debug-apk` - APK de Android (debug)
- `android-apk` - APK de Android (CI pipeline)
- `ios-build` - Build de iOS
- `web-build` - Build de Web
- `coverage-report` - Reporte de cobertura de tests

Retención: 5-7 días según el workflow.

## Mejoras Futuras

Posibles extensiones del CI/CD:
- [ ] Integration tests en emuladores
- [ ] Deployment automático a Firebase App Distribution
- [ ] Release builds firmados para producción
- [ ] Tests de seguridad (Dependabot ya configurado)
- [ ] Performance regression tests
- [ ] UI/Screenshot tests
