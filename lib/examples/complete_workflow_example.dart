/// Example: Complete Simulation Workflow
/// Demonstrates integration of multiple agents and bots

import '../agents/roulette_simulator_agent.dart';
import '../agents/predictor_agent.dart';
import '../agents/rng_analyzer_agent.dart';
import '../bots/betting_bot.dart';
import '../bots/casino_mock_bot.dart';

Future<void> main() async {
  print('=== Complete Simulation Workflow ===\n');

  // Step 1: Set up casino mock
  print('Step 1: Setting up mock casino...');
  final casino = CasinoMockBot();
  await casino.initialize({'roulette_type': 'european'});
  await casino.execute();
  
  final session = casino.createSession(
    userId: 'demo_user',
    initialBalance: 500.0,
  );
  print('  Session created: ${session.sessionId}');
  print('  Initial balance: \$${session.balance}\n');

  // Step 2: Initialize predictor
  print('Step 2: Initializing predictor agent...');
  final predictor = PredictorAgent();
  await predictor.initialize({'strategy': 'hybridModel'});
  await predictor.start();
  print('  Predictor ready with hybrid model\n');

  // Step 3: Initialize RNG analyzer
  print('Step 3: Initializing RNG analyzer...');
  final analyzer = RngAnalyzerAgent();
  await analyzer.initialize(null);
  await analyzer.start();
  print('  Analyzer ready\n');

  // Step 4: Initialize betting bot
  print('Step 4: Initializing betting bot...');
  final bettingBot = BettingBot();
  await bettingBot.initialize({
    'strategy': 'martingale',
    'base_bet': 5.0,
    'bankroll': session.balance,
    'max_bet': 100.0,
  });
  print('  Betting bot ready with Martingale strategy\n');

  // Step 5: Generate training data
  print('Step 5: Generating training data (50 spins)...');
  for (int i = 0; i < 50; i++) {
    final bet = await casino.processBet(
      sessionId: session.sessionId,
      betType: 'red',
      betValue: 'red',
      amount: 1.0,
    );
    
    final spinNumber = bet['spin_result']['number'] as int;
    predictor.addResult(spinNumber);
    analyzer.addObservation(spinNumber);
  }
  print('  Training complete\n');

  // Step 6: Analyze RNG
  print('Step 6: Analyzing RNG patterns...');
  final analysis = await analyzer.analyze();
  print('  Potentially biased: ${analysis.isPotentiallyBiased}');
  print('  Chi-square statistic: ${analysis.chiSquareStatistic.toStringAsFixed(2)}');
  print('  Findings: ${analysis.findings.length} issues detected');
  for (final finding in analysis.findings) {
    print('    - $finding');
  }
  print('');

  // Step 7: Run automated betting session
  print('Step 7: Running automated betting session (20 rounds)...');
  for (int i = 0; i < 20; i++) {
    // Get prediction
    final prediction = await predictor.predict();
    
    // Calculate bet using betting bot
    final bet = bettingBot.calculateNextBet(betType: 'straight', betValue: prediction.predictedNumber);
    
    // Check if we have enough balance
    if (bet.amount > casino.getBalance(session.sessionId)) {
      print('  Round ${i + 1}: Insufficient balance, adding funds...');
      casino.addFunds(session.sessionId, 100.0);
    }
    
    // Place bet at casino
    final result = await casino.processBet(
      sessionId: session.sessionId,
      betType: bet.type,
      betValue: bet.value,
      amount: bet.amount,
    );
    
    // Process result in betting bot
    final won = result['won'] as bool;
    bettingBot.processBetResult(bet, won, payoutMultiplier: 36.0);
    
    // Update predictor and analyzer
    final spinNumber = result['spin_result']['number'] as int;
    predictor.addResult(spinNumber);
    analyzer.addObservation(spinNumber);
    
    if ((i + 1) % 5 == 0) {
      print('  Round ${i + 1}: Balance = \$${casino.getBalance(session.sessionId).toStringAsFixed(2)}');
    }
  }
  print('');

  // Step 8: Display final results
  print('Step 8: Final Results\n');
  
  print('Casino Statistics:');
  final casinoStats = casino.getCasinoStatistics();
  print('  Total bets: ${casinoStats['total_bets']}');
  print('  Total wagered: \$${casinoStats['total_wagered']}');
  print('  House profit: \$${casinoStats['house_profit']}\n');
  
  print('Betting Bot Statistics:');
  final botStats = bettingBot.getStatistics();
  print('  Win rate: ${botStats['win_rate']}%');
  print('  ROI: ${botStats['roi']}%\n');
  
  print('Predictor Statistics:');
  final predStats = predictor.getStatistics();
  print('  Total predictions: ${predStats['total_results']}');
  print('  Strategy: ${predStats['strategy']}\n');
  
  print('Session Summary:');
  final finalSession = casino.getSession(session.sessionId);
  print('  Final balance: \$${finalSession.balance.toStringAsFixed(2)}');
  print('  Total transactions: ${finalSession.transactions.length}');
  print('  Profit/Loss: \$${(finalSession.balance - 500.0).toStringAsFixed(2)}');

  // Cleanup
  casino.endSession(session.sessionId);
  await predictor.stop();
  await analyzer.stop();
  await casino.stop();
  
  print('\n=== Simulation Complete ===');
}
