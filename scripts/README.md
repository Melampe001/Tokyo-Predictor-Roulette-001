# Scripts de Ejecución de Workflows

Este directorio contiene scripts para ejecutar los workflows de CI/CD localmente, uno por uno.

## Scripts Disponibles

### 1. Ejecución Individual de Workflows

#### `run_lint.sh` - Workflow de Lint
Ejecuta verificaciones de calidad de código:
- Formato de código (dart format)
- Análisis estático (flutter analyze)
- Verificación de dependencias (pub outdated)

```bash
bash scripts/run_lint.sh
```

#### `run_test.sh` - Workflow de Test
Ejecuta la suite completa de tests:
- Tests unitarios con cobertura
- Widget tests
- Performance tests

```bash
bash scripts/run_test.sh
```

#### `run_build.sh` - Workflow de Build
Compila el proyecto:
- Limpia builds anteriores
- Instala dependencias
- Compila APK de Android (debug)

```bash
bash scripts/run_build.sh
```

#### `run_ci.sh` - Workflow CI Completo
Ejecuta el pipeline completo de CI:
- Quick Analysis (formato + análisis)
- Run Tests (suite completa)
- Build Android (APK)

```bash
bash scripts/run_ci.sh
```

### 2. Ejecución Secuencial de Todos los Workflows

#### `run_workflows_sequential.sh` - Ejecutar Todo Secuencialmente
Ejecuta todos los workflows en orden, uno por uno:
1. Lint (análisis y formato)
2. Test (tests unitarios y performance)
3. Build (compilación)
4. CI (verificación final)

```bash
bash scripts/run_workflows_sequential.sh
```

Este script simula la ejecución completa de GitHub Actions localmente, mostrando el progreso de cada paso.

### 3. Verificación de Test Workflows

#### `verify_test_workflows.sh` - Verificar Configuración
Valida que los workflows de test estén correctamente configurados:
- Verifica sintaxis YAML
- Valida jobs configurados
- Confirma triggers y versiones

```bash
bash scripts/verify_test_workflows.sh
```

## Orden de Ejecución Recomendado

Para desarrollo local, ejecuta en este orden:

```bash
# 1. Primero: Lint (rápido, detecta problemas de formato)
bash scripts/run_lint.sh

# 2. Segundo: Test (valida funcionalidad)
bash scripts/run_test.sh

# 3. Tercero: Build (verifica compilación)
bash scripts/run_build.sh

# 4. Finalmente: CI completo (validación final)
bash scripts/run_ci.sh
```

O ejecuta todo de una vez:

```bash
bash scripts/run_workflows_sequential.sh
```

## Salida Esperada

Cada script muestra:
- ✓ Pasos completados exitosamente (verde)
- ✗ Pasos fallidos (rojo)
- ⚠ Advertencias (amarillo)
- Información de artefactos generados

## Artefactos Generados

Después de ejecutar los workflows, encontrarás:

- **coverage/lcov.info** - Reporte de cobertura de tests
- **build/app/outputs/flutter-apk/app-debug.apk** - APK de Android

## Requisitos

- Flutter SDK 3.16.0 o superior
- Dart SDK incluido con Flutter
- Android SDK (para builds de Android)

## Troubleshooting

### "flutter: command not found"
Instala Flutter SDK y agrégalo al PATH.

### "Build failed"
Asegúrate de tener Android SDK configurado:
```bash
flutter doctor -v
```

### "Tests failed"
Ejecuta individualmente para ver detalles:
```bash
flutter test --reporter expanded
```

## Integración con GitHub Actions

Estos scripts simulan localmente lo que ocurre en GitHub Actions.
Los workflows reales se encuentran en `.github/workflows/`:

- `ci.yml` - Pipeline principal
- `build.yml` - Builds multiplataforma  
- `test.yml` - Suite de tests
- `lint.yml` - Análisis de código

Para activar los workflows en GitHub:
```bash
git push origin <branch>
```

Los workflows se ejecutan automáticamente en push/PR a: `main`, `develop`, `copilot/**`

## Documentación Adicional

- [.github/workflows/README.md](../.github/workflows/README.md) - Documentación de workflows
- [docs/CI_CD_IMPLEMENTATION.md](../docs/CI_CD_IMPLEMENTATION.md) - Guía de implementación CI/CD
- [docs/TEST_WORKFLOW_VERIFICATION.md](../docs/TEST_WORKFLOW_VERIFICATION.md) - Guía de verificación de tests
