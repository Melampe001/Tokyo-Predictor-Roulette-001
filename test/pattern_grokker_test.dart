import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_predictor_roulette_001/services/pattern_grokker.dart';

void main() {
  group('PatternGrokker', () {
    late PatternGrokker grokker;

    setUp(() {
      grokker = PatternGrokker();
    });

    test('returns empty analysis for empty history', () {
      final analysis = grokker.grokHistory([]);
      expect(analysis.hotNumbers, isEmpty);
      expect(analysis.coldNumbers, isEmpty);
      expect(analysis.recommendations, isEmpty);
    });

    test('identifies hot numbers correctly', () {
      // Create history with number 7 appearing frequently
      final history = [7, 12, 7, 3, 7, 18, 7, 24];
      final analysis = grokker.grokHistory(history);

      expect(analysis.hotNumbers, isNotEmpty);
      expect(analysis.hotNumbers.first.number, 7);
      expect(analysis.hotNumbers.first.frequency, 4);
      expect(analysis.hotNumbers.first.percentage, 50.0);
    });

    test('identifies cold numbers correctly', () {
      final history = [1, 2, 3, 4, 5];
      final analysis = grokker.grokHistory(history);

      expect(analysis.coldNumbers, isNotEmpty);
      // Numbers 6-36 should be cold (never appeared)
      expect(analysis.coldNumbers.first.frequency, 0);
    });

    test('detects red streaks', () {
      // All red numbers
      final history = [1, 3, 5, 7, 9];
      final analysis = grokker.grokHistory(history);

      expect(analysis.streaks.currentRedStreak, greaterThan(0));
      expect(analysis.streaks.currentBlackStreak, 0);
    });

    test('detects black streaks', () {
      // All black numbers
      final history = [2, 4, 6, 8, 10];
      final analysis = grokker.grokHistory(history);

      expect(analysis.streaks.currentBlackStreak, greaterThan(0));
      expect(analysis.streaks.currentRedStreak, 0);
    });

    test('analyzes color distribution correctly', () {
      final history = [1, 2, 0, 3, 4]; // 2 red, 2 black, 1 green
      final analysis = grokker.grokHistory(history);

      expect(analysis.colorAnalysis.redCount, 2);
      expect(analysis.colorAnalysis.blackCount, 2);
      expect(analysis.colorAnalysis.greenCount, 1);
    });

    test('analyzes even/odd distribution', () {
      final history = [1, 2, 3, 4, 5, 6]; // 3 even, 3 odd
      final analysis = grokker.grokHistory(history);

      expect(analysis.evenOddAnalysis.evenCount, 3);
      expect(analysis.evenOddAnalysis.oddCount, 3);
      expect(analysis.evenOddAnalysis.evenPercentage, 50.0);
      expect(analysis.evenOddAnalysis.oddPercentage, 50.0);
    });

    test('analyzes sectors (dozens) correctly', () {
      final history = [1, 13, 25]; // One from each dozen
      final analysis = grokker.grokHistory(history);

      expect(analysis.sectorAnalysis.firstDozenCount, 1);
      expect(analysis.sectorAnalysis.secondDozenCount, 1);
      expect(analysis.sectorAnalysis.thirdDozenCount, 1);
    });

    test('generates recommendations for hot numbers', () {
      final history = [7, 7, 7, 7, 1, 2, 3, 4];
      final analysis = grokker.grokHistory(history);

      expect(analysis.recommendations, isNotEmpty);
      final hotNumberRec = analysis.recommendations.firstWhere(
        (rec) => rec.type == RecommendationType.hotNumber,
        orElse: () => throw Exception('No hot number recommendation found'),
      );
      expect(hotNumberRec.suggestedNumber, 7);
      expect(hotNumberRec.confidence, greaterThan(0.5));
    });

    test('generates recommendations for streaks', () {
      // Create a long red streak (4+ reds in a row)
      final history = [1, 3, 5, 7]; // All red
      final analysis = grokker.grokHistory(history);

      // Should have a streak recommendation
      final hasStreakRec = analysis.recommendations
          .any((rec) => rec.type == RecommendationType.streak);
      expect(hasStreakRec, isTrue);
    });

    test('handles mixed number history', () {
      final history = [0, 5, 12, 18, 22, 30, 36, 8, 15, 27];
      final analysis = grokker.grokHistory(history);

      expect(analysis.hotNumbers.length, lessThanOrEqualTo(5));
      expect(analysis.coldNumbers.length, lessThanOrEqualTo(5));
      expect(analysis.colorAnalysis.redCount +
                 analysis.colorAnalysis.blackCount +
                 analysis.colorAnalysis.greenCount,
             history.length);
    });

    test('confidence levels are reasonable', () {
      final history = [7, 7, 7, 1, 2, 3, 4, 5];
      final analysis = grokker.grokHistory(history);

      for (final rec in analysis.recommendations) {
        expect(rec.confidence, greaterThanOrEqualTo(0.0));
        expect(rec.confidence, lessThanOrEqualTo(1.0));
      }
    });

    test('handles zero in history correctly', () {
      final history = [0, 0, 0, 1, 2];
      final analysis = grokker.grokHistory(history);

      expect(analysis.colorAnalysis.greenCount, 3);
      expect(analysis.hotNumbers.first.number, 0);
    });

    test('sector analysis ignores zero', () {
      final history = [0, 1, 13, 25]; // Zero + one from each dozen
      final analysis = grokker.grokHistory(history);

      // Zero shouldn't be counted in any dozen
      expect(
        analysis.sectorAnalysis.firstDozenCount +
            analysis.sectorAnalysis.secondDozenCount +
            analysis.sectorAnalysis.thirdDozenCount,
        3, // Only the three non-zero numbers
      );
    });

    test('streak analysis handles alternating colors', () {
      final history = [1, 2, 3, 4, 5, 6]; // Red, black, red, black...
      final analysis = grokker.grokHistory(history);

      // Current streak should be 1 (last number is black: 6)
      expect(analysis.streaks.currentBlackStreak, 1);
      expect(analysis.streaks.currentRedStreak, 0);
    });

    test('provides reasoning for all recommendations', () {
      final history = [7, 7, 7, 1, 2, 3, 4, 5];
      final analysis = grokker.grokHistory(history);

      for (final rec in analysis.recommendations) {
        expect(rec.reasoning, isNotEmpty);
        expect(rec.reasoning.length, greaterThan(10));
      }
    });
  });
}
