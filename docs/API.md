# API Documentation

Documentación de las APIs principales del proyecto Tokyo Roulette.

## 📑 Tabla de Contenidos

- [RouletteLogic](#roulettelogic)
- [Estructuras de Datos](#estructuras-de-datos)
- [Constantes](#constantes)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Mejores Prácticas](#mejores-prácticas)

---

## RouletteLogic

Clase principal que contiene la lógica de la ruleta europea.

### Constructor

```dart
RouletteLogic()
```

Crea una nueva instancia de RouletteLogic con RNG seguro inicializado.

**Ejemplo:**
```dart
final roulette = RouletteLogic();
```

---

### Propiedades

#### `wheel` (List<int>)

**Tipo:** `List<int>` (read-only)

**Descripción:** Lista de números de la ruleta europea (0-36).

**Valor:** `[0, 1, 2, ..., 36]`

**Ejemplo:**
```dart
final numbers = roulette.wheel;
print(numbers); // [0, 1, 2, ..., 36]
print(numbers.length); // 37
```

---

#### `rng` (Random)

**Tipo:** `Random` (privado)

**Descripción:** Generador de números aleatorios criptográficamente seguro.

**Implementación:** `Random.secure()`

**Nota:** No accesible directamente. Usar `generateSpin()`.

---

#### `history` (managed internally)

**Nota:** En la implementación actual de `roulette_logic.dart`, el historial NO es una propiedad pública de la clase. El método `predictNext` recibe el historial como parámetro.

Si necesitas mantener un historial en tu aplicación, debes gestionarlo externamente:

**Ejemplo:**
```dart
final roulette = RouletteLogic();
final myHistory = <int>[];

// Agregar spins al historial
final spin = roulette.generateSpin();
myHistory.add(spin);

// Limitar a 20 elementos
if (myHistory.length > 20) {
  myHistory.removeAt(0);
}

// Usar para predicción
final prediction = roulette.predictNext(myHistory);
```

---

### Métodos Públicos

#### `generateSpin()`

Genera un nuevo número de ruleta aleatorio.

**Firma:**
```dart
int generateSpin()
```

**Retorna:** `int` - Número entre 0 y 36 (inclusive)

**Comportamiento:**
- Genera número aleatorio usando RNG seguro
- Agrega al historial (mantiene últimos 20)
- Retorna el número generado

**Ejemplo:**
```dart
final number = roulette.generateSpin();
print(number); // Puede ser cualquier número de 0 a 36

// Múltiples giros
for (var i = 0; i < 5; i++) {
  print('Giro ${i + 1}: ${roulette.generateSpin()}');
}
```

**Complejidad:** O(1)

---

#### `getColor(int number)`

Determina el color de un número de ruleta.

**Firma:**
```dart
String getColor(int number)
```

**Parámetros:**
- `number` (int): Número de ruleta (0-36)

**Retorna:** `String`
- `"green"` si number == 0
- `"red"` si number está en números rojos
- `"black"` si number está en números negros

**Throws:** `ArgumentError` si number < 0 o number > 36

**Ejemplo:**
```dart
print(roulette.getColor(0));  // "green"
print(roulette.getColor(1));  // "red"
print(roulette.getColor(2));  // "black"
print(roulette.getColor(32)); // "red"

// Manejo de errores
try {
  roulette.getColor(37); // ❌ Fuera de rango
} catch (e) {
  print('Error: $e');
}
```

**Complejidad:** O(1) - Usa Set para búsqueda

---

#### `predictNext(List<int> history)`

Genera predicción simple basada en historial proporcionado.

**Firma:**
```dart
int predictNext(List<int> history)
```

**Parámetros:**
- `history` (List<int>): Lista de números de giros previos

**Retorna:** `int` - Número sugerido (0-36)

**Algoritmo:**
1. Si historial está vacío: Retorna número aleatorio
2. Si historial tiene datos:
   - Calcula frecuencias de cada número
   - Retorna el número más frecuente

**Nota:** Las predicciones son educativas, no tienen valor real.

**Ejemplo:**
```dart
// Sin historial
print(roulette.predictNext([])); // Random number

// Con historial
final history = [5, 5, 5, 1, 2];
final prediction = roulette.predictNext(history);
print('Predicción: $prediction'); // 5 (más frecuente)

// Historial balanceado
final balancedHistory = [1, 2, 3, 4, 5];
final pred = roulette.predictNext(balancedHistory);
print('Predicción: $pred'); // Cualquiera de los más frecuentes
```

**Complejidad:** O(n) donde n es el tamaño del historial

---

### Métodos Privados

Nota: La implementación actual de `RouletteLogic` no tiene métodos privados. El historial se gestiona externamente por la aplicación que usa la clase.

---

## Estructuras de Datos

### Números Rojos

**Tipo:** `Set<int>`

**Definición:**
```dart
const Set<int> redNumbers = {
  1, 3, 5, 7, 9, 12, 14, 16, 18, 19,
  21, 23, 25, 27, 30, 32, 34, 36
};
```

**Total:** 18 números

**Uso:**
```dart
bool isRed = redNumbers.contains(number);
```

---

### Números Negros

**Tipo:** `Set<int>`

**Definición:**
```dart
const Set<int> blackNumbers = {
  2, 4, 6, 8, 10, 11, 13, 15, 17, 20,
  22, 24, 26, 28, 29, 31, 33, 35
};
```

**Total:** 18 números

**Uso:**
```dart
bool isBlack = blackNumbers.contains(number);
```

---

## Constantes

### Límites

```dart
const int MIN_NUMBER = 0;
const int MAX_NUMBER = 36;
const int MAX_HISTORY = 20;
const int MIN_PREDICTIONS = 1;
const int MAX_PREDICTIONS = 10;
```

### Colores

```dart
const String COLOR_RED = "red";
const String COLOR_BLACK = "black";
const String COLOR_GREEN = "green";
```

---

## Ejemplos de Uso

### Ejemplo 1: Juego Simple

```dart
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  final roulette = RouletteLogic();
  
  // Giro simple
  final number = roulette.generateSpin();
  final color = roulette.getColor(number);
  
  print('Número: $number');
  print('Color: $color');
}
```

### Ejemplo 2: Múltiples Giros con Historial

```dart
void playMultipleRounds() {
  final roulette = RouletteLogic();
  final history = <int>[];
  
  print('=== Jugando 10 rondas ===');
  for (var i = 0; i < 10; i++) {
    final number = roulette.generateSpin();
    final color = roulette.getColor(number);
    history.add(number);
    print('Ronda ${i + 1}: $number ($color)');
  }
  
  print('\n=== Historial ===');
  print(history);
}
```

### Ejemplo 3: Con Predicciones

```dart
void playWithPredictions() {
  final roulette = RouletteLogic();
  final history = <int>[];
  
  // Construir historial
  print('Construyendo historial...');
  for (var i = 0; i < 15; i++) {
    final spin = roulette.generateSpin();
    history.add(spin);
  }
  
  // Obtener predicción
  final prediction = roulette.predictNext(history);
  print('Predicción basada en historial: $prediction');
  
  // Siguiente giro
  final next = roulette.generateSpin();
  print('Resultado real: $next');
  
  // Verificar si acertó
  if (prediction == next) {
    print('¡Predicción correcta!');
  } else {
    print('Predicción incorrecta');
  }
}
```

### Ejemplo 4: Análisis de Frecuencias

```dart
void analyzeFrequencies() {
  final roulette = RouletteLogic();
  final frequencies = <int, int>{};
  
  // Girar 1000 veces
  for (var i = 0; i < 1000; i++) {
    final number = roulette.generateSpin();
    frequencies[number] = (frequencies[number] ?? 0) + 1;
  }
  
  // Analizar distribución
  print('=== Análisis de Frecuencias (1000 giros) ===');
  frequencies.forEach((number, count) {
    final percentage = (count / 1000 * 100).toStringAsFixed(2);
    print('Número $number: $count veces ($percentage%)');
  });
  
  // Estadísticas
  final average = frequencies.values.reduce((a, b) => a + b) / frequencies.length;
  print('\nPromedio por número: ${average.toStringAsFixed(2)}');
  print('Esperado (1000/37): ${(1000/37).toStringAsFixed(2)}');
}
```

### Ejemplo 5: Distribución de Colores

```dart
void analyzeColorDistribution() {
  final roulette = RouletteLogic();
  var redCount = 0;
  var blackCount = 0;
  var greenCount = 0;
  
  final rounds = 1000;
  for (var i = 0; i < rounds; i++) {
    final number = roulette.generateSpin();
    final color = roulette.getColor(number);
    
    switch (color) {
      case 'red':
        redCount++;
        break;
      case 'black':
        blackCount++;
        break;
      case 'green':
        greenCount++;
        break;
    }
  }
  
  print('=== Distribución de Colores ($rounds giros) ===');
  print('🔴 Rojo: $redCount (${(redCount/rounds*100).toStringAsFixed(2)}%)');
  print('⚫ Negro: $blackCount (${(blackCount/rounds*100).toStringAsFixed(2)}%)');
  print('🟢 Verde: $greenCount (${(greenCount/rounds*100).toStringAsFixed(2)}%)');
  
  print('\n=== Esperado ===');
  print('🔴 Rojo: 48.65%');
  print('⚫ Negro: 48.65%');
  print('🟢 Verde: 2.70%');
}
```

---

## Mejores Prácticas

### ✅ Hacer

```dart
// 1. Reutilizar instancia
final roulette = RouletteLogic();
for (var i = 0; i < 10; i++) {
  roulette.generateSpin();
}

// 2. Validar inputs
try {
  final color = roulette.getColor(userInput);
} catch (e) {
  print('Número inválido');
}

// 3. Usar const para búsquedas
bool isRed = redNumbers.contains(number); // O(1)
```

### ❌ Evitar

```dart
// 1. Crear instancia repetidamente
for (var i = 0; i < 10; i++) {
  final roulette = RouletteLogic(); // ❌ Innecesario
  roulette.generateSpin();
}

// 2. Modificar wheel directamente
roulette.wheel.add(37); // ❌ Rompe lógica

// 3. Confiar en predicciones
if (predictions.contains(next)) {
  bet(allMyMoney); // ❌ Predicciones son educativas
}
```

---

## Testing

### Unit Tests Recomendados

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    test('generateSpin retorna número válido', () {
      final number = roulette.generateSpin();
      expect(number, greaterThanOrEqualTo(0));
      expect(number, lessThanOrEqualTo(36));
    });

    test('getColor retorna color correcto', () {
      expect(roulette.getColor(0), equals('green'));
      expect(roulette.getColor(1), equals('red'));
      expect(roulette.getColor(2), equals('black'));
    });

    test('getColor lanza error para número inválido', () {
      expect(() => roulette.getColor(-1), throwsArgumentError);
      expect(() => roulette.getColor(37), throwsArgumentError);
    });

    test('predictNext retorna número basado en historial', () {
      final history = [5, 5, 5, 1, 2];
      final prediction = roulette.predictNext(history);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext con historial vacío retorna número válido', () {
      final prediction = roulette.predictNext([]);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });
  });
}
```

---

## Extensiones Futuras

### Posibles Mejoras

1. **Estadísticas Avanzadas**
```dart
class RouletteStats {
  Map<int, int> getFrequencies();
  double getRedPercentage();
  List<int> getHotNumbers();
  List<int> getColdNumbers();
}
```

2. **Tipos de Apuestas**
```dart
enum BetType {
  straight,  // Un número
  split,     // Dos números
  street,    // Tres números
  corner,    // Cuatro números
  line,      // Seis números
  red,       // Todos los rojos
  black,     // Todos los negros
  even,      // Pares
  odd,       // Impares
}
```

3. **Historial Persistente**
```dart
Future<void> saveHistory();
Future<void> loadHistory();
void clearHistory();
```

---

## Referencias

### Documentación Relacionada

- [USER_GUIDE.md](USER_GUIDE.md) - Guía de usuario
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitectura del sistema
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Convenciones de código

### Recursos Externos

- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Roulette Rules](https://en.wikipedia.org/wiki/Roulette)

---

**Última actualización**: Diciembre 2024  
**Versión de API**: 1.0.0  
**Mantenido por**: Tokyo Apps Team

**¿Preguntas sobre la API?**  
[Abre un issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues) o [discussion](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)
