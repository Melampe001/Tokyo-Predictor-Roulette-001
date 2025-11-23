/// Unit tests for RngAnalyzerAgent

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/agents/rng_analyzer_agent.dart';
import 'package:tokyo_roulette_predicciones/core/base_agent.dart';

void main() {
  group('RngAnalyzerAgent Tests', () {
    late RngAnalyzerAgent analyzer;

    setUp(() {
      analyzer = RngAnalyzerAgent(id: 'test-analyzer', name: 'TestAnalyzer');
    });

    test('should initialize correctly', () async {
      await analyzer.initialize(null);
      expect(analyzer.state, AgentState.idle);
      expect(analyzer.id, 'test-analyzer');
    });

    test('should add observations', () {
      analyzer.addObservation(5);
      analyzer.addObservation(10);
      
      final stats = analyzer.getDetailedStatistics();
      expect(stats['total_observations'], 2);
    });

    test('should reject invalid observations', () {
      analyzer.addObservation(37); // Invalid
      analyzer.addObservation(-1); // Invalid
      analyzer.addObservation(20); // Valid
      
      final stats = analyzer.getDetailedStatistics();
      expect(stats['total_observations'], 1);
    });

    test('should throw error with insufficient data', () async {
      await analyzer.initialize(null);
      await analyzer.start();
      
      // Add less than 37 observations
      for (int i = 0; i < 30; i++) {
        analyzer.addObservation(i);
      }
      
      expect(
        () => analyzer.analyze(),
        throwsA(isA<StateError>()),
      );
    });

    test('should analyze with sufficient data', () async {
      await analyzer.initialize(null);
      await analyzer.start();
      
      // Add enough observations (at least 37)
      for (int i = 0; i < 100; i++) {
        analyzer.addObservation(i % 37);
      }
      
      final result = await analyzer.analyze();
      expect(result.chiSquareStatistic, greaterThanOrEqualTo(0));
      expect(result.statistics, isNotEmpty);
    });

    test('should detect uniform distribution as non-biased', () async {
      await analyzer.initialize(null);
      await analyzer.start();
      
      // Add perfectly uniform distribution
      for (int i = 0; i < 37; i++) {
        for (int j = 0; j < 10; j++) {
          analyzer.addObservation(i);
        }
      }
      
      final result = await analyzer.analyze();
      // Perfectly uniform should have low chi-square
      expect(result.chiSquareStatistic, lessThan(50.998)); // Critical value
    });

    test('should clear observations', () {
      analyzer.addObservation(1);
      analyzer.addObservation(2);
      
      analyzer.clearObservations();
      
      final stats = analyzer.getDetailedStatistics();
      expect(stats['total_observations'], 0);
    });
  });
}
