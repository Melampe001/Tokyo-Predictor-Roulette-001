# 🤖 Bot System Overview

El sistema de bots de Tokyo Roulette Predictor proporciona automatización completa para construcción, testing, seguridad, calidad de código, deployment y monitoreo.

## 🎯 Filosofía

Cada bot es un agente especializado que:
- 🎯 Tiene un rol específico y bien definido
- ⚡ Ejecuta tareas de forma autónoma
- 📊 Reporta resultados estructurados
- 🔄 Puede ejecutarse independientemente o como parte de un workflow

## 🤖 Bots Disponibles

### 🏗️ Atlas Build Bot
**Rol**: Build System Manager  
**Prioridad**: Alta  
**Triggers**: Push, Pull Request

Gestiona todo el proceso de compilación:
- Clean y rebuild
- Gestión de dependencias
- Build de APK (Android)
- Build de Web
- Generación de artifacts

[Ver documentación completa →](individual-bots/atlas-bot.md)

---

### 🔮 Oracle Test Bot
**Rol**: Testing Oracle  
**Prioridad**: Crítica  
**Triggers**: Push, Pull Request, Schedule (cada 6 horas)

Ejecuta todos los tests del proyecto:
- Tests de Flutter estándar
- Vercel emulator tests
- Generación de cobertura
- Reportes detallados

[Ver documentación completa →](individual-bots/oracle-bot.md)

---

### 🛡️ Sentinel Security Bot
**Rol**: Security Guardian  
**Prioridad**: Crítica  
**Triggers**: Push, Pull Request, Schedule (diario)

Escanea vulnerabilidades de seguridad:
- Secretos hardcodeados
- Análisis de dependencias
- Análisis de código estático
- Detección de patrones inseguros

[Ver documentación completa →](individual-bots/sentinel-bot.md)

---

### 🔍 Scout Dependency Bot
**Rol**: Dependency Scout  
**Prioridad**: Media  
**Triggers**: Schedule (semanal)

Gestiona dependencias del proyecto:
- Detección de paquetes desactualizados
- Verificación de compatibilidad
- Auditoría de licencias
- Recomendaciones de actualización

[Ver documentación completa →](individual-bots/scout-bot.md)

---

### ☯️ Zen Code Quality Bot
**Rol**: Code Quality Master  
**Prioridad**: Alta  
**Triggers**: Push, Pull Request

Mantiene la calidad del código:
- Linting
- Verificación de formato
- Análisis de complejidad
- Detección de code smells

[Ver documentación completa →](individual-bots/zen-bot.md)

---

### 🔥 Phoenix Deploy Bot
**Rol**: Deployment Orchestrator  
**Prioridad**: Crítica  
**Triggers**: Release, Tag

Gestiona deployments:
- Pre-deployment checks
- Build de artifacts
- Deployment a staging/production
- Health checks post-deployment
- Rollback automático si falla

[Ver documentación completa →](individual-bots/phoenix-bot.md)

---

### 📚 Mercury Docs Bot
**Rol**: Documentation Curator  
**Prioridad**: Media  
**Triggers**: Push, Pull Request, Schedule (semanal)

Genera y actualiza documentación:
- Documentación de bots
- API docs (dartdoc)
- Actualización de README
- Sync de changelog

[Ver documentación completa →](individual-bots/mercury-bot.md)

---

### 👁️ Guardian Monitor Bot
**Rol**: System Monitor  
**Prioridad**: Alta  
**Triggers**: Schedule (cada 15 minutos)

Monitorea la salud del sistema:
- Salud del repositorio
- Recursos del sistema
- Logs de errores
- Métricas de rendimiento

[Ver documentación completa →](individual-bots/guardian-bot.md)

---

## 🚀 Running Bots

### Ejecución Manual

```bash
# Ejecutar todos los bots aplicables para un trigger
dart bots/run_bots.dart --push

# Ejecución en paralelo (más rápido)
dart bots/run_bots.dart --push --parallel

# Ejecutar un bot específico
dart bots/run_bots.dart --push --bot atlas

# Trigger de Pull Request
dart bots/run_bots.dart --pr

# Trigger de Release
dart bots/run_bots.dart --release

# Trigger programado
dart bots/run_bots.dart --schedule
```

### Workflows Comunes

#### Para Push/PR
```bash
dart bots/run_bots.dart --push --parallel
```
Ejecuta:
- 🏗️ Atlas (Build)
- 🔮 Oracle (Tests)
- 🛡️ Sentinel (Security)
- ☯️ Zen (Quality)
- 📚 Mercury (Docs)

#### Para Release
```bash
dart bots/run_bots.dart --release
```
Ejecuta:
- 🔥 Phoenix (Deploy)

#### Mantenimiento Programado
```bash
dart bots/run_bots.dart --schedule
```
Ejecuta:
- 🔍 Scout (Dependencies)
- 👁️ Guardian (Monitoring)

## 📊 Prioridades

Los bots se ejecutan según su prioridad:

1. **Critical** 🔴 - Deben pasar para continuar
   - Oracle (Tests)
   - Sentinel (Security)
   - Phoenix (Deploy)

2. **High** 🟡 - Importantes pero no bloquean
   - Atlas (Build)
   - Zen (Quality)
   - Guardian (Monitor)

3. **Medium** 🟢 - Ejecutan pero no afectan el resultado
   - Scout (Dependencies)
   - Mercury (Docs)

## 🔄 Lifecycle

Cada bot sigue este ciclo:

1. **Can Execute**: Verifica si puede ejecutarse
2. **Execute**: Ejecuta su tarea principal
3. **On Success/Failure**: Hooks post-ejecución
4. **Report**: Genera reporte de resultados

## 📝 Estructura de Archivos

```
bots/
├── run_bots.dart              # Script principal
├── core/
│   ├── bot_base.dart          # Clase base de bots
│   └── bot_scheduler.dart     # Orquestador
├── registry/
│   └── bot_registry.yaml      # Configuración central
├── specialized/
│   ├── atlas_build_bot.dart
│   ├── oracle_test_bot.dart
│   ├── sentinel_security_bot.dart
│   ├── scout_dependency_bot.dart
│   ├── zen_code_quality_bot.dart
│   ├── phoenix_deploy_bot.dart
│   ├── mercury_docs_bot.dart
│   └── guardian_monitor_bot.dart
└── config/
    └── [configuraciones específicas]
```

## ⚙️ Configuración

El registro central está en `bots/registry/bot_registry.yaml`:

```yaml
bots:
  atlas:
    name: "Atlas Build Bot"
    emoji: "🏗️"
    role: "Build System Manager"
    triggers:
      - on_push
      - on_pr
    capabilities:
      - flutter_build
      - android_build
    priority: high
    enabled: true
```

## 🔌 Integración con GitHub Actions

```yaml
name: Bot Automation

on: [push, pull_request]

jobs:
  run-bots:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1
      - name: Run bots
        run: dart bots/run_bots.dart --push --parallel
```

## 📈 Resultados

Los bots generan resultados estructurados:

```json
{
  "success": true,
  "message": "Build completed successfully",
  "duration": "45s",
  "data": {
    "artifacts": ["app-release.apk"],
    "size_mb": "25.3"
  }
}
```

## 🎯 Best Practices

1. **Bots Rápidos**: Optimiza para ejecución < 5 minutos
2. **Idempotencia**: Mismo resultado con múltiples ejecuciones
3. **Logging Claro**: Usa el emoji y mensajes descriptivos
4. **Manejo de Errores**: Captura y reporta errores apropiadamente
5. **Cleanup**: Limpia recursos temporales

## 🛠️ Crear Bots Personalizados

Ver [Creating Custom Bots](creating-custom-bots.md) para una guía completa.

---

*Para más información, consulta la [documentación completa](../README.md)*
