import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    test('generateSpin returns value between 0 and 36', () {
      final logic = RouletteLogic();
      final spin = logic.generateSpin();
      expect(spin, inInclusiveRange(0, 36));
    });

    test('predictNext returns value when history is not empty', () {
      final logic = RouletteLogic();
      final prediction = logic.predictNext([1, 2, 3, 1, 1]);
      expect(prediction, inInclusiveRange(0, 36));
    });

    test('predictNext returns most frequent number', () {
      final logic = RouletteLogic();
      // 5 appears most frequently
      final prediction = logic.predictNext([5, 1, 5, 2, 5]);
      expect(prediction, equals(5));
    });
  });

  group('MartingaleAdvisor', () {
    test('doubles bet after loss', () {
      final advisor = MartingaleAdvisor();
      advisor.baseBet = 10.0;
      advisor.currentBet = 10.0;
      
      final nextBet = advisor.getNextBet(false);
      expect(nextBet, equals(20.0));
    });

    test('resets bet to base after win', () {
      final advisor = MartingaleAdvisor();
      advisor.baseBet = 10.0;
      advisor.currentBet = 40.0;
      
      final nextBet = advisor.getNextBet(true);
      expect(nextBet, equals(10.0));
    });

    test('reset returns to initial state', () {
      final advisor = MartingaleAdvisor();
      advisor.baseBet = 10.0;
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      
      advisor.reset();
      expect(advisor.currentBet, equals(10.0));
      expect(advisor.lastWin, isTrue);
    });
  });

  group('GameStateManager', () {
    test('initial state shows correct message', () {
      final gameState = GameStateManager();
      expect(gameState.result, equals('Presiona Girar'));
      expect(gameState.history, isEmpty);
    });

    test('spin updates result and history', () {
      final gameState = GameStateManager();
      gameState.spin();
      
      expect(gameState.result, isNot(equals('Presiona Girar')));
      expect(gameState.history.length, equals(1));
    });

    test('multiple spins accumulate in history', () {
      final gameState = GameStateManager();
      gameState.spin();
      gameState.spin();
      gameState.spin();
      
      expect(gameState.history.length, equals(3));
    });

    test('reset clears history and result', () {
      final gameState = GameStateManager();
      gameState.spin();
      gameState.spin();
      
      gameState.reset();
      
      expect(gameState.result, equals('Presiona Girar'));
      expect(gameState.history, isEmpty);
      expect(gameState.currentBet, equals(10.0));
    });

    test('getPrediction returns valid number', () {
      final gameState = GameStateManager();
      gameState.spin();
      gameState.spin();
      
      final prediction = gameState.getPrediction();
      expect(prediction, inInclusiveRange(0, 36));
    });

    test('updateBet changes current bet', () {
      final gameState = GameStateManager();
      final initialBet = gameState.currentBet;
      
      gameState.updateBet(false); // Loss doubles bet
      expect(gameState.currentBet, equals(initialBet * 2));
      
      gameState.updateBet(true); // Win resets to base
      expect(gameState.currentBet, equals(initialBet));
    });

    test('history is immutable from outside', () {
      final gameState = GameStateManager();
      gameState.spin();
      
      final historyRef = gameState.history;
      expect(() => historyRef.add(99), throwsUnsupportedError);
    });
  });
}
