# Tests - test/

Este directorio contiene los tests unitarios y de widgets para Tokyo Roulette.

## 📁 Estructura de Tests

```
test/
├── roulette_logic_test.dart    # Tests unitarios de lógica
└── widget_test.dart             # Tests de widgets UI
```

## 🧪 Tipos de Tests

### Tests Unitarios (`roulette_logic_test.dart`)

**Propósito**: Verificar la lógica de negocio aislada

**Cubre**:
- ✅ Generación de números aleatorios (0-36)
- ✅ Identificación correcta de colores
- ✅ Gestión del historial de giros
- ✅ Sistema de predicciones

**Ejemplo de estructura**:
```dart
group('RouletteLogic', () {
  late RouletteLogic roulette;

  setUp(() {
    roulette = RouletteLogic();
  });

  test('generateSpin devuelve número válido', () {
    final result = roulette.generateSpin();
    expect(result, greaterThanOrEqualTo(0));
    expect(result, lessThanOrEqualTo(36));
  });
});
```

### Tests de Widgets (`widget_test.dart`)

**Propósito**: Verificar que la UI funciona correctamente

**Cubre**:
- ✅ Renderizado de widgets
- ✅ Interacciones del usuario
- ✅ Navegación entre pantallas
- ✅ Actualización de estado

**Ejemplo de estructura**:
```dart
testWidgets('Botón de girar funciona', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  final button = find.text('Girar');
  expect(button, findsOneWidget);
  
  await tester.tap(button);
  await tester.pump();
  
  // Verificar que algo cambió
});
```

## 🚀 Ejecutar Tests

### Todos los Tests

```bash
# Ejecutar todos los tests
flutter test

# Con verbose para más información
flutter test --verbose

# Con reporter expandido
flutter test --reporter expanded
```

### Test Específico

```bash
# Solo tests de lógica
flutter test test/roulette_logic_test.dart

# Solo tests de widgets
flutter test test/widget_test.dart

# Test específico por nombre
flutter test --name "generateSpin"
```

### Coverage de Código

```bash
# Generar reporte de cobertura
flutter test --coverage

# La salida estará en: coverage/lcov.info
```

### Visualizar Coverage

```bash
# Instalar lcov (Linux/Mac)
sudo apt-get install lcov  # Ubuntu
brew install lcov          # Mac

# Generar HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir en navegador
open coverage/html/index.html  # Mac
xdg-open coverage/html/index.html  # Linux
```

## 📊 Coverage Actual

**Meta**: 80% de cobertura mínima

Ver reporte completo ejecutando:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## ✍️ Escribir Nuevos Tests

### Test Unitario Básico

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('NuevaFuncionalidad', () {
    test('descripción del comportamiento esperado', () {
      // Arrange (Preparar)
      final roulette = RouletteLogic();
      
      // Act (Actuar)
      final result = roulette.nuevaFuncion();
      
      // Assert (Verificar)
      expect(result, equals(valorEsperado));
    });
  });
}
```

### Test de Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('descripción de la interacción', (WidgetTester tester) async {
    // Build del widget
    await tester.pumpWidget(MyApp());
    
    // Buscar elementos
    final elemento = find.text('Texto');
    expect(elemento, findsOneWidget);
    
    // Interactuar
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    // Verificar resultado
    expect(find.text('Resultado'), findsOneWidget);
  });
}
```

## 🎯 Buenas Prácticas

### ✅ Hacer

- **Nombrar tests descriptivamente**: `'calcula el balance correctamente después de ganar'`
- **Usar setUp/tearDown**: Para preparar y limpiar estado
- **Agrupar tests relacionados**: Con `group()`
- **Tests independientes**: Cada test debe funcionar solo
- **Verificar edge cases**: Valores límite, null, vacíos
- **Usar matchers apropiados**: `expect()` con matchers descriptivos

### ❌ Evitar

- Tests que dependen del orden de ejecución
- Tests que comparten estado mutable
- Tests muy largos (dividir en múltiples tests)
- Tests sin assertions (`expect()`)
- Tests que requieren red o recursos externos

## 🔍 Matchers Comunes

```dart
// Igualdad
expect(actual, equals(expected));
expect(actual, isNot(equals(expected)));

// Booleanos
expect(value, isTrue);
expect(value, isFalse);

// Números
expect(value, greaterThan(10));
expect(value, lessThanOrEqualTo(100));
expect(value, closeTo(10.0, 0.1)); // 10.0 ± 0.1

// Strings
expect(string, contains('substring'));
expect(string, startsWith('prefix'));
expect(string, matches(RegExp(r'\d+')));

// Listas
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(5));
expect(list, contains(element));

// Tipos
expect(object, isA<TipoEsperado>());

// Widgets
expect(find.text('Texto'), findsOneWidget);
expect(find.byType(Container), findsNothing);
expect(find.byKey(Key('mi-key')), findsWidgets);
```

## 🐛 Debugging de Tests

### Ver Detalles de Fallos

```bash
# Con stack trace completo
flutter test --verbose

# Con colores (más legible)
flutter test --color
```

### Debugging en IDE

**VS Code**:
1. Agregar breakpoint en test
2. Click derecho → "Debug Test"
3. Usar debug console

**Android Studio**:
1. Click en el icono "Debug" junto al test
2. Usar el debugger integrado

### Imprimir en Tests

```dart
test('mi test', () {
  print('Valor de variable: $variable');
  debugPrint('Solo aparece en modo debug');
});
```

## 🔄 Tests de Integración (Futuro)

Para tests de integración completos:

```
integration_test/
└── app_test.dart    # Tests end-to-end
```

```bash
# Ejecutar integration tests
flutter test integration_test/
```

## 📚 Recursos

### Documentación Oficial

- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito para Mocking](https://pub.dev/packages/mockito)

### Tutoriales Recomendados

- [Testing Flutter Apps - Codelab](https://codelabs.developers.google.com/codelabs/flutter-app-testing)
- [Unit Testing with Flutter](https://flutter.dev/docs/cookbook/testing/unit/introduction)

## 🎓 Testing Patterns

### AAA Pattern (Arrange-Act-Assert)

```dart
test('ejemplo AAA pattern', () {
  // Arrange: Preparar el escenario
  final roulette = RouletteLogic();
  
  // Act: Ejecutar la acción
  final result = roulette.generateSpin();
  
  // Assert: Verificar el resultado
  expect(result, greaterThanOrEqualTo(0));
});
```

### Given-When-Then

```dart
test('dado un balance de 100, cuando apuesto 10 y gano, entonces balance es 110', () {
  // Given
  var balance = 100.0;
  
  // When
  balance += 10.0;
  
  // Then
  expect(balance, equals(110.0));
});
```

## ✅ Checklist de Test PR

Antes de hacer PR con código nuevo:

- [ ] Tests escritos para funcionalidad nueva
- [ ] Todos los tests existentes pasan
- [ ] Coverage no bajó (idealmente subió)
- [ ] Tests de edge cases incluidos
- [ ] Tests documentados si es complejo
- [ ] `flutter analyze` pasa sin errores

## 🤝 Contribuir con Tests

Ver [CONTRIBUTING.md](../CONTRIBUTING.md) para:
- Convenciones de testing
- Cómo agregar tests a un PR
- Estándares de cobertura

---

**Mantenido por**: Tokyo Apps Team  
**Última actualización**: Diciembre 2024  
**Coverage Objetivo**: 80%+
