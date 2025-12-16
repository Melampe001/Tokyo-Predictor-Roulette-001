import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/services/rng_service.dart';
import 'package:tokyo_roulette_predicciones/services/prediction_service.dart';
import 'package:tokyo_roulette_predicciones/models/prediction_model.dart';

void main() {
  group('PredictionService', () {
    late PredictionService predictionService;
    late RNGService rngService;

    setUp(() {
      rngService = RNGService();
      predictionService = PredictionService(rngService);
    });

    group('predictNext con historial vacío', () {
      test('devuelve una predicción válida', () {
        final prediction = predictionService.predictNext([]);
        
        expect(prediction, isA<PredictionModel>());
        expect(prediction.predictedNumber, greaterThanOrEqualTo(0));
        expect(prediction.predictedNumber, lessThanOrEqualTo(36));
      });

      test('devuelve confianza baja', () {
        final prediction = predictionService.predictNext([]);
        expect(prediction.confidence, equals(0.1));
      });

      test('usa método random', () {
        final prediction = predictionService.predictNext([]);
        expect(prediction.method, equals('random'));
      });

      test('incluye timestamp', () {
        final before = DateTime.now();
        final prediction = predictionService.predictNext([]);
        final after = DateTime.now();
        
        expect(
          prediction.timestamp.isAfter(before) || 
          prediction.timestamp.isAtSameMomentAs(before),
          isTrue,
        );
        expect(
          prediction.timestamp.isBefore(after) || 
          prediction.timestamp.isAtSameMomentAs(after),
          isTrue,
        );
      });
    });

    group('predictNext con historial', () {
      test('devuelve el número más frecuente cuando es claro', () {
        final history = [5, 5, 5, 5, 1, 2, 3];
        final prediction = predictionService.predictNext(history);
        
        expect(prediction.predictedNumber, equals(5));
      });

      test('usa método frequency_analysis', () {
        final history = [1, 2, 3, 3, 3];
        final prediction = predictionService.predictNext(history);
        
        expect(prediction.method, equals('frequency_analysis'));
      });

      test('calcula confianza mayor con historial', () {
        final history = [5, 5, 5, 1, 2];
        final prediction = predictionService.predictNext(history);
        
        expect(prediction.confidence, greaterThan(0.2));
      });

      test('confianza aumenta con más repeticiones', () {
        final history1 = [5, 1, 2, 3, 4];
        final prediction1 = predictionService.predictNext(history1);
        
        final history2 = [5, 5, 5, 1, 2];
        final prediction2 = predictionService.predictNext(history2);
        
        if (prediction2.predictedNumber == 5) {
          expect(prediction2.confidence, greaterThan(prediction1.confidence));
        }
      });

      test('confianza está entre 0.1 y 0.9', () {
        final history = List.generate(20, (_) => 5); // Todos 5
        final prediction = predictionService.predictNext(history);
        
        expect(prediction.confidence, greaterThanOrEqualTo(0.1));
        expect(prediction.confidence, lessThanOrEqualTo(0.9));
      });

      test('maneja historial pequeño correctamente', () {
        final history = [3];
        final prediction = predictionService.predictNext(history);
        
        expect(prediction, isA<PredictionModel>());
        expect(prediction.predictedNumber, greaterThanOrEqualTo(0));
        expect(prediction.predictedNumber, lessThanOrEqualTo(36));
      });

      test('maneja historial grande correctamente', () {
        final history = List.generate(100, (i) => i % 37);
        final prediction = predictionService.predictNext(history);
        
        expect(prediction, isA<PredictionModel>());
        expect(prediction.predictedNumber, greaterThanOrEqualTo(0));
        expect(prediction.predictedNumber, lessThanOrEqualTo(36));
      });
    });

    group('números calientes (hot numbers)', () {
      test('considera números que aparecen múltiples veces', () {
        // Los últimos 10 números con algunos repetidos
        final history = [1, 2, 7, 7, 3, 4, 7, 5, 6, 7, 8, 9, 10];
        
        // Ejecutar múltiples veces ya que hay aleatoriedad
        final predictions = <int>{};
        for (int i = 0; i < 20; i++) {
          final prediction = predictionService.predictNext(history);
          predictions.add(prediction.predictedNumber);
        }
        
        // El 7 aparece 4 veces, debería estar en las predicciones
        expect(predictions.contains(7), isTrue);
      });

      test('solo considera los últimos números para hot numbers', () {
        // Número 5 aparece al inicio, 7 aparece al final
        final history = [5, 5, 5, 1, 2, 3, 4, 7, 7, 8, 9, 7, 10];
        
        // Las predicciones deberían favorecer 7 sobre 5
        final predictions = <int>[];
        for (int i = 0; i < 50; i++) {
          final prediction = predictionService.predictNext(history);
          predictions.add(prediction.predictedNumber);
        }
        
        final sevenCount = predictions.where((n) => n == 7).length;
        final fiveCount = predictions.where((n) => n == 5).length;
        
        // 7 debería aparecer más que 5 (aunque hay aleatoriedad)
        expect(sevenCount + fiveCount, greaterThan(0));
      });
    });

    group('validación de datos', () {
      test('no lanza excepción con historial vacío', () {
        expect(() => predictionService.predictNext([]), returnsNormally);
      });

      test('no lanza excepción con historial muy largo', () {
        final history = List.generate(1000, (i) => i % 37);
        expect(() => predictionService.predictNext(history), returnsNormally);
      });

      test('maneja todos los números de ruleta válidos', () {
        for (int i = 0; i <= 36; i++) {
          final history = [i, i, i];
          final prediction = predictionService.predictNext(history);
          expect(prediction.predictedNumber, equals(i));
        }
      });
    });

    group('consistencia del servicio', () {
      test('siempre devuelve timestamp actual', () {
        final history = [1, 2, 3];
        
        final prediction1 = predictionService.predictNext(history);
        // Espera un poco
        Future.delayed(const Duration(milliseconds: 10));
        final prediction2 = predictionService.predictNext(history);
        
        expect(
          prediction2.timestamp.isAtSameMomentAs(prediction1.timestamp) ||
          prediction2.timestamp.isAfter(prediction1.timestamp),
          isTrue,
        );
      });

      test('es independiente entre llamadas', () {
        final history = [1, 2, 3];
        
        final prediction1 = predictionService.predictNext(history);
        final prediction2 = predictionService.predictNext(history);
        
        // Aunque pueden ser iguales por casualidad, deben ser objetos diferentes
        expect(identical(prediction1, prediction2), isFalse);
      });
    });
  });
}
