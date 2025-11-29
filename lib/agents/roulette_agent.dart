/// Roulette Agent - Core prediction and simulation agent for Tokyo Roulette
///
/// This module provides the [RouletteAgent] class which encapsulates
/// all roulette-related logic including number generation, prediction,
/// and game simulation.
///
/// ## Usage
///
/// ```dart
/// // Create a roulette agent
/// final agent = RouletteAgent();
///
/// // Generate a spin result
/// final result = agent.spin();
/// print('Spin result: \$result');
///
/// // Add result to history and get a prediction
/// agent.addToHistory(result);
/// final prediction = agent.predictNext();
/// print('Next prediction: \$prediction');
/// ```
///
/// ## Important Note
///
/// This is an educational simulator. In real roulette, each spin is
/// independent and cannot be predicted. This agent is designed for
/// entertainment and educational purposes only.
library roulette_agent;

import 'dart:math';

/// European roulette number representing the possible outcomes (0-36).
typedef RouletteNumber = int;

/// Agent responsible for roulette simulation and prediction logic.
///
/// The [RouletteAgent] provides secure random number generation for
/// simulating roulette spins and maintains a history of results for
/// educational prediction analysis.
///
/// ### Example
///
/// ```dart
/// final agent = RouletteAgent();
///
/// // Simulate 10 spins
/// for (var i = 0; i < 10; i++) {
///   final result = agent.spin();
///   agent.addToHistory(result);
///   print('Spin \${i + 1}: \$result');
/// }
///
/// // Get prediction based on history
/// print('Prediction: \${agent.predictNext()}');
/// ```
class RouletteAgent {
  /// Creates a new [RouletteAgent] with a secure random number generator.
  RouletteAgent() : _rng = Random.secure();

  /// The list of numbers on a European roulette wheel (0-36).
  static const List<RouletteNumber> wheel = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36,
  ];

  /// Red numbers on a European roulette wheel.
  static const List<RouletteNumber> redNumbers = [
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19,
    21, 23, 25, 27, 30, 32, 34, 36,
  ];

  /// Black numbers on a European roulette wheel.
  static const List<RouletteNumber> blackNumbers = [
    2, 4, 6, 8, 10, 11, 13, 15, 17, 20,
    22, 24, 26, 28, 29, 31, 33, 35,
  ];

  /// Secure random number generator.
  final Random _rng;

  /// History of spin results.
  final List<RouletteNumber> _history = [];

  /// Maximum history size to maintain.
  static const int maxHistorySize = 1000;

  /// Returns an unmodifiable view of the spin history.
  List<RouletteNumber> get history => List.unmodifiable(_history);

  /// Returns the number of spins in the history.
  int get historyLength => _history.length;

  /// Generates a random spin result using a secure RNG.
  ///
  /// Returns a number between 0 and 36 (inclusive), simulating
  /// a European roulette wheel.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final agent = RouletteAgent();
  /// final result = agent.spin();
  /// assert(result >= 0 && result <= 36);
  /// ```
  RouletteNumber spin() {
    return wheel[_rng.nextInt(wheel.length)];
  }

  /// Adds a spin result to the history.
  ///
  /// The history is limited to [maxHistorySize] entries to prevent
  /// unbounded memory growth.
  ///
  /// ### Parameters
  ///
  /// - [result]: The roulette number to add (must be 0-36).
  ///
  /// ### Throws
  ///
  /// - [ArgumentError] if [result] is not a valid roulette number.
  void addToHistory(RouletteNumber result) {
    if (result < 0 || result > 36) {
      throw ArgumentError('Invalid roulette number: $result. Must be 0-36.');
    }
    _history.add(result);
    if (_history.length > maxHistorySize) {
      _history.removeAt(0);
    }
  }

  /// Clears the spin history.
  void clearHistory() {
    _history.clear();
  }

  /// Predicts the next number based on frequency analysis.
  ///
  /// This prediction is based on the most frequently occurring number
  /// in the history. **Note**: This is for educational purposes only.
  /// In real roulette, each spin is independent.
  ///
  /// Returns a random number if history is empty.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final agent = RouletteAgent();
  /// agent.addToHistory(7);
  /// agent.addToHistory(7);
  /// agent.addToHistory(14);
  /// final prediction = agent.predictNext();
  /// print('Most likely: \$prediction'); // Likely 7
  /// ```
  RouletteNumber predictNext() {
    if (_history.isEmpty) {
      return spin();
    }

    final frequency = <RouletteNumber, int>{};
    for (final number in _history) {
      frequency[number] = (frequency[number] ?? 0) + 1;
    }

    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Checks if a number is red.
  ///
  /// ### Parameters
  ///
  /// - [number]: The roulette number to check.
  ///
  /// ### Returns
  ///
  /// `true` if the number is red, `false` otherwise.
  static bool isRed(RouletteNumber number) {
    return redNumbers.contains(number);
  }

  /// Checks if a number is black.
  ///
  /// ### Parameters
  ///
  /// - [number]: The roulette number to check.
  ///
  /// ### Returns
  ///
  /// `true` if the number is black, `false` otherwise.
  static bool isBlack(RouletteNumber number) {
    return blackNumbers.contains(number);
  }

  /// Checks if a number is green (zero).
  ///
  /// ### Parameters
  ///
  /// - [number]: The roulette number to check.
  ///
  /// ### Returns
  ///
  /// `true` if the number is zero, `false` otherwise.
  static bool isGreen(RouletteNumber number) {
    return number == 0;
  }

  /// Gets the color of a roulette number.
  ///
  /// ### Parameters
  ///
  /// - [number]: The roulette number to check.
  ///
  /// ### Returns
  ///
  /// A string representing the color: 'red', 'black', or 'green'.
  static String getColor(RouletteNumber number) {
    if (isRed(number)) return 'red';
    if (isBlack(number)) return 'black';
    return 'green';
  }

  /// Calculates statistics for the spin history.
  ///
  /// ### Returns
  ///
  /// A [RouletteStats] object containing various statistics.
  RouletteStats getStatistics() {
    return RouletteStats.fromHistory(_history);
  }
}

/// Statistics calculated from roulette spin history.
///
/// Provides various analytical metrics for educational purposes.
class RouletteStats {
  /// Creates statistics from a history of spins.
  factory RouletteStats.fromHistory(List<RouletteNumber> history) {
    if (history.isEmpty) {
      return RouletteStats._(
        totalSpins: 0,
        redCount: 0,
        blackCount: 0,
        greenCount: 0,
        evenCount: 0,
        oddCount: 0,
        lowCount: 0,
        highCount: 0,
        mostFrequent: null,
        leastFrequent: null,
      );
    }

    int redCount = 0;
    int blackCount = 0;
    int greenCount = 0;
    int evenCount = 0;
    int oddCount = 0;
    int lowCount = 0;
    int highCount = 0;
    final frequency = <RouletteNumber, int>{};

    for (final number in history) {
      frequency[number] = (frequency[number] ?? 0) + 1;

      if (RouletteAgent.isRed(number)) {
        redCount++;
      } else if (RouletteAgent.isBlack(number)) {
        blackCount++;
      } else {
        greenCount++;
      }

      if (number != 0) {
        if (number % 2 == 0) {
          evenCount++;
        } else {
          oddCount++;
        }

        if (number <= 18) {
          lowCount++;
        } else {
          highCount++;
        }
      }
    }

    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return RouletteStats._(
      totalSpins: history.length,
      redCount: redCount,
      blackCount: blackCount,
      greenCount: greenCount,
      evenCount: evenCount,
      oddCount: oddCount,
      lowCount: lowCount,
      highCount: highCount,
      mostFrequent: sortedEntries.first.key,
      leastFrequent: sortedEntries.last.key,
    );
  }

  const RouletteStats._({
    required this.totalSpins,
    required this.redCount,
    required this.blackCount,
    required this.greenCount,
    required this.evenCount,
    required this.oddCount,
    required this.lowCount,
    required this.highCount,
    required this.mostFrequent,
    required this.leastFrequent,
  });

  /// Total number of spins analyzed.
  final int totalSpins;

  /// Number of red results.
  final int redCount;

  /// Number of black results.
  final int blackCount;

  /// Number of green (zero) results.
  final int greenCount;

  /// Number of even results (excluding zero).
  final int evenCount;

  /// Number of odd results.
  final int oddCount;

  /// Number of low results (1-18).
  final int lowCount;

  /// Number of high results (19-36).
  final int highCount;

  /// Most frequently occurring number.
  final RouletteNumber? mostFrequent;

  /// Least frequently occurring number.
  final RouletteNumber? leastFrequent;

  /// Red percentage of non-zero results.
  double get redPercentage =>
      totalSpins > 0 ? (redCount / totalSpins) * 100 : 0;

  /// Black percentage of non-zero results.
  double get blackPercentage =>
      totalSpins > 0 ? (blackCount / totalSpins) * 100 : 0;

  @override
  String toString() {
    return '''RouletteStats(
  totalSpins: $totalSpins,
  red: $redCount (${redPercentage.toStringAsFixed(1)}%),
  black: $blackCount (${blackPercentage.toStringAsFixed(1)}%),
  green: $greenCount,
  mostFrequent: $mostFrequent,
  leastFrequent: $leastFrequent
)''';
  }
}
