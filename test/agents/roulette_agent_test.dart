/// Unit tests for RouletteAgent
///
/// These tests verify the functionality of the roulette simulation agent,
/// including spin generation, history management, and statistics calculation.

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/agents/roulette_agent.dart';

void main() {
  group('RouletteAgent', () {
    late RouletteAgent agent;

    setUp(() {
      agent = RouletteAgent();
    });

    group('spin()', () {
      test('should return a valid roulette number (0-36)', () {
        // Table-driven test: run multiple spins and verify all are valid
        for (var i = 0; i < 100; i++) {
          final result = agent.spin();
          expect(result, inInclusiveRange(0, 36),
              reason: 'Spin $i returned invalid number: $result');
        }
      });

      test('should use secure random generator', () {
        // Run enough spins to statistically verify randomness
        final results = <int, int>{};
        const spins = 1000;

        for (var i = 0; i < spins; i++) {
          final result = agent.spin();
          results[result] = (results[result] ?? 0) + 1;
        }

        // Each number should appear at least once in 1000 spins
        // (probability of not appearing is extremely low)
        for (var i = 0; i <= 36; i++) {
          expect(results.containsKey(i), isTrue,
              reason: 'Number $i never appeared in $spins spins');
        }
      });
    });

    group('addToHistory()', () {
      test('should add valid numbers to history', () {
        agent.addToHistory(0);
        agent.addToHistory(17);
        agent.addToHistory(36);

        expect(agent.history, equals([0, 17, 36]));
        expect(agent.historyLength, equals(3));
      });

      test('should throw ArgumentError for invalid numbers', () {
        // Table-driven test for invalid inputs
        final invalidNumbers = [-1, -100, 37, 100, 1000];

        for (final invalid in invalidNumbers) {
          expect(
            () => agent.addToHistory(invalid),
            throwsA(isA<ArgumentError>()),
            reason: 'Should reject invalid number: $invalid',
          );
        }
      });

      test('should maintain max history size limit', () {
        // Add more than maxHistorySize entries
        for (var i = 0; i < RouletteAgent.maxHistorySize + 100; i++) {
          agent.addToHistory(i % 37);
        }

        expect(agent.historyLength, equals(RouletteAgent.maxHistorySize));
      });
    });

    group('clearHistory()', () {
      test('should clear all history entries', () {
        agent.addToHistory(1);
        agent.addToHistory(2);
        agent.addToHistory(3);

        agent.clearHistory();

        expect(agent.history, isEmpty);
        expect(agent.historyLength, equals(0));
      });
    });

    group('predictNext()', () {
      test('should return random number for empty history', () {
        final prediction = agent.predictNext();
        expect(prediction, inInclusiveRange(0, 36));
      });

      test('should return most frequent number from history', () {
        // Add history with clear winner (7 appears most)
        agent.addToHistory(7);
        agent.addToHistory(7);
        agent.addToHistory(7);
        agent.addToHistory(14);
        agent.addToHistory(21);

        expect(agent.predictNext(), equals(7));
      });

      test('should handle single entry history', () {
        agent.addToHistory(25);
        expect(agent.predictNext(), equals(25));
      });
    });

    group('Color classification', () {
      // Table-driven tests for color classification
      test('isRed should correctly identify red numbers', () {
        final testCases = [
          (number: 1, expected: true),
          (number: 3, expected: true),
          (number: 7, expected: true),
          (number: 32, expected: true),
          (number: 36, expected: true),
          (number: 2, expected: false),
          (number: 0, expected: false),
          (number: 10, expected: false),
        ];

        for (final tc in testCases) {
          expect(RouletteAgent.isRed(tc.number), equals(tc.expected),
              reason: 'isRed(${tc.number}) should be ${tc.expected}');
        }
      });

      test('isBlack should correctly identify black numbers', () {
        final testCases = [
          (number: 2, expected: true),
          (number: 4, expected: true),
          (number: 10, expected: true),
          (number: 35, expected: true),
          (number: 1, expected: false),
          (number: 0, expected: false),
          (number: 36, expected: false),
        ];

        for (final tc in testCases) {
          expect(RouletteAgent.isBlack(tc.number), equals(tc.expected),
              reason: 'isBlack(${tc.number}) should be ${tc.expected}');
        }
      });

      test('isGreen should correctly identify zero', () {
        expect(RouletteAgent.isGreen(0), isTrue);
        expect(RouletteAgent.isGreen(1), isFalse);
        expect(RouletteAgent.isGreen(36), isFalse);
      });

      test('getColor should return correct color strings', () {
        expect(RouletteAgent.getColor(0), equals('green'));
        expect(RouletteAgent.getColor(1), equals('red'));
        expect(RouletteAgent.getColor(2), equals('black'));
      });
    });

    group('getStatistics()', () {
      test('should return empty stats for no history', () {
        final stats = agent.getStatistics();

        expect(stats.totalSpins, equals(0));
        expect(stats.redCount, equals(0));
        expect(stats.blackCount, equals(0));
        expect(stats.greenCount, equals(0));
        expect(stats.mostFrequent, isNull);
      });

      test('should calculate correct statistics', () {
        // Add known history
        agent.addToHistory(0); // green
        agent.addToHistory(1); // red, odd, low
        agent.addToHistory(2); // black, even, low
        agent.addToHistory(36); // red, even, high
        agent.addToHistory(1); // red, odd, low (duplicate)

        final stats = agent.getStatistics();

        expect(stats.totalSpins, equals(5));
        expect(stats.greenCount, equals(1));
        expect(stats.redCount, equals(3)); // 1, 36, 1
        expect(stats.blackCount, equals(1)); // 2
        expect(stats.mostFrequent, equals(1)); // appears twice
      });
    });
  });

  group('RouletteStats', () {
    test('should calculate percentages correctly', () {
      final agent = RouletteAgent();
      // Add 100 spins worth of red (approximation)
      for (var i = 0; i < 50; i++) {
        agent.addToHistory(1); // red
        agent.addToHistory(2); // black
      }

      final stats = agent.getStatistics();
      expect(stats.redPercentage, equals(50.0));
      expect(stats.blackPercentage, equals(50.0));
    });

    test('toString should return formatted string', () {
      final agent = RouletteAgent();
      agent.addToHistory(7);
      final stats = agent.getStatistics();

      final str = stats.toString();
      expect(str, contains('RouletteStats'));
      expect(str, contains('totalSpins: 1'));
    });
  });

  group('Static constants', () {
    test('wheel should contain numbers 0-36', () {
      expect(RouletteAgent.wheel.length, equals(37));
      expect(RouletteAgent.wheel.first, equals(0));
      expect(RouletteAgent.wheel.last, equals(36));
    });

    test('red and black numbers should be mutually exclusive', () {
      final redSet = RouletteAgent.redNumbers.toSet();
      final blackSet = RouletteAgent.blackNumbers.toSet();

      expect(redSet.intersection(blackSet), isEmpty,
          reason: 'Red and black numbers should not overlap');
    });

    test('red, black numbers and zero should cover all wheel numbers', () {
      final covered = <int>{
        0,
        ...RouletteAgent.redNumbers,
        ...RouletteAgent.blackNumbers,
      };

      expect(covered.length, equals(37));
      for (var i = 0; i <= 36; i++) {
        expect(covered.contains(i), isTrue,
            reason: 'Number $i should be covered');
      }
    });
  });
}
