import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Servicio de Performance Monitoring de Firebase
/// 
/// Monitorea el rendimiento de la app:
/// - Tiempos de carga
/// - Operaciones de red
/// - Operaciones de base de datos
/// - Renderizado de pantallas
class PerformanceService {
  final FirebasePerformance _performance = FirebasePerformance.instance;

  // Mapa para mantener traces activos
  final Map<String, Trace> _activeTraces = {};

  /// Inicializar Performance Monitoring
  /// 
  /// Configura ajustes y habilita recopilación
  Future<void> initialize() async {
    try {
      // Habilitar recopilación de performance (solo en release)
      await _performance.setPerformanceCollectionEnabled(!kDebugMode);
      
      debugPrint('Performance Monitoring inicializado');
    } catch (e) {
      debugPrint('Error al inicializar Performance Monitoring: $e');
    }
  }

  // ==================== TRACES ====================

  /// Iniciar un trace personalizado
  /// 
  /// [traceName] Nombre único del trace
  /// Returns: Trace iniciado
  Future<Trace?> startTrace(String traceName) async {
    try {
      // Si ya existe un trace con este nombre, retornar el existente
      if (_activeTraces.containsKey(traceName)) {
        debugPrint('Trace $traceName ya existe, retornando existente');
        return _activeTraces[traceName];
      }
      
      final trace = _performance.newTrace(traceName);
      await trace.start();
      
      _activeTraces[traceName] = trace;
      
      if (kDebugMode) {
        debugPrint('Trace iniciado: $traceName');
      }
      
      return trace;
    } catch (e) {
      debugPrint('Error al iniciar trace: $e');
      return null;
    }
  }

  /// Detener un trace
  /// 
  /// [traceName] Nombre del trace a detener
  Future<void> stopTrace(String traceName) async {
    try {
      final trace = _activeTraces[traceName];
      
      if (trace == null) {
        debugPrint('Trace $traceName no encontrado');
        return;
      }
      
      await trace.stop();
      _activeTraces.remove(traceName);
      
      if (kDebugMode) {
        debugPrint('Trace detenido: $traceName');
      }
    } catch (e) {
      debugPrint('Error al detener trace: $e');
    }
  }

  /// Agregar métrica a un trace
  /// 
  /// [traceName] Nombre del trace
  /// [metricName] Nombre de la métrica
  /// [value] Valor de la métrica
  Future<void> setMetric(
    String traceName,
    String metricName,
    int value,
  ) async {
    try {
      final trace = _activeTraces[traceName];
      
      if (trace == null) {
        debugPrint('Trace $traceName no encontrado para agregar métrica');
        return;
      }
      
      trace.setMetric(metricName, value);
      
      if (kDebugMode) {
        debugPrint('Métrica agregada a $traceName: $metricName = $value');
      }
    } catch (e) {
      debugPrint('Error al agregar métrica: $e');
    }
  }

  /// Incrementar métrica en un trace
  /// 
  /// [traceName] Nombre del trace
  /// [metricName] Nombre de la métrica
  /// [incrementBy] Cantidad a incrementar (default: 1)
  Future<void> incrementMetric(
    String traceName,
    String metricName, {
    int incrementBy = 1,
  }) async {
    try {
      final trace = _activeTraces[traceName];
      
      if (trace == null) {
        debugPrint('Trace $traceName no encontrado para incrementar métrica');
        return;
      }
      
      trace.incrementMetric(metricName, incrementBy);
      
      if (kDebugMode) {
        debugPrint('Métrica incrementada en $traceName: $metricName +$incrementBy');
      }
    } catch (e) {
      debugPrint('Error al incrementar métrica: $e');
    }
  }

  /// Agregar atributo a un trace
  /// 
  /// [traceName] Nombre del trace
  /// [attribute] Nombre del atributo
  /// [value] Valor del atributo
  Future<void> putAttribute(
    String traceName,
    String attribute,
    String value,
  ) async {
    try {
      final trace = _activeTraces[traceName];
      
      if (trace == null) {
        debugPrint('Trace $traceName no encontrado para agregar atributo');
        return;
      }
      
      trace.putAttribute(attribute, value);
      
      if (kDebugMode) {
        debugPrint('Atributo agregado a $traceName: $attribute = $value');
      }
    } catch (e) {
      debugPrint('Error al agregar atributo: $e');
    }
  }

  // ==================== TRACES PRE-DEFINIDOS ====================

  /// Medir tiempo de inicio de la app
  Future<void> traceAppStartup() async {
    final trace = await startTrace('app_startup');
    // El trace debe detenerse manualmente cuando la app esté lista
    // Típicamente después de que se cargue la primera pantalla
  }

  /// Detener trace de inicio de app
  Future<void> stopAppStartupTrace() async {
    await stopTrace('app_startup');
  }

  /// Medir tiempo de cálculo de predicción
  Future<T> tracePredictionCalculation<T>(
    Future<T> Function() calculation,
  ) async {
    const traceName = 'prediction_calculation';
    await startTrace(traceName);
    
    try {
      final result = await calculation();
      await stopTrace(traceName);
      return result;
    } catch (e) {
      await stopTrace(traceName);
      rethrow;
    }
  }

  /// Medir tiempo de giro de ruleta
  Future<T> traceRouletteSpin<T>(Future<T> Function() spin) async {
    const traceName = 'roulette_spin';
    await startTrace(traceName);
    
    try {
      final result = await spin();
      await stopTrace(traceName);
      return result;
    } catch (e) {
      await stopTrace(traceName);
      rethrow;
    }
  }

  /// Medir operación de base de datos
  Future<T> traceFirestoreOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final traceName = 'firestore_$operationName';
    await startTrace(traceName);
    
    try {
      final result = await operation();
      await stopTrace(traceName);
      return result;
    } catch (e) {
      await stopTrace(traceName);
      rethrow;
    }
  }

  /// Medir renderizado de pantalla
  Future<T> traceScreenLoad<T>(
    String screenName,
    Future<T> Function() loadScreen,
  ) async {
    final traceName = 'screen_$screenName';
    await startTrace(traceName);
    
    try {
      final result = await loadScreen();
      await stopTrace(traceName);
      return result;
    } catch (e) {
      await stopTrace(traceName);
      rethrow;
    }
  }

  /// Medir operación de autenticación
  Future<T> traceAuthOperation<T>(
    String operationType,
    Future<T> Function() operation,
  ) async {
    final traceName = 'auth_$operationType';
    await startTrace(traceName);
    
    try {
      final result = await operation();
      await stopTrace(traceName);
      return result;
    } catch (e) {
      await stopTrace(traceName);
      rethrow;
    }
  }

  // ==================== HTTP TRACES ====================

  /// Crear trace de HTTP
  /// 
  /// [url] URL de la petición
  /// [method] Método HTTP (GET, POST, etc.)
  /// Returns: HttpMetric para la petición
  HttpMetric? createHttpMetric(String url, HttpMethod method) {
    try {
      return _performance.newHttpMetric(url, method);
    } catch (e) {
      debugPrint('Error al crear HTTP metric: $e');
      return null;
    }
  }

  /// Wrapper para peticiones HTTP con monitoring
  /// 
  /// [url] URL de la petición
  /// [method] Método HTTP
  /// [request] Función que realiza la petición
  Future<T> traceHttpRequest<T>(
    String url,
    HttpMethod method,
    Future<T> Function() request,
  ) async {
    HttpMetric? metric;
    
    try {
      metric = createHttpMetric(url, method);
      await metric?.start();
      
      final result = await request();
      
      // Establecer código de respuesta exitoso
      metric?.httpResponseCode = 200;
      await metric?.stop();
      
      return result;
    } catch (e) {
      // Establecer código de error
      metric?.httpResponseCode = 500;
      await metric?.stop();
      rethrow;
    }
  }

  // ==================== UTILIDADES ====================

  /// Wrapper genérico para medir cualquier operación
  /// 
  /// [name] Nombre del trace
  /// [operation] Operación a medir
  /// [attributes] Atributos adicionales (opcional)
  /// [metrics] Métricas adicionales (opcional)
  Future<T> trace<T>(
    String name,
    Future<T> Function() operation, {
    Map<String, String>? attributes,
    Map<String, int>? metrics,
  }) async {
    await startTrace(name);
    
    // Agregar atributos si se proporcionaron
    if (attributes != null) {
      for (final entry in attributes.entries) {
        await putAttribute(name, entry.key, entry.value);
      }
    }
    
    // Agregar métricas si se proporcionaron
    if (metrics != null) {
      for (final entry in metrics.entries) {
        await setMetric(name, entry.key, entry.value);
      }
    }
    
    try {
      final result = await operation();
      await stopTrace(name);
      return result;
    } catch (e) {
      await stopTrace(name);
      rethrow;
    }
  }

  /// Medir función síncrona
  /// 
  /// [name] Nombre del trace
  /// [operation] Operación a medir
  T traceSync<T>(String name, T Function() operation) {
    // Para operaciones síncronas, usar Stopwatch
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = operation();
      stopwatch.stop();
      
      if (kDebugMode) {
        debugPrint('$name completado en ${stopwatch.elapsedMilliseconds}ms');
      }
      
      return result;
    } catch (e) {
      stopwatch.stop();
      rethrow;
    }
  }

  /// Limpiar traces activos (útil al cerrar sesión o limpiar estado)
  Future<void> clearActiveTraces() async {
    try {
      for (final traceName in _activeTraces.keys.toList()) {
        await stopTrace(traceName);
      }
      _activeTraces.clear();
      debugPrint('Traces activos limpiados');
    } catch (e) {
      debugPrint('Error al limpiar traces: $e');
    }
  }

  /// Habilitar o deshabilitar recopilación de performance
  /// 
  /// [enabled] Si se debe recopilar o no
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    try {
      await _performance.setPerformanceCollectionEnabled(enabled);
      debugPrint('Recopilación de Performance: $enabled');
    } catch (e) {
      debugPrint('Error al configurar recopilación de Performance: $e');
    }
  }

  /// Verificar si Performance Monitoring está habilitado
  /// 
  /// Returns: true si está habilitado
  Future<bool> isPerformanceCollectionEnabled() async {
    try {
      return await _performance.isPerformanceCollectionEnabled();
    } catch (e) {
      debugPrint('Error al verificar estado de Performance: $e');
      return false;
    }
  }
}
