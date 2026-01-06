import 'dart:math';

/// European roulette logic with numbers 0-36.
///
/// This class handles the core roulette simulation including:
/// - Random number generation using cryptographically secure RNG
/// - Prediction system based on historical frequency analysis
///
/// **Educational Purpose:**
/// This is a simulator for educational purposes only. It does not promote
/// real gambling and all predictions are for demonstration purposes.
///
/// **Example:**
/// ```dart
/// final roulette = RouletteLogic();
/// 
/// // Generate a spin
/// final number = roulette.generateSpin();
/// print('Spun: $number');
/// 
/// // Add to history and get prediction
/// final history = [7, 7, 15, 7, 22];
/// final prediction = roulette.predictNext(history);
/// print('Predicted: $prediction');
/// ```
class RouletteLogic {
  /// European roulette wheel numbers (0-36).
  ///
  /// The wheel contains 37 numbers: 0 (green), 1-36 (red/black).
  /// This matches a standard European roulette layout.
  final List<int> wheel = List.generate(37, (i) => i);
  
  /// Cryptographically secure random number generator.
  ///
  /// Uses [Random.secure()] to ensure true randomness and prevent
  /// prediction or manipulation of results. This is critical for
  /// fair game simulation.
  final Random rng = Random.secure();

  /// Generates a random roulette number between 0 and 36.
  ///
  /// Returns an integer representing the result of a roulette spin.
  /// Each number has equal probability (1/37 or ~2.7%).
  ///
  /// **Performance:** O(1) time complexity, executes in microseconds.
  ///
  /// **Returns:** A random integer between 0 and 36 (inclusive).
  ///
  /// **Example:**
  /// ```dart
  /// final roulette = RouletteLogic();
  /// final result = roulette.generateSpin();
  /// // result could be any number from 0 to 36
  /// ```
  ///
  /// See also:
  /// - [predictNext] for getting number predictions based on history
  int generateSpin() {
    return wheel[rng.nextInt(wheel.length)];
  }

  /// Predicts the next number based on historical frequency analysis.
  ///
  /// Analyzes the provided [history] of past spins and returns the
  /// most frequently occurring number as a prediction.
  ///
  /// **Parameters:**
  /// - [history]: List of previous spin results to analyze
  ///
  /// **Returns:**
  /// - Most frequent number in history if history is not empty
  /// - Random number (0-36) if history is empty
  ///
  /// **Algorithm:**
  /// 1. Count frequency of each number in history
  /// 2. Find the number with maximum frequency
  /// 3. Return that number as prediction
  ///
  /// **Complexity:** O(n) where n is the length of history.
  ///
  /// **Important Educational Note:**
  /// This is a simulation for educational purposes. In real roulette,
  /// each spin is independent and past results do not influence future
  /// outcomes. This "prediction" is based on frequency analysis only
  /// and has no bearing on actual probability.
  ///
  /// **Example:**
  /// ```dart
  /// final roulette = RouletteLogic();
  /// 
  /// // Empty history returns random number
  /// final pred1 = roulette.predictNext([]);
  /// 
  /// // Predicts most frequent (7 appears 3 times)
  /// final history = [7, 15, 7, 22, 7, 33];
  /// final pred2 = roulette.predictNext(history);  // Returns 7
  /// ```
  ///
  /// See also:
  /// - [generateSpin] for generating actual spin results
  int predictNext(List<int> history) {
    if (history.isEmpty) return rng.nextInt(37);
    
    // Count frequency of each number
    final freq = <int, int>{};
    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    
    // Return number with highest frequency
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

/// Martingale betting strategy advisor.
///
/// The Martingale strategy is a progressive betting system where:
/// - After a loss: Double the bet
/// - After a win: Return to base bet
///
/// **Goal:** Recover all previous losses plus win one base bet unit.
///
/// **⚠️ CRITICAL WARNING:**
/// This is an EDUCATIONAL SIMULATION ONLY. The Martingale strategy:
/// - Requires large bankroll (can escalate quickly)
/// - Does NOT overcome house edge
/// - Can lead to rapid losses in real gambling
/// - Is subject to table limits in casinos
/// - Does NOT guarantee profits
///
/// **Example Progression:**
/// ```
/// Bet  | Result | Cumulative Loss | Next Bet
/// -----|--------|-----------------|----------
/// $10  | Loss   | -$10           | $20
/// $20  | Loss   | -$30           | $40
/// $40  | Loss   | -$70           | $80
/// $80  | Win    | +$10           | $10 (reset)
/// ```
///
/// **Usage Example:**
/// ```dart
/// final advisor = MartingaleAdvisor();
/// advisor.baseBet = 10.0;
/// 
/// // After loss
/// print(advisor.getNextBet(false));  // 20.0
/// print(advisor.getNextBet(false));  // 40.0
/// 
/// // After win
/// print(advisor.getNextBet(true));   // 10.0 (back to base)
/// ```
///
/// See also:
/// - [RouletteLogic] for roulette simulation
class MartingaleAdvisor {
  /// Base bet amount to start with and return to after wins.
  ///
  /// This is the fundamental betting unit. All calculations are based
  /// on multiples of this value. Default is 1.0 (currency unit).
  double baseBet = 1.0;
  
  /// Current bet amount for the next wager.
  ///
  /// This value changes based on wins/losses:
  /// - Doubles after each loss
  /// - Resets to [baseBet] after each win
  double currentBet = 1.0;
  
  /// Whether the last bet was a win.
  ///
  /// Used to track betting history. True if last bet won,
  /// false if last bet lost.
  bool lastWin = true;

  /// Calculates the next bet amount based on the outcome.
  ///
  /// Implements the core Martingale logic:
  /// - **Win:** Resets [currentBet] to [baseBet]
  /// - **Loss:** Doubles the [currentBet]
  ///
  /// **Parameters:**
  /// - [win]: Whether the bet was won (true) or lost (false)
  ///
  /// **Returns:** The next bet amount to wager.
  ///
  /// **Example:**
  /// ```dart
  /// final advisor = MartingaleAdvisor();
  /// advisor.baseBet = 10.0;
  /// 
  /// var nextBet = advisor.getNextBet(false);  // Lost: returns 20.0
  /// nextBet = advisor.getNextBet(false);      // Lost again: returns 40.0
  /// nextBet = advisor.getNextBet(true);       // Won: returns 10.0 (reset)
  /// ```
  ///
  /// **Escalation Example:**
  /// Starting with $10 base bet, seven consecutive losses result in:
  /// $10 → $20 → $40 → $80 → $160 → $320 → $640 → $1,280
  /// Total wagered: $2,550
  ///
  /// See also:
  /// - [reset] to manually reset to base bet
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

  /// Resets the advisor to initial state.
  ///
  /// Sets [currentBet] back to [baseBet] and marks [lastWin] as true.
  /// Use this when starting a new game session or after a major loss
  /// to restart the betting progression.
  ///
  /// **Example:**
  /// ```dart
  /// final advisor = MartingaleAdvisor();
  /// advisor.baseBet = 10.0;
  /// 
  /// // After several bets
  /// advisor.getNextBet(false);  // 20.0
  /// advisor.getNextBet(false);  // 40.0
  /// 
  /// // Reset to start fresh
  /// advisor.reset();
  /// print(advisor.currentBet);  // 10.0
  /// print(advisor.lastWin);     // true
  /// ```
  ///
  /// See also:
  /// - [getNextBet] for normal bet progression
  void reset() {
    currentBet = baseBet;
    lastWin = true;
  }
}