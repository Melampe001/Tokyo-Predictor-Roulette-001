/// Example: Betting Bot Usage
/// Demonstrates how to use the BettingBot with different strategies

import '../bots/betting_bot.dart';

Future<void> main() async {
  print('=== Betting Bot Example ===\n');

  // Test Martingale strategy
  await testStrategy(BettingStrategy.martingale, 'Martingale');
  print('\n${"=" * 50}\n');

  // Test Fibonacci strategy
  await testStrategy(BettingStrategy.fibonacci, 'Fibonacci');
  print('\n${"=" * 50}\n');

  // Test D'Alembert strategy
  await testStrategy(BettingStrategy.dAlembert, "D'Alembert");
  
  print('=== Example Complete ===');
}

Future<void> testStrategy(BettingStrategy strategy, String strategyName) async {
  print('Testing $strategyName Strategy:\n');

  final bot = BettingBot(
    id: 'betting-bot-demo',
    name: 'DemoBettingBot',
  );

  await bot.initialize({
    'strategy': strategy.toString().split('.').last,
    'base_bet': 1.0,
    'bankroll': 100.0,
    'max_bet': 50.0,
  });

  print('Initial bankroll: \$${bot.bankroll.toStringAsFixed(2)}\n');

  // Simulate 20 bets with alternating results
  print('Simulating 20 bets:');
  for (int i = 0; i < 20; i++) {
    // Calculate next bet
    final bet = bot.calculateNextBet(betType: 'red');
    
    // Simulate win/loss (alternate for demonstration)
    // In reality, this would come from actual roulette results
    final won = i % 3 != 0; // Win 2 out of 3 times
    
    // Process result
    final result = bot.processBetResult(bet, won);
    
    print('  Bet ${i + 1}: \$${bet.amount.toStringAsFixed(2)} - ${won ? "WON" : "LOST"} - '
          'Profit: \$${result.profit.toStringAsFixed(2)} - '
          'Bankroll: \$${bot.bankroll.toStringAsFixed(2)}');
  }

  // Get final statistics
  print('\nFinal Statistics:');
  final stats = bot.getStatistics();
  print('  Total Bets: ${stats['total_bets']}');
  print('  Wins: ${stats['wins']}');
  print('  Losses: ${stats['losses']}');
  print('  Win Rate: ${stats['win_rate']}%');
  print('  Total Profit: \$${stats['total_profit']}');
  print('  Total Wagered: \$${stats['total_wagered']}');
  print('  ROI: ${stats['roi']}%');
  print('  Final Bankroll: \$${stats['bankroll']}');

  await bot.stop();
}
