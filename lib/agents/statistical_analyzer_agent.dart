/// Statistical Analyzer Agent - Advanced statistical modeling and analysis
/// Provides comprehensive statistical insights into roulette outcomes

import 'dart:math';
import '../core/base_agent.dart';
import '../core/logger.dart';

/// Statistical model result
class StatisticalModel {
  final String modelType;
  final Map<String, dynamic> parameters;
  final double fitQuality;
  final List<String> insights;

  StatisticalModel({
    required this.modelType,
    required this.parameters,
    required this.fitQuality,
    required this.insights,
  });

  Map<String, dynamic> toJson() => {
        'model_type': modelType,
        'parameters': parameters,
        'fit_quality': fitQuality,
        'insights': insights,
      };
}

/// Statistical Analyzer Agent
class StatisticalAnalyzerAgent extends AbstractAgent {
  final List<int> _dataset = [];
  final Map<int, int> _frequency = {};

  StatisticalAnalyzerAgent({
    String id = 'statistical-analyzer-001',
    String name = 'StatisticalAnalyzerAgent',
  }) : super(id: id, name: name);

  /// Add data point to dataset
  void addDataPoint(int value) {
    if (value < 0 || value > 36) {
      logger.warning('Invalid value: $value. Must be 0-36.');
      return;
    }

    _dataset.add(value);
    _frequency[value] = (_frequency[value] ?? 0) + 1;
    monitor.recordCounter('data_points_added', 1);
  }

  /// Calculate descriptive statistics
  Map<String, dynamic> calculateDescriptiveStats() {
    if (_dataset.isEmpty) {
      logger.warning('No data available for analysis');
      return {};
    }

    monitor.recordCounter('descriptive_stats_calculated', 1);

    final mean = _calculateMean();
    final median = _calculateMedian();
    final mode = _calculateMode();
    final variance = _calculateVariance(mean);
    final stdDev = sqrt(variance);
    final range = _calculateRange();
    final quartiles = _calculateQuartiles();

    return {
      'mean': mean,
      'median': median,
      'mode': mode,
      'variance': variance,
      'standard_deviation': stdDev,
      'range': range,
      'quartiles': quartiles,
      'sample_size': _dataset.length,
      'skewness': _calculateSkewness(mean, stdDev),
      'kurtosis': _calculateKurtosis(mean, stdDev),
    };
  }

  /// Build probability distribution model
  Future<StatisticalModel> buildProbabilityModel() async {
    if (state != AgentState.running) {
      throw StateError('Agent not running');
    }

    if (_dataset.length < 50) {
      logger.warning('Insufficient data for probability model');
      throw StateError('Need at least 50 data points');
    }

    monitor.recordCounter('probability_models_built', 1);

    final insights = <String>[];
    final parameters = <String, dynamic>{};

    // Calculate empirical probabilities
    final probabilities = <int, double>{};
    for (int i = 0; i <= 36; i++) {
      probabilities[i] = (_frequency[i] ?? 0) / _dataset.length;
    }
    parameters['empirical_probabilities'] = probabilities;

    // Expected probability for fair roulette
    const expectedProb = 1.0 / 37.0;
    parameters['expected_probability'] = expectedProb;

    // Calculate deviation from expected
    final deviations = <int, double>{};
    double maxDeviation = 0.0;
    int? maxDeviationNumber;

    for (int i = 0; i <= 36; i++) {
      final deviation = (probabilities[i]! - expectedProb).abs();
      deviations[i] = deviation;
      
      if (deviation > maxDeviation) {
        maxDeviation = deviation;
        maxDeviationNumber = i;
      }
    }

    parameters['probability_deviations'] = deviations;

    if (maxDeviation > 0.015) {
      insights.add('Number $maxDeviationNumber shows significant deviation from expected probability');
    }

    // Calculate entropy
    final entropy = _calculateEntropy(probabilities);
    parameters['entropy'] = entropy;
    
    // Maximum entropy for uniform distribution over 37 numbers
    final maxEntropy = log(37) / log(2);
    parameters['max_entropy'] = maxEntropy;
    parameters['entropy_ratio'] = entropy / maxEntropy;

    if (entropy / maxEntropy < 0.95) {
      insights.add('Distribution entropy is lower than expected, suggesting non-uniform distribution');
    }

    final fitQuality = entropy / maxEntropy;

    return StatisticalModel(
      modelType: 'empirical_probability',
      parameters: parameters,
      fitQuality: fitQuality,
      insights: insights,
    );
  }

  /// Perform regression analysis on time series
  Map<String, dynamic> performTimeSeriesAnalysis() {
    if (_dataset.length < 10) {
      logger.warning('Insufficient data for time series analysis');
      return {};
    }

    monitor.recordCounter('time_series_analyses', 1);

    // Simple moving averages
    final sma5 = _calculateSMA(5);
    final sma10 = _calculateSMA(10);

    // Trend analysis
    final trend = _calculateTrend();

    // Volatility
    final volatility = _calculateVolatility();

    return {
      'sma_5': sma5,
      'sma_10': sma10,
      'trend': trend,
      'volatility': volatility,
      'autocorrelation_lag1': _calculateAutocorrelation(1),
      'autocorrelation_lag2': _calculateAutocorrelation(2),
    };
  }

  /// Calculate confidence intervals
  Map<String, dynamic> calculateConfidenceIntervals(double confidenceLevel) {
    if (_dataset.isEmpty) return {};

    final mean = _calculateMean();
    final stdDev = sqrt(_calculateVariance(mean));
    final n = _dataset.length;

    // Z-scores for common confidence levels
    final zScores = {
      0.90: 1.645,
      0.95: 1.96,
      0.99: 2.576,
    };

    final zScore = zScores[confidenceLevel] ?? 1.96;
    final marginOfError = zScore * (stdDev / sqrt(n));

    return {
      'mean': mean,
      'confidence_level': confidenceLevel,
      'margin_of_error': marginOfError,
      'lower_bound': mean - marginOfError,
      'upper_bound': mean + marginOfError,
    };
  }

  // Helper methods for statistical calculations

  double _calculateMean() {
    if (_dataset.isEmpty) return 0.0;
    return _dataset.reduce((a, b) => a + b) / _dataset.length;
  }

  double _calculateMedian() {
    if (_dataset.isEmpty) return 0.0;
    final sorted = List<int>.from(_dataset)..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[middle].toDouble()
        : (sorted[middle - 1] + sorted[middle]) / 2.0;
  }

  List<int> _calculateMode() {
    if (_frequency.isEmpty) return [];
    final maxFreq = _frequency.values.reduce(max);
    return _frequency.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();
  }

  double _calculateVariance(double mean) {
    if (_dataset.isEmpty) return 0.0;
    double sumSquaredDiff = 0.0;
    for (final value in _dataset) {
      sumSquaredDiff += pow(value - mean, 2);
    }
    return sumSquaredDiff / _dataset.length;
  }

  Map<String, int> _calculateRange() {
    if (_dataset.isEmpty) return {'min': 0, 'max': 0};
    return {
      'min': _dataset.reduce(min),
      'max': _dataset.reduce(max),
    };
  }

  Map<String, double> _calculateQuartiles() {
    if (_dataset.isEmpty) return {};
    final sorted = List<int>.from(_dataset)..sort();
    final n = sorted.length;

    double q1, q2, q3;
    q2 = _calculateMedian();

    final lowerHalf = sorted.sublist(0, n ~/ 2);
    q1 = lowerHalf.isEmpty ? 0.0 : _calculateMedianOfList(lowerHalf);

    final upperHalf = sorted.sublist(n.isOdd ? (n ~/ 2) + 1 : n ~/ 2);
    q3 = upperHalf.isEmpty ? 0.0 : _calculateMedianOfList(upperHalf);

    return {'q1': q1, 'q2': q2, 'q3': q3, 'iqr': q3 - q1};
  }

  double _calculateMedianOfList(List<int> list) {
    if (list.isEmpty) return 0.0;
    final middle = list.length ~/ 2;
    return list.length.isOdd
        ? list[middle].toDouble()
        : (list[middle - 1] + list[middle]) / 2.0;
  }

  double _calculateSkewness(double mean, double stdDev) {
    if (_dataset.isEmpty || stdDev == 0) return 0.0;
    double sum = 0.0;
    for (final value in _dataset) {
      sum += pow((value - mean) / stdDev, 3);
    }
    return sum / _dataset.length;
  }

  double _calculateKurtosis(double mean, double stdDev) {
    if (_dataset.isEmpty || stdDev == 0) return 0.0;
    double sum = 0.0;
    for (final value in _dataset) {
      sum += pow((value - mean) / stdDev, 4);
    }
    return (sum / _dataset.length) - 3.0; // Excess kurtosis
  }

  double _calculateEntropy(Map<int, double> probabilities) {
    double entropy = 0.0;
    for (final prob in probabilities.values) {
      if (prob > 0) {
        entropy -= prob * (log(prob) / log(2));
      }
    }
    return entropy;
  }

  List<double> _calculateSMA(int period) {
    if (_dataset.length < period) return [];
    final sma = <double>[];
    for (int i = period - 1; i < _dataset.length; i++) {
      final sum = _dataset.sublist(i - period + 1, i + 1).reduce((a, b) => a + b);
      sma.add(sum / period);
    }
    return sma;
  }

  double _calculateTrend() {
    if (_dataset.length < 2) return 0.0;
    // Simple linear regression slope
    final n = _dataset.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    
    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += _dataset[i];
      sumXY += i * _dataset[i];
      sumX2 += i * i;
    }
    
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    return slope;
  }

  double _calculateVolatility() {
    if (_dataset.length < 2) return 0.0;
    final returns = <double>[];
    for (int i = 1; i < _dataset.length; i++) {
      returns.add(_dataset[i] - _dataset[i - 1].toDouble());
    }
    final mean = returns.reduce((a, b) => a + b) / returns.length;
    double variance = 0.0;
    for (final r in returns) {
      variance += pow(r - mean, 2);
    }
    return sqrt(variance / returns.length);
  }

  double _calculateAutocorrelation(int lag) {
    if (_dataset.length < lag + 1) return 0.0;
    final mean = _calculateMean();
    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i < _dataset.length - lag; i++) {
      numerator += (_dataset[i] - mean) * (_dataset[i + lag] - mean);
    }

    for (final value in _dataset) {
      denominator += pow(value - mean, 2);
    }

    return denominator > 0 ? numerator / denominator : 0.0;
  }

  /// Clear all data
  void clearData() {
    _dataset.clear();
    _frequency.clear();
    logger.info('Data cleared');
    monitor.recordCounter('data_cleared', 1);
  }

  // TODO: Implement Markov chain analysis for state transitions
  // TODO: Add Bayesian inference for probability updates
  // TODO: Implement ARIMA models for time series forecasting
  // TODO: Add Monte Carlo simulation capabilities
  // TODO: Support for multivariate statistical analysis
}
