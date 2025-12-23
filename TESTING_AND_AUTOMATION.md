# 🤖 Advanced Testing & Automation Systems

Este documento describe los nuevos sistemas de testing y automatización del proyecto.

## 🔮 Vercel-Style Test Emulator

### ¿Qué es?
Un sistema de testing modular que emula el estilo de ejecución de Vercel, proporcionando:
- ✅ Tests paralelos por módulo
- 📊 Reportes en tiempo real (Console, HTML, JSON)
- 🎯 Configuración flexible por módulo
- ⚡ Ejecución rápida y eficiente

### Módulos de Testing

#### 🎨 UI Module
Tests de componentes de interfaz:
- Estado de la ruleta
- Animaciones
- Tema dark/light
- Validación de apuestas

#### 🧠 ML Module  
Tests de lógica y predicciones:
- RNG (Random Number Generator)
- Algoritmo de predicción
- Estrategia Martingale

#### 💾 Data Module
Tests de persistencia:
- LocalStorage
- Validación de datos
- Sistema de créditos

#### 🔗 Integration Module
Tests end-to-end:
- Workflow completo de spin
- Upgrade a premium
- Persistencia de sesión

### Ejecución

```bash
# Ejecutar todos los tests estilo Vercel
dart testing/vercel_emulator/run_tests.dart

# Modo verbose
dart testing/vercel_emulator/run_tests.dart --verbose

# Secuencial (debugging)
dart testing/vercel_emulator/run_tests.dart --sequential
```

### Reportes

Los tests generan 3 tipos de reportes en `test-results/`:
- **Console**: Output en tiempo real estilo Vercel
- **HTML**: Reporte visual moderno con diseño oscuro
- **JSON**: Datos estructurados para CI/CD

---

## 🤖 Bot Automation System

Sistema de 8 bots especializados para automatización completa del proyecto.

### 🏗️ Atlas Build Bot
**Build System Manager**

Gestiona construcción y compilación:
- Flutter clean & rebuild
- Gestión de dependencias
- Build APK (Android)
- Build Web
- Generación de artifacts

```bash
dart bots/run_bots.dart --push --bot atlas
```

### 🔮 Oracle Test Bot
**Testing Oracle** (Prioridad: Crítica)

Ejecuta todos los tests:
- Tests de Flutter
- Vercel emulator tests
- Generación de cobertura
- Reportes detallados

```bash
dart bots/run_bots.dart --push --bot oracle
```

### 🛡️ Sentinel Security Bot
**Security Guardian** (Prioridad: Crítica)

Escanea vulnerabilidades:
- Secretos hardcodeados
- Análisis de dependencias
- Análisis de código estático
- Patrones inseguros

```bash
dart bots/run_bots.dart --push --bot sentinel
```

### 🔍 Scout Dependency Bot
**Dependency Scout**

Gestiona dependencias:
- Detección de paquetes desactualizados
- Verificación de compatibilidad
- Auditoría de licencias

```bash
dart bots/run_bots.dart --schedule --bot scout
```

### ☯️ Zen Code Quality Bot
**Code Quality Master**

Mantiene calidad del código:
- Linting
- Verificación de formato
- Análisis de complejidad
- Code smells

```bash
dart bots/run_bots.dart --push --bot zen
```

### 🔥 Phoenix Deploy Bot
**Deployment Orchestrator** (Prioridad: Crítica)

Gestiona deployments:
- Pre-deployment checks
- Build de artifacts
- Deploy a staging/production
- Health checks
- Rollback automático

```bash
dart bots/run_bots.dart --release --bot phoenix
```

### 📚 Mercury Docs Bot
**Documentation Curator**

Genera documentación:
- Docs de bots
- API docs (dartdoc)
- Actualización de README
- Sync de changelog

```bash
dart bots/run_bots.dart --push --bot mercury
```

### 👁️ Guardian Monitor Bot
**System Monitor**

Monitorea salud del sistema:
- Salud del repositorio
- Recursos del sistema
- Logs de errores
- Métricas de rendimiento

```bash
dart bots/run_bots.dart --schedule --bot guardian
```

---

## 🚀 Workflows Rápidos

### Para Push/Pull Request
```bash
# Ejecuta: Atlas, Oracle, Sentinel, Zen, Mercury (en paralelo)
dart bots/run_bots.dart --push --parallel
```

### Para Release
```bash
# Ejecuta: Phoenix (deployment)
dart bots/run_bots.dart --release
```

### Mantenimiento Programado
```bash
# Ejecuta: Scout, Guardian
dart bots/run_bots.dart --schedule
```

---

## 📊 Estructura del Sistema

```
testing/vercel_emulator/     # Sistema de testing
├── test_runner.dart          # Core del emulador
├── run_tests.dart            # Script principal
├── config/
│   └── test_config.yaml      # Configuración
├── modules/                  # Módulos de test
│   ├── ui_module_test.dart
│   ├── ml_module_test.dart
│   ├── data_module_test.dart
│   └── integration_module_test.dart
└── reporters/                # Generadores de reportes
    ├── console_reporter.dart
    ├── html_reporter.dart
    └── json_reporter.dart

bots/                         # Sistema de bots
├── run_bots.dart             # Script principal
├── core/                     # Core del sistema
│   ├── bot_base.dart
│   └── bot_scheduler.dart
├── registry/
│   └── bot_registry.yaml     # Configuración central
└── specialized/              # Bots especializados
    ├── atlas_build_bot.dart
    ├── oracle_test_bot.dart
    ├── sentinel_security_bot.dart
    ├── scout_dependency_bot.dart
    ├── zen_code_quality_bot.dart
    ├── phoenix_deploy_bot.dart
    ├── mercury_docs_bot.dart
    └── guardian_monitor_bot.dart
```

---

## 📚 Documentación Completa

Toda la documentación está centralizada en `docs/library/`:

- 📖 [Índice Principal](docs/library/README.md)
- 🚀 [Quick Start](docs/library/getting-started/quick-start.md)
- 🔮 [Vercel Emulator](docs/library/testing/vercel-emulator.md)
- 🤖 [Bot System](docs/library/bots/bot-system-overview.md)
- 🛠️ [Creating Custom Bots](docs/library/bots/creating-custom-bots.md)

---

## 🔌 Integración con CI/CD

### GitHub Actions

```yaml
name: Automated Testing & Bots

on: [push, pull_request]

jobs:
  test-and-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1
      
      # Vercel-style tests
      - name: Run Vercel Emulator
        run: dart testing/vercel_emulator/run_tests.dart
      
      # Bot workflow
      - name: Run Bots
        run: dart bots/run_bots.dart --push --parallel
      
      # Upload results
      - name: Upload Test Results
        uses: actions/upload-artifact@v2
        with:
          name: test-results
          path: test-results/
```

---

## 🎯 Características Clave

### Testing
- ✅ Tests modulares organizados por dominio
- ✅ Ejecución paralela para velocidad
- ✅ Reportes múltiples (Console/HTML/JSON)
- ✅ Configuración flexible por módulo
- ✅ Compatible con CI/CD

### Automatización
- ✅ 8 bots especializados
- ✅ Prioridades configurables
- ✅ Ejecución secuencial o paralela
- ✅ Manejo robusto de errores
- ✅ Logging descriptivo con emojis
- ✅ Integración con GitHub Actions

---

## 📈 Ventajas

### Para Desarrolladores
- 🚀 **Feedback Rápido**: Tests en < 5 segundos
- 🎯 **Enfocado**: Solo ejecuta lo necesario
- 📊 **Visibilidad**: Reportes claros y visuales
- 🔧 **Extensible**: Fácil agregar nuevos tests/bots

### Para CI/CD
- ⚡ **Eficiente**: Ejecución paralela optimizada
- 🔄 **Confiable**: Manejo robusto de errores
- 📦 **Artifacts**: Generación automática
- 🔒 **Seguro**: Escaneo continuo de vulnerabilidades

### Para DevOps
- 🎛️ **Control**: Workflows configurables
- 📈 **Métricas**: Tracking de rendimiento
- 🚨 **Alertas**: Notificaciones automáticas
- 🔥 **Deploy**: Automatización completa

---

## 🆘 Troubleshooting

### Tests fallan
```bash
# Ejecutar con más detalles
dart testing/vercel_emulator/run_tests.dart --verbose
```

### Bot falla
```bash
# Ejecutar bot específico para debugging
dart bots/run_bots.dart --push --bot nombre_bot
```

### Ver logs completos
Los reportes detallados están en:
- `test-results/test_results.html`
- `test-results/test_results.json`

---

## 🤝 Contribuir

Para agregar tests o bots personalizados:

1. Lee la [guía de contribución](CONTRIBUTING.md)
2. Consulta [Creating Custom Bots](docs/library/bots/creating-custom-bots.md)
3. Revisa [ejemplos](docs/library/examples/)

---

## 📄 Licencia

Ver [LICENSE](LICENSE) para más detalles.

---

*Sistemas desarrollados con 💙 para el proyecto Tokyo Roulette Predictor*
