import 'dart:math';

class RouletteLogic {
  final List<int> wheel = List.generate(37, (i) => i);  // Europea
  final Random rng = Random.secure();

  int generateSpin() {
    return wheel[rng.nextInt(wheel.length)];
  }

  int predictNext(List<int> history) {
    if (history.isEmpty) return rng.nextInt(37);
    // Predicción simple: más frecuente
    var freq = <int, int>{};
    for (var num in history) freq[num] = (freq[num] ?? 0) + 1;
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
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