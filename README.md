# Tokyo Roulette Predicciones

[![Flutter CI](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions/workflows/ci.yml/badge.svg)](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions/workflows/ci.yml)
[![Build APK](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions/workflows/build-apk.yml/badge.svg)](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions/workflows/build-apk.yml)

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

> **⚠️ Disclaimer**: Este es un simulador educativo. No promueve ni facilita el gambling real. Cada giro de ruleta real es independiente y no se puede predecir.

## 📋 Tabla de Contenidos

- [Instalación](#instalación)
- [Uso Rápido](#uso-rápido)
- [Arquitectura de Agentes](#arquitectura-de-agentes)
- [Comandos Make](#comandos-make)
- [CI/CD](#cicd)
- [Contribuir](#contribuir)

## Instalación

### Requisitos Previos

- Flutter SDK 3.0.0 o superior
- Dart SDK 3.0.0 o superior
- Android Studio o VS Code con extensiones Flutter
- Para builds Android: JDK 17

### Pasos de Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la aplicación
flutter run
```

## Uso Rápido

### Ejecutar Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Con cobertura
flutter test --coverage
```

### Construir APK/AAB

```bash
# APK de release
flutter build apk --release

# Android App Bundle para Play Store
flutter build appbundle --release
```

## Arquitectura de Agentes

El proyecto utiliza una arquitectura modular basada en **agentes** que encapsulan funcionalidades específicas.

### RouletteAgent

Agente principal para simulación de ruleta europea (0-36).

```dart
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

void main() {
  final agent = RouletteAgent();
  
  // Generar un giro
  final result = agent.spin();
  print('Resultado: $result (${RouletteAgent.getColor(result)})');
  
  // Agregar al historial
  agent.addToHistory(result);
  
  // Obtener predicción basada en frecuencia
  final prediction = agent.predictNext();
  print('Predicción: $prediction');
  
  // Ver estadísticas
  print(agent.getStatistics());
}
```

### MartingaleAdvisor

Asesor de estrategia Martingale para propósitos educativos.

```dart
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

void main() {
  final advisor = MartingaleAdvisor(baseBet: 10.0, maxBet: 1000.0);
  
  // Simular una pérdida - la apuesta se duplica
  final nextBet = advisor.processBet(won: false);
  print('Siguiente apuesta: \$$nextBet');
  
  // Simular una ganancia - la apuesta se resetea
  final resetBet = advisor.processBet(won: true);
  print('Apuesta después de ganar: \$$resetBet');
  
  // Ver estadísticas de la sesión
  print(advisor.sessionStats);
}
```

### Integrar Ambos Agentes

```dart
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

void main() {
  final roulette = RouletteAgent();
  final advisor = MartingaleAdvisor(baseBet: 5.0);
  
  // Simular 10 rondas apostando a rojo
  for (var i = 0; i < 10; i++) {
    final result = roulette.spin();
    roulette.addToHistory(result);
    
    final won = RouletteAgent.isRed(result);
    advisor.processBet(won: won);
    
    print('Ronda ${i + 1}: $result (${RouletteAgent.getColor(result)}) - '
          '${won ? "GANÓ" : "PERDIÓ"} - Siguiente: \$${advisor.currentBet}');
  }
  
  print('\nEstadísticas finales:');
  print(advisor.sessionStats);
}
```

## Comandos Make

El proyecto incluye un Makefile para simplificar tareas comunes:

```bash
make help       # Mostrar ayuda
make deps       # Instalar dependencias
make build      # Compilar (debug)
make test       # Ejecutar pruebas
make lint       # Análisis estático
make format     # Formatear código
make apk        # Construir APK release
make aab        # Construir AAB release
make clean      # Limpiar artefactos
make ci         # Ejecutar checks de CI
```

## CI/CD

### Workflows de GitHub Actions

| Workflow | Trigger | Descripción |
|----------|---------|-------------|
| `ci.yml` | Push/PR | Lint, format, test, build debug |
| `build-apk.yml` | Push/PR main, tags | Build APK release |
| `build-aab.yml` | Tags v* | Build AAB para Play Store |

### Configuración de Keystore para Android

#### Opción 1: Desarrollo Local (key.properties)

Crea un archivo `key.properties` en el directorio raíz:

```properties
storeFile=/ruta/a/tu/keystore.jks
storePassword=tu_password_del_keystore
keyAlias=tu_alias
keyPassword=tu_password_de_la_key
```

#### Opción 2: CI/CD (Variables de Entorno)

Define estos secretos en tu repositorio de GitHub:

- `ANDROID_KEYSTORE_PATH`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`

> **⚠️ Importante**: Nunca commits el archivo `key.properties` o keystores al repositorio.

## Contribuir

### Checklist para PRs

- [ ] He ejecutado `make lint` y no hay errores
- [ ] He ejecutado `make format` antes de commitear
- [ ] He agregado/actualizado tests para los cambios
- [ ] He ejecutado `make test` y todas las pruebas pasan
- [ ] La documentación está actualizada si aplica

### Estructura del Proyecto

```
lib/
├── agents/             # Módulos de agentes
│   ├── agents.dart     # Barrel export
│   ├── roulette_agent.dart
│   └── martingale_advisor.dart
├── models/             # Modelos de datos
├── screens/            # Pantallas de UI
├── services/           # Servicios externos
├── main.dart           # Entry point
└── roulette_logic.dart # Legacy (deprecado)

test/
├── agents/             # Tests de agentes
│   ├── roulette_agent_test.dart
│   └── martingale_advisor_test.dart
└── widget_test.dart    # Tests de widgets
```

---

## Fases del Proyecto

### 1. Definición y planificación
- [x] Redactar objetivo y alcance del proyecto
- [x] Identificar requerimientos y entregables principales
- [x] Crear roadmap con hitos y fechas estimadas
- [x] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [x] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [x] Revisar dependencias y recursos necesarios
- [x] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [x] Implementar funcionalidades según el roadmap
- [x] Realizar revisiones de código y PR siguiendo checklist
- [x] Actualizar documentación según cambios realizados

### 4. Pruebas
- [x] Ejecutar pruebas unitarias y funcionales
- [x] Validar requisitos y criterios de aceptación
- [x] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [x] Preparar ambiente de release
- [x] Documentar lecciones aprendidas
- [x] Presentar entregables y cerrar fase
