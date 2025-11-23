/// Casino Mock Bot - Simulates casino behavior for testing
/// Provides realistic casino simulation without real money integration

import 'dart:async';
import 'dart:math';
import '../core/base_bot.dart';
import '../core/logger.dart';
import '../agents/roulette_simulator_agent.dart';

/// Casino session state
class CasinoSession {
  final String sessionId;
  final String userId;
  final DateTime startTime;
  DateTime? endTime;
  double balance;
  final List<Map<String, dynamic>> transactions;

  CasinoSession({
    required this.sessionId,
    required this.userId,
    required this.balance,
    DateTime? startTime,
  })  : startTime = startTime ?? DateTime.now(),
        transactions = [];

  bool get isActive => endTime == null;

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'user_id': userId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'balance': balance,
        'is_active': isActive,
        'transaction_count': transactions.length,
      };
}

/// Casino Mock Bot for simulating casino operations
class CasinoMockBot extends AbstractBot {
  final Map<String, CasinoSession> _sessions = {};
  final RouletteSimulatorAgent _simulator = RouletteSimulatorAgent();
  final Random _random = Random();
  
  double _houseEdge = 2.7; // European roulette house edge (2.7%)
  RouletteType _rouletteType = RouletteType.european;

  CasinoMockBot({
    String id = 'casino-mock-bot-001',
    String name = 'CasinoMockBot',
  }) : super(id: id, name: name);

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    await super.initialize(config);

    if (config != null) {
      _houseEdge = (config['house_edge'] as num?)?.toDouble() ?? 2.7;
      final typeStr = config['roulette_type'] as String?;
      if (typeStr == 'american') {
        _rouletteType = RouletteType.american;
        _houseEdge = 5.26; // American roulette house edge
      }
    }

    await _simulator.initialize({'roulette_type': _rouletteType == RouletteType.american ? 'american' : 'european'});
    await _simulator.start();

    logger.info('Casino mock initialized. House edge: $_houseEdge%, Type: $_rouletteType');
  }

  /// Create a new casino session
  CasinoSession createSession({
    required String userId,
    double initialBalance = 1000.0,
  }) {
    final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
    
    final session = CasinoSession(
      sessionId: sessionId,
      userId: userId,
      balance: initialBalance,
    );

    _sessions[sessionId] = session;
    
    logger.info('Created session: $sessionId for user: $userId with balance: $initialBalance');
    monitor.recordCounter('sessions_created', 1);
    monitor.recordGauge('active_sessions', _sessions.values.where((s) => s.isActive).length.toDouble());

    return session;
  }

  /// Process a bet for a session
  Future<Map<String, dynamic>> processBet({
    required String sessionId,
    required String betType,
    required dynamic betValue,
    required double amount,
  }) async {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }

    if (!session.isActive) {
      throw StateError('Session is not active');
    }

    if (amount > session.balance) {
      throw ArgumentError('Insufficient balance. Available: ${session.balance}, Requested: $amount');
    }

    if (amount <= 0) {
      throw ArgumentError('Bet amount must be positive');
    }

    logger.info('Processing bet: $amount on $betType ($betValue) for session: $sessionId');
    monitor.recordCounter('bets_processed', 1);
    monitor.recordGauge('bet_amount', amount);

    // Deduct bet amount from balance
    session.balance -= amount;

    // Spin the wheel
    final spinResult = await _simulator.spin();

    // Check if bet won
    final won = _simulator.checkBet(spinResult, betType, betValue: betValue);

    // Calculate payout
    final payout = won ? _calculatePayout(betType, amount) : 0.0;
    final profit = payout - amount;

    // Update balance with payout
    session.balance += payout;

    // Record transaction
    final transaction = {
      'timestamp': DateTime.now().toIso8601String(),
      'bet_type': betType,
      'bet_value': betValue,
      'amount': amount,
      'spin_result': spinResult.toJson(),
      'won': won,
      'payout': payout,
      'profit': profit,
      'balance_after': session.balance,
    };

    session.transactions.add(transaction);

    logger.info('Bet result: ${won ? "WON" : "LOST"}, Spin: ${spinResult.number}, Profit: $profit, Balance: ${session.balance}');
    monitor.recordCounter(won ? 'bets_won' : 'bets_lost', 1);

    return transaction;
  }

  /// Calculate payout based on bet type
  double _calculatePayout(String betType, double amount) {
    switch (betType.toLowerCase()) {
      case 'straight':
        return amount * 36; // 35:1 + original bet
      case 'split':
        return amount * 18; // 17:1 + original bet
      case 'street':
        return amount * 12; // 11:1 + original bet
      case 'corner':
        return amount * 9; // 8:1 + original bet
      case 'line':
        return amount * 6; // 5:1 + original bet
      case 'dozen':
      case 'column':
        return amount * 3; // 2:1 + original bet
      case 'red':
      case 'black':
      case 'even':
      case 'odd':
      case 'high':
      case 'low':
        return amount * 2; // 1:1 + original bet
      default:
        logger.warning('Unknown bet type for payout calculation: $betType');
        return 0.0;
    }
  }

  /// Get session balance
  double getBalance(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }
    return session.balance;
  }

  /// Add funds to session (mock deposit)
  void addFunds(String sessionId, double amount) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }

    session.balance += amount;
    
    session.transactions.add({
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'deposit',
      'amount': amount,
      'balance_after': session.balance,
    });

    logger.info('Funds added to session $sessionId: $amount. New balance: ${session.balance}');
    monitor.recordCounter('deposits', 1);
    monitor.recordGauge('deposit_amount', amount);
  }

  /// Withdraw funds from session (mock withdrawal)
  void withdrawFunds(String sessionId, double amount) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }

    if (amount > session.balance) {
      throw ArgumentError('Insufficient balance for withdrawal');
    }

    session.balance -= amount;
    
    session.transactions.add({
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'withdrawal',
      'amount': amount,
      'balance_after': session.balance,
    });

    logger.info('Funds withdrawn from session $sessionId: $amount. New balance: ${session.balance}');
    monitor.recordCounter('withdrawals', 1);
    monitor.recordGauge('withdrawal_amount', amount);
  }

  /// End a casino session
  void endSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }

    session.endTime = DateTime.now();
    
    logger.info('Session ended: $sessionId. Final balance: ${session.balance}');
    monitor.recordCounter('sessions_ended', 1);
    monitor.recordGauge('active_sessions', _sessions.values.where((s) => s.isActive).length.toDouble());
  }

  /// Get session details
  CasinoSession getSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw ArgumentError('Session not found: $sessionId');
    }
    return session;
  }

  /// Get all sessions for a user
  List<CasinoSession> getUserSessions(String userId) {
    return _sessions.values
        .where((s) => s.userId == userId)
        .toList();
  }

  /// Get casino statistics
  Map<String, dynamic> getCasinoStatistics() {
    final activeSessions = _sessions.values.where((s) => s.isActive).length;
    final totalSessions = _sessions.length;
    
    var totalBets = 0;
    var totalWagered = 0.0;
    var totalPayouts = 0.0;

    for (final session in _sessions.values) {
      for (final transaction in session.transactions) {
        if (transaction['type'] == null) {
          // It's a bet transaction
          totalBets++;
          totalWagered += transaction['amount'] as double;
          totalPayouts += transaction['payout'] as double;
        }
      }
    }

    final houseProfit = totalWagered - totalPayouts;
    final actualEdge = totalWagered > 0 ? (houseProfit / totalWagered * 100) : 0.0;

    return {
      'total_sessions': totalSessions,
      'active_sessions': activeSessions,
      'total_bets': totalBets,
      'total_wagered': totalWagered,
      'total_payouts': totalPayouts,
      'house_profit': houseProfit,
      'configured_house_edge': _houseEdge,
      'actual_house_edge': actualEdge.toStringAsFixed(2),
      'roulette_type': _rouletteType.toString(),
    };
  }

  /// Clear all sessions (for testing)
  void clearAllSessions() {
    _sessions.clear();
    logger.info('All sessions cleared');
    monitor.recordCounter('sessions_cleared', 1);
  }

  @override
  Future<void> stop() async {
    await _simulator.stop();
    await super.stop();
  }

  // TODO: Implement table limits and betting rules
  // TODO: Add support for progressive jackpots
  // TODO: Implement player tracking and rewards system
  // TODO: Add session timeout and auto-logout
  // TODO: Support for tournament mode and leaderboards
  // TODO: Implement responsible gambling features (limits, cooldowns)
}
