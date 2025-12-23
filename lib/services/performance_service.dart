import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Service for handling Firebase Performance Monitoring
class PerformanceService {
  final FirebasePerformance _performance = FirebasePerformance.instance;

  bool _isInitialized = false;

  // Trace names
  static const String traceAppStart = 'app_start';
  static const String traceScreenLoad = 'screen_load';
  static const String traceDatabaseQuery = 'database_query';
  static const String traceApiCall = 'api_call';
  static const String tracePredictionCalculation = 'prediction_calculation';
  static const String traceGameSession = 'game_session';
  static const String traceAuthentication = 'authentication';

  /// Initialize Performance Monitoring
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Performance monitoring is automatically enabled
      // You can disable it manually if needed
      await _performance.setPerformanceCollectionEnabled(true);

      _isInitialized = true;

      if (kDebugMode) {
        print('Performance monitoring initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Performance monitoring initialization error: $e');
      }
    }
  }

  /// Create a new trace
  Trace newTrace(String name) {
    return _performance.newTrace(name);
  }

  /// Start app start trace
  Future<Trace> startAppStartTrace() async {
    final trace = _performance.newTrace(traceAppStart);
    await trace.start();

    if (kDebugMode) {
      print('Performance: App start trace started');
    }

    return trace;
  }

  /// Start screen load trace
  Future<Trace> startScreenLoadTrace(String screenName) async {
    final trace = _performance.newTrace('$traceScreenLoad-$screenName');
    await trace.start();

    if (kDebugMode) {
      print('Performance: Screen load trace started for $screenName');
    }

    return trace;
  }

  /// Start database query trace
  Future<Trace> startDatabaseQueryTrace(String queryName) async {
    final trace = _performance.newTrace('$traceDatabaseQuery-$queryName');
    await trace.start();

    if (kDebugMode) {
      print('Performance: Database query trace started for $queryName');
    }

    return trace;
  }

  /// Start API call trace
  Future<Trace> startApiCallTrace(String apiName) async {
    final trace = _performance.newTrace('$traceApiCall-$apiName');
    await trace.start();

    if (kDebugMode) {
      print('Performance: API call trace started for $apiName');
    }

    return trace;
  }

  /// Start prediction calculation trace
  Future<Trace> startPredictionTrace() async {
    final trace = _performance.newTrace(tracePredictionCalculation);
    await trace.start();

    if (kDebugMode) {
      print('Performance: Prediction calculation trace started');
    }

    return trace;
  }

  /// Start game session trace
  Future<Trace> startGameSessionTrace() async {
    final trace = _performance.newTrace(traceGameSession);
    await trace.start();

    if (kDebugMode) {
      print('Performance: Game session trace started');
    }

    return trace;
  }

  /// Start authentication trace
  Future<Trace> startAuthTrace(String authMethod) async {
    final trace = _performance.newTrace('$traceAuthentication-$authMethod');
    await trace.start();

    if (kDebugMode) {
      print('Performance: Authentication trace started for $authMethod');
    }

    return trace;
  }

  /// Stop a trace and record metrics
  Future<void> stopTrace(
    Trace trace, {
    Map<String, int>? metrics,
    Map<String, String>? attributes,
  }) async {
    try {
      // Set metrics
      if (metrics != null) {
        for (final entry in metrics.entries) {
          trace.setMetric(entry.key, entry.value);
        }
      }

      // Set attributes
      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value);
        }
      }

      await trace.stop();

      if (kDebugMode) {
        print('Performance: Trace stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Performance: Error stopping trace: $e');
      }
    }
  }

  /// Create and execute a traced operation
  Future<T> traceOperation<T>(
    String traceName,
    Future<T> Function() operation, {
    Map<String, int>? metrics,
    Map<String, String>? attributes,
  }) async {
    final trace = _performance.newTrace(traceName);

    try {
      await trace.start();

      final result = await operation();

      // Set metrics
      if (metrics != null) {
        for (final entry in metrics.entries) {
          trace.setMetric(entry.key, entry.value);
        }
      }

      // Set attributes
      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value);
        }
      }

      await trace.stop();

      return result;
    } catch (e) {
      await trace.stop();
      rethrow;
    }
  }

  /// Monitor HTTP requests automatically
  HttpMetric newHttpMetric(String url, HttpMethod httpMethod) {
    return _performance.newHttpMetric(url, httpMethod);
  }

  /// Start HTTP metric
  Future<HttpMetric> startHttpMetric(
    String url,
    HttpMethod method,
  ) async {
    final metric = _performance.newHttpMetric(url, method);
    await metric.start();

    if (kDebugMode) {
      print('Performance: HTTP metric started for $url');
    }

    return metric;
  }

  /// Stop HTTP metric
  Future<void> stopHttpMetric(
    HttpMetric metric, {
    int? httpResponseCode,
    int? requestPayloadSize,
    int? responsePayloadSize,
    String? responseContentType,
    Map<String, String>? attributes,
  }) async {
    try {
      if (httpResponseCode != null) {
        metric.httpResponseCode = httpResponseCode;
      }

      if (requestPayloadSize != null) {
        metric.requestPayloadSize = requestPayloadSize;
      }

      if (responsePayloadSize != null) {
        metric.responsePayloadSize = responsePayloadSize;
      }

      if (responseContentType != null) {
        metric.responseContentType = responseContentType;
      }

      if (attributes != null) {
        for (final entry in attributes.entries) {
          metric.putAttribute(entry.key, entry.value);
        }
      }

      await metric.stop();

      if (kDebugMode) {
        print('Performance: HTTP metric stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Performance: Error stopping HTTP metric: $e');
      }
    }
  }

  /// Trace a prediction operation
  Future<T> tracePrediction<T>(Future<T> Function() operation) async {
    return traceOperation(
      tracePredictionCalculation,
      operation,
      attributes: {
        'operation_type': 'prediction',
      },
    );
  }

  /// Trace a database operation
  Future<T> traceDatabaseOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    return traceOperation(
      '$traceDatabaseQuery-$operationName',
      operation,
      attributes: {
        'operation_type': 'database',
        'operation_name': operationName,
      },
    );
  }

  /// Trace screen rendering
  Future<void> traceScreenRender(
    String screenName,
    Future<void> Function() renderOperation,
  ) async {
    await traceOperation(
      '$traceScreenLoad-$screenName',
      renderOperation,
      attributes: {
        'screen_name': screenName,
      },
    );
  }

  /// Enable/disable performance collection
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    try {
      await _performance.setPerformanceCollectionEnabled(enabled);

      if (kDebugMode) {
        print('Performance collection ${enabled ? "enabled" : "disabled"}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting performance collection: $e');
      }
    }
  }

  /// Check if performance collection is enabled
  Future<bool> isPerformanceCollectionEnabled() async {
    return await _performance.isPerformanceCollectionEnabled();
  }
}
