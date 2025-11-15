import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    test('generateSpin returns valid number between 0 and 36', () {
      for (int i = 0; i < 100; i++) {
        final spin = roulette.generateSpin();
        expect(spin, greaterThanOrEqualTo(0));
        expect(spin, lessThanOrEqualTo(36));
      }
    });

    test('predictNext returns random when history is empty', () {
      final prediction = roulette.predictNext([]);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext returns most frequent number', () {
      final history = [5, 10, 5, 20, 5, 30];
      final prediction = roulette.predictNext(history);
      expect(prediction, equals(5)); // 5 appears 3 times
    });

    test('predictNext handles single element', () {
      final history = [15];
      final prediction = roulette.predictNext(history);
      expect(prediction, equals(15));
    });

    test('predictNext performance with large history', () {
      // Test that predictNext performs well with large history
      final history = List.generate(1000, (i) => i % 37);
      final stopwatch = Stopwatch()..start();
      final prediction = roulette.predictNext(history);
      stopwatch.stop();
      
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
      // Should complete in less than 100ms for 1000 items
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });

  group('MartingaleAdvisor', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    test('getNextBet doubles on loss', () {
      expect(advisor.getNextBet(false), equals(2.0));
      expect(advisor.getNextBet(false), equals(4.0));
      expect(advisor.getNextBet(false), equals(8.0));
    });

    test('getNextBet resets to base on win', () {
      advisor.getNextBet(false); // 2.0
      advisor.getNextBet(false); // 4.0
      expect(advisor.getNextBet(true), equals(1.0));
    });

    test('reset returns to initial state', () {
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      advisor.reset();
      expect(advisor.currentBet, equals(1.0));
      expect(advisor.lastWin, equals(true));
    });
  });
}
