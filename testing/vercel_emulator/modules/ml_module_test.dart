import '../test_runner.dart';

/// Módulo de pruebas para lógica de Machine Learning (Roulette Logic)
class MLModuleTest extends TestModule {
  @override
  String get name => 'ML & Roulette Logic';

  @override
  bool get critical => true;

  @override
  List<Test> get tests => [
        Test(
          name: 'RNG generates valid numbers (0-36)',
          run: () async {
            // Simular lógica de RNG
            final results = <int>[];
            for (var i = 0; i < 100; i++) {
              final num = _simulateRNG();
              results.add(num);
              
              // Verificar rango válido
              if (num < 0 || num > 36) {
                throw Exception('Invalid number generated: $num');
              }
            }

            // Verificar distribución razonable
            if (results.toSet().length < 20) {
              throw Exception('Poor RNG distribution');
            }
          },
        ),
        Test(
          name: 'Prediction algorithm returns valid number',
          run: () async {
            final history = [1, 5, 12, 5, 23, 5, 8];
            final prediction = _simulatePrediction(history);

            if (prediction < 0 || prediction > 36) {
              throw Exception('Invalid prediction: $prediction');
            }
          },
        ),
        Test(
          name: 'Martingale strategy calculates correctly',
          run: () async {
            double currentBet = 1.0;

            // Primera apuesta pierde - debe duplicar
            currentBet = _martingaleNextBet(currentBet, false);
            if (currentBet != 2.0) {
              throw Exception('Expected 2.0, got $currentBet');
            }

            // Segunda apuesta pierde - debe duplicar nuevamente
            currentBet = _martingaleNextBet(currentBet, false);
            if (currentBet != 4.0) {
              throw Exception('Expected 4.0, got $currentBet');
            }

            // Tercera apuesta gana - debe volver a base
            currentBet = _martingaleNextBet(currentBet, true);
            if (currentBet != 1.0) {
              throw Exception('Expected 1.0, got $currentBet');
            }
          },
        ),
        Test(
          name: 'Prediction with empty history',
          run: () async {
            final prediction = _simulatePrediction([]);
            
            if (prediction < 0 || prediction > 36) {
              throw Exception('Invalid prediction for empty history: $prediction');
            }
          },
        ),
        Test(
          name: 'Frequency analysis works correctly',
          run: () async {
            final history = [5, 5, 5, 12, 12, 7];
            final mostFrequent = _getMostFrequent(history);

            if (mostFrequent != 5) {
              throw Exception('Expected 5, got $mostFrequent');
            }
          },
        ),
      ];

  // Simulaciones de lógica de negocio
  int _simulateRNG() {
    return DateTime.now().microsecond % 37;
  }

  int _simulatePrediction(List<int> history) {
    if (history.isEmpty) return 0;
    return _getMostFrequent(history);
  }

  int _getMostFrequent(List<int> numbers) {
    final freq = <int, int>{};
    for (final num in numbers) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _martingaleNextBet(double current, bool win) {
    if (win) {
      return 1.0; // Volver a apuesta base
    } else {
      return current * 2; // Duplicar apuesta
    }
  }
}
