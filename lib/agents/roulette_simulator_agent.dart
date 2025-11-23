/// Roulette Simulator Agent - Simulates American and European roulette wheels
/// Provides realistic roulette simulation with configurable parameters

import 'dart:math';
import '../core/base_agent.dart';
import '../core/logger.dart';

/// Roulette type enumeration
enum RouletteType {
  european, // 0-36 (37 numbers)
  american, // 0-36 + 00 (38 numbers)
}

/// Spin result containing outcome and metadata
class SpinResult {
  final dynamic number; // int for European, int or String ('00') for American
  final String color;
  final bool isZero;
  final String dozen;
  final String column;
  final bool isEven;
  final bool isHigh;
  final DateTime timestamp;

  SpinResult({
    required this.number,
    required this.color,
    required this.isZero,
    required this.dozen,
    required this.column,
    required this.isEven,
    required this.isHigh,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'number': number,
        'color': color,
        'is_zero': isZero,
        'dozen': dozen,
        'column': column,
        'is_even': isEven,
        'is_high': isHigh,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Roulette Simulator Agent
class RouletteSimulatorAgent extends AbstractAgent {
  RouletteType _type = RouletteType.european;
  final Random _rng = Random.secure();
  final List<SpinResult> _history = [];
  
  // European roulette color mapping
  static const Map<int, String> _europeanColors = {
    0: 'green',
    1: 'red', 2: 'black', 3: 'red', 4: 'black', 5: 'red',
    6: 'black', 7: 'red', 8: 'black', 9: 'red', 10: 'black',
    11: 'black', 12: 'red', 13: 'black', 14: 'red', 15: 'black',
    16: 'red', 17: 'black', 18: 'red', 19: 'red', 20: 'black',
    21: 'red', 22: 'black', 23: 'red', 24: 'black', 25: 'red',
    26: 'black', 27: 'red', 28: 'black', 29: 'black', 30: 'red',
    31: 'black', 32: 'red', 33: 'black', 34: 'red', 35: 'black',
    36: 'red',
  };

  RouletteSimulatorAgent({
    String id = 'roulette-simulator-001',
    String name = 'RouletteSimulatorAgent',
  }) : super(id: id, name: name);

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    await super.initialize(config);

    if (config != null) {
      final typeStr = config['roulette_type'] as String?;
      if (typeStr != null) {
        _type = typeStr == 'american' 
            ? RouletteType.american 
            : RouletteType.european;
      }
    }

    logger.info('Simulator initialized with type: $_type');
  }

  /// Spin the roulette wheel
  Future<SpinResult> spin() async {
    if (state != AgentState.running) {
      throw StateError('Agent not running');
    }

    monitor.recordCounter('spins_performed', 1);

    final result = _type == RouletteType.european
        ? _spinEuropean()
        : _spinAmerican();

    _history.add(result);
    logger.debug('Spin result: ${result.number} (${result.color})');

    return result;
  }

  /// Spin European roulette (0-36)
  SpinResult _spinEuropean() {
    final number = _rng.nextInt(37); // 0-36
    return _createSpinResult(number);
  }

  /// Spin American roulette (0-36 + 00)
  SpinResult _spinAmerican() {
    final value = _rng.nextInt(38); // 0-37 (37 represents 00)
    final number = value == 37 ? '00' : value;
    return _createSpinResult(number);
  }

  /// Create spin result with all metadata
  SpinResult _createSpinResult(dynamic number) {
    String color;
    bool isZero;
    String dozen;
    String column;
    bool isEven;
    bool isHigh;

    if (number == 0 || number == '00') {
      color = 'green';
      isZero = true;
      dozen = 'none';
      column = 'none';
      isEven = false;
      isHigh = false;
    } else {
      final numValue = number is String ? 0 : number as int;
      color = _europeanColors[numValue] ?? 'unknown';
      isZero = false;
      
      // Dozen: 1-12, 13-24, 25-36
      if (numValue >= 1 && numValue <= 12) {
        dozen = 'first';
      } else if (numValue >= 13 && numValue <= 24) {
        dozen = 'second';
      } else {
        dozen = 'third';
      }

      // Column: based on position on betting layout
      final columnNum = numValue % 3;
      if (columnNum == 1) {
        column = 'first';
      } else if (columnNum == 2) {
        column = 'second';
      } else {
        column = 'third';
      }

      isEven = numValue % 2 == 0;
      isHigh = numValue >= 19;
    }

    return SpinResult(
      number: number,
      color: color,
      isZero: isZero,
      dozen: dozen,
      column: column,
      isEven: isEven,
      isHigh: isHigh,
    );
  }

  /// Simulate multiple spins
  Future<List<SpinResult>> simulateSpins(int count) async {
    if (state != AgentState.running) {
      throw StateError('Agent not running');
    }

    logger.info('Simulating $count spins');
    final results = <SpinResult>[];

    for (int i = 0; i < count; i++) {
      results.add(await spin());
    }

    monitor.recordCounter('batch_simulations', 1);
    monitor.recordGauge('batch_size', count.toDouble());

    return results;
  }

  /// Get simulation statistics
  Map<String, dynamic> getStatistics() {
    if (_history.isEmpty) {
      return {'total_spins': 0};
    }

    final colorCounts = <String, int>{};
    final numberCounts = <dynamic, int>{};
    int zeros = 0;
    int evens = 0;
    int highs = 0;

    for (final result in _history) {
      colorCounts[result.color] = (colorCounts[result.color] ?? 0) + 1;
      numberCounts[result.number] = (numberCounts[result.number] ?? 0) + 1;
      
      if (result.isZero) zeros++;
      if (result.isEven && !result.isZero) evens++;
      if (result.isHigh) highs++;
    }

    return {
      'total_spins': _history.length,
      'roulette_type': _type.toString(),
      'color_distribution': colorCounts,
      'number_frequency': numberCounts,
      'zeros': zeros,
      'evens': evens,
      'highs': highs,
      'red_percentage': colorCounts['red'] != null 
          ? (colorCounts['red']! / _history.length * 100).toStringAsFixed(2)
          : '0.00',
      'black_percentage': colorCounts['black'] != null
          ? (colorCounts['black']! / _history.length * 100).toStringAsFixed(2)
          : '0.00',
    };
  }

  /// Get spin history
  List<SpinResult> getHistory({int? limit}) {
    if (limit == null || limit >= _history.length) {
      return List.unmodifiable(_history);
    }
    return List.unmodifiable(_history.sublist(_history.length - limit));
  }

  /// Check if a bet would have won
  bool checkBet(SpinResult result, String betType, {dynamic betValue}) {
    switch (betType.toLowerCase()) {
      case 'straight':
        return result.number == betValue;
      case 'red':
        return result.color == 'red';
      case 'black':
        return result.color == 'black';
      case 'even':
        return result.isEven && !result.isZero;
      case 'odd':
        return !result.isEven && !result.isZero;
      case 'high':
        return result.isHigh;
      case 'low':
        return !result.isHigh && !result.isZero;
      case 'dozen':
        return result.dozen == betValue;
      case 'column':
        return result.column == betValue;
      default:
        logger.warning('Unknown bet type: $betType');
        return false;
    }
  }

  /// Clear simulation history
  void clearHistory() {
    _history.clear();
    logger.info('History cleared');
    monitor.recordCounter('history_cleared', 1);
  }

  /// Get current roulette type
  RouletteType get rouletteType => _type;

  /// Set roulette type (requires reinitialization)
  void setRouletteType(RouletteType type) {
    _type = type;
    logger.info('Roulette type changed to: $_type');
  }

  // TODO: Add support for biased wheel simulation
  // TODO: Implement sector-based betting patterns
  // TODO: Add configurable RNG with different distributions
  // TODO: Support for neighbor bets and call bets
  // TODO: Add visual representation of wheel and ball trajectory
}
