# Checklist de Integración y Agentes

Este documento describe los agentes disponibles en el proyecto Tokyo Roulette, cómo integrarlos, y las mejores prácticas para CI/CD.

## Índice

1. [Agentes Disponibles](#agentes-disponibles)
2. [Cómo Integrar Agentes](#cómo-integrar-agentes)
3. [Checklist de CI/CD](#checklist-de-cicd)
4. [Plantillas para PRs](#plantillas-para-prs)

---

## Agentes Disponibles

### RouletteAgent

**Ubicación**: `lib/agents/roulette_agent.dart`

**Propósito**: Simulación de ruleta europea con generación segura de números aleatorios.

**Características**:
- Generación de números usando `Random.secure()`
- Clasificación de colores (rojo, negro, verde)
- Historial de giros con límite configurable
- Predicción basada en frecuencia (educativo)
- Cálculo de estadísticas

**Ejemplo de uso**:

```dart
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

// Crear instancia
final agent = RouletteAgent();

// Simular un giro
final result = agent.spin(); // 0-36

// Agregar al historial
agent.addToHistory(result);

// Obtener color
final color = RouletteAgent.getColor(result); // 'red', 'black', 'green'

// Obtener estadísticas
final stats = agent.getStatistics();
print(stats.redPercentage);
```

### MartingaleAdvisor

**Ubicación**: `lib/agents/martingale_advisor.dart`

**Propósito**: Asesor de estrategia Martingale para fines educativos.

**Características**:
- Cálculo automático de apuestas
- Límite máximo de apuesta configurable
- Multiplicador configurable
- Estadísticas de sesión
- Simulación de rondas

**Ejemplo de uso**:

```dart
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

// Configuración personalizada
final advisor = MartingaleAdvisor(
  baseBet: 10.0,
  maxBet: 1000.0,
  multiplier: 2.0,
);

// Procesar resultado de apuesta
final nextBet = advisor.processBet(won: false); // Duplica
final resetBet = advisor.processBet(won: true); // Resetea

// Ver estadísticas
print(advisor.sessionStats);

// Simular 100 rondas
final results = advisor.simulate(rounds: 100, winProbability: 0.486);
```

---

## Cómo Integrar Agentes

### Paso 1: Importar el módulo

```dart
// Importar todos los agentes
import 'package:tokyo_roulette_predicciones/agents/agents.dart';

// O importar específicos
import 'package:tokyo_roulette_predicciones/agents/roulette_agent.dart';
import 'package:tokyo_roulette_predicciones/agents/martingale_advisor.dart';
```

### Paso 2: Crear instancias

```dart
// En tu Widget o lógica de negocio
class GameController {
  final RouletteAgent _roulette = RouletteAgent();
  final MartingaleAdvisor _advisor = MartingaleAdvisor(baseBet: 5.0);
  
  void playRound(BetType bet) {
    final result = _roulette.spin();
    _roulette.addToHistory(result);
    
    final won = _evaluateBet(bet, result);
    _advisor.processBet(won: won);
  }
  
  bool _evaluateBet(BetType bet, int result) {
    switch (bet) {
      case BetType.red: return RouletteAgent.isRed(result);
      case BetType.black: return RouletteAgent.isBlack(result);
      // ... más casos
    }
  }
}
```

### Paso 3: Agregar pruebas

```dart
// test/game_controller_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should process round correctly', () {
    final controller = GameController();
    controller.playRound(BetType.red);
    // Assertions...
  });
}
```

---

## Checklist de CI/CD

### 1) Build y Compilación

- **Descripción**: Verificar que el proyecto compila correctamente
- **Tipo de agente**: CI runner (GitHub Actions: `ubuntu-latest`)
- **Cómo activar**: Job `build-debug` en `.github/workflows/ci.yml`
- **Comando local**: `make build` o `flutter build apk --debug`

### 2) Tests Unitarios y Widget

- **Descripción**: Ejecutar la suite de tests
- **Tipo de agente**: CI runner
- **Cómo activar**: Job `test` en `.github/workflows/ci.yml`
- **Comando local**: `make test` o `flutter test --coverage`

### 3) Lint y Formato

- **Descripción**: Ejecutar `flutter analyze` y verificar formato
- **Tipo de agente**: CI runner
- **Cómo activar**: Jobs `analyze` y `format` en CI workflow
- **Comandos locales**:
  - `make lint` o `flutter analyze`
  - `make format` o `dart format lib/ test/`

### 4) Build Release APK

- **Descripción**: Generar APK firmada para distribución
- **Tipo de agente**: CI runner con secretos de keystore
- **Cómo activar**: `.github/workflows/build-apk.yml`
- **Comando local**: `make apk` o `flutter build apk --release`

### 5) Build Release AAB

- **Descripción**: Generar AAB para Google Play Store
- **Tipo de agente**: CI runner con secretos de keystore
- **Cómo activar**: `.github/workflows/build-aab.yml` (en tags v*)
- **Comando local**: `make aab` o `flutter build appbundle --release`

### 6) Seguridad y Dependencias

- **Descripción**: Verificar que no hay secretos expuestos
- **Tipo de agente**: Revisor humano + escáneres automáticos
- **Verificaciones**:
  - No hay claves API hardcodeadas
  - `.gitignore` incluye archivos sensibles
  - Variables de entorno para secretos

---

## Plantillas para PRs

### Plantilla corta para usar en PRs:

```markdown
## Checklist

- [ ] Build y compilación — CI: `build-debug`
- [ ] Tests unitarios — CI: `test` 
- [ ] Lint y formato — CI: `analyze`, `format`
- [ ] Documentación actualizada
- [ ] No hay secretos expuestos

### Agentes modificados

- [ ] RouletteAgent
- [ ] MartingaleAdvisor
- [ ] Ninguno

### Comandos ejecutados

```bash
make ci
```
```

### Ejemplo completo:

```markdown
## 📄 Descripción

Implementa nueva funcionalidad de [descripción].

## Checklist

- [x] Build y compilación — CI: `build-debug` ✅
- [x] Tests unitarios — CI: `test` ✅
- [x] Lint y formato — CI: `analyze`, `format` ✅
- [x] Documentación actualizada
- [ ] No hay secretos expuestos (verificado)

### Agentes modificados

- [x] RouletteAgent - Agregado método `getStatistics()`
- [ ] MartingaleAdvisor

### Comandos ejecutados

```bash
make deps      # Instalar dependencias
make lint      # Sin errores
make test      # 45/45 tests pasaron
make format    # Código formateado
```

### Screenshots (si aplica)

[Imagen de la nueva funcionalidad]
```

---

## Notas Importantes

1. **Seguridad**: Nunca commits claves API, keystores, o archivos `key.properties`
2. **Tests**: Cada agente debe tener tests unitarios correspondientes en `test/agents/`
3. **Documentación**: Actualiza este archivo y el README cuando agregues nuevos agentes
4. **Deprecación**: El archivo `lib/roulette_logic.dart` está deprecado; usa `lib/agents/` en su lugar
