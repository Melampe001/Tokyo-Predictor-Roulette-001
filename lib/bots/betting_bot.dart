/// Betting Bot - Automated betting logic with various strategies
/// Simulates betting behavior without real money (mock/template only)

import '../core/base_bot.dart';
import '../core/logger.dart';

/// Betting strategy enumeration
enum BettingStrategy {
  martingale,
  reverseMartingale,
  dAlembert,
  fibonacci,
  flat,
  labouchere,
}

/// Bet type
class Bet {
  final String type; // 'straight', 'red', 'black', 'even', 'odd', etc.
  final dynamic value; // number or color/type
  final double amount;
  final DateTime timestamp;

  Bet({
    required this.type,
    required this.value,
    required this.amount,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Bet result
class BetResult {
  final Bet bet;
  final bool won;
  final double payout;
  final double profit;

  BetResult({
    required this.bet,
    required this.won,
    required this.payout,
    required this.profit,
  });

  Map<String, dynamic> toJson() => {
        'bet': bet.toJson(),
        'won': won,
        'payout': payout,
        'profit': profit,
      };
}

/// Betting Bot for automated betting simulation
class BettingBot extends AbstractBot {
  BettingStrategy _strategy = BettingStrategy.flat;
  double _baseBet = 1.0;
  double _currentBet = 1.0;
  double _bankroll = 100.0;
  double _maxBet = 100.0;
  
  final List<BetResult> _betHistory = [];
  final List<int> _fibonacciSequence = [1, 1];
  int _fibonacciIndex = 0;
  final List<double> _labouchereSequence = [];

  BettingBot({
    String id = 'betting-bot-001',
    String name = 'BettingBot',
  }) : super(id: id, name: name);

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    await super.initialize(config);

    if (config != null) {
      final strategyStr = config['strategy'] as String?;
      if (strategyStr != null) {
        _strategy = BettingStrategy.values.firstWhere(
          (e) => e.toString().split('.').last == strategyStr,
          orElse: () => BettingStrategy.flat,
        );
      }

      _baseBet = (config['base_bet'] as num?)?.toDouble() ?? 1.0;
      _currentBet = _baseBet;
      _bankroll = (config['bankroll'] as num?)?.toDouble() ?? 100.0;
      _maxBet = (config['max_bet'] as num?)?.toDouble() ?? 100.0;
    }

    logger.info('Betting bot initialized: strategy=$_strategy, baseBet=$_baseBet, bankroll=$_bankroll');
  }

  /// Calculate next bet based on strategy
  Bet calculateNextBet({String betType = 'red', dynamic betValue}) {
    if (_currentBet > _bankroll) {
      logger.warning('Insufficient bankroll. Current bet: $_currentBet, Bankroll: $_bankroll');
      _currentBet = _bankroll;
    }

    if (_currentBet > _maxBet) {
      logger.warning('Bet exceeds maximum. Capping at $_maxBet');
      _currentBet = _maxBet;
    }

    final bet = Bet(
      type: betType,
      value: betValue ?? betType,
      amount: _currentBet,
    );

    logger.debug('Next bet: ${bet.amount} on ${bet.type}');
    monitor.recordCounter('bets_calculated', 1);
    monitor.recordGauge('current_bet', _currentBet);

    return bet;
  }

  /// Process bet result and update strategy
  BetResult processBetResult(Bet bet, bool won, {double payoutMultiplier = 2.0}) {
    final payout = won ? bet.amount * payoutMultiplier : 0.0;
    final profit = payout - bet.amount;

    _bankroll += profit;

    final result = BetResult(
      bet: bet,
      won: won,
      payout: payout,
      profit: profit,
    );

    _betHistory.add(result);
    _updateStrategy(won);

    logger.info('Bet result: ${won ? "WON" : "LOST"}, Profit: $profit, New bankroll: $_bankroll');
    monitor.recordCounter(won ? 'bets_won' : 'bets_lost', 1);
    monitor.recordGauge('bankroll', _bankroll);

    return result;
  }

  /// Update betting amount based on strategy
  void _updateStrategy(bool won) {
    switch (_strategy) {
      case BettingStrategy.martingale:
        _updateMartingale(won);
        break;
      case BettingStrategy.reverseMartingale:
        _updateReverseMartingale(won);
        break;
      case BettingStrategy.dAlembert:
        _updateDAlembert(won);
        break;
      case BettingStrategy.fibonacci:
        _updateFibonacci(won);
        break;
      case BettingStrategy.flat:
        _currentBet = _baseBet;
        break;
      case BettingStrategy.labouchere:
        _updateLabouchere(won);
        break;
    }
  }

  void _updateMartingale(bool won) {
    if (won) {
      _currentBet = _baseBet;
    } else {
      _currentBet = _currentBet * 2;
    }
  }

  void _updateReverseMartingale(bool won) {
    if (won) {
      _currentBet = _currentBet * 2;
    } else {
      _currentBet = _baseBet;
    }
  }

  void _updateDAlembert(bool won) {
    if (won) {
      _currentBet = (_currentBet - _baseBet).clamp(_baseBet, _maxBet);
    } else {
      _currentBet = (_currentBet + _baseBet).clamp(_baseBet, _maxBet);
    }
  }

  void _updateFibonacci(bool won) {
    if (won) {
      _fibonacciIndex = (_fibonacciIndex - 2).clamp(0, _fibonacciSequence.length - 1);
    } else {
      _fibonacciIndex++;
      while (_fibonacciIndex >= _fibonacciSequence.length) {
        final next = _fibonacciSequence[_fibonacciSequence.length - 1] +
                     _fibonacciSequence[_fibonacciSequence.length - 2];
        _fibonacciSequence.add(next);
      }
    }
    _currentBet = _baseBet * _fibonacciSequence[_fibonacciIndex];
  }

  void _updateLabouchere(bool won) {
    if (_labouchereSequence.isEmpty) {
      _labouchereSequence.addAll([1, 2, 3, 4]);
    }

    if (won && _labouchereSequence.length >= 2) {
      _labouchereSequence.removeAt(0);
      _labouchereSequence.removeAt(_labouchereSequence.length - 1);
    } else if (!won) {
      final betUnits = _labouchereSequence.isEmpty 
          ? 1.0 
          : _labouchereSequence.first + _labouchereSequence.last;
      _labouchereSequence.add(betUnits);
    }

    _currentBet = _labouchereSequence.isEmpty
        ? _baseBet
        : _baseBet * (_labouchereSequence.first + _labouchereSequence.last);
  }

  /// Get betting statistics
  Map<String, dynamic> getStatistics() {
    if (_betHistory.isEmpty) {
      return {
        'total_bets': 0,
        'bankroll': _bankroll,
        'current_bet': _currentBet,
      };
    }

    final totalBets = _betHistory.length;
    final wins = _betHistory.where((r) => r.won).length;
    final losses = totalBets - wins;
    final totalProfit = _betHistory.fold(0.0, (sum, r) => sum + r.profit);
    final totalWagered = _betHistory.fold(0.0, (sum, r) => sum + r.bet.amount);

    return {
      'total_bets': totalBets,
      'wins': wins,
      'losses': losses,
      'win_rate': totalBets > 0 ? (wins / totalBets * 100).toStringAsFixed(2) : '0.00',
      'total_profit': totalProfit,
      'total_wagered': totalWagered,
      'roi': totalWagered > 0 ? (totalProfit / totalWagered * 100).toStringAsFixed(2) : '0.00',
      'bankroll': _bankroll,
      'current_bet': _currentBet,
      'strategy': _strategy.toString(),
    };
  }

  /// Get bet history
  List<BetResult> getBetHistory({int? limit}) {
    if (limit == null || limit >= _betHistory.length) {
      return List.unmodifiable(_betHistory);
    }
    return List.unmodifiable(_betHistory.sublist(_betHistory.length - limit));
  }

  /// Reset betting state
  @override
  Future<void> reset() async {
    await super.reset();
    _currentBet = _baseBet;
    _fibonacciIndex = 0;
    _labouchereSequence.clear();
    _betHistory.clear();
    logger.info('Betting bot reset');
  }

  /// Get current bankroll
  double get bankroll => _bankroll;

  /// Set bankroll
  void setBankroll(double amount) {
    _bankroll = amount;
    logger.info('Bankroll updated to: $_bankroll');
  }

  // TODO: Implement risk management and stop-loss mechanisms
  // TODO: Add support for complex bet types (splits, corners, streets)
  // TODO: Implement Kelly Criterion for optimal bet sizing
  // TODO: Add session management with profit targets
  // TODO: Support for parlay and accumulator betting
}
