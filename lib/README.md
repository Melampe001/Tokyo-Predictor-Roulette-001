# Código Fuente - lib/

Este directorio contiene el código fuente principal de la aplicación Tokyo Roulette.

## 📁 Estructura Actual

```
lib/
├── main.dart              # Punto de entrada de la aplicación
└── roulette_logic.dart    # Lógica de ruleta y Martingale
```

## 📄 Archivos Principales

### main.dart

**Propósito**: Punto de entrada de la aplicación Flutter

**Contiene**:
- `main()` - Función principal que inicia la app
- `MyApp` - Widget raíz de la aplicación
- `LoginScreen` - Pantalla de inicio de sesión
- `MainScreen` - Pantalla principal del juego
- UI completa de la aplicación

**Responsabilidades**:
- Configuración de Material App
- Gestión de estado de la UI
- Manejo de interacciones del usuario
- Visualización de resultados

### roulette_logic.dart

**Propósito**: Lógica de negocio de la ruleta

**Contiene**:
- `RouletteLogic` - Clase principal de lógica de ruleta
- Generación de números aleatorios con RNG seguro
- Cálculo de colores (rojo, negro, verde)
- Gestión del historial de giros
- Sistema de predicciones simple

**Responsabilidades**:
- Generar spins aleatorios
- Mantener historial
- Proporcionar predicciones
- Validación de números de ruleta

## 🎯 Convenciones de Código

### Nomenclatura

- **Clases**: `PascalCase` (ej: `RouletteLogic`, `MainScreen`)
- **Funciones**: `camelCase` (ej: `generateSpin()`, `updateBalance()`)
- **Variables**: `camelCase` (ej: `currentBet`, `isGameActive`)
- **Constantes**: `camelCase` (ej: `const maxBalance = 10000`)
- **Privados**: Prefijo `_` (ej: `_updateState()`)

### Estilo de Código

```dart
// ✅ BUENO: Uso de const para widgets inmutables
const Text('Gira la ruleta');

// ✅ BUENO: Trailing commas para mejor formato
Column(
  children: [
    Text('Hello'),
    Text('World'),
  ], // <-- trailing comma
);

// ✅ BUENO: Nombrar parámetros con claridad
void updateBet({required double newBet, bool resetHistory = false}) {
  // ...
}

// ❌ MALO: Líneas muy largas
final message = 'Este es un mensaje extremadamente largo que no debería estar en una sola línea porque dificulta la lectura';

// ✅ BUENO: Dividir líneas largas
final message = 'Este es un mensaje largo '
    'que se divide en múltiples líneas '
    'para mejor legibilidad';
```

## 🔨 Estructura Futura Recomendada

A medida que el proyecto crece, considera organizar en subcarpetas:

```
lib/
├── main.dart
├── screens/              # Pantallas completas
│   ├── login_screen.dart
│   ├── main_screen.dart
│   └── settings_screen.dart
├── widgets/              # Widgets reutilizables
│   ├── roulette_wheel.dart
│   ├── bet_display.dart
│   └── history_card.dart
├── logic/                # Lógica de negocio
│   ├── roulette_logic.dart
│   └── martingale_advisor.dart
├── models/               # Modelos de datos
│   ├── game_state.dart
│   └── spin_result.dart
├── services/             # Servicios externos
│   ├── firebase_service.dart
│   ├── stripe_service.dart
│   └── storage_service.dart
├── utils/                # Utilidades y helpers
│   ├── constants.dart
│   ├── helpers.dart
│   └── validators.dart
└── theme/                # Configuración de tema
    ├── app_theme.dart
    └── colors.dart
```

## 🧪 Testing

Los tests correspondientes a este código están en `../test/`:

- `roulette_logic_test.dart` → Tests para `roulette_logic.dart`
- `widget_test.dart` → Tests para widgets en `main.dart`

## 📚 Recursos

### Documentación de Flutter

- [Flutter Widgets Catalog](https://docs.flutter.dev/ui/widgets)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

### Patrones Recomendados

- **Separation of Concerns**: UI separada de lógica
- **Single Responsibility**: Cada clase una responsabilidad
- **DRY**: No repetir código
- **KISS**: Mantener simple

## 🔧 Comandos Útiles

```bash
# Formatear código
dart format lib/

# Analizar código
flutter analyze lib/

# Ver árbol de widgets (en debug)
flutter run --dart-define=FLUTTER_WEB_USE_SKIA=true
```

## 🐛 Debugging

Para debug de código Dart:

1. Agrega breakpoints en VS Code/Android Studio
2. Usa `print()` statements (remover en producción)
3. Usa `debugPrint()` para logs de debug
4. Usa Flutter DevTools para análisis profundo

```dart
// Debug logging
debugPrint('Balance actual: $balance');

// Assertions (solo en modo debug)
assert(balance >= 0, 'Balance no puede ser negativo');
```

## 📝 TODOs Conocidos

Ver issues en GitHub o buscar en el código:

```bash
# Buscar TODOs en el código
grep -r "TODO:" lib/

# Buscar FIXMEs
grep -r "FIXME:" lib/
```

## 🤝 Contribuir

Al agregar código nuevo:

1. Sigue las convenciones de nomenclatura
2. Agrega documentación con `///` para APIs públicas
3. Escribe tests para funcionalidad nueva
4. Ejecuta `flutter analyze` antes de commit
5. Formatea con `dart format` antes de commit

Ver [CONTRIBUTING.md](../CONTRIBUTING.md) para más detalles.

---

**Mantenido por**: Tokyo Apps Team  
**Última actualización**: Diciembre 2024
