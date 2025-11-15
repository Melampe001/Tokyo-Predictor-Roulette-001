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

/// Manages the complete game state including history, results, and betting
class GameStateManager {
  static const double _initialBet = 10.0;
  
  final RouletteLogic _rouletteLogic = RouletteLogic();
  final MartingaleAdvisor _martingaleAdvisor = MartingaleAdvisor();
  
  List<int> _history = [];
  int? _currentResult;
  late double _currentBet;

  GameStateManager() {
    _martingaleAdvisor.baseBet = _initialBet;
    _currentBet = _initialBet;
  }

  List<int> get history => List.unmodifiable(_history);
  String get result => _currentResult?.toString() ?? 'Presiona Girar';
  double get currentBet => _currentBet;

  /// Performs a roulette spin and updates the game state
  void spin() {
    _currentResult = _rouletteLogic.generateSpin();
    _history.add(_currentResult!);
  }

  /// Gets the next predicted number based on history
  int getPrediction() {
    return _rouletteLogic.predictNext(_history);
  }

  /// Updates betting amount based on win/loss
  void updateBet(bool win) {
    _currentBet = _martingaleAdvisor.getNextBet(win);
  }

  /// Resets the game state to initial values
  void reset() {
    _history.clear();
    _currentResult = null;
    _martingaleAdvisor.reset();
    _currentBet = _initialBet;
  }
}