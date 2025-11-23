/// Unit tests for PredictorAgent

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/agents/predictor_agent.dart';
import 'package:tokyo_roulette_predicciones/core/base_agent.dart';

void main() {
  group('PredictorAgent Tests', () {
    late PredictorAgent predictor;

    setUp(() {
      predictor = PredictorAgent(id: 'test-predictor', name: 'TestPredictor');
    });

    test('should initialize correctly', () async {
      await predictor.initialize({'strategy': 'frequencyBased'});
      expect(predictor.state, AgentState.idle);
      expect(predictor.id, 'test-predictor');
      expect(predictor.name, 'TestPredictor');
    });

    test('should start and stop', () async {
      await predictor.initialize(null);
      await predictor.start();
      expect(predictor.state, AgentState.running);
      
      await predictor.stop();
      expect(predictor.state, AgentState.stopped);
    });

    test('should add results', () {
      predictor.addResult(5);
      predictor.addResult(10);
      predictor.addResult(5);
      
      final stats = predictor.getStatistics();
      expect(stats['total_results'], 3);
      expect(stats['unique_numbers'], 2);
    });

    test('should reject invalid numbers', () {
      predictor.addResult(37); // Invalid
      predictor.addResult(-1); // Invalid
      predictor.addResult(20); // Valid
      
      final stats = predictor.getStatistics();
      expect(stats['total_results'], 1); // Only valid number counted
    });

    test('should make predictions when running', () async {
      await predictor.initialize({'strategy': 'frequencyBased'});
      await predictor.start();
      
      // Add some data
      for (int i = 0; i < 10; i++) {
        predictor.addResult(i);
      }
      
      final prediction = await predictor.predict();
      expect(prediction.predictedNumber, greaterThanOrEqualTo(0));
      expect(prediction.predictedNumber, lessThanOrEqualTo(36));
      expect(prediction.method, isNotEmpty);
    });

    test('should throw error when predicting while not running', () async {
      await predictor.initialize(null);
      
      expect(
        () => predictor.predict(),
        throwsA(isA<StateError>()),
      );
    });

    test('should clear history', () {
      predictor.addResult(1);
      predictor.addResult(2);
      predictor.addResult(3);
      
      predictor.clearHistory();
      
      final stats = predictor.getStatistics();
      expect(stats['total_results'], 0);
      expect(stats['unique_numbers'], 0);
    });

    test('should use different prediction strategies', () async {
      final strategies = ['frequencyBased', 'patternRecognition', 'hotColdNumbers', 'hybridModel'];
      
      for (final strategy in strategies) {
        final p = PredictorAgent();
        await p.initialize({'strategy': strategy});
        await p.start();
        
        // Add some data
        for (int i = 0; i < 20; i++) {
          p.addResult(i % 10);
        }
        
        final prediction = await p.predict();
        expect(prediction.predictedNumber, greaterThanOrEqualTo(0));
        expect(prediction.predictedNumber, lessThanOrEqualTo(36));
        
        await p.stop();
      }
    });

    test('should return confidence between 0 and 1', () async {
      await predictor.initialize(null);
      await predictor.start();
      
      for (int i = 0; i < 10; i++) {
        predictor.addResult(5); // Same number repeatedly
      }
      
      final prediction = await predictor.predict();
      expect(prediction.confidence, greaterThanOrEqualTo(0.0));
      expect(prediction.confidence, lessThanOrEqualTo(1.0));
    });
  });
}
