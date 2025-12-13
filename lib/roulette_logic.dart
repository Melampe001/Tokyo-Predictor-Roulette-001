import 'dart:math';

/// Representa el color de un número de ruleta
enum RouletteColor { red, black, green }

/// Resultado de un giro de ruleta
class SpinResult {
  final int number;
  final RouletteColor color;

  SpinResult(this.number, this.color);
}

/// Lógica de ruleta europea (0-36)
class RouletteLogic {
  final List<int> wheel = List.generate(37, (i) => i);  // Ruleta europea
  final Random rng = Random.secure();

  // Números rojos en ruleta europea
  static const List<int> redNumbers = [
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  ];

  /// Obtiene el color de un número
  RouletteColor getColor(int number) {
    if (number == 0) return RouletteColor.green;
    return redNumbers.contains(number) ? RouletteColor.red : RouletteColor.black;
  }

  /// Genera un número aleatorio de la ruleta usando RNG seguro
  SpinResult generateSpin() {
    final number = wheel[rng.nextInt(wheel.length)];
    return SpinResult(number, getColor(number));
  }

  /// Predice el siguiente número basado en el historial
  /// Nota: Esta es una simulación educativa. En ruletas reales,
  /// cada giro es independiente y no se puede predecir.
  int predictNext(List<int> history) {
    if (history.isEmpty) return rng.nextInt(37);
    
    // Predicción simple: número más frecuente en historial
    final freq = <int, int>{};
    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Obtiene estadísticas del historial
  Map<String, dynamic> getStatistics(List<int> history) {
    if (history.isEmpty) {
      return {
        'total': 0,
        'reds': 0,
        'blacks': 0,
        'greens': 0,
        'most_frequent': null,
      };
    }

    int reds = 0, blacks = 0, greens = 0;
    final freq = <int, int>{};

    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
      final color = getColor(num);
      if (color == RouletteColor.red) reds++;
      else if (color == RouletteColor.black) blacks++;
      else greens++;
    }

    final mostFrequent = freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'total': history.length,
      'reds': reds,
      'blacks': blacks,
      'greens': greens,
      'most_frequent': mostFrequent,
    };
  }
}

/// Asesor de estrategia Martingale
/// ADVERTENCIA: Esta es una simulación educativa.
/// La estrategia Martingale tiene riesgos significativos en juegos reales.
class MartingaleAdvisor {
  double baseBet = 1.0;
  double currentBet = 1.0;
  bool lastWin = true;

  /// Calcula la siguiente apuesta basada en el resultado
  /// Si se gana, vuelve a la apuesta base
  /// Si se pierde, duplica la apuesta
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

  /// Reinicia el asesor a valores iniciales
  void reset() {
    currentBet = baseBet;
    lastWin = true;
  }
}