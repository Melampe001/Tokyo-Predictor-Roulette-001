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
  double baseAttempt = 1.0;
  double currentAttempt = 1.0;
  bool lastSuccess = true;

  double getNextAttempt(bool success) {
    if (success) {
      currentAttempt = baseAttempt;
      lastSuccess = true;
    } else {
      currentAttempt *= 2;
      lastSuccess = false;
    }
    return currentAttempt;
  }

  void reset() {
    currentAttempt = baseAttempt;
    lastSuccess = true;
  }
}