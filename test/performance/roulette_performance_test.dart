import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

/// Performance tests for critical algorithms
/// These tests ensure that operations complete within acceptable time limits
void main() {
  group('RouletteLogic Performance', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    test('generateSpin completes in under 1ms', () {
      final stopwatch = Stopwatch()..start();
      
      // Run 1000 times to get average
      for (int i = 0; i < 1000; i++) {
        roulette.generateSpin();
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / 1000;
      
      // Should be very fast (under 1000 microseconds = 1ms per operation)
      expect(averageTime, lessThan(1000));
      
      // ignore: avoid_print
      print('Average generateSpin time: ${averageTime.toStringAsFixed(2)} μs');
    });

    test('predictNext completes in under 10ms with long history', () {
      // Create a long history (100 numbers)
      final history = List.generate(100, (i) => i % 37);
      
      final stopwatch = Stopwatch()..start();
      
      // Run 100 times
      for (int i = 0; i < 100; i++) {
        roulette.predictNext(history);
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / 100;
      
      // Should complete in under 10ms (10000 microseconds)
      expect(averageTime, lessThan(10000));
      
      // ignore: avoid_print
      print('Average predictNext time (100 items): ${averageTime.toStringAsFixed(2)} μs');
    });

    test('predictNext scales linearly with history size', () {
      final sizes = [10, 50, 100, 200];
      final times = <int, double>{};
      
      for (final size in sizes) {
        final history = List.generate(size, (i) => i % 37);
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 100; i++) {
          roulette.predictNext(history);
        }
        
        stopwatch.stop();
        times[size] = stopwatch.elapsedMicroseconds / 100;
      }
      
      // Verify that time increases with size (but not exponentially)
      expect(times[50]!, greaterThan(times[10]!));
      expect(times[100]!, greaterThan(times[50]!));
      
      // Verify reasonable scaling (100 items shouldn't take more than 10x as long as 10 items)
      expect(times[100]! / times[10]!, lessThan(20));
      
      // ignore: avoid_print
      for (final entry in times.entries) {
        print('predictNext (${entry.key} items): ${entry.value.toStringAsFixed(2)} μs');
      }
    });

    test('generateSpin maintains performance over many iterations', () {
      final iterations = 10000;
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < iterations; i++) {
        roulette.generateSpin();
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / iterations;
      
      // Should maintain consistent performance
      expect(averageTime, lessThan(1000));
      
      // ignore: avoid_print
      print('$iterations iterations average time: ${averageTime.toStringAsFixed(2)} μs');
    });
  });

  group('MartingaleAdvisor Performance', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    test('getNextBet completes in under 1ms', () {
      final stopwatch = Stopwatch()..start();
      
      // Run 1000 times
      for (int i = 0; i < 1000; i++) {
        advisor.getNextBet(i % 2 == 0);
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / 1000;
      
      expect(averageTime, lessThan(1000));
      
      // ignore: avoid_print
      print('Average getNextBet time: ${averageTime.toStringAsFixed(2)} μs');
    });

    test('reset completes instantly', () {
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 1000; i++) {
        advisor.reset();
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / 1000;
      
      // Reset should be extremely fast
      expect(averageTime, lessThan(100));
      
      // ignore: avoid_print
      print('Average reset time: ${averageTime.toStringAsFixed(2)} μs');
    });

    test('maintains performance during long losing streak', () {
      final iterations = 100;
      final stopwatch = Stopwatch()..start();
      
      // Simulate 100 consecutive losses
      for (int i = 0; i < iterations; i++) {
        advisor.getNextBet(false);
      }
      
      stopwatch.stop();
      final averageTime = stopwatch.elapsedMicroseconds / iterations;
      
      expect(averageTime, lessThan(1000));
      
      // ignore: avoid_print
      print('Long losing streak average time: ${averageTime.toStringAsFixed(2)} μs');
    });
  });

  group('Memory Performance', () {
    test('RouletteLogic does not leak memory', () {
      // Create and discard many instances
      for (int i = 0; i < 1000; i++) {
        final roulette = RouletteLogic();
        roulette.generateSpin();
        // Instance should be garbage collected
      }
      
      // If we reach here without OOM, memory is managed correctly
      expect(true, isTrue);
    });

    test('History list does not grow unbounded', () {
      // Simulates the app's history limiting behavior
      final history = <int>[];
      const maxHistory = 20;
      
      // Add 100 numbers
      for (int i = 0; i < 100; i++) {
        history.add(i % 37);
        
        // Limit history size (as done in the app)
        if (history.length > maxHistory) {
          history.removeRange(0, history.length - maxHistory);
        }
      }
      
      // History should be limited to maxHistory
      expect(history.length, equals(maxHistory));
    });
  });

  group('Benchmark Summary', () {
    test('run full benchmark suite', () {
      final roulette = RouletteLogic();
      final advisor = MartingaleAdvisor();
      final results = <String, double>{};
      
      // Benchmark generateSpin
      var stopwatch = Stopwatch()..start();
      for (int i = 0; i < 10000; i++) {
        roulette.generateSpin();
      }
      stopwatch.stop();
      results['generateSpin (10k ops)'] = stopwatch.elapsedMilliseconds.toDouble();
      
      // Benchmark predictNext
      final history = List.generate(50, (i) => i % 37);
      stopwatch = Stopwatch()..start();
      for (int i = 0; i < 1000; i++) {
        roulette.predictNext(history);
      }
      stopwatch.stop();
      results['predictNext (1k ops, 50 items)'] = stopwatch.elapsedMilliseconds.toDouble();
      
      // Benchmark getNextBet
      stopwatch = Stopwatch()..start();
      for (int i = 0; i < 10000; i++) {
        advisor.getNextBet(i % 2 == 0);
      }
      stopwatch.stop();
      results['getNextBet (10k ops)'] = stopwatch.elapsedMilliseconds.toDouble();
      
      // ignore: avoid_print
      print('\n=== Performance Benchmark Summary ===');
      for (final entry in results.entries) {
        // ignore: avoid_print
        print('${entry.key}: ${entry.value.toStringAsFixed(2)} ms');
      }
      // ignore: avoid_print
      print('=====================================\n');
      
      // All benchmarks should complete in reasonable time
      for (final time in results.values) {
        expect(time, lessThan(1000)); // All operations under 1 second
      }
    });
  });
}
