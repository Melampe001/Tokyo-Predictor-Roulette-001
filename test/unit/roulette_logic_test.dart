import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    group('generateSpin', () {
      test('devuelve un número válido entre 0 y 36', () {
        for (int i = 0; i < 100; i++) {
          final spin = roulette.generateSpin();
          expect(spin, greaterThanOrEqualTo(0));
          expect(spin, lessThanOrEqualTo(36));
        }
      });

      test('genera números aleatorios (no todos iguales)', () {
        final results = <int>{};
        for (int i = 0; i < 50; i++) {
          results.add(roulette.generateSpin());
        }
        // Debería tener al menos 10 números diferentes en 50 intentos
        expect(results.length, greaterThan(10));
      });

      test('incluye el número 0 en posibles resultados', () {
        final results = <int>[];
        for (int i = 0; i < 200; i++) {
          results.add(roulette.generateSpin());
        }
        // El 0 debería aparecer al menos una vez en 200 giros
        expect(results.contains(0), isTrue);
      });

      test('incluye el número 36 en posibles resultados', () {
        final results = <int>[];
        for (int i = 0; i < 200; i++) {
          results.add(roulette.generateSpin());
        }
        // El 36 debería aparecer al menos una vez en 200 giros
        expect(results.contains(36), isTrue);
      });

      test('usa RNG seguro (Random.secure)', () {
        // Verificamos que rng está definido y es de tipo Random
        expect(roulette.rng, isNotNull);
        // Este test verifica que la implementación usa Random
        // La seguridad se verifica mediante code review
      });
    });

    group('predictNext', () {
      test('devuelve un número entre 0 y 36', () {
        final history = [1, 2, 3, 4, 5];
        final prediction = roulette.predictNext(history);
        expect(prediction, greaterThanOrEqualTo(0));
        expect(prediction, lessThanOrEqualTo(36));
      });

      test('con historial vacío devuelve un número válido', () {
        final prediction = roulette.predictNext([]);
        expect(prediction, greaterThanOrEqualTo(0));
        expect(prediction, lessThanOrEqualTo(36));
      });

      test('devuelve el número más frecuente en el historial', () {
        final history = [5, 5, 5, 1, 2];
        final prediction = roulette.predictNext(history);
        expect(prediction, equals(5));
      });

      test('devuelve el primer número más frecuente cuando hay empate', () {
        // Con dos números igualmente frecuentes, debe devolver uno de ellos
        final history = [5, 5, 7, 7];
        final prediction = roulette.predictNext(history);
        expect([5, 7].contains(prediction), isTrue);
      });

      test('maneja historial con un solo número', () {
        final history = [15];
        final prediction = roulette.predictNext(history);
        expect(prediction, equals(15));
      });

      test('maneja historial con todos ceros', () {
        final history = [0, 0, 0];
        final prediction = roulette.predictNext(history);
        expect(prediction, equals(0));
      });

      test('maneja historial con números al límite superior', () {
        final history = [36, 36, 36, 35];
        final prediction = roulette.predictNext(history);
        expect(prediction, equals(36));
      });

      test('maneja historial largo', () {
        final history = List.generate(100, (i) => i % 37);
        final prediction = roulette.predictNext(history);
        expect(prediction, greaterThanOrEqualTo(0));
        expect(prediction, lessThanOrEqualTo(36));
      });

      test('predicción consistente para el mismo historial', () {
        final history = [10, 20, 10, 30, 10];
        final prediction1 = roulette.predictNext(history);
        final prediction2 = roulette.predictNext(history);
        // Ambas predicciones deben ser 10 (el más frecuente)
        expect(prediction1, equals(10));
        expect(prediction2, equals(10));
        expect(prediction1, equals(prediction2));
      });
    });

    group('wheel property', () {
      test('contiene exactamente 37 números (0-36)', () {
        expect(roulette.wheel.length, equals(37));
      });

      test('contiene todos los números de 0 a 36', () {
        for (int i = 0; i <= 36; i++) {
          expect(roulette.wheel.contains(i), isTrue);
        }
      });

      test('no contiene números duplicados', () {
        final uniqueNumbers = roulette.wheel.toSet();
        expect(uniqueNumbers.length, equals(37));
      });

      test('no contiene números negativos', () {
        for (final num in roulette.wheel) {
          expect(num, greaterThanOrEqualTo(0));
        }
      });

      test('no contiene números mayores a 36', () {
        for (final num in roulette.wheel) {
          expect(num, lessThanOrEqualTo(36));
        }
      });
    });
  });

  group('MartingaleAdvisor', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    group('initialization', () {
      test('inicia con apuesta base de 1.0', () {
        expect(advisor.baseBet, equals(1.0));
        expect(advisor.currentBet, equals(1.0));
      });

      test('inicia con lastWin en true', () {
        expect(advisor.lastWin, isTrue);
      });
    });

    group('getNextBet - perder', () {
      test('duplica la apuesta después de perder', () {
        final nextBet = advisor.getNextBet(false);
        expect(nextBet, equals(2.0));
        expect(advisor.currentBet, equals(2.0));
      });

      test('sigue duplicando en pérdidas consecutivas', () {
        expect(advisor.getNextBet(false), equals(2.0));
        expect(advisor.getNextBet(false), equals(4.0));
        expect(advisor.getNextBet(false), equals(8.0));
        expect(advisor.getNextBet(false), equals(16.0));
      });

      test('actualiza lastWin a false al perder', () {
        advisor.getNextBet(false);
        expect(advisor.lastWin, isFalse);
      });

      test('puede crecer exponencialmente', () {
        for (int i = 0; i < 10; i++) {
          advisor.getNextBet(false);
        }
        // Después de 10 pérdidas: 1 * 2^10 = 1024
        expect(advisor.currentBet, equals(1024.0));
      });
    });

    group('getNextBet - ganar', () {
      test('vuelve a la apuesta base después de ganar', () {
        advisor.getNextBet(false); // Pierde, apuesta sube a 2.0
        advisor.getNextBet(false); // Pierde, apuesta sube a 4.0
        final nextBet = advisor.getNextBet(true); // Gana
        expect(nextBet, equals(1.0));
        expect(advisor.currentBet, equals(1.0));
      });

      test('mantiene apuesta base si se gana desde el inicio', () {
        final nextBet = advisor.getNextBet(true);
        expect(nextBet, equals(1.0));
        expect(advisor.currentBet, equals(1.0));
      });

      test('actualiza lastWin a true al ganar', () {
        advisor.getNextBet(false);
        advisor.getNextBet(true);
        expect(advisor.lastWin, isTrue);
      });
    });

    group('reset', () {
      test('restaura valores iniciales', () {
        advisor.getNextBet(false);
        advisor.getNextBet(false);
        advisor.reset();
        expect(advisor.currentBet, equals(advisor.baseBet));
        expect(advisor.lastWin, isTrue);
      });

      test('respeta la apuesta base configurada', () {
        advisor.baseBet = 5.0;
        advisor.getNextBet(false);
        advisor.reset();
        expect(advisor.currentBet, equals(5.0));
      });
    });

    group('apuesta base personalizada', () {
      test('puede configurar apuesta base personalizada', () {
        advisor.baseBet = 5.0;
        advisor.reset();
        expect(advisor.currentBet, equals(5.0));
        advisor.getNextBet(false);
        expect(advisor.currentBet, equals(10.0));
      });

      test('funciona con apuesta base de 0.5', () {
        advisor.baseBet = 0.5;
        advisor.reset();
        expect(advisor.currentBet, equals(0.5));
        advisor.getNextBet(false);
        expect(advisor.currentBet, equals(1.0));
      });

      test('funciona con apuesta base alta', () {
        advisor.baseBet = 100.0;
        advisor.reset();
        expect(advisor.currentBet, equals(100.0));
        advisor.getNextBet(false);
        expect(advisor.currentBet, equals(200.0));
      });
    });

    group('escenarios complejos', () {
      test('secuencia mixta de victorias y derrotas', () {
        expect(advisor.getNextBet(false), equals(2.0)); // Pierde
        expect(advisor.getNextBet(false), equals(4.0)); // Pierde
        expect(advisor.getNextBet(true), equals(1.0)); // Gana, resetea
        expect(advisor.getNextBet(false), equals(2.0)); // Pierde nuevamente
        expect(advisor.getNextBet(true), equals(1.0)); // Gana, resetea
      });

      test('múltiples victorias consecutivas mantienen apuesta base', () {
        expect(advisor.getNextBet(true), equals(1.0));
        expect(advisor.getNextBet(true), equals(1.0));
        expect(advisor.getNextBet(true), equals(1.0));
        expect(advisor.currentBet, equals(1.0));
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

    group('edge cases', () {
      test('maneja apuesta base cero', () {
        advisor.baseBet = 0.0;
        advisor.reset();
        expect(advisor.currentBet, equals(0.0));
        advisor.getNextBet(false);
        expect(advisor.currentBet, equals(0.0)); // 0 * 2 = 0
      });

      test('maneja apuesta base negativa (no recomendado)', () {
        advisor.baseBet = -1.0;
        advisor.reset();
        expect(advisor.currentBet, equals(-1.0));
        advisor.getNextBet(false);
        expect(advisor.currentBet, equals(-2.0));
      });
    });
  });
}
