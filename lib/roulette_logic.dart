/// Legacy roulette logic module - Redirects to new modular agents
///
/// This file maintains backward compatibility with older imports.
/// New code should import from 'agents/agents.dart' instead.
///
/// @deprecated Use 'agents/roulette_agent.dart' instead.
library roulette_logic;

import 'dart:math';

/// Lógica de ruleta europea (0-36)
///
/// @deprecated Use [RouletteAgent] from 'agents/roulette_agent.dart' instead.
class RouletteLogic {
  /// Creates a new [RouletteLogic] with a secure random number generator.
  RouletteLogic();

  /// The list of numbers on a European roulette wheel (0-36).
  final List<int> wheel = List.generate(37, (i) => i);

  /// Secure random number generator.
  final Random rng = Random.secure();

  /// Generates a random spin result using a secure RNG.
  ///
  /// Returns a number between 0 and 36 (inclusive), simulating
  /// a European roulette wheel.
  int generateSpin() {
    return wheel[rng.nextInt(wheel.length)];
  }

  /// Predicts the next number based on the most frequent number in history.
  ///
  /// **Note**: This is a simulation for educational purposes only.
  /// In real roulette, each spin is independent and cannot be predicted.
  ///
  /// Returns a random number if history is empty.
  int predictNext(List<int> history) {
    if (history.isEmpty) {
      return rng.nextInt(37);
    }

    final freq = <int, int>{};
    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

/// Asesor de estrategia Martingale
///
/// **WARNING**: This is an educational simulation only.
/// The Martingale strategy has significant risks in real gambling.
///
/// @deprecated Use [MartingaleAdvisor] from 'agents/martingale_advisor.dart' instead.
class MartingaleAdvisor {
  /// The base bet amount.
  double baseBet = 1.0;

  /// The current bet amount.
  double currentBet = 1.0;

  /// Whether the last bet was won.
  bool lastWin = true;

  /// Calculates the next bet based on whether the previous bet was won.
  ///
  /// If won, returns to base bet. If lost, doubles the bet.
  ///
  /// ### Parameters
  ///
  /// - [win]: Whether the previous bet was won.
  ///
  /// ### Returns
  ///
  /// The next recommended bet amount.
  double getNextBet(bool win) {
    if (win) {
      currentBet = baseBet;
      lastWin = true;
    } else {
      currentBet *= 2;
      lastWin = false;
    }
    return currentBet;
  }

  /// Resets the advisor to initial values.
  void reset() {
    currentBet = baseBet;
    lastWin = true;
  }
}