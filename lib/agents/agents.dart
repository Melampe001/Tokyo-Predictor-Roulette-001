/// Tokyo Roulette Agents Library
///
/// This library exports all agent modules for the Tokyo Roulette application.
/// Agents are modular components that encapsulate specific functionality
/// for roulette simulation, prediction, and betting strategy advice.
///
/// ## Available Agents
///
/// - [RouletteAgent] - Core roulette simulation and prediction agent
/// - [MartingaleAdvisor] - Martingale betting strategy advisor
///
/// ## Usage
///
/// ```dart
/// import 'package:tokyo_roulette_predicciones/agents/agents.dart';
///
/// void main() {
///   // Create agents
///   final rouletteAgent = RouletteAgent();
///   final advisor = MartingaleAdvisor(baseBet: 10.0);
///
///   // Simulate a spin
///   final result = rouletteAgent.spin();
///   rouletteAgent.addToHistory(result);
///
///   // Use advisor based on result
///   final won = result > 18; // Example: betting on high numbers
///   final nextBet = advisor.processBet(won: won);
///
///   print('Result: \$result, Next bet: \$nextBet');
/// }
/// ```
///
/// ## Educational Disclaimer
///
/// These agents are designed for educational and simulation purposes only.
/// They do not provide any advantage in real gambling scenarios.
/// In real roulette, each spin is independent and cannot be predicted.
library agents;

export 'roulette_agent.dart';
export 'martingale_advisor.dart';
