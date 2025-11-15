import 'dart:math';

class RouletteLogic {
  static const List<int> wheel = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36];  // Europea
  final Random rng = Random.secure();

  int generateSpin() {
    return rng.nextInt(37); // Direct random, no need to index into wheel
  }

  int predictNext(List<int> history) {
    if (history.isEmpty) return rng.nextInt(37);
    // Predicción simple: más frecuente
    // Optimized: single pass frequency count
    var freq = <int, int>{};
    var maxFreq = 0;
    var mostFrequent = 0;
    
    for (var num in history) {
      final count = (freq[num] ?? 0) + 1;
      freq[num] = count;
      if (count > maxFreq) {
        maxFreq = count;
        mostFrequent = num;
      }
    }
    
    return mostFrequent;
  }
}

class MartingaleAdvisor {
  double baseBet = 1.0;
  double currentBet = 1.0;
  bool lastWin = true;

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

  void reset() {
    currentBet = baseBet;
    lastWin = true;
  }
}