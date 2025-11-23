/// Predictor Agent - Advanced prediction logic for roulette outcomes
/// Uses statistical models, pattern recognition, and historical data analysis

import 'dart:math';
import '../core/base_agent.dart';
import '../core/logger.dart';

/// Prediction result containing predicted number and confidence
class PredictionResult {
  final int predictedNumber;
  final double confidence;
  final String method;
  final Map<String, dynamic>? metadata;

  PredictionResult({
    required this.predictedNumber,
    required this.confidence,
    required this.method,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'predicted_number': predictedNumber,
        'confidence': confidence,
        'method': method,
        'metadata': metadata,
      };
}

/// Prediction strategies enumeration
enum PredictionStrategy {
  frequencyBased,
  patternRecognition,
  hotColdNumbers,
  sectorAnalysis,
  hybridModel,
}

/// Predictor Agent for roulette number prediction
class PredictorAgent extends AbstractAgent {
  final List<int> _history = [];
  final Map<int, int> _frequency = {};
  PredictionStrategy _strategy = PredictionStrategy.frequencyBased;
  final Random _random = Random();

  PredictorAgent({
    String id = 'predictor-001',
    String name = 'PredictorAgent',
  }) : super(id: id, name: name);

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    await super.initialize(config);
    
    if (config != null) {
      final strategyStr = config['strategy'] as String?;
      if (strategyStr != null) {
        _strategy = PredictionStrategy.values.firstWhere(
          (e) => e.toString().split('.').last == strategyStr,
          orElse: () => PredictionStrategy.frequencyBased,
        );
      }
    }
    
    logger.info('Predictor initialized with strategy: $_strategy');
  }

  /// Add a new spin result to the history
  void addResult(int number) {
    if (number < 0 || number > 36) {
      logger.warning('Invalid number: $number. Must be 0-36.');
      return;
    }
    
    _history.add(number);
    _frequency[number] = (_frequency[number] ?? 0) + 1;
    monitor.recordCounter('results_added', 1);
    monitor.recordHistogram('result_value', number.toDouble());
  }

  /// Predict next number based on current strategy
  Future<PredictionResult> predict() async {
    if (state != AgentState.running) {
      logger.warning('Agent must be running to make predictions');
      throw StateError('Agent not running');
    }

    monitor.recordCounter('predictions_made', 1);
    
    switch (_strategy) {
      case PredictionStrategy.frequencyBased:
        return _predictByFrequency();
      case PredictionStrategy.patternRecognition:
        return _predictByPattern();
      case PredictionStrategy.hotColdNumbers:
        return _predictByHotCold();
      case PredictionStrategy.sectorAnalysis:
        return _predictBySector();
      case PredictionStrategy.hybridModel:
        return _predictHybrid();
    }
  }

  /// Predict based on most frequent numbers
  PredictionResult _predictByFrequency() {
    if (_frequency.isEmpty) {
      return PredictionResult(
        predictedNumber: _random.nextInt(37),
        confidence: 0.0,
        method: 'random_fallback',
      );
    }

    final sortedEntries = _frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final mostFrequent = sortedEntries.first;
    final totalSpins = _history.length;
    final confidence = totalSpins > 0 ? mostFrequent.value / totalSpins : 0.0;

    return PredictionResult(
      predictedNumber: mostFrequent.key,
      confidence: confidence,
      method: 'frequency_based',
      metadata: {'total_occurrences': mostFrequent.value},
    );
  }

  /// Predict based on pattern recognition
  PredictionResult _predictByPattern() {
    if (_history.length < 3) {
      return _predictByFrequency();
    }

    // Simple pattern: look for repeating sequences
    final last3 = _history.sublist(_history.length - 3);
    int? repeatingNumber;
    
    // Check for immediate repeats
    if (last3[1] == last3[2]) {
      repeatingNumber = last3[1];
    }

    final predicted = repeatingNumber ?? _frequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return PredictionResult(
      predictedNumber: predicted,
      confidence: repeatingNumber != null ? 0.6 : 0.4,
      method: 'pattern_recognition',
      metadata: {'last_3': last3},
    );
  }

  /// Predict based on hot/cold number analysis
  PredictionResult _predictByHotCold() {
    if (_history.length < 10) {
      return _predictByFrequency();
    }

    // Analyze recent history (last 20 spins or all if less)
    final recentHistory = _history.length > 20 
        ? _history.sublist(_history.length - 20)
        : _history;
    
    final recentFreq = <int, int>{};
    for (final num in recentHistory) {
      recentFreq[num] = (recentFreq[num] ?? 0) + 1;
    }

    final hotNumber = recentFreq.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return PredictionResult(
      predictedNumber: hotNumber,
      confidence: 0.5,
      method: 'hot_cold_analysis',
      metadata: {'recent_frequency': recentFreq[hotNumber]},
    );
  }

  /// Predict based on sector analysis (wheel sectors)
  PredictionResult _predictBySector() {
    // European roulette wheel sectors
    final sectors = <String, List<int>>{
      'zero_sector': [0, 32, 15, 19, 4, 21, 2, 25],
      'voisins': [22, 18, 29, 7, 28, 12, 35, 3, 26],
      'orphelins': [17, 34, 6, 1, 20, 14, 31, 9],
      'tier': [27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33],
    };

    // TODO: Implement more sophisticated sector-based prediction
    // For now, use frequency-based as fallback
    return _predictByFrequency();
  }

  /// Hybrid prediction combining multiple strategies
  PredictionResult _predictHybrid() {
    final predictions = [
      _predictByFrequency(),
      _predictByPattern(),
      _predictByHotCold(),
    ];

    // Weighted average based on confidence
    final weights = predictions.map((p) => p.confidence).toList();
    final totalWeight = weights.reduce((a, b) => a + b);
    
    if (totalWeight == 0) {
      return predictions[0];
    }

    // Select prediction with highest confidence
    final best = predictions.reduce(
      (a, b) => a.confidence > b.confidence ? a : b,
    );

    return PredictionResult(
      predictedNumber: best.predictedNumber,
      confidence: best.confidence,
      method: 'hybrid_model',
      metadata: {
        'component_predictions': predictions.map((p) => p.toJson()).toList(),
      },
    );
  }

  /// Get prediction statistics
  Map<String, dynamic> getStatistics() {
    return {
      'total_results': _history.length,
      'unique_numbers': _frequency.keys.length,
      'most_frequent': _frequency.isNotEmpty
          ? _frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : null,
      'strategy': _strategy.toString(),
      'frequency_distribution': _frequency,
    };
  }

  /// Clear all historical data
  void clearHistory() {
    _history.clear();
    _frequency.clear();
    logger.info('History cleared');
    monitor.recordCounter('history_cleared', 1);
  }

  // TODO: Integrate advanced AI predictive models (e.g., neural networks)
  // TODO: Add support for American roulette (0 and 00)
  // TODO: Implement Bayesian inference for probability updates
  // TODO: Add external data source integration for bias detection
}
