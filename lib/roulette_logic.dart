import 'dart:math';

/// Clase para simular la lógica de un generador de números aleatorios
/// basado en el sistema de ruleta europea (37 números: 0-36).
/// Propósito educativo: demostrar RNG y análisis estadístico.
class RouletteLogic {
  final List<int> wheel = List.generate(37, (i) => i);  // Ruleta europea (0-36)
  final Random rng = Random.secure();

  /// Genera un número aleatorio entre 0 y 36
  int generateSpin() {
    return wheel[rng.nextInt(wheel.length)];
  }

  /// Análisis estadístico simple: predice basándose en frecuencias históricas
  /// Nota educativa: esto demuestra que en sistemas verdaderamente aleatorios,
  /// el pasado no predice el futuro (falacia del jugador)
  int predictNext(List<int> history) {
    if (history.isEmpty) return rng.nextInt(37);
    // Análisis de frecuencia: número más común en el historial
    var freq = <int, int>{};
    for (var num in history) freq[num] = (freq[num] ?? 0) + 1;
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

/// Asesor de simulación que implementa una estrategia de duplicación progresiva
/// (conocida académicamente como "Martingala").
/// Propósito educativo: demostrar cómo funcionan las progresiones geométricas
/// y por qué no garantizan éxito en sistemas aleatorios.
class SimulationAdvisor {
  double baseValue = 1.0;
  double currentValue = 1.0;
  bool lastSuccess = true;

  /// Calcula el siguiente valor según el resultado del intento anterior
  /// Success: reinicia al valor base
  /// Fallo: duplica el valor actual
  double getNextValue(bool success) {
    if (success) {
      currentValue = baseValue;
      lastSuccess = true;
    } else {
      currentValue *= 2;
      lastSuccess = false;
    }
    return currentValue;
  }

  /// Reinicia la simulación a los valores iniciales
  void reset() {
    currentValue = baseValue;
    lastSuccess = true;
  }
}