# 🔮 Vercel-Style Test Emulator

El sistema de testing de Tokyo Roulette Predictor emula el estilo de ejecución de Vercel, proporcionando una experiencia moderna y eficiente para ejecutar pruebas.

## 🎯 Características

- **Ejecución Paralela**: Los módulos se ejecutan en paralelo para máxima velocidad
- **Reportes Múltiples**: Console, HTML y JSON
- **Configuración Flexible**: YAML para configurar cada módulo
- **Tiempo Real**: Feedback inmediato durante la ejecución
- **Modular**: Tests organizados por módulo (UI, ML, Data, Integration)

## 🚀 Quick Start

### Ejecutar todos los tests

```bash
# Desde el directorio raíz del proyecto
dart testing/vercel_emulator/run_tests.dart
```

### Opciones de ejecución

```bash
# Modo verbose (más detalles)
dart testing/vercel_emulator/run_tests.dart --verbose

# Ejecución secuencial (para debugging)
dart testing/vercel_emulator/run_tests.dart --sequential

# Especificar directorio de salida
dart testing/vercel_emulator/run_tests.dart --output custom-results
```

## 📊 Módulos de Testing

### 1. UI Module 🎨
Tests de componentes de interfaz de usuario:
- Estado de la ruleta
- Animaciones
- Tema dark/light
- Validación de apuestas
- Historial visual

### 2. ML Module 🧠
Tests de lógica de Machine Learning y predicciones:
- RNG (Random Number Generator)
- Algoritmo de predicción
- Estrategia Martingale
- Análisis de frecuencias

### 3. Data Module 💾
Tests de persistencia y datos:
- LocalStorage
- Validación de emails
- Sistema de créditos
- Preferencias de usuario
- Historial de spins

### 4. Integration Module 🔗
Tests de integración end-to-end:
- Workflow completo de spin
- Workflow de Martingale
- Upgrade a premium
- Persistencia de sesión

## 📝 Estructura de Archivos

```
testing/vercel_emulator/
├── test_runner.dart           # Core del emulador
├── run_tests.dart             # Script principal
├── config/
│   └── test_config.yaml       # Configuración
├── modules/
│   ├── ui_module_test.dart
│   ├── ml_module_test.dart
│   ├── data_module_test.dart
│   └── integration_module_test.dart
└── reporters/
    ├── console_reporter.dart
    ├── html_reporter.dart
    └── json_reporter.dart
```

## 🎨 Formato de Salida

### Console Output (Estilo Vercel)

```
═══════════════════════════════════════════════════════════
📊 Test Summary (Vercel Style)
═══════════════════════════════════════════════════════════
Total Tests: 25
✅ Passed: 25 (100.0%)
❌ Failed: 0
⏱️  Duration: 2s
═══════════════════════════════════════════════════════════
🎉 All tests passed! Ready to deploy.
```

### HTML Report
Se genera un reporte HTML moderno con:
- Diseño oscuro estilo Vercel
- Estadísticas visuales
- Detalles de cada módulo
- Errores expandibles

### JSON Report
Formato estructurado para integración con CI/CD:
- Resultados de todos los tests
- Métricas de tiempo
- Eventos de ejecución
- Fácil parsing

## ⚙️ Configuración

Edita `testing/vercel_emulator/config/test_config.yaml`:

```yaml
test_config:
  parallel_execution: true
  max_workers: 4
  timeout_seconds: 300
  
  modules:
    ui:
      enabled: true
      critical: true
      timeout: 60
      
    ml:
      enabled: true
      critical: true
      timeout: 120
```

## 🔌 Integración con CI/CD

### GitHub Actions

```yaml
- name: Run Vercel-style tests
  run: |
    dart testing/vercel_emulator/run_tests.dart
    
- name: Upload test results
  uses: actions/upload-artifact@v2
  with:
    name: test-results
    path: test-results/
```

## 📈 Métricas

El emulador rastrea:
- ✅ Tests pasados/fallados
- ⏱️ Tiempo de ejecución por módulo
- 📊 Cobertura de código (cuando está habilitado)
- 🎯 Porcentaje de éxito

## 🐛 Debugging

### Ver más detalles
```bash
dart testing/vercel_emulator/run_tests.dart --verbose
```

### Ejecutar solo un módulo
Edita `run_tests.dart` y comenta los módulos que no necesites:

```dart
final modules = <TestModule>[
  // UIModuleTest(),
  MLModuleTest(),  // Solo este
  // DataModuleTest(),
  // IntegrationModuleTest(),
];
```

## 📚 Escribir Nuevos Tests

Ver [Writing Tests](writing-tests.md) para una guía completa.

### Ejemplo básico

```dart
class MyModuleTest extends TestModule {
  @override
  String get name => 'My Module';

  @override
  List<Test> get tests => [
    Test(
      name: 'My test',
      run: () async {
        // Tu código de test aquí
        expect(1 + 1, equals(2));
      },
    ),
  ];
}
```

## 🎯 Best Practices

1. **Tests Rápidos**: Cada test debe ejecutarse en < 30 segundos
2. **Independencia**: Los tests no deben depender de otros
3. **Nombres Claros**: Nombres descriptivos para cada test
4. **Assertions Específicas**: Verifica exactamente lo que necesitas
5. **Cleanup**: Usa `setup()` y `teardown()` apropiadamente

---

*Para más información, consulta la [documentación completa](../README.md)*
