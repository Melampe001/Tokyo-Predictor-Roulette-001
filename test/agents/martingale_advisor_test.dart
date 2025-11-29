/// Unit tests for MartingaleAdvisor
///
/// These tests verify the functionality of the Martingale betting strategy
/// advisor, including bet calculations, session statistics, and simulation.

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/agents/martingale_advisor.dart';

void main() {
  group('MartingaleConfig', () {
    test('should create config with valid parameters', () {
      const config = MartingaleConfig(
        baseBet: 10.0,
        maxBet: 1000.0,
        multiplier: 2.0,
      );

      expect(config.baseBet, equals(10.0));
      expect(config.maxBet, equals(1000.0));
      expect(config.multiplier, equals(2.0));
    });

    test('toString should return formatted string', () {
      const config = MartingaleConfig(baseBet: 10.0);
      final str = config.toString();

      expect(str, contains('MartingaleConfig'));
      expect(str, contains('baseBet: 10.0'));
    });
  });

  group('MartingaleAdvisor', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor(baseBet: 10.0);
    });

    group('Initialization', () {
      test('should initialize with correct default values', () {
        expect(advisor.currentBet, equals(10.0));
        expect(advisor.baseBet, equals(10.0));
        expect(advisor.lastResult, isTrue);
        expect(advisor.consecutiveLosses, equals(0));
      });

      test('should initialize from config', () {
        const config = MartingaleConfig(
          baseBet: 5.0,
          maxBet: 500.0,
          multiplier: 3.0,
        );
        final configAdvisor = MartingaleAdvisor.fromConfig(config);

        expect(configAdvisor.baseBet, equals(5.0));
        expect(configAdvisor.maxBet, equals(500.0));
        expect(configAdvisor.multiplier, equals(3.0));
      });
    });

    group('processBet()', () {
      test('should reset to base bet after win', () {
        // Lose first to increase bet
        advisor.processBet(won: false);
        expect(advisor.currentBet, equals(20.0));

        // Win should reset to base
        final nextBet = advisor.processBet(won: true);
        expect(nextBet, equals(10.0));
        expect(advisor.lastResult, isTrue);
      });

      test('should double bet after loss', () {
        final nextBet = advisor.processBet(won: false);
        expect(nextBet, equals(20.0));
        expect(advisor.lastResult, isFalse);
      });

      // Table-driven test for consecutive losses
      test('should double correctly through consecutive losses', () {
        final testCases = [
          (losses: 1, expectedBet: 20.0),
          (losses: 2, expectedBet: 40.0),
          (losses: 3, expectedBet: 80.0),
          (losses: 4, expectedBet: 160.0),
          (losses: 5, expectedBet: 320.0),
        ];

        for (final tc in testCases) {
          advisor.reset();
          for (var i = 0; i < tc.losses; i++) {
            advisor.processBet(won: false);
          }
          expect(advisor.currentBet, equals(tc.expectedBet),
              reason: 'After ${tc.losses} losses, bet should be ${tc.expectedBet}');
        }
      });

      test('should respect max bet limit', () {
        final limitedAdvisor = MartingaleAdvisor(baseBet: 10.0, maxBet: 50.0);

        limitedAdvisor.processBet(won: false); // 20
        limitedAdvisor.processBet(won: false); // 40
        limitedAdvisor.processBet(won: false); // Would be 80, capped at 50

        expect(limitedAdvisor.currentBet, equals(50.0));
        expect(limitedAdvisor.isAtMaxBet, isTrue);
      });

      test('should track consecutive losses', () {
        advisor.processBet(won: false);
        expect(advisor.consecutiveLosses, equals(1));

        advisor.processBet(won: false);
        expect(advisor.consecutiveLosses, equals(2));

        advisor.processBet(won: true);
        expect(advisor.consecutiveLosses, equals(0));
      });

      test('should accept custom bet amount', () {
        advisor.processBet(won: false, betAmount: 100.0);

        final stats = advisor.sessionStats;
        expect(stats.totalBet, equals(100.0));
      });
    });

    group('reset()', () {
      test('should reset all values to initial state', () {
        // Make some bets
        advisor.processBet(won: false);
        advisor.processBet(won: false);
        advisor.processBet(won: true);

        // Reset
        advisor.reset();

        expect(advisor.currentBet, equals(10.0));
        expect(advisor.lastResult, isTrue);
        expect(advisor.consecutiveLosses, equals(0));

        final stats = advisor.sessionStats;
        expect(stats.totalWins, equals(0));
        expect(stats.totalLosses, equals(0));
        expect(stats.totalBet, equals(0.0));
        expect(stats.profitLoss, equals(0.0));
      });
    });

    group('sessionStats', () {
      test('should track wins and losses correctly', () {
        advisor.processBet(won: true);
        advisor.processBet(won: false);
        advisor.processBet(won: true);

        final stats = advisor.sessionStats;
        expect(stats.totalWins, equals(2));
        expect(stats.totalLosses, equals(1));
        expect(stats.totalRounds, equals(3));
      });

      test('should calculate profit/loss correctly', () {
        // Win: +10, Loss: -10, Win: +20 = +20
        advisor.processBet(won: true); // Win 10
        advisor.processBet(won: false); // Lose 10
        advisor.processBet(won: true); // Win 20 (doubled bet)

        final stats = advisor.sessionStats;
        expect(stats.profitLoss, equals(20.0));
      });

      test('should calculate win rate correctly', () {
        advisor.processBet(won: true);
        advisor.processBet(won: true);
        advisor.processBet(won: false);
        advisor.processBet(won: false);

        final stats = advisor.sessionStats;
        expect(stats.winRate, equals(50.0));
      });
    });

    group('getNextBet()', () {
      test('should return current bet', () {
        expect(advisor.getNextBet(), equals(10.0));

        advisor.processBet(won: false);
        expect(advisor.getNextBet(), equals(20.0));
      });
    });

    group('simulate()', () {
      test('should run specified number of rounds', () {
        final results = advisor.simulate(rounds: 50);

        expect(results.length, equals(50));
      });

      test('should return MartingaleStats for each round', () {
        final results = advisor.simulate(rounds: 10);

        for (var i = 0; i < results.length; i++) {
          expect(results[i].totalRounds, equals(i + 1),
              reason: 'Round ${i + 1} should have ${i + 1} total rounds');
        }
      });

      test('simulation should reset advisor first', () {
        advisor.processBet(won: false);
        advisor.processBet(won: false);

        advisor.simulate(rounds: 10);

        // After simulation, advisor should be at the state after 10 rounds
        final stats = advisor.sessionStats;
        expect(stats.totalRounds, equals(10));
      });
    });

    group('Custom multiplier', () {
      test('should use custom multiplier after loss', () {
        final tripleAdvisor = MartingaleAdvisor(
          baseBet: 10.0,
          multiplier: 3.0,
        );

        tripleAdvisor.processBet(won: false);
        expect(tripleAdvisor.currentBet, equals(30.0));

        tripleAdvisor.processBet(won: false);
        expect(tripleAdvisor.currentBet, equals(90.0));
      });
    });

    group('toString()', () {
      test('should return formatted string', () {
        final str = advisor.toString();

        expect(str, contains('MartingaleAdvisor'));
        expect(str, contains('currentBet'));
      });
    });
  });

  group('MartingaleStats', () {
    test('should calculate ROI correctly', () {
      final advisor = MartingaleAdvisor(baseBet: 10.0);

      // Win 2, lose 1 with standard Martingale
      advisor.processBet(won: true); // +10, total bet: 10
      advisor.processBet(won: true); // +10, total bet: 20
      advisor.processBet(won: false); // -10, total bet: 30
      // Net: +10, Total bet: 30, ROI = 10/30 * 100 = 33.33%

      final stats = advisor.sessionStats;
      expect(stats.roi, closeTo(33.33, 0.1));
    });

    test('should have zero ROI for no bets', () {
      final stats = MartingaleStats(
        totalWins: 0,
        totalLosses: 0,
        totalBet: 0,
        profitLoss: 0,
        consecutiveLosses: 0,
        currentBet: 10,
        isAtMaxBet: false,
      );

      expect(stats.roi, equals(0.0));
      expect(stats.winRate, equals(0.0));
    });

    test('toString should include all relevant info', () {
      final stats = MartingaleStats(
        totalWins: 5,
        totalLosses: 3,
        totalBet: 100,
        profitLoss: 20,
        consecutiveLosses: 0,
        currentBet: 10,
        isAtMaxBet: false,
      );

      final str = stats.toString();

      expect(str, contains('rounds: 8'));
      expect(str, contains('wins: 5'));
      expect(str, contains('losses: 3'));
      expect(str, contains('profitLoss'));
    });
  });

  group('Integration tests', () {
    test('should handle realistic betting session', () {
      final advisor = MartingaleAdvisor(baseBet: 10.0, maxBet: 1000.0);

      // Simulate realistic session: WWLLLWWLW
      final outcomes = [true, true, false, false, false, true, true, false, true];

      for (final won in outcomes) {
        advisor.processBet(won: won);
      }

      final stats = advisor.sessionStats;
      expect(stats.totalRounds, equals(9));
      expect(stats.totalWins, equals(5));
      expect(stats.totalLosses, equals(4));
    });

    test('edge case: max bet reached during losing streak', () {
      final advisor = MartingaleAdvisor(baseBet: 10.0, maxBet: 80.0);

      // 4 consecutive losses: 10 -> 20 -> 40 -> 80 (max)
      for (var i = 0; i < 5; i++) {
        advisor.processBet(won: false);
      }

      expect(advisor.currentBet, equals(80.0));
      expect(advisor.isAtMaxBet, isTrue);
      expect(advisor.consecutiveLosses, equals(5));
    });
  });
}
