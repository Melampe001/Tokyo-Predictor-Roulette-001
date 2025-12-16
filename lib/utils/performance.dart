import 'package:flutter/foundation.dart';

/// Monitor de rendimiento de la aplicación
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  
  final Map<String, DateTime> _operationStarts = {};
  final List<PerformanceMetric> _metrics = [];
  
  /// Inicia el seguimiento de una operación
  void startTracking(String operationName) {
    _operationStarts[operationName] = DateTime.now();
  }
  
  /// Finaliza el seguimiento de una operación y registra el tiempo
  void endTracking(String operationName) {
    final start = _operationStarts[operationName];
    if (start == null) {
      if (kDebugMode) {
        print('⚠️ No se encontró inicio para la operación: $operationName');
      }
      return;
    }
    
    final duration = DateTime.now().difference(start);
    final metric = PerformanceMetric(
      operationName: operationName,
      duration: duration,
      timestamp: DateTime.now(),
    );
    
    _metrics.add(metric);
    _operationStarts.remove(operationName);
    
    // Log si la operación es lenta (>500ms)
    if (duration.inMilliseconds > 500 && kDebugMode) {
      print('🐌 Operación lenta detectada: $operationName - ${duration.inMilliseconds}ms');
    }
  }
  
  /// Registra el frame rate actual
  void trackFrameRate(double fps) {
    if (fps < 55 && kDebugMode) {
      print('⚠️ Frame rate bajo detectado: ${fps.toStringAsFixed(2)} FPS');
    }
  }
  
  /// Registra el uso de memoria
  void trackMemoryUsage(double memoryMB) {
    if (memoryMB > 200 && kDebugMode) {
      print('⚠️ Uso alto de memoria: ${memoryMB.toStringAsFixed(2)} MB');
    }
  }
  
  /// Registra operaciones lentas
  void logSlowOperation(String operationName, Duration duration) {
    if (kDebugMode) {
      print('🐌 Operación lenta: $operationName - ${duration.inMilliseconds}ms');
    }
  }
  
  /// Obtiene todas las métricas registradas
  List<PerformanceMetric> getMetrics() => List.unmodifiable(_metrics);
  
  /// Obtiene el promedio de tiempo para una operación específica
  Duration? getAverageDuration(String operationName) {
    final operationMetrics = _metrics
        .where((m) => m.operationName == operationName)
        .toList();
    
    if (operationMetrics.isEmpty) return null;
    
    final totalMs = operationMetrics
        .map((m) => m.duration.inMilliseconds)
        .reduce((a, b) => a + b);
    
    return Duration(milliseconds: totalMs ~/ operationMetrics.length);
  }
  
  /// Limpia todas las métricas
  void clearMetrics() {
    _metrics.clear();
    _operationStarts.clear();
  }
  
  /// Obtiene un reporte de rendimiento
  String getPerformanceReport() {
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('Total operations tracked: ${_metrics.length}');
    
    final uniqueOperations = _metrics.map((m) => m.operationName).toSet();
    for (final operation in uniqueOperations) {
      final avg = getAverageDuration(operation);
      if (avg != null) {
        buffer.writeln('$operation: ${avg.inMilliseconds}ms avg');
      }
    }
    
    return buffer.toString();
  }
}

/// Métrica de rendimiento
class PerformanceMetric {
  final String operationName;
  final Duration duration;
  final DateTime timestamp;
  
  const PerformanceMetric({
    required this.operationName,
    required this.duration,
    required this.timestamp,
  });
}
