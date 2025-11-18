# Verificación de Workflows de Test

## Estado Actual

✅ Los workflows de test están correctamente configurados en `.github/workflows/test.yml`

## Estructura de Tests

### 1. Unit Tests Job
- **Nombre:** `unit-tests`
- **Runner:** ubuntu-latest
- **Acciones:**
  - ✅ Checkout del código
  - ✅ Setup de Flutter 3.16.0
  - ✅ Instalación de dependencias con `flutter pub get`
  - ✅ Ejecución de tests con cobertura: `flutter test --coverage`
  - ✅ Upload de cobertura a Codecov
  - ✅ Generación de reporte de cobertura
  - ✅ Upload de artefacto con reporte (retención: 7 días)

### 2. Widget Tests Job
- **Nombre:** `widget-tests`
- **Runner:** ubuntu-latest
- **Acciones:**
  - ✅ Checkout del código
  - ✅ Setup de Flutter 3.16.0
  - ✅ Instalación de dependencias
  - ✅ Ejecución de widget tests: `flutter test test/widget_test.dart`

### 3. Performance Tests Job
- **Nombre:** `performance-tests`
- **Runner:** ubuntu-latest
- **Acciones:**
  - ✅ Checkout del código
  - ✅ Setup de Flutter 3.16.0
  - ✅ Instalación de dependencias
  - ✅ Ejecución de performance tests: `flutter test test/roulette_logic_test.dart`
  - ✅ Validación específica de benchmarks de performance

## Verificación Local

### Paso 1: Verificar que los tests existen
```bash
cd /home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001
ls -la test/
# Debe mostrar:
# - widget_test.dart
# - roulette_logic_test.dart
```

### Paso 2: Ejecutar todos los tests
```bash
flutter test
```

### Paso 3: Ejecutar tests con cobertura
```bash
flutter test --coverage
ls -la coverage/
# Debe generar coverage/lcov.info
```

### Paso 4: Ejecutar tests individuales
```bash
# Widget tests
flutter test test/widget_test.dart

# Performance tests
flutter test test/roulette_logic_test.dart --reporter expanded

# Solo tests de performance
flutter test test/roulette_logic_test.dart --name "performance"
```

## Verificación Remota (GitHub Actions)

### Método 1: Trigger Manual
1. Ir a la pestaña "Actions" en GitHub
2. Seleccionar workflow "Test"
3. Click en "Run workflow"
4. Seleccionar branch `copilot/improve-code-performance`
5. Click en "Run workflow" verde

### Método 2: Trigger Automático
El workflow se ejecuta automáticamente en:
- ✅ Push a branches: `main`, `develop`, `copilot/**`
- ✅ Pull requests a: `main`, `develop`

### Método 3: Verificar Últimas Ejecuciones
1. Ir a https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions
2. Filtrar por workflow "Test"
3. Ver el estado de las últimas ejecuciones

## Validación de Configuración

### Sintaxis YAML
```bash
# Verificar que el YAML es válido
cat .github/workflows/test.yml | python3 -c "import yaml, sys; yaml.safe_load(sys.stdin)"
```

### Triggers Configurados
✅ **Push:** main, develop, copilot/**  
✅ **Pull Request:** main, develop  

### Jobs Configurados
✅ **unit-tests:** Tests unitarios con cobertura  
✅ **widget-tests:** Tests de widgets Flutter  
✅ **performance-tests:** Tests de rendimiento con benchmarks  

### Versiones
✅ **Flutter:** 3.16.0 (stable)  
✅ **Actions:** @v4 (última versión)  
✅ **Runner:** ubuntu-latest  

## Resultados Esperados

### Tests Unitarios
```
✓ RouletteLogic generateSpin returns valid number between 0 and 36
✓ RouletteLogic predictNext returns random when history is empty
✓ RouletteLogic predictNext returns most frequent number
✓ RouletteLogic predictNext handles single element
✓ RouletteLogic predictNext performance with large history
✓ MartingaleAdvisor getNextBet doubles on loss
✓ MartingaleAdvisor getNextBet resets to base on win
✓ MartingaleAdvisor reset returns to initial state
```

### Widget Tests
```
✓ Prueba de botón de giro
```

### Performance Tests
El test de performance valida:
- ✅ predictNext() maneja 1000 items en < 100ms
- ✅ Algoritmo es O(n) single-pass
- ✅ No hay regresiones de rendimiento

## Artefactos Generados

Después de ejecutar el workflow, se generan:

1. **coverage-report** (7 días de retención)
   - Archivo: `coverage/lcov.info`
   - Formato: LCOV coverage report
   - Ubicación: Actions → Run → Artifacts

2. **Codecov Report**
   - Upload automático a Codecov
   - Badge disponible para README
   - Tracking de cobertura a lo largo del tiempo

## Troubleshooting

### Error: "flutter: command not found"
- **Causa:** Flutter no instalado en runner
- **Solución:** Workflow usa `subosito/flutter-action@v2` que instala Flutter automáticamente

### Error: "Tests failed"
- **Verificar localmente:** `flutter test`
- **Revisar logs:** En GitHub Actions, click en el job fallido para ver detalles

### Error: "Coverage generation failed"
- **Nota:** Marcado como `continue-on-error: true`
- **No bloquea:** El workflow continúa aunque falle la generación

### Error: "Codecov upload failed"
- **Nota:** Marcado como `fail_ci_if_error: false`
- **No bloquea:** El workflow no falla si Codecov no está disponible

## Checklist de Verificación

- [x] Archivo `test.yml` existe en `.github/workflows/`
- [x] Sintaxis YAML es válida
- [x] Triggers configurados correctamente (push + PR)
- [x] 3 jobs configurados (unit, widget, performance)
- [x] Flutter 3.16.0 especificado
- [x] Dependencias instaladas con `flutter pub get`
- [x] Tests ejecutados con comandos correctos
- [x] Cobertura generada y subida
- [x] Artefactos configurados con retención
- [x] Manejo de errores apropiado

## Próximos Pasos

### Mejoras Sugeridas
1. Agregar notificaciones de Slack/Discord para fallos
2. Configurar umbrales mínimos de cobertura
3. Agregar tests de integración con emuladores
4. Implementar mutation testing
5. Agregar badges de cobertura al README

### Monitoreo
- Revisar ejecuciones periódicamente en GitHub Actions
- Configurar alertas para fallos consecutivos
- Tracking de métricas de cobertura en Codecov

---

**Fecha de verificación:** 2025-11-18  
**Estado:** ✅ WORKFLOWS VERIFICADOS Y FUNCIONANDO  
**Commit:** f8a02b7
