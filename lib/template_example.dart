// ============================================================================
// PLANTILLA DE CÓDIGO DART - GUÍA PARA NUEVOS COLABORADORES
// ============================================================================
//
// Este archivo sirve como referencia y plantilla para crear nuevos archivos
// Dart en el proyecto Tokyo Roulette Predicciones. Sigue las mejores prácticas
// de Dart y Flutter, y está diseñado para ser educativo y autocontenido.
//
// DOCUMENTACIÓN ESTÁNDAR:
// - Usa comentarios /// para documentación DartDoc (aparecen en autocompletado IDE)
// - Usa comentarios // para notas internas y explicaciones de implementación
// - Documenta todas las clases, métodos y propiedades públicas
// - Incluye ejemplos de uso cuando sea apropiado
//
// ESTRUCTURA RECOMENDADA:
// 1. Imports (organizados: dart, flutter, packages, relativos)
// 2. Constantes globales (si son necesarias)
// 3. Clases principales
// 4. Clases auxiliares
// 5. Extensiones (si las hay)
// 6. Funciones helper (si las hay)
//
// ============================================================================

// IMPORTS
// Primero las librerías dart: core
import 'dart:async';
import 'dart:math';

// Luego las dependencias de packages externos (alfabéticamente)
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Finalmente, imports relativos del proyecto
// import 'roulette_logic.dart';

// ============================================================================
// CONSTANTES GLOBALES
// ============================================================================
// Las constantes deben estar en mayúsculas con guiones bajos
// Úsalas para valores que no cambiarán durante la ejecución

/// Número máximo de intentos permitidos para una operación
const int MAX_RETRY_ATTEMPTS = 3;

/// Tiempo de espera predeterminado en milisegundos
const int DEFAULT_TIMEOUT_MS = 5000;

/// Prefijo para claves de almacenamiento local
const String STORAGE_KEY_PREFIX = 'tokyo_roulette_';

// ============================================================================
// ENUMERACIONES
// ============================================================================
// Usa enums para representar un conjunto fijo de valores relacionados
// Declaradas antes de las clases que las usan

/// Estados posibles del procesador
enum ProcessorState {
  /// Estado inicial, listo para procesar
  idle,

  /// Procesando datos actualmente
  processing,

  /// Completado exitosamente
  completed,

  /// Ocurrió un error
  error,
}

// ============================================================================
// CLASE PRINCIPAL - EJEMPLO
// ============================================================================

/// Clase de ejemplo que demuestra las mejores prácticas de Dart.
///
/// Esta clase muestra cómo estructurar una clase Dart con documentación
/// completa, propiedades, constructores, métodos y manejo de errores.
///
/// **Ejemplo de uso:**
/// ```dart
/// final calculator = DataProcessor(
///   name: 'Procesador Principal',
///   maxItems: 100,
/// );
///
/// final result = await calculator.processData([1, 2, 3, 4, 5]);
/// print('Resultado: $result');
/// ```
///
/// **Notas importantes:**
/// - Esta clase es inmutable cuando se usa con propiedades finales
/// - Usa async/await para operaciones asíncronas
/// - Implementa manejo de errores apropiado
class DataProcessor {
  // ==========================================================================
  // PROPIEDADES
  // ==========================================================================
  // Usa 'final' para propiedades que no cambian después de la construcción
  // Usa propiedades privadas (con _) cuando no deben ser accesibles externamente

  /// Nombre identificador del procesador
  final String name;

  /// Número máximo de elementos que puede procesar
  final int maxItems;

  /// Indica si el procesador está en modo debug
  final bool debugMode;

  /// Contador interno de operaciones procesadas (privado)
  int _operationCount = 0;

  /// Estado interno del procesador
  ProcessorState _state = ProcessorState.idle;

  // ==========================================================================
  // GETTERS Y SETTERS
  // ==========================================================================
  // Usa getters para propiedades calculadas o para exponer estado privado

  /// Obtiene el número total de operaciones procesadas
  int get operationCount => _operationCount;

  /// Obtiene el estado actual del procesador
  ProcessorState get state => _state;

  /// Verifica si el procesador está disponible para procesar datos
  bool get isReady => _state == ProcessorState.idle;

  // ==========================================================================
  // CONSTRUCTORES
  // ==========================================================================

  /// Constructor principal con parámetros nombrados.
  ///
  /// [name] es el identificador del procesador
  /// [maxItems] especifica el límite de elementos (por defecto 50)
  /// [debugMode] activa mensajes de depuración (por defecto false)
  DataProcessor({
    required this.name,
    this.maxItems = 50,
    this.debugMode = false,
  }) {
    // Validación en el constructor
    if (maxItems <= 0) {
      throw ArgumentError('maxItems debe ser mayor que 0');
    }
    if (name.isEmpty) {
      throw ArgumentError('name no puede estar vacío');
    }

    if (debugMode) {
      print('[DEBUG] DataProcessor creado: $name (max: $maxItems)');
    }
  }

  /// Constructor factory para crear un procesador con configuración por defecto
  factory DataProcessor.withDefaults() {
    return DataProcessor(
      name: 'Procesador Estándar',
      maxItems: 50,
      debugMode: false,
    );
  }

  /// Constructor factory para crear un procesador desde un mapa de configuración
  ///
  /// Útil para deserializar desde JSON o configuración externa
  factory DataProcessor.fromConfig(Map<String, dynamic> config) {
    return DataProcessor(
      name: config['name'] as String? ?? 'Sin nombre',
      maxItems: config['maxItems'] as int? ?? 50,
      debugMode: config['debugMode'] as bool? ?? false,
    );
  }

  // ==========================================================================
  // MÉTODOS PÚBLICOS
  // ==========================================================================

  /// Procesa una lista de datos numéricos y retorna el resultado.
  ///
  /// Este método demuestra:
  /// - Operaciones asíncronas con async/await
  /// - Manejo de errores con try-catch
  /// - Validación de entrada
  /// - Actualización de estado interno
  ///
  /// [data] es la lista de números a procesar
  ///
  /// Retorna la suma de todos los elementos procesados
  ///
  /// Lanza [ArgumentError] si la lista está vacía o excede [maxItems]
  /// Lanza [StateError] si el procesador no está en estado idle
  Future<double> processData(List<num> data) async {
    // Validación de precondiciones
    if (!isReady) {
      throw StateError('El procesador está ocupado (estado: $_state)');
    }

    if (data.isEmpty) {
      throw ArgumentError('La lista de datos no puede estar vacía');
    }

    if (data.length > maxItems) {
      throw ArgumentError(
        'La lista excede el límite de $maxItems elementos',
      );
    }

    // Cambiar estado a procesando
    _state = ProcessorState.processing;

    try {
      if (debugMode) {
        print('[DEBUG] Procesando ${data.length} elementos...');
      }

      // Simular procesamiento asíncrono
      await Future.delayed(Duration(milliseconds: 100));

      // Realizar cálculo
      final result = _calculateSum(data);

      // Incrementar contador
      _operationCount++;

      if (debugMode) {
        print('[DEBUG] Procesamiento completado. Resultado: $result');
      }

      return result;
    } catch (e) {
      if (debugMode) {
        print('[ERROR] Error durante procesamiento: $e');
      }
      _state = ProcessorState.error;
      rethrow; // Re-lanzar la excepción
    } finally {
      // Restaurar estado si no hubo error
      if (_state != ProcessorState.error) {
        _state = ProcessorState.idle;
      }
    }
  }

  /// Calcula estadísticas básicas de un conjunto de datos.
  ///
  /// Retorna un [Statistics] con min, max, promedio y mediana
  Future<Statistics> calculateStatistics(List<num> data) async {
    if (data.isEmpty) {
      throw ArgumentError('Se requiere al menos un elemento');
    }

    await Future.delayed(Duration(milliseconds: 50));

    final sorted = List<num>.from(data)..sort();
    final min = sorted.first;
    final max = sorted.last;
    final average = data.reduce((a, b) => a + b) / data.length;
    final median = sorted.length.isOdd
        ? sorted[sorted.length ~/ 2].toDouble()
        : (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2;

    return Statistics(
      min: min.toDouble(),
      max: max.toDouble(),
      average: average.toDouble(),
      median: median,
      count: data.length,
    );
  }

  /// Reinicia el procesador a su estado inicial
  void reset() {
    _operationCount = 0;
    _state = ProcessorState.idle;

    if (debugMode) {
      print('[DEBUG] Procesador reiniciado');
    }
  }

  // ==========================================================================
  // MÉTODOS PRIVADOS
  // ==========================================================================
  // Los métodos privados empiezan con _ y no están disponibles externamente
  // Se usan para encapsular lógica interna

  /// Calcula la suma de una lista de números (método privado)
  double _calculateSum(List<num> data) {
    return data.fold(0.0, (sum, element) => sum + element);
  }

  /// Valida que los datos cumplan criterios internos
  bool _validateData(List<num> data) {
    return data.every((element) => element.isFinite);
  }

  // ==========================================================================
  // SOBRESCRITURA DE MÉTODOS
  // ==========================================================================

  @override
  String toString() {
    return 'DataProcessor(name: $name, maxItems: $maxItems, '
        'operationCount: $_operationCount, state: $_state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataProcessor &&
        other.name == name &&
        other.maxItems == maxItems;
  }

  @override
  int get hashCode => name.hashCode ^ maxItems.hashCode;
}

// ============================================================================
// CLASES DE DATOS (DATA CLASSES)
// ============================================================================
// Clases simples para almacenar datos relacionados

/// Clase inmutable que almacena estadísticas calculadas
///
/// Esta es una clase de datos simple que demuestra:
/// - Inmutabilidad (todas las propiedades son final)
/// - Constructor conciso
/// - Sobrescritura de métodos útiles
class Statistics {
  /// Valor mínimo encontrado
  final double min;

  /// Valor máximo encontrado
  final double max;

  /// Promedio de todos los valores
  final double average;

  /// Mediana del conjunto de datos
  final double median;

  /// Cantidad total de elementos
  final int count;

  /// Constructor con todos los parámetros requeridos
  const Statistics({
    required this.min,
    required this.max,
    required this.average,
    required this.median,
    required this.count,
  });

  /// Crea una copia de esta instancia con valores modificados
  Statistics copyWith({
    double? min,
    double? max,
    double? average,
    double? median,
    int? count,
  }) {
    return Statistics(
      min: min ?? this.min,
      max: max ?? this.max,
      average: average ?? this.average,
      median: median ?? this.median,
      count: count ?? this.count,
    );
  }

  /// Convierte a un mapa para serialización
  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'average': average,
      'median': median,
      'count': count,
    };
  }

  /// Crea una instancia desde un mapa
  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      average: (json['average'] as num).toDouble(),
      median: (json['median'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  @override
  String toString() {
    return 'Statistics(min: $min, max: $max, avg: $average, '
        'median: $median, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Statistics &&
        other.min == min &&
        other.max == max &&
        other.average == average &&
        other.median == median &&
        other.count == count;
  }

  @override
  int get hashCode {
    return min.hashCode ^
        max.hashCode ^
        average.hashCode ^
        median.hashCode ^
        count.hashCode;
  }
}

// ============================================================================
// CLASES ABSTRACTAS E INTERFACES
// ============================================================================
// Usa clases abstractas para definir contratos que otras clases deben cumplir

/// Interfaz abstracta para procesadores de datos
///
/// Define el contrato que todos los procesadores deben implementar
abstract class IDataHandler {
  /// Procesa datos de entrada y retorna un resultado
  Future<dynamic> process(List<dynamic> data);

  /// Valida los datos antes de procesarlos
  bool validate(List<dynamic> data);

  /// Limpia recursos y resetea el estado
  void cleanup();
}

// ============================================================================
// EXTENSIONES
// ============================================================================
// Las extensiones añaden funcionalidad a tipos existentes sin modificarlos

/// Extensión que añade métodos útiles a List<num>
extension NumListExtension on List<num> {
  /// Calcula la suma de todos los elementos
  double sum() => fold(0.0, (sum, element) => sum + element);

  /// Calcula el promedio de todos los elementos
  double average() => isEmpty ? 0.0 : sum() / length;

  /// Encuentra el valor máximo o retorna 0 si está vacía
  double maxOrZero() {
    if (isEmpty) return 0.0;
    return reduce((a, b) => max(a, b)).toDouble();
  }

  /// Encuentra el valor mínimo o retorna 0 si está vacía
  double minOrZero() {
    if (isEmpty) return 0.0;
    return reduce((a, b) => min(a, b)).toDouble();
  }
}

// ============================================================================
// FUNCIONES HELPER/UTILIDAD
// ============================================================================
// Funciones globales que proporcionan utilidades reutilizables

/// Genera una lista de números aleatorios para pruebas
///
/// [count] especifica cuántos números generar
/// [min] es el valor mínimo (inclusive)
/// [max] es el valor máximo (exclusive)
///
/// Ejemplo:
/// ```dart
/// final numbers = generateRandomNumbers(10, min: 0, max: 100);
/// ```
List<int> generateRandomNumbers(int count, {int min = 0, int max = 100}) {
  if (count <= 0) {
    throw ArgumentError('count debe ser mayor que 0');
  }

  if (min >= max) {
    throw ArgumentError('min debe ser menor que max');
  }

  final random = Random();
  return List.generate(
    count,
    (_) => min + random.nextInt(max - min),
  );
}

/// Formatea un número decimal con una cantidad específica de decimales
///
/// [value] es el número a formatear
/// [decimals] especifica cuántos decimales mostrar
String formatDecimal(double value, {int decimals = 2}) {
  return value.toStringAsFixed(decimals);
}

// ============================================================================
// PRUEBAS UNITARIAS - SUGERENCIAS
// ============================================================================
//
// Para probar el código en este archivo, crea un archivo correspondiente
// en test/template_example_test.dart con la siguiente estructura:
//
// ```dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tokyo_roulette_predicciones/template_example.dart';
//
// void main() {
//   group('DataProcessor Tests', () {
//     late DataProcessor processor;
//
//     setUp(() {
//       processor = DataProcessor(name: 'Test', maxItems: 10);
//     });
//
//     test('debe procesar datos correctamente', () async {
//       final result = await processor.processData([1, 2, 3, 4, 5]);
//       expect(result, equals(15.0));
//       expect(processor.operationCount, equals(1));
//     });
//
//     test('debe lanzar error con lista vacía', () {
//       expect(
//         () => processor.processData([]),
//         throwsArgumentError,
//       );
//     });
//
//     test('debe calcular estadísticas correctamente', () async {
//       final stats = await processor.calculateStatistics([1, 2, 3, 4, 5]);
//       expect(stats.min, equals(1.0));
//       expect(stats.max, equals(5.0));
//       expect(stats.average, equals(3.0));
//     });
//   });
//
//   group('Statistics Tests', () {
//     test('debe crear instancia correctamente', () {
//       final stats = Statistics(
//         min: 1.0,
//         max: 10.0,
//         average: 5.5,
//         median: 5.0,
//         count: 10,
//       );
//       expect(stats.count, equals(10));
//     });
//
//     test('debe serializar y deserializar correctamente', () {
//       final original = Statistics(
//         min: 1.0,
//         max: 10.0,
//         average: 5.5,
//         median: 5.0,
//         count: 10,
//       );
//       final json = original.toJson();
//       final restored = Statistics.fromJson(json);
//       expect(restored, equals(original));
//     });
//   });
//
//   group('Extension Tests', () {
//     test('debe calcular suma correctamente', () {
//       final numbers = [1, 2, 3, 4, 5];
//       expect(numbers.sum(), equals(15.0));
//     });
//
//     test('debe calcular promedio correctamente', () {
//       final numbers = [1, 2, 3, 4, 5];
//       expect(numbers.average(), equals(3.0));
//     });
//   });
// }
// ```
//
// Ejecuta las pruebas con: flutter test
//
// ============================================================================
// SUGERENCIAS DE EXTENSIÓN Y MEJORES PRÁCTICAS
// ============================================================================
//
// 1. MODULARIDAD:
//    - Mantén las clases pequeñas y enfocadas en una sola responsabilidad
//    - Separa la lógica de negocio de la presentación (UI)
//    - Usa composición sobre herencia cuando sea posible
//
// 2. MANEJO DE ERRORES:
//    - Usa try-catch para operaciones que pueden fallar
//    - Lanza excepciones específicas (ArgumentError, StateError, etc.)
//    - Documenta qué excepciones puede lanzar un método
//
// 3. CÓDIGO ASÍNCRONO:
//    - Usa async/await para operaciones asíncronas
//    - Considera usar Stream para datos continuos
//    - Maneja correctamente los errores en código asíncrono
//
// 4. INMUTABILIDAD:
//    - Prefiere 'final' sobre 'var' cuando los valores no cambien
//    - Usa 'const' para valores conocidos en tiempo de compilación
//    - Considera usar paquetes como 'freezed' para clases inmutables complejas
//
// 5. DOCUMENTACIÓN:
//    - Documenta el 'qué' y el 'por qué', no el 'cómo' (el código muestra el cómo)
//    - Incluye ejemplos de uso en la documentación
//    - Mantén la documentación actualizada con el código
//
// 6. TESTING:
//    - Escribe tests para toda la lógica de negocio
//    - Usa mocks para dependencias externas
//    - Apunta a una cobertura de código >80%
//
// 7. RENDIMIENTO:
//    - Evita operaciones costosas en constructores
//    - Usa 'const' constructores cuando sea posible para reducir instancias
//    - Considera lazy loading para datos grandes
//
// 8. SEGURIDAD:
//    - Nunca almacenes credenciales en el código
//    - Valida siempre la entrada del usuario
//    - Usa el paquete 'crypto' para operaciones criptográficas
//
// 9. ESTILO DE CÓDIGO:
//    - Sigue las guías oficiales de Dart: https://dart.dev/guides/language/effective-dart
//    - Usa el formateador automático: dart format .
//    - Usa el analizador estático: dart analyze
//
// 10. PAQUETES ÚTILES:
//     - equatable: Para comparación de objetos simplificada
//     - freezed: Para clases de datos inmutables con copyWith
//     - dartz: Para programación funcional (Either, Option, etc.)
//     - rxdart: Para programación reactiva avanzada
//     - get_it: Para inyección de dependencias
//
// ============================================================================
// FIN DE LA PLANTILLA
// ============================================================================
