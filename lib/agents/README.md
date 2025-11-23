# Agents

This directory contains intelligent agents for roulette analysis and prediction. Each agent is designed to be modular, extensible, and self-contained.

## Available Agents

### PredictorAgent (`predictor_agent.dart`)
**Purpose**: Predicts next roulette numbers using various statistical strategies.

**Features**:
- Multiple prediction strategies (frequency-based, pattern recognition, hot/cold analysis, hybrid)
- Configurable strategy selection
- Confidence scoring for predictions
- Historical data tracking

**Usage**:
```dart
final predictor = PredictorAgent();
await predictor.initialize({'strategy': 'hybridModel'});
await predictor.start();

predictor.addResult(15);
predictor.addResult(23);
// ... add more results

final prediction = await predictor.predict();
print('Predicted: ${prediction.predictedNumber}');
print('Confidence: ${prediction.confidence}');
```

### RngAnalyzerAgent (`rng_analyzer_agent.dart`)
**Purpose**: Analyzes RNG patterns and detects potential biases in roulette outcomes.

**Features**:
- Chi-square test for uniform distribution
- Runs test for randomness
- Serial correlation analysis
- Frequency distribution analysis
- Statistical anomaly detection

**Usage**:
```dart
final analyzer = RngAnalyzerAgent();
await analyzer.initialize(null);
await analyzer.start();

// Add observations
for (final number in results) {
  analyzer.addObservation(number);
}

final analysis = await analyzer.analyze();
print('Potentially biased: ${analysis.isPotentiallyBiased}');
print('Findings: ${analysis.findings}');
```

### StatisticalAnalyzerAgent (`statistical_analyzer_agent.dart`)
**Purpose**: Provides comprehensive statistical modeling and analysis.

**Features**:
- Descriptive statistics (mean, median, mode, variance, etc.)
- Probability distribution modeling
- Time series analysis
- Confidence intervals
- Entropy calculations

**Usage**:
```dart
final analyzer = StatisticalAnalyzerAgent();
await analyzer.initialize(null);
await analyzer.start();

for (final value in dataset) {
  analyzer.addDataPoint(value);
}

final stats = analyzer.calculateDescriptiveStats();
final model = await analyzer.buildProbabilityModel();
```

### RouletteSimulatorAgent (`roulette_simulator_agent.dart`)
**Purpose**: Simulates European and American roulette wheels.

**Features**:
- Support for European (0-36) and American (0-36 + 00) roulette
- Realistic spin simulation with metadata (color, dozen, column, etc.)
- Batch simulation capabilities
- Bet validation
- Historical tracking

**Usage**:
```dart
final simulator = RouletteSimulatorAgent();
await simulator.initialize({'roulette_type': 'european'});
await simulator.start();

final result = await simulator.spin();
print('Number: ${result.number}, Color: ${result.color}');

// Simulate many spins
final results = await simulator.simulateSpins(1000);
```

## Common Features

All agents inherit from `AbstractAgent` and provide:
- Lifecycle management (initialize, start, stop, pause, resume, reset)
- Structured logging
- Metrics collection and monitoring
- State management
- Status reporting

## Extension Points

Each agent includes TODO comments marking areas for future enhancement:
- Advanced AI/ML integration
- Additional statistical tests
- Performance optimizations
- Real-time monitoring capabilities
- External data source integration

## Testing

Unit tests for all agents are located in `/test/agents/`. Run with:
```bash
flutter test test/agents/
```

## Best Practices

1. Always initialize agents before use
2. Start agents before performing operations
3. Handle state errors appropriately
4. Clear data periodically to manage memory
5. Monitor metrics for performance insights
6. Use appropriate strategy for your use case

## Architecture

```
BaseAgent (interface)
    ↓
AbstractAgent (common implementation)
    ↓
[Specific Agents] (domain logic)
```

Each agent is independent and can be used standalone or composed with other agents for complex workflows.
