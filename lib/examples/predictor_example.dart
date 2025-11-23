/// Example: Basic Predictor Agent Usage
/// Demonstrates how to use the PredictorAgent for roulette prediction

import '../agents/predictor_agent.dart';
import '../agents/roulette_simulator_agent.dart';

Future<void> main() async {
  print('=== Predictor Agent Example ===\n');

  // Create and initialize predictor agent
  final predictor = PredictorAgent(
    id: 'predictor-demo',
    name: 'DemoPredictor',
  );

  await predictor.initialize({
    'strategy': 'frequencyBased', // or 'patternRecognition', 'hotColdNumbers', 'hybridModel'
  });

  await predictor.start();
  print('Predictor agent started with frequency-based strategy\n');

  // Create a simulator to generate data
  final simulator = RouletteSimulatorAgent();
  await simulator.initialize(null);
  await simulator.start();

  // Generate training data (100 spins)
  print('Generating training data...');
  final trainingData = await simulator.simulateSpins(100);
  
  for (final spin in trainingData) {
    predictor.addResult(spin.number as int);
  }
  print('Added ${trainingData.length} results to predictor\n');

  // Get statistics
  final stats = predictor.getStatistics();
  print('Statistics:');
  print('  Total results: ${stats['total_results']}');
  print('  Unique numbers: ${stats['unique_numbers']}');
  print('  Most frequent: ${stats['most_frequent']}\n');

  // Make predictions
  print('Making predictions:');
  for (int i = 0; i < 5; i++) {
    final prediction = await predictor.predict();
    final actualSpin = await simulator.spin();
    
    print('  Prediction ${i + 1}:');
    print('    Predicted: ${prediction.predictedNumber}');
    print('    Actual: ${actualSpin.number}');
    print('    Confidence: ${(prediction.confidence * 100).toStringAsFixed(2)}%');
    print('    Method: ${prediction.method}');
    print('    Match: ${prediction.predictedNumber == actualSpin.number ? "✓" : "✗"}');
    print('');
    
    // Add actual result for next prediction
    predictor.addResult(actualSpin.number as int);
  }

  // Get final status
  final status = predictor.getStatus();
  print('Agent Status:');
  print('  ID: ${status['id']}');
  print('  State: ${status['state']}');
  print('  Metrics: ${status['metrics_summary']}\n');

  // Clean up
  await predictor.stop();
  await simulator.stop();
  
  print('=== Example Complete ===');
}
