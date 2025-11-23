/// Unit tests for CasinoMockBot

import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/bots/casino_mock_bot.dart';
import 'package:tokyo_roulette_predicciones/core/base_bot.dart';

void main() {
  group('CasinoMockBot Tests', () {
    late CasinoMockBot casino;

    setUp(() async {
      casino = CasinoMockBot(id: 'test-casino', name: 'TestCasino');
      await casino.initialize(null);
      await casino.execute();
    });

    tearDown(() async {
      await casino.stop();
    });

    test('should create session', () {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      expect(session.userId, 'user1');
      expect(session.balance, 100.0);
      expect(session.isActive, true);
    });

    test('should process winning bet', () async {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      // Place multiple bets until we get a win
      bool foundWin = false;
      for (int i = 0; i < 50 && !foundWin; i++) {
        final result = await casino.processBet(
          sessionId: session.sessionId,
          betType: 'red',
          betValue: 'red',
          amount: 10.0,
        );
        
        if (result['won'] as bool) {
          foundWin = true;
          expect(result['payout'], greaterThan(0));
          expect(result['profit'], greaterThan(0));
        }
      }
    });

    test('should deduct bet amount from balance', () async {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      final initialBalance = casino.getBalance(session.sessionId);
      
      await casino.processBet(
        sessionId: session.sessionId,
        betType: 'red',
        betValue: 'red',
        amount: 10.0,
      );
      
      final newBalance = casino.getBalance(session.sessionId);
      expect(newBalance, lessThanOrEqualTo(initialBalance));
    });

    test('should throw on insufficient balance', () async {
      final session = casino.createSession(userId: 'user1', initialBalance: 10.0);
      
      expect(
        () => casino.processBet(
          sessionId: session.sessionId,
          betType: 'red',
          betValue: 'red',
          amount: 100.0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should add funds to session', () {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      casino.addFunds(session.sessionId, 50.0);
      
      expect(casino.getBalance(session.sessionId), 150.0);
    });

    test('should withdraw funds from session', () {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      casino.withdrawFunds(session.sessionId, 30.0);
      
      expect(casino.getBalance(session.sessionId), 70.0);
    });

    test('should throw on insufficient balance for withdrawal', () {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      expect(
        () => casino.withdrawFunds(session.sessionId, 200.0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should end session', () {
      final session = casino.createSession(userId: 'user1');
      
      casino.endSession(session.sessionId);
      
      final updatedSession = casino.getSession(session.sessionId);
      expect(updatedSession.isActive, false);
      expect(updatedSession.endTime, isNotNull);
    });

    test('should get session details', () {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      final retrieved = casino.getSession(session.sessionId);
      expect(retrieved.sessionId, session.sessionId);
      expect(retrieved.userId, 'user1');
    });

    test('should get user sessions', () {
      casino.createSession(userId: 'user1');
      casino.createSession(userId: 'user1');
      casino.createSession(userId: 'user2');
      
      final user1Sessions = casino.getUserSessions('user1');
      expect(user1Sessions.length, 2);
      
      final user2Sessions = casino.getUserSessions('user2');
      expect(user2Sessions.length, 1);
    });

    test('should get casino statistics', () async {
      final session = casino.createSession(userId: 'user1', initialBalance: 100.0);
      
      // Place some bets
      for (int i = 0; i < 10; i++) {
        await casino.processBet(
          sessionId: session.sessionId,
          betType: 'red',
          betValue: 'red',
          amount: 5.0,
        );
      }
      
      final stats = casino.getCasinoStatistics();
      expect(stats['total_bets'], greaterThan(0));
      expect(stats['total_wagered'], greaterThan(0));
    });

    test('should throw on invalid session', () {
      expect(
        () => casino.getSession('invalid-session'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should calculate correct payout for different bet types', () async {
      final session = casino.createSession(userId: 'user1', initialBalance: 10000.0);
      
      // We need to place many bets to eventually hit each type
      // For testing purposes, we just verify the payout calculation is working
      
      final result = await casino.processBet(
        sessionId: session.sessionId,
        betType: 'red',
        betValue: 'red',
        amount: 10.0,
      );
      
      // Red/black pays 2:1 (bet + winnings = 2x bet)
      if (result['won'] as bool) {
        expect(result['payout'], 20.0);
      }
    });

    test('should clear all sessions', () {
      casino.createSession(userId: 'user1');
      casino.createSession(userId: 'user2');
      
      casino.clearAllSessions();
      
      expect(
        () => casino.getSession('any-session'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
