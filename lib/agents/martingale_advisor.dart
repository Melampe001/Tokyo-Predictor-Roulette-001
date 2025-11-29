/// Martingale Advisor Agent - Betting strategy advisor for Tokyo Roulette
///
/// This module provides the [MartingaleAdvisor] class which implements
/// the Martingale betting strategy for educational purposes.
///
/// ## Usage
///
/// ```dart
/// // Create a Martingale advisor with base bet of 5.0
/// final advisor = MartingaleAdvisor(baseBet: 5.0);
///
/// // Simulate a loss - bet doubles
/// final nextBet = advisor.processBet(won: false);
/// print('Next bet after loss: \$nextBet'); // 10.0
///
/// // Simulate a win - bet resets
/// final resetBet = advisor.processBet(won: true);
/// print('Next bet after win: \$resetBet'); // 5.0
/// ```
///
/// ## Warning
///
/// The Martingale strategy has significant risks and can lead to large
/// losses. This is an educational simulator only. Never use this for
/// real gambling decisions.
library martingale_advisor;

/// Configuration for the Martingale betting strategy.
///
/// This class encapsulates the parameters that control the
/// behavior of the [MartingaleAdvisor].
class MartingaleConfig {
  /// Creates a new Martingale configuration.
  ///
  /// ### Parameters
  ///
  /// - [baseBet]: The starting bet amount.
  /// - [maxBet]: The maximum allowed bet (to prevent runaway losses).
  /// - [multiplier]: The factor to multiply bet by after a loss.
  const MartingaleConfig({
    required this.baseBet,
    this.maxBet = 10000.0,
    this.multiplier = 2.0,
  })  : assert(baseBet > 0, 'Base bet must be positive'),
        assert(maxBet > baseBet, 'Max bet must be greater than base bet'),
        assert(multiplier > 1, 'Multiplier must be greater than 1');

  /// The base (starting) bet amount.
  final double baseBet;

  /// The maximum allowed bet amount.
  final double maxBet;

  /// The multiplier applied after each loss.
  final double multiplier;

  @override
  String toString() =>
      'MartingaleConfig(baseBet: $baseBet, maxBet: $maxBet, multiplier: $multiplier)';
}

/// Betting strategy advisor implementing the Martingale system.
///
/// The Martingale strategy is a betting system where the player doubles
/// their bet after each loss. After a win, the bet returns to the base
/// amount. This strategy aims to recover all previous losses with a single
/// win, plus gain a profit equal to the base bet.
///
/// ### Warning
///
/// This is for educational purposes only. The Martingale strategy:
/// - Requires an unlimited bankroll (impossible in practice)
/// - Has no long-term mathematical advantage
/// - Can lead to catastrophic losses due to table limits
///
/// ### Example
///
/// ```dart
/// final advisor = MartingaleAdvisor(baseBet: 10.0);
///
/// // Sequence: loss, loss, win
/// print(advisor.processBet(won: false)); // 20.0
/// print(advisor.processBet(won: false)); // 40.0
/// print(advisor.processBet(won: true));  // 10.0 (reset)
///
/// // Check session statistics
/// print(advisor.sessionStats);
/// ```
class MartingaleAdvisor {
  /// Creates a new [MartingaleAdvisor] with the specified configuration.
  ///
  /// ### Parameters
  ///
  /// - [baseBet]: The starting bet amount (default: 1.0).
  /// - [maxBet]: The maximum allowed bet (default: 10000.0).
  /// - [multiplier]: The factor to multiply bet by after loss (default: 2.0).
  MartingaleAdvisor({
    double baseBet = 1.0,
    double maxBet = 10000.0,
    double multiplier = 2.0,
  }) : _config = MartingaleConfig(
          baseBet: baseBet,
          maxBet: maxBet,
          multiplier: multiplier,
        ) {
    _currentBet = _config.baseBet;
  }

  /// Creates a new [MartingaleAdvisor] from a configuration object.
  MartingaleAdvisor.fromConfig(MartingaleConfig config) : _config = config {
    _currentBet = _config.baseBet;
  }

  /// The configuration for this advisor.
  final MartingaleConfig _config;

  /// The current bet amount.
  late double _currentBet;

  /// The result of the last bet (true = win, false = loss).
  bool _lastResult = true;

  /// Consecutive losses counter.
  int _consecutiveLosses = 0;

  /// Total wins in this session.
  int _totalWins = 0;

  /// Total losses in this session.
  int _totalLosses = 0;

  /// Total amount bet in this session.
  double _totalBet = 0.0;

  /// Total profit/loss in this session.
  double _totalProfitLoss = 0.0;

  /// Returns the current recommended bet amount.
  double get currentBet => _currentBet;

  /// Returns the base bet amount.
  double get baseBet => _config.baseBet;

  /// Returns the maximum allowed bet.
  double get maxBet => _config.maxBet;

  /// Returns the multiplier used after losses.
  double get multiplier => _config.multiplier;

  /// Returns the result of the last bet.
  bool get lastResult => _lastResult;

  /// Returns the current consecutive loss streak.
  int get consecutiveLosses => _consecutiveLosses;

  /// Returns true if the current bet has reached the maximum limit.
  bool get isAtMaxBet => _currentBet >= _config.maxBet;

  /// Gets the recommended bet for the next round.
  ///
  /// This is the same as [currentBet] but named for clarity.
  double getNextBet() => _currentBet;

  /// Processes the result of a bet and calculates the next recommended bet.
  ///
  /// ### Parameters
  ///
  /// - [won]: Whether the bet was won (true) or lost (false).
  /// - [betAmount]: Optional custom bet amount (uses current bet if not specified).
  ///
  /// ### Returns
  ///
  /// The recommended bet amount for the next round.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final advisor = MartingaleAdvisor(baseBet: 10.0);
  ///
  /// // After a loss, bet doubles
  /// var nextBet = advisor.processBet(won: false);
  /// print(nextBet); // 20.0
  ///
  /// // After a win, bet resets to base
  /// nextBet = advisor.processBet(won: true);
  /// print(nextBet); // 10.0
  /// ```
  double processBet({required bool won, double? betAmount}) {
    final actualBet = betAmount ?? _currentBet;
    _totalBet += actualBet;
    _lastResult = won;

    if (won) {
      // Win: profit equals the bet amount, reset to base
      _totalProfitLoss += actualBet;
      _totalWins++;
      _consecutiveLosses = 0;
      _currentBet = _config.baseBet;
    } else {
      // Loss: lose the bet amount, double next bet
      _totalProfitLoss -= actualBet;
      _totalLosses++;
      _consecutiveLosses++;
      _currentBet = (_currentBet * _config.multiplier).clamp(
        _config.baseBet,
        _config.maxBet,
      );
    }

    return _currentBet;
  }

  /// Resets the advisor to initial state.
  ///
  /// This clears all session statistics and resets the bet to base amount.
  void reset() {
    _currentBet = _config.baseBet;
    _lastResult = true;
    _consecutiveLosses = 0;
    _totalWins = 0;
    _totalLosses = 0;
    _totalBet = 0.0;
    _totalProfitLoss = 0.0;
  }

  /// Returns session statistics.
  MartingaleStats get sessionStats => MartingaleStats(
        totalWins: _totalWins,
        totalLosses: _totalLosses,
        totalBet: _totalBet,
        profitLoss: _totalProfitLoss,
        consecutiveLosses: _consecutiveLosses,
        currentBet: _currentBet,
        isAtMaxBet: isAtMaxBet,
      );

  /// Simulates a series of bets with given win probability.
  ///
  /// This is useful for educational analysis of the strategy.
  ///
  /// ### Parameters
  ///
  /// - [rounds]: Number of rounds to simulate.
  /// - [winProbability]: Probability of winning each round (0.0 to 1.0).
  ///
  /// ### Returns
  ///
  /// A list of [MartingaleStats] for each round.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final advisor = MartingaleAdvisor(baseBet: 10.0);
  /// final results = advisor.simulate(rounds: 100, winProbability: 0.486);
  /// print('Final P/L: \${results.last.profitLoss}');
  /// ```
  List<MartingaleStats> simulate({
    required int rounds,
    double winProbability = 0.486, // European roulette even bet probability
  }) {
    final results = <MartingaleStats>[];
    final rng = _MockRandom(winProbability);

    reset();

    for (var i = 0; i < rounds; i++) {
      final won = rng.nextBool();
      processBet(won: won);
      results.add(sessionStats);
    }

    return results;
  }

  @override
  String toString() =>
      'MartingaleAdvisor(currentBet: $_currentBet, config: $_config)';
}

/// Statistics for a Martingale betting session.
class MartingaleStats {
  /// Creates session statistics.
  const MartingaleStats({
    required this.totalWins,
    required this.totalLosses,
    required this.totalBet,
    required this.profitLoss,
    required this.consecutiveLosses,
    required this.currentBet,
    required this.isAtMaxBet,
  });

  /// Total number of wins.
  final int totalWins;

  /// Total number of losses.
  final int totalLosses;

  /// Total amount bet.
  final double totalBet;

  /// Net profit or loss.
  final double profitLoss;

  /// Current consecutive loss streak.
  final int consecutiveLosses;

  /// Current bet amount.
  final double currentBet;

  /// Whether the max bet limit has been reached.
  final bool isAtMaxBet;

  /// Total number of rounds played.
  int get totalRounds => totalWins + totalLosses;

  /// Win rate as a percentage.
  double get winRate => totalRounds > 0 ? (totalWins / totalRounds) * 100 : 0;

  /// Return on investment percentage.
  double get roi => totalBet > 0 ? (profitLoss / totalBet) * 100 : 0;

  @override
  String toString() => '''MartingaleStats(
  rounds: $totalRounds,
  wins: $totalWins,
  losses: $totalLosses,
  winRate: ${winRate.toStringAsFixed(1)}%,
  profitLoss: \$${profitLoss.toStringAsFixed(2)},
  roi: ${roi.toStringAsFixed(1)}%,
  consecutiveLosses: $consecutiveLosses,
  currentBet: \$$currentBet
)''';
}

/// A mock random generator for simulation with configurable probability.
class _MockRandom {
  _MockRandom(this.winProbability) : _rng = _SimpleRng();

  final double winProbability;
  final _SimpleRng _rng;

  bool nextBool() => _rng.nextDouble() < winProbability;
}

/// A simple linear congruential generator for deterministic simulations.
class _SimpleRng {
  int _seed = DateTime.now().millisecondsSinceEpoch;

  double nextDouble() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
