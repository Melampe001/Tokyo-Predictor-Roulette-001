import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/services/rng_service.dart';

void main() {
  group('RNGService', () {
    late RNGService rngService;

    setUp(() {
      rngService = RNGService();
    });

    group('generateRouletteNumber', () {
      test('genera números válidos entre 0 y 36', () {
        for (int i = 0; i < 100; i++) {
          final number = rngService.generateRouletteNumber();
          expect(number, greaterThanOrEqualTo(0));
          expect(number, lessThanOrEqualTo(36));
        }
      });

      test('genera diferentes números (no siempre el mismo)', () {
        final numbers = <int>{};
        for (int i = 0; i < 50; i++) {
          numbers.add(rngService.generateRouletteNumber());
        }
        // Debe haber al menos 10 números diferentes en 50 generaciones
        expect(numbers.length, greaterThan(10));
      });

      test('cubre todo el rango 0-36 con suficientes muestras', () {
        final numbers = <int>{};
        for (int i = 0; i < 500; i++) {
          numbers.add(rngService.generateRouletteNumber());
        }
        // Debe cubrir al menos el 80% del rango (30 de 37 números)
        expect(numbers.length, greaterThan(30));
      });
    });

    group('generateInRange', () {
      test('genera números en el rango especificado', () {
        for (int i = 0; i < 50; i++) {
          final number = rngService.generateInRange(10, 20);
          expect(number, greaterThanOrEqualTo(10));
          expect(number, lessThanOrEqualTo(20));
        }
      });

      test('funciona con rango de un solo número', () {
        final number = rngService.generateInRange(5, 5);
        expect(number, equals(5));
      });

      test('genera diferentes números en el rango', () {
        final numbers = <int>{};
        for (int i = 0; i < 30; i++) {
          numbers.add(rngService.generateInRange(1, 10));
        }
        expect(numbers.length, greaterThan(5));
      });

      test('lanza error si min > max', () {
        expect(
          () => rngService.generateInRange(20, 10),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('funciona con números negativos', () {
        final number = rngService.generateInRange(-10, -5);
        expect(number, greaterThanOrEqualTo(-10));
        expect(number, lessThanOrEqualTo(-5));
      });
    });

    group('generateDouble', () {
      test('genera números entre 0.0 y 1.0', () {
        for (int i = 0; i < 50; i++) {
          final value = rngService.generateDouble();
          expect(value, greaterThanOrEqualTo(0.0));
          expect(value, lessThanOrEqualTo(1.0));
        }
      });

      test('genera diferentes valores', () {
        final values = <double>{};
        for (int i = 0; i < 50; i++) {
          values.add(rngService.generateDouble());
        }
        // Debe haber muchos valores únicos
        expect(values.length, greaterThan(45));
      });
    });

    group('generateBool', () {
      test('genera true y false', () {
        final values = <bool>{};
        for (int i = 0; i < 20; i++) {
          values.add(rngService.generateBool());
        }
        // Debe tener ambos valores en 20 generaciones
        expect(values.contains(true), isTrue);
        expect(values.contains(false), isTrue);
      });

      test('distribución aproximadamente equitativa', () {
        int trueCount = 0;
        const iterations = 1000;
        
        for (int i = 0; i < iterations; i++) {
          if (rngService.generateBool()) {
            trueCount++;
          }
        }
        
        // Debe estar cerca del 50% (entre 40% y 60%)
        expect(trueCount / iterations, greaterThan(0.4));
        expect(trueCount / iterations, lessThan(0.6));
      });
    });
  });
}
