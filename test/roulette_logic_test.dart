import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic rouletteLogic;

    setUp(() {
      rouletteLogic = RouletteLogic();
    });

    test('generateSpin devuelve un número entre 0 y 36', () {
      for (int i = 0; i < 100; i++) {
        final spin = rouletteLogic.generateSpin();
        expect(spin, greaterThanOrEqualTo(0));
        expect(spin, lessThanOrEqualTo(36));
      }
    });

    test('generateSpin produce diferentes números (no siempre el mismo)', () {
      final results = <int>{};
      for (int i = 0; i < 50; i++) {
        results.add(rouletteLogic.generateSpin());
      }
      // Con 50 giros, deberíamos tener al menos 10 números diferentes
      expect(results.length, greaterThan(10));
    });

    test('predictNext devuelve un número válido con historial vacío', () {
      final prediction = rouletteLogic.predictNext([]);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext devuelve el número más frecuente del historial', () {
      final history = [5, 10, 5, 20, 5, 15];
      final prediction = rouletteLogic.predictNext(history);
      // El 5 aparece 3 veces, debería ser la predicción
      expect(prediction, equals(5));
    });

    test('predictNext maneja historial con un solo elemento', () {
      final history = [10];
      final prediction = rouletteLogic.predictNext(history);
      expect(prediction, equals(10));
    });

    test('predictNext maneja empates en frecuencia', () {
      final history = [5, 10, 5, 10];
      final prediction = rouletteLogic.predictNext(history);
      // Debería devolver 5 o 10 (ambos tienen la misma frecuencia)
      expect([5, 10].contains(prediction), isTrue);
    });

    test('wheel contiene exactamente 37 números (0-36)', () {
      expect(rouletteLogic.wheel.length, equals(37));
      expect(rouletteLogic.wheel.first, equals(0));
      expect(rouletteLogic.wheel.last, equals(36));
    });
  });

  group('MartingaleAdvisor', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    test('baseBet inicial es 1.0', () {
      expect(advisor.baseBet, equals(1.0));
      expect(advisor.currentBet, equals(1.0));
    });

    test('getNextBet duplica la apuesta después de una pérdida', () {
      advisor.baseBet = 10.0;
      advisor.currentBet = 10.0;
      
      final nextBet = advisor.getNextBet(false); // pérdida
      expect(nextBet, equals(20.0));
      expect(advisor.currentBet, equals(20.0));
    });

    test('getNextBet vuelve a baseBet después de una victoria', () {
      advisor.baseBet = 10.0;
      advisor.currentBet = 40.0; // después de varias pérdidas
      
      final nextBet = advisor.getNextBet(true); // victoria
      expect(nextBet, equals(10.0));
      expect(advisor.currentBet, equals(10.0));
    });

    test('getNextBet duplica progresivamente con pérdidas consecutivas', () {
      advisor.baseBet = 5.0;
      advisor.currentBet = 5.0;
      
      expect(advisor.getNextBet(false), equals(10.0));  // pérdida 1
      expect(advisor.getNextBet(false), equals(20.0));  // pérdida 2
      expect(advisor.getNextBet(false), equals(40.0));  // pérdida 3
      expect(advisor.getNextBet(false), equals(80.0));  // pérdida 4
    });

    test('lastWin se actualiza correctamente', () {
      expect(advisor.lastWin, isTrue); // inicial
      
      advisor.getNextBet(false);
      expect(advisor.lastWin, isFalse);
      
      advisor.getNextBet(true);
      expect(advisor.lastWin, isTrue);
    });

    test('reset restaura valores iniciales', () {
      advisor.baseBet = 10.0;
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      
      expect(advisor.currentBet, equals(40.0));
      expect(advisor.lastWin, isFalse);
      
      advisor.reset();
      
      expect(advisor.currentBet, equals(10.0));
      expect(advisor.lastWin, isTrue);
    });

    test('baseBet puede ser modificado', () {
      advisor.baseBet = 25.0;
      expect(advisor.baseBet, equals(25.0));
      
      advisor.getNextBet(false);
      advisor.getNextBet(true); // vuelve a baseBet
      expect(advisor.currentBet, equals(25.0));
    });

    test('estrategia Martingale con escenario realista', () {
      advisor.baseBet = 10.0;
      advisor.currentBet = 10.0;
      
      // Secuencia: pérdida, pérdida, pérdida, victoria
      expect(advisor.getNextBet(false), equals(20.0));
      expect(advisor.getNextBet(false), equals(40.0));
      expect(advisor.getNextBet(false), equals(80.0));
      expect(advisor.getNextBet(true), equals(10.0)); // vuelve a base
    });
  });
}
