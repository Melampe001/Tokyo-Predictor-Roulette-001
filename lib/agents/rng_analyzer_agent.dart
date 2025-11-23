/// RNG Analyzer Agent - Analyzes Random Number Generator patterns and biases
/// Detects potential non-randomness, biases, and statistical anomalies

import 'dart:math';
import '../core/base_agent.dart';
import '../core/logger.dart';

/// Analysis result containing findings and statistics
class AnalysisResult {
  final bool isPotentiallyBiased;
  final double chiSquareStatistic;
  final Map<String, dynamic> statistics;
  final List<String> findings;

  AnalysisResult({
    required this.isPotentiallyBiased,
    required this.chiSquareStatistic,
    required this.statistics,
    required this.findings,
  });

  Map<String, dynamic> toJson() => {
        'is_potentially_biased': isPotentiallyBiased,
        'chi_square_statistic': chiSquareStatistic,
        'statistics': statistics,
        'findings': findings,
      };
}

/// RNG Analyzer Agent for detecting patterns and biases
class RngAnalyzerAgent extends AbstractAgent {
  final List<int> _observations = [];
  final Map<int, int> _frequency = {};

  RngAnalyzerAgent({
    String id = 'rng-analyzer-001',
    String name = 'RngAnalyzerAgent',
  }) : super(id: id, name: name);

  /// Add an observation to the dataset
  void addObservation(int number) {
    if (number < 0 || number > 36) {
      logger.warning('Invalid number: $number. Must be 0-36.');
      return;
    }

    _observations.add(number);
    _frequency[number] = (_frequency[number] ?? 0) + 1;
    monitor.recordCounter('observations_added', 1);
    monitor.recordHistogram('observation_value', number.toDouble());
  }

  /// Analyze the RNG for biases and patterns
  Future<AnalysisResult> analyze() async {
    if (state != AgentState.running) {
      logger.warning('Agent must be running to perform analysis');
      throw StateError('Agent not running');
    }

    if (_observations.length < 37) {
      logger.warning('Insufficient data for analysis. Need at least 37 observations.');
      throw StateError('Insufficient data');
    }

    monitor.recordCounter('analyses_performed', 1);

    final findings = <String>[];
    final statistics = <String, dynamic>{};

    // Chi-square test for uniform distribution
    final chiSquare = _performChiSquareTest();
    statistics['chi_square'] = chiSquare;

    // Critical value for chi-square with 36 degrees of freedom at 95% confidence
    const criticalValue = 50.998; // Approximate
    final isPotentiallyBiased = chiSquare > criticalValue;

    if (isPotentiallyBiased) {
      findings.add('Chi-square test suggests potential bias (χ² = ${chiSquare.toStringAsFixed(2)})');
    }

    // Frequency analysis
    final freqAnalysis = _analyzeFrequency();
    statistics.addAll(freqAnalysis);

    if (freqAnalysis['max_frequency'] > _observations.length * 0.05) {
      findings.add('Number ${freqAnalysis['most_frequent']} appears unusually often');
    }

    if (freqAnalysis['min_frequency'] == 0) {
      findings.add('Some numbers have not appeared: ${freqAnalysis['missing_numbers']}');
    }

    // Run test for randomness
    final runsAnalysis = _performRunsTest();
    statistics.addAll(runsAnalysis);

    if (runsAnalysis['runs_z_score'].abs() > 1.96) {
      findings.add('Runs test suggests non-random pattern (z = ${runsAnalysis['runs_z_score'].toStringAsFixed(2)})');
    }

    // Serial correlation
    final correlation = _analyzeSerialCorrelation();
    statistics['serial_correlation'] = correlation;

    if (correlation.abs() > 0.3) {
      findings.add('High serial correlation detected (${correlation.toStringAsFixed(2)})');
    }

    logger.info('Analysis complete. Findings: ${findings.length}');

    return AnalysisResult(
      isPotentiallyBiased: isPotentiallyBiased,
      chiSquareStatistic: chiSquare,
      statistics: statistics,
      findings: findings,
    );
  }

  /// Perform chi-square test for uniform distribution
  double _performChiSquareTest() {
    final n = _observations.length;
    final expected = n / 37.0;
    double chiSquare = 0.0;

    for (int i = 0; i <= 36; i++) {
      final observed = _frequency[i] ?? 0;
      final diff = observed - expected;
      chiSquare += (diff * diff) / expected;
    }

    return chiSquare;
  }

  /// Analyze frequency distribution
  Map<String, dynamic> _analyzeFrequency() {
    final frequencies = List.generate(37, (i) => _frequency[i] ?? 0);
    final maxFreq = frequencies.reduce(max);
    final minFreq = frequencies.reduce(min);
    final avgFreq = _observations.length / 37.0;

    final mostFrequent = frequencies.indexOf(maxFreq);
    final missingNumbers = <int>[];
    
    for (int i = 0; i <= 36; i++) {
      if ((_frequency[i] ?? 0) == 0) {
        missingNumbers.add(i);
      }
    }

    return {
      'max_frequency': maxFreq,
      'min_frequency': minFreq,
      'avg_frequency': avgFreq,
      'most_frequent': mostFrequent,
      'missing_numbers': missingNumbers,
      'standard_deviation': _calculateStandardDeviation(frequencies, avgFreq),
    };
  }

  /// Perform runs test for randomness
  Map<String, dynamic> _performRunsTest() {
    if (_observations.length < 2) {
      return {'runs': 0, 'runs_z_score': 0.0};
    }

    final median = _calculateMedian(_observations);
    final aboveMedian = _observations.map((n) => n > median ? 1 : 0).toList();
    
    int runs = 1;
    for (int i = 1; i < aboveMedian.length; i++) {
      if (aboveMedian[i] != aboveMedian[i - 1]) {
        runs++;
      }
    }

    final n1 = aboveMedian.where((x) => x == 1).length;
    final n2 = aboveMedian.length - n1;

    if (n1 == 0 || n2 == 0) {
      return {'runs': runs, 'runs_z_score': 0.0};
    }

    final expectedRuns = (2 * n1 * n2) / (n1 + n2) + 1;
    final variance = (2 * n1 * n2 * (2 * n1 * n2 - n1 - n2)) / 
                     (pow(n1 + n2, 2) * (n1 + n2 - 1));
    final stdDev = sqrt(variance);

    final zScore = stdDev > 0 ? (runs - expectedRuns) / stdDev : 0.0;

    return {
      'runs': runs,
      'expected_runs': expectedRuns,
      'runs_z_score': zScore,
    };
  }

  /// Analyze serial correlation (lag-1 autocorrelation)
  double _analyzeSerialCorrelation() {
    if (_observations.length < 2) return 0.0;

    final mean = _observations.reduce((a, b) => a + b) / _observations.length;
    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i < _observations.length - 1; i++) {
      numerator += (_observations[i] - mean) * (_observations[i + 1] - mean);
    }

    for (final obs in _observations) {
      denominator += pow(obs - mean, 2);
    }

    return denominator > 0 ? numerator / denominator : 0.0;
  }

  /// Calculate standard deviation
  double _calculateStandardDeviation(List<int> values, double mean) {
    if (values.isEmpty) return 0.0;
    
    double sumSquaredDiff = 0.0;
    for (final value in values) {
      sumSquaredDiff += pow(value - mean, 2);
    }
    
    return sqrt(sumSquaredDiff / values.length);
  }

  /// Calculate median
  double _calculateMedian(List<int> values) {
    if (values.isEmpty) return 0.0;
    
    final sorted = List<int>.from(values)..sort();
    final middle = sorted.length ~/ 2;
    
    if (sorted.length.isOdd) {
      return sorted[middle].toDouble();
    } else {
      return (sorted[middle - 1] + sorted[middle]) / 2.0;
    }
  }

  /// Get detailed statistics
  Map<String, dynamic> getDetailedStatistics() {
    return {
      'total_observations': _observations.length,
      'frequency_distribution': _frequency,
      'unique_numbers_seen': _frequency.keys.length,
    };
  }

  /// Clear all observations
  void clearObservations() {
    _observations.clear();
    _frequency.clear();
    logger.info('Observations cleared');
    monitor.recordCounter('observations_cleared', 1);
  }

  // TODO: Implement entropy analysis for randomness assessment
  // TODO: Add spectral test for detecting patterns in frequency domain
  // TODO: Implement Kolmogorov-Smirnov test for distribution comparison
  // TODO: Add real-time monitoring with alerts for bias detection
  // TODO: Support for analyzing multiple RNG sources simultaneously
}
