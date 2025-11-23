/// Monitoring and metrics collection for agents and bots
/// Provides hooks for performance tracking and observability

import 'dart:collection';

/// Metric types for monitoring
enum MetricType {
  counter,
  gauge,
  histogram,
}

/// Metric data structure
class Metric {
  final String name;
  final MetricType type;
  final dynamic value;
  final DateTime timestamp;
  final Map<String, String>? tags;

  Metric({
    required this.name,
    required this.type,
    required this.value,
    DateTime? timestamp,
    this.tags,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.toString(),
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'tags': tags,
      };
}

/// Monitor for collecting and aggregating metrics
class Monitor {
  final String name;
  final List<Metric> _metrics = [];
  final void Function(Metric metric)? onMetricCollected;

  Monitor(this.name, {this.onMetricCollected});

  /// Record a counter metric (incremental value)
  void recordCounter(String metricName, int value, {Map<String, String>? tags}) {
    _recordMetric(Metric(
      name: metricName,
      type: MetricType.counter,
      value: value,
      tags: tags,
    ));
  }

  /// Record a gauge metric (point-in-time value)
  void recordGauge(String metricName, double value, {Map<String, String>? tags}) {
    _recordMetric(Metric(
      name: metricName,
      type: MetricType.gauge,
      value: value,
      tags: tags,
    ));
  }

  /// Record a histogram metric (distribution of values)
  void recordHistogram(String metricName, double value, {Map<String, String>? tags}) {
    _recordMetric(Metric(
      name: metricName,
      type: MetricType.histogram,
      value: value,
      tags: tags,
    ));
  }

  void _recordMetric(Metric metric) {
    _metrics.add(metric);
    onMetricCollected?.call(metric);
  }

  /// Get all collected metrics
  UnmodifiableListView<Metric> get metrics => UnmodifiableListView(_metrics);

  /// Clear all metrics
  void clear() => _metrics.clear();

  /// Get metrics summary
  Map<String, dynamic> getSummary() {
    final summary = <String, dynamic>{
      'name': name,
      'total_metrics': _metrics.length,
      'metrics_by_type': <String, int>{},
    };

    for (final metric in _metrics) {
      final type = metric.type.toString();
      summary['metrics_by_type'][type] = 
          (summary['metrics_by_type'][type] as int? ?? 0) + 1;
    }

    return summary;
  }
}
