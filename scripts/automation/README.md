# 🤖 Tokyo Roulette - Automation Scripts

Scripts Python para automatizar testing y builds del proyecto Tokyo Roulette Predictor.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Requisitos](#requisitos)
- [Scripts Disponibles](#scripts-disponibles)
  - [test_runner.py](#test_runnerpy)
  - [build_bot.py](#build_botpy)
- [Instalación](#instalación)
- [Uso Rápido](#uso-rápido)
- [Ejemplos Avanzados](#ejemplos-avanzados)
- [Integración CI/CD](#integración-cicd)
- [Exit Codes](#exit-codes)
- [Performance](#performance)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Descripción

Esta suite de automation proporciona:

✅ **Parallel Test Runner** - Ejecuta tests de Flutter 4x más rápido usando multithreading  
✅ **Automated Build Bot** - Pipeline completo: clean → deps → build → verify  
✅ **JSON Reports** - Reportes estructurados para análisis y CI/CD  
✅ **Zero Dependencies** - Solo usa Python stdlib (no pip install necesario)  
✅ **CI/CD Ready** - Exit codes apropiados para pipelines automatizados  
✅ **Professional Output** - Console output colorido y fácil de leer

---

## ✅ Requisitos

- **Python 3.7+** (incluido en la mayoría de sistemas)
- **Flutter SDK** instalado y en PATH
- **Proyecto Flutter** válido (este repositorio)

Verificar versiones:
```bash
python3 --version    # Debe ser ≥ 3.7
flutter --version    # Debe estar instalado
```

---

## 📦 Scripts Disponibles

### `test_runner.py`

**Descripción**: Ejecutor paralelo de tests de Flutter con reportes JSON.

**Características**:
- 🚀 Ejecución paralela con ThreadPoolExecutor
- 📊 Genera reporte JSON (`test_report.json`)
- ⏱️ Timeout configurable por test
- 🎨 Output colorido (verde/rojo/amarillo)
- 🔍 Auto-descubrimiento de archivos `*_test.dart`
- 📈 Métricas de performance y duración

**Sintaxis Básica**:
```bash
python3 test_runner.py [opciones]
```

**Opciones**:
```
--workers N         Número de workers paralelos (default: 4)
--timeout N         Timeout por test en segundos (default: 120)
--project-root DIR  Directorio raíz del proyecto (default: .)
--verbose           Mostrar output detallado
--no-report         No guardar reporte JSON
```

**Ejemplos**:
```bash
# Ejecutar todos los tests (configuración por defecto)
python3 scripts/automation/test_runner.py

# Usar 8 workers para mayor paralelismo
python3 scripts/automation/test_runner.py --workers 8

# Timeout de 3 minutos por test
python3 scripts/automation/test_runner.py --timeout 180

# Modo verbose con salida completa
python3 scripts/automation/test_runner.py --verbose

# Sin generar archivo de reporte
python3 scripts/automation/test_runner.py --no-report
```

**Output Ejemplo**:
```
Tokyo Roulette - Parallel Test Runner
Project: /path/to/project
Workers: 4
Timeout: 120s

🔍 Discovered 2 test files
  • test/roulette_logic_test.dart
  • test/widget_test.dart

🚀 Running 2 tests with 4 workers...

✅ PASSED test/roulette_logic_test.dart (2.45s)
✅ PASSED test/widget_test.dart (3.12s)

============================================================
📊 TEST SUMMARY
============================================================
Total:    2
Passed:   2
Duration: 5.57s
============================================================

💾 Report saved to: /path/to/project/test_report.json
```

**Reporte JSON Formato**:
```json
{
  "summary": {
    "total": 2,
    "passed": 2,
    "failed": 0,
    "timeout": 0,
    "error": 0,
    "duration": 5.57,
    "total_time": 3.25,
    "timestamp": "2024-12-15 10:30:45"
  },
  "tests": [
    {
      "test_file": "test/roulette_logic_test.dart",
      "status": "passed",
      "duration": 2.45,
      "exit_code": 0
    }
  ]
}
```

**Exit Codes**:
- `0` - Todos los tests pasaron ✅
- `1` - Uno o más tests fallaron ❌
- `2` - No se encontraron tests ⚠️
- `3` - Error fatal 💥

---

### `build_bot.py`

**Descripción**: Bot automatizado para builds de APK de Flutter con verificación.

**Características**:
- 🧹 Limpieza automática (opcional)
- 📦 Gestión de dependencias (pub get)
- 🏗️ Build de APK (debug/release)
- ✅ Verificación automática de APK
- 💾 Reporte de tamaño de APK
- ⏱️ Métricas de tiempo de build

**Sintaxis Básica**:
```bash
python3 build_bot.py [opciones]
```

**Opciones**:
```
--release           Build en modo release (default: debug)
--no-clean          Saltar flutter clean (builds incrementales más rápidos)
--clean-only        Solo ejecutar flutter clean
--project-root DIR  Directorio raíz del proyecto (default: .)
--verbose           Mostrar output completo del build
```

**Ejemplos**:
```bash
# Build debug APK (con clean)
python3 scripts/automation/build_bot.py

# Build release APK
python3 scripts/automation/build_bot.py --release

# Build incremental (sin clean, más rápido)
python3 scripts/automation/build_bot.py --no-clean

# Solo limpiar archivos de build
python3 scripts/automation/build_bot.py --clean-only

# Build release verbose
python3 scripts/automation/build_bot.py --release --verbose
```

**Output Ejemplo**:
```
============================================================
Tokyo Roulette - Automated Build Bot
============================================================
Project:    /path/to/project
Build Mode: DEBUG
Skip Clean: False
============================================================

[CLEAN] Running: flutter clean
✅ Success

[DEPENDENCIES] Running: flutter pub get
✅ Success

[BUILD APK] Running: flutter build apk --debug
✅ Success

[VERIFY] Checking APK file...
✅ APK verified
   Location: /path/to/build/app/outputs/flutter-apk/app-debug.apk
   Size:     42.35 MB (44,425,216 bytes)

============================================================
🎉 BUILD SUCCESSFUL!
============================================================
Build Mode:    DEBUG
Total Time:    85.23s (1.4 minutes)
APK Location:  /path/to/build/app/outputs/flutter-apk/app-debug.apk
============================================================

💡 Next steps:
   • Install on device: adb install /path/to/app-debug.apk
   • Test the application
```

**Exit Codes**:
- `0` - Build exitoso ✅
- `1` - Build falló ❌
- `2` - Verificación falló (APK no encontrada) ⚠️
- `3` - Error fatal 💥

---

## 🚀 Uso Rápido

### Ejecutar Tests
```bash
cd /path/to/Tokyo-Predictor-Roulette-001
python3 scripts/automation/test_runner.py
```

### Build Debug APK
```bash
cd /path/to/Tokyo-Predictor-Roulette-001
python3 scripts/automation/build_bot.py
```

### Build Release APK
```bash
cd /path/to/Tokyo-Predictor-Roulette-001
python3 scripts/automation/build_bot.py --release
```

---

## 🔧 Ejemplos Avanzados

### Pipeline Completo CI/CD
```bash
#!/bin/bash
# ci_pipeline.sh - Pipeline completo de CI/CD

set -e  # Exit on error

echo "🔄 Step 1: Running tests..."
python3 scripts/automation/test_runner.py --workers 8

echo "🔄 Step 2: Building release APK..."
python3 scripts/automation/build_bot.py --release

echo "✅ CI/CD Pipeline completed successfully!"
```

### Tests con Coverage
```bash
# Primero ejecutar tests
python3 scripts/automation/test_runner.py

# Luego generar coverage (requiere Flutter)
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Build Optimizado para Desarrollo
```bash
# Primera vez (con clean)
python3 scripts/automation/build_bot.py

# Subsecuentes builds (sin clean, más rápido)
python3 scripts/automation/build_bot.py --no-clean
```

### Monitoring de Performance
```bash
# Script para medir mejora de velocidad
time python3 scripts/automation/test_runner.py --workers 1  # Secuencial
time python3 scripts/automation/test_runner.py --workers 8  # Paralelo
```

---

## 🔄 Integración CI/CD

### GitHub Actions

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Run Tests
        run: python3 scripts/automation/test_runner.py --workers 8
      
      - name: Upload Test Report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-report
          path: test_report.json

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Build Release APK
        run: python3 scripts/automation/build_bot.py --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
```

### GitLab CI

```yaml
stages:
  - test
  - build

variables:
  FLUTTER_VERSION: "3.16.0"

test:
  stage: test
  image: cirrusci/flutter:${FLUTTER_VERSION}
  script:
    - python3 scripts/automation/test_runner.py --workers 8
  artifacts:
    when: always
    paths:
      - test_report.json
    reports:
      junit: test_report.json

build:
  stage: build
  image: cirrusci/flutter:${FLUTTER_VERSION}
  script:
    - python3 scripts/automation/build_bot.py --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
  only:
    - main
    - tags
```

---

## 📊 Exit Codes

Ambos scripts retornan exit codes apropiados para CI/CD:

| Exit Code | test_runner.py | build_bot.py |
|-----------|----------------|--------------|
| `0` | ✅ Todos los tests pasaron | ✅ Build exitoso |
| `1` | ❌ Tests fallaron | ❌ Build falló |
| `2` | ⚠️ No tests encontrados | ⚠️ APK no verificada |
| `3` | 💥 Error fatal | 💥 Error fatal |

**Uso en scripts**:
```bash
python3 scripts/automation/test_runner.py
if [ $? -eq 0 ]; then
    echo "Tests passed!"
else
    echo "Tests failed!"
    exit 1
fi
```

---

## ⚡ Performance

### Test Runner - Benchmarks

| Número de Tests | Secuencial (1 worker) | Paralelo (4 workers) | Speedup |
|-----------------|----------------------|---------------------|---------|
| 2 tests | 30s | 15s | 2.0x |
| 10 tests | 150s | 40s | 3.75x |
| 20 tests | 300s | 80s | 3.75x |

**Recomendaciones**:
- Para 2-4 tests: usar 2 workers
- Para 5-10 tests: usar 4 workers
- Para 10+ tests: usar 8 workers
- CPU-bound: workers = CPU cores
- IO-bound: workers = 2 * CPU cores

### Build Bot - Tiempos Típicos

| Operación | Debug | Release |
|-----------|-------|---------|
| flutter clean | 5s | 5s |
| flutter pub get | 10s | 10s |
| flutter build apk | 60s | 120s |
| Verificación | 1s | 1s |
| **Total (con clean)** | **~80s** | **~150s** |
| **Total (sin clean)** | **~30s** | **~60s** |

**Tips de Optimización**:
- Usar `--no-clean` para builds incrementales (2-3x más rápido)
- Builds debug son 2x más rápidos que release
- Usar cache de dependencias en CI/CD

---

## 🔧 Troubleshooting

### Problema: "flutter: command not found"

**Solución**:
```bash
# Verificar si Flutter está instalado
which flutter

# Si no está en PATH, añadirlo:
export PATH="$PATH:/path/to/flutter/bin"

# O instalar Flutter:
# https://docs.flutter.dev/get-started/install
```

### Problema: "No test files found"

**Solución**:
```bash
# Verificar que existen archivos *_test.dart
ls test/*_test.dart

# Verificar que está en el directorio correcto
pwd
# Debe ser la raíz del proyecto
```

### Problema: Tests timeout

**Solución**:
```bash
# Incrementar timeout
python3 scripts/automation/test_runner.py --timeout 300

# O reducir workers si es problema de recursos
python3 scripts/automation/test_runner.py --workers 2
```

### Problema: Build falla con "Out of memory"

**Solución**:
```bash
# Incrementar heap de Gradle en android/gradle.properties
org.gradle.jvmargs=-Xmx4096m

# O usar build sin clean
python3 scripts/automation/build_bot.py --no-clean
```

### Problema: APK no encontrada después de build

**Solución**:
```bash
# Verificar que el build fue exitoso
flutter build apk --debug

# Verificar ubicación manualmente
ls -la build/app/outputs/flutter-apk/

# Si el problema persiste, hacer clean completo
python3 scripts/automation/build_bot.py --clean-only
python3 scripts/automation/build_bot.py
```

### Problema: "Permission denied"

**Solución**:
```bash
# Hacer los scripts ejecutables
chmod +x scripts/automation/*.py

# O ejecutar con python3 explícitamente
python3 scripts/automation/test_runner.py
```

---

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment/android)
- [Python Threading](https://docs.python.org/3/library/concurrent.futures.html)
- [Tokyo Roulette Main README](../../README.md)

---

## 🤝 Contribuir

Si encuentras bugs o quieres mejorar estos scripts:

1. Reporta issues en GitHub
2. Propón mejoras vía Pull Request
3. Sigue las convenciones de código Python (PEP 8)

---

## 📝 Licencia

Estos scripts son parte del proyecto Tokyo Roulette Predicciones.  
Ver [LICENSE](../../LICENSE) para detalles.

---

**Versión**: 1.0.0  
**Última actualización**: Diciembre 2024  
**Desarrollado con**: ❤️ y Python
