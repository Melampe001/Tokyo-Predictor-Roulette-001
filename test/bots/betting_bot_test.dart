/// Unit tests for BettingBot

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/bots/betting_bot.dart';
import 'package:tokyo_roulette_predicciones/core/base_bot.dart';

void main() {
  group('BettingBot Tests', () {
    late BettingBot bot;

    setUp(() {
      bot = BettingBot(id: 'test-bot', name: 'TestBot');
    });

    test('should initialize with default values', () async {
      await bot.initialize(null);
      expect(bot.state, BotState.idle);
      expect(bot.bankroll, 100.0);
    });

    test('should initialize with custom config', () async {
      await bot.initialize({
        'strategy': 'martingale',
        'base_bet': 5.0,
        'bankroll': 200.0,
        'max_bet': 50.0,
      });
      
      expect(bot.bankroll, 200.0);
    });

    test('should calculate next bet', () {
      bot.initialize({'base_bet': 10.0});
      
      final bet = bot.calculateNextBet(betType: 'red');
      expect(bet.type, 'red');
      expect(bet.amount, greaterThan(0));
    });

    test('should process winning bet', () async {
      await bot.initialize({'base_bet': 10.0, 'bankroll': 100.0});
      
      final bet = bot.calculateNextBet(betType: 'red');
      final initialBankroll = bot.bankroll;
      
      final result = bot.processBetResult(bet, true);
      
      expect(result.won, true);
      expect(result.payout, greaterThan(0));
      expect(bot.bankroll, greaterThan(initialBankroll));
    });

    test('should process losing bet', () async {
      await bot.initialize({'base_bet': 10.0, 'bankroll': 100.0});
      
      final bet = bot.calculateNextBet(betType: 'red');
      final initialBankroll = bot.bankroll;
      
      final result = bot.processBetResult(bet, false);
      
      expect(result.won, false);
      expect(result.payout, 0);
      expect(bot.bankroll, lessThan(initialBankroll));
    });

    test('Martingale should double on loss', () async {
      await bot.initialize({
        'strategy': 'martingale',
        'base_bet': 10.0,
        'bankroll': 1000.0,
      });
      
      final bet1 = bot.calculateNextBet();
      expect(bet1.amount, 10.0);
      
      bot.processBetResult(bet1, false); // Lose
      
      final bet2 = bot.calculateNextBet();
      expect(bet2.amount, 20.0); // Should double
      
      bot.processBetResult(bet2, false); // Lose again
      
      final bet3 = bot.calculateNextBet();
      expect(bet3.amount, 40.0); // Should double again
    });

    test('Martingale should reset on win', () async {
      await bot.initialize({
        'strategy': 'martingale',
        'base_bet': 10.0,
        'bankroll': 1000.0,
      });
      
      final bet1 = bot.calculateNextBet();
      bot.processBetResult(bet1, false); // Lose
      
      final bet2 = bot.calculateNextBet();
      expect(bet2.amount, 20.0);
      
      bot.processBetResult(bet2, true); // Win
      
      final bet3 = bot.calculateNextBet();
      expect(bet3.amount, 10.0); // Should reset to base
    });

    test('should get statistics', () async {
      await bot.initialize({'base_bet': 10.0});
      
      // Place some bets
      for (int i = 0; i < 10; i++) {
        final bet = bot.calculateNextBet();
        bot.processBetResult(bet, i % 2 == 0);
      }
      
      final stats = bot.getStatistics();
      expect(stats['total_bets'], 10);
      expect(stats['wins'], 5);
      expect(stats['losses'], 5);
    });

    test('should get bet history', () async {
      await bot.initialize({'base_bet': 10.0});
      
      for (int i = 0; i < 5; i++) {
        final bet = bot.calculateNextBet();
        bot.processBetResult(bet, true);
      }
      
      final history = bot.getBetHistory();
      expect(history.length, 5);
    });

    test('should respect max bet limit', () async {
      await bot.initialize({
        'strategy': 'martingale',
        'base_bet': 10.0,
        'bankroll': 10000.0,
        'max_bet': 100.0,
      });
      
      // Keep losing to increase bet
      for (int i = 0; i < 10; i++) {
        final bet = bot.calculateNextBet();
        expect(bet.amount, lessThanOrEqualTo(100.0));
        bot.processBetResult(bet, false);
      }
    });

    test('should reset correctly', () async {
      await bot.initialize({'base_bet': 10.0});
      
      // Place some bets
      final bet = bot.calculateNextBet();
      bot.processBetResult(bet, false);
      
      await bot.reset();
      
      final stats = bot.getStatistics();
      expect(stats['total_bets'], 0);
    });

    test('should set and get bankroll', () {
      bot.setBankroll(500.0);
      expect(bot.bankroll, 500.0);
    });
  });
}
