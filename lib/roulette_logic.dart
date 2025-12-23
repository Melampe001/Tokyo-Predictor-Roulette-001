import 'dart:math';

/// Lógica de ruleta europea (0-36)
class RouletteLogic {
  final List<int> wheel = List.generate(37, (i) => i); // Ruleta europea
  final Random rng = Random.secure();

  /// Genera un número aleatorio de la ruleta usando RNG seguro
  int generateSpin() {
    return wheel[rng.nextInt(wheel.length)];
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
