/// Unit tests for RouletteSimulatorAgent

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/agents/roulette_simulator_agent.dart';
import 'package:tokyo_roulette_predicciones/core/base_agent.dart';

void main() {
  group('RouletteSimulatorAgent Tests', () {
    late RouletteSimulatorAgent simulator;

    setUp(() {
      simulator = RouletteSimulatorAgent(id: 'test-sim', name: 'TestSimulator');
    });

    test('should initialize with European roulette by default', () async {
      await simulator.initialize(null);
      expect(simulator.rouletteType, RouletteType.european);
    });

    test('should initialize with American roulette', () async {
      await simulator.initialize({'roulette_type': 'american'});
      expect(simulator.rouletteType, RouletteType.american);
    });

    test('should spin and return valid result', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      final result = await simulator.spin();
      expect(result.number, isNotNull);
      expect(result.color, isIn(['red', 'black', 'green']));
    });

    test('European spin should return 0-36', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      for (int i = 0; i < 50; i++) {
        final result = await simulator.spin();
        expect(result.number, greaterThanOrEqualTo(0));
        expect(result.number, lessThanOrEqualTo(36));
      }
    });

    test('should simulate multiple spins', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      final results = await simulator.simulateSpins(100);
      expect(results.length, 100);
    });

    test('should track history', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      await simulator.simulateSpins(10);
      final history = simulator.getHistory();
      
      expect(history.length, 10);
    });

    test('should get statistics', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      await simulator.simulateSpins(100);
      final stats = simulator.getStatistics();
      
      expect(stats['total_spins'], 100);
      expect(stats['color_distribution'], isNotEmpty);
    });

    test('should check bet correctly', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      final result = await simulator.spin();
      
      // Test straight bet
      final straightWin = simulator.checkBet(result, 'straight', betValue: result.number);
      expect(straightWin, true);
      
      // Test color bet
      if (result.color == 'red') {
        expect(simulator.checkBet(result, 'red'), true);
        expect(simulator.checkBet(result, 'black'), false);
      }
    });

    test('should clear history', () async {
      await simulator.initialize(null);
      await simulator.start();
      
      await simulator.simulateSpins(10);
      simulator.clearHistory();
      
      final history = simulator.getHistory();
      expect(history.length, 0);
    });

    test('should set roulette type', () {
      simulator.setRouletteType(RouletteType.american);
      expect(simulator.rouletteType, RouletteType.american);
    });
  });
}
