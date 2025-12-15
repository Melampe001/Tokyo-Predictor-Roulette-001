import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/services/martingale_service.dart';

void main() {
  group('MartingaleService', () {
    late MartingaleService service;

    setUp(() {
      service = MartingaleService(baseBet: 10.0);
    });

    group('inicialización', () {
      test('inicia con apuesta base correcta', () {
        expect(service.baseBet, equals(10.0));
        expect(service.currentBet, equals(10.0));
      });

      test('inicia con lastWin en true', () {
        expect(service.lastWin, isTrue);
      });

      test('permite configurar apuesta base personalizada', () {
        final customService = MartingaleService(baseBet: 25.0);
        expect(customService.baseBet, equals(25.0));
        expect(customService.currentBet, equals(25.0));
      });
    });

    group('getNextBet', () {
      test('duplica la apuesta después de perder', () {
        final nextBet = service.getNextBet(false);
        expect(nextBet, equals(20.0));
        expect(service.currentBet, equals(20.0));
        expect(service.lastWin, isFalse);
      });

      test('vuelve a la apuesta base después de ganar', () {
        service.getNextBet(false); // Pierde, sube a 20.0
        service.getNextBet(false); // Pierde, sube a 40.0
        
        final nextBet = service.getNextBet(true); // Gana
        expect(nextBet, equals(10.0));
        expect(service.currentBet, equals(10.0));
        expect(service.lastWin, isTrue);
      });

      test('sigue duplicando en pérdidas consecutivas', () {
        expect(service.getNextBet(false), equals(20.0));
        expect(service.getNextBet(false), equals(40.0));
        expect(service.getNextBet(false), equals(80.0));
        expect(service.getNextBet(false), equals(160.0));
        expect(service.getNextBet(false), equals(320.0));
      });

      test('respeta el límite máximo de apuesta', () {
        service.getNextBet(false); // 20
        service.getNextBet(false); // 40
        service.getNextBet(false); // 80
        
        final nextBet = service.getNextBet(false, maxBet: 100.0);
        expect(nextBet, equals(100.0));
        expect(service.currentBet, equals(100.0));
      });

      test('mantiene el límite en múltiples llamadas', () {
        service.getNextBet(false, maxBet: 50.0); // 20
        service.getNextBet(false, maxBet: 50.0); // 40
        final bet = service.getNextBet(false, maxBet: 50.0); // debería ser 50, no 80
        expect(bet, equals(50.0));
      });

      test('no afecta la apuesta base al ganar', () {
        service.getNextBet(false); // 20
        service.getNextBet(false); // 40
        service.getNextBet(true);  // Vuelve a 10
        
        expect(service.baseBet, equals(10.0));
        expect(service.currentBet, equals(10.0));
      });
    });

    group('reset', () {
      test('restaura valores iniciales', () {
        service.getNextBet(false);
        service.getNextBet(false);
        service.getNextBet(false);
        
        service.reset();
        
        expect(service.currentBet, equals(service.baseBet));
        expect(service.lastWin, isTrue);
      });

      test('mantiene la apuesta base', () {
        service.getNextBet(false);
        final originalBase = service.baseBet;
        
        service.reset();
        
        expect(service.baseBet, equals(originalBase));
      });
    });

    group('baseBet setter', () {
      test('actualiza la apuesta base y resetea', () {
        service.getNextBet(false); // 20
        service.getNextBet(false); // 40
        
        service.baseBet = 5.0;
        
        expect(service.baseBet, equals(5.0));
        expect(service.currentBet, equals(5.0));
        expect(service.lastWin, isTrue);
      });

      test('lanza error si el valor es 0 o negativo', () {
        expect(() => service.baseBet = 0, throwsA(isA<ArgumentError>()));
        expect(() => service.baseBet = -10, throwsA(isA<ArgumentError>()));
      });
    });

    group('escenarios complejos', () {
      test('simula una sesión de juego realista', () {
        // Gana, pierde, pierde, gana
        expect(service.getNextBet(true), equals(10.0));  // Gana, mantiene 10
        expect(service.getNextBet(false), equals(20.0)); // Pierde, sube a 20
        expect(service.getNextBet(false), equals(40.0)); // Pierde, sube a 40
        expect(service.getNextBet(true), equals(10.0));  // Gana, vuelve a 10
      });

      test('puede manejar rachas largas de pérdidas', () {
        double expected = 10.0;
        for (int i = 0; i < 10; i++) {
          expected *= 2;
          final result = service.getNextBet(false);
          expect(result, equals(expected));
        }
        
        // Después de 10 pérdidas consecutivas
        expect(service.currentBet, equals(10240.0));
      });

      test('recupera correctamente después de racha de pérdidas', () {
        // 5 pérdidas consecutivas
        service.getNextBet(false); // 20
        service.getNextBet(false); // 40
        service.getNextBet(false); // 80
        service.getNextBet(false); // 160
        service.getNextBet(false); // 320
        
        // Una victoria
        final bet = service.getNextBet(true);
        expect(bet, equals(10.0));
        
        // La siguiente apuesta debe ser la base
        expect(service.currentBet, equals(10.0));
      });
    });
  });
}
