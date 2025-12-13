import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    test('generateSpin devuelve un número válido entre 0 y 36', () {
      for (int i = 0; i < 100; i++) {
        final spin = roulette.generateSpin();
        expect(spin, greaterThanOrEqualTo(0));
        expect(spin, lessThanOrEqualTo(36));
      }
    });

    test('predictNext devuelve un número entre 0 y 36', () {
      final history = [1, 2, 3, 4, 5];
      final prediction = roulette.predictNext(history);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext con historial vacío devuelve un número válido', () {
      final prediction = roulette.predictNext([]);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext devuelve el número más frecuente', () {
      final history = [5, 5, 5, 1, 2];
      final prediction = roulette.predictNext(history);
      expect(prediction, equals(5));
    });
  });

  group('MartingaleAdvisor', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    test('inicia con apuesta base de 1.0', () {
      expect(advisor.baseBet, equals(1.0));
      expect(advisor.currentBet, equals(1.0));
    });

    test('duplica la apuesta después de perder', () {
      final nextBet = advisor.getNextBet(false);
      expect(nextBet, equals(2.0));
      expect(advisor.currentBet, equals(2.0));
    });

    test('vuelve a la apuesta base después de ganar', () {
      advisor.getNextBet(false); // Pierde, apuesta sube a 2.0
      advisor.getNextBet(false); // Pierde, apuesta sube a 4.0
      final nextBet = advisor.getNextBet(true); // Gana
      expect(nextBet, equals(1.0));
      expect(advisor.currentBet, equals(1.0));
    });

    test('sigue duplicando en pérdidas consecutivas', () {
      expect(advisor.getNextBet(false), equals(2.0));
      expect(advisor.getNextBet(false), equals(4.0));
      expect(advisor.getNextBet(false), equals(8.0));
      expect(advisor.getNextBet(false), equals(16.0));
    });

    test('reset restaura valores iniciales', () {
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      advisor.reset();
      expect(advisor.currentBet, equals(advisor.baseBet));
      expect(advisor.lastWin, isTrue);
    });

    test('puede configurar apuesta base personalizada', () {
      advisor.baseBet = 5.0;
      advisor.reset();
      expect(advisor.currentBet, equals(5.0));
      advisor.getNextBet(false);
      expect(advisor.currentBet, equals(10.0));
    });

    test('la apuesta puede exceder límites teóricos', () {
      // Simula múltiples pérdidas consecutivas
      advisor.getNextBet(false); // 2.0
      advisor.getNextBet(false); // 4.0
      advisor.getNextBet(false); // 8.0
      advisor.getNextBet(false); // 16.0
      advisor.getNextBet(false); // 32.0
      
      // La apuesta puede crecer más allá del balance disponible
      // La limitación debe hacerse en la lógica de la UI
      expect(advisor.currentBet, equals(32.0));
    });
  });
}
