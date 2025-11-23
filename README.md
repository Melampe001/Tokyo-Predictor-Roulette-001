# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## 🆕 Nueva Estructura de Agentes y Bots

Este proyecto ahora incluye una arquitectura completa de **agentes y bots automatizados** para análisis y simulación de ruleta:

### 📊 Agentes de Análisis
- **PredictorAgent**: Predicción de números con múltiples estrategias
- **RngAnalyzerAgent**: Detección de sesgos en RNG
- **StatisticalAnalyzerAgent**: Modelado estadístico avanzado
- **RouletteSimulatorAgent**: Simulación de ruleta europea/americana

### 🤖 Bots de Automatización
- **BettingBot**: Estrategias de apuestas automatizadas (Martingale, Fibonacci, etc.)
- **ApiIntegrationBot**: Template para integración con APIs externas
- **TestBot**: Testing automatizado de todo el stack
- **CasinoMockBot**: Simulación de casino para pruebas

### 📚 Documentación Completa
Ver documentación detallada en:
- `/docs/AGENTS_BOTS_STRUCTURE.md` - Arquitectura completa
- `/lib/agents/README.md` - Documentación de agentes
- `/lib/bots/README.md` - Documentación de bots
- `/lib/examples/README.md` - Ejemplos de uso
- `/lib/core/README.md` - Infraestructura core

**⚠️ Importante**: Toda la estructura es solo para simulación/educación. No incluye apuestas reales ni integración con casinos reales.

---

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

## Ejecutar Ejemplos
```bash
# Ejemplo de predictor
dart run lib/examples/predictor_example.dart

# Ejemplo de bot de apuestas
dart run lib/examples/betting_bot_example.dart

# Workflow completo
dart run lib/examples/complete_workflow_example.dart
```

## Tests
```bash
# Todos los tests
flutter test

# Tests de agentes
flutter test test/agents/

# Tests de bots
flutter test test/bots/
```

**Disclaimer**: Solo simulación. No promueve gambling real.

---

## Fases del Proyecto

### 1. Definición y planificación
- [ ] Redactar objetivo y alcance del proyecto
- [ ] Identificar requerimientos y entregables principales
- [ ] Crear roadmap con hitos y fechas estimadas
- [ ] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [ ] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [ ] Revisar dependencias y recursos necesarios
- [ ] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [ ] Implementar funcionalidades según el roadmap
- [ ] Realizar revisiones de código y PR siguiendo checklist
- [ ] Actualizar documentación según cambios realizados

### 4. Pruebas
- [ ] Ejecutar pruebas unitarias y funcionales
- [ ] Validar requisitos y criterios de aceptación
- [ ] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [ ] Preparar ambiente de release
- [ ] Documentar lecciones aprendidas
- [ ] Presentar entregables y cerrar fase