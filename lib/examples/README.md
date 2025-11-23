# Examples

This directory contains usage examples demonstrating how to use the agents and bots in this library.

## Available Examples

### predictor_example.dart
Demonstrates basic usage of the PredictorAgent for making roulette predictions.

**What it shows**:
- Agent initialization and configuration
- Adding historical data
- Making predictions
- Accessing statistics
- Agent lifecycle management

**Run with**:
```bash
dart run lib/examples/predictor_example.dart
```

### betting_bot_example.dart
Shows how to use the BettingBot with different betting strategies.

**What it shows**:
- Bot initialization with different strategies
- Calculating next bets
- Processing bet results
- Tracking performance statistics
- Comparing multiple strategies

**Run with**:
```bash
dart run lib/examples/betting_bot_example.dart
```

### complete_workflow_example.dart
Comprehensive example integrating multiple agents and bots in a realistic workflow.

**What it shows**:
- Setting up a mock casino environment
- Initializing multiple agents (predictor, analyzer)
- Running automated betting sessions
- RNG analysis
- End-to-end simulation
- Performance metrics and reporting

**Run with**:
```bash
dart run lib/examples/complete_workflow_example.dart
```

**This example demonstrates**:
1. Casino mock setup
2. Predictor agent initialization
3. RNG analyzer configuration
4. Betting bot setup with Martingale strategy
5. Training data generation
6. RNG bias analysis
7. Automated betting loop with predictions
8. Final statistics and reporting

## How to Use These Examples

1. **Study the code**: Each example is well-commented and shows best practices
2. **Run them**: Execute the examples to see the output
3. **Modify them**: Change parameters to see different behaviors
4. **Build on them**: Use as templates for your own implementations

## Example Output

When you run `complete_workflow_example.dart`, you'll see:
```
=== Complete Simulation Workflow ===

Step 1: Setting up mock casino...
  Session created: session_1234567890_5678
  Initial balance: $500.00

Step 2: Initializing predictor agent...
  Predictor ready with hybrid model

...

Final Results:
Casino Statistics:
  Total bets: 70
  Total wagered: $387.50
  House profit: $12.34

=== Simulation Complete ===
```

## Creating Your Own Examples

To create a new example:

1. Create a new file in this directory
2. Import the necessary agents/bots
3. Write a `main()` function
4. Add descriptive comments
5. Handle errors appropriately
6. Clean up resources (stop agents/bots)

**Template**:
```dart
/// Example: Your Feature
/// Description of what this example demonstrates

import '../agents/your_agent.dart';
import '../bots/your_bot.dart';

Future<void> main() async {
  print('=== Your Example ===\n');
  
  // Your example code here
  
  print('\n=== Example Complete ===');
}
```

## Best Practices

1. **Always clean up**: Stop agents/bots when done
2. **Handle errors**: Use try-catch for robustness
3. **Add logging**: Show progress and results
4. **Document**: Explain what the example demonstrates
5. **Keep it simple**: Focus on one concept per example
6. **Make it runnable**: Ensure examples can run standalone

## Learning Path

**Recommended order**:
1. Start with `predictor_example.dart` - Learn basic agent usage
2. Move to `betting_bot_example.dart` - Understand bot operations
3. Study `complete_workflow_example.dart` - See full integration

## Integration Patterns

These examples demonstrate common integration patterns:

- **Agent composition**: Using multiple agents together
- **Agent-bot interaction**: Connecting predictors with betting bots
- **Event-driven workflows**: Responding to spin results
- **Data pipelines**: Training → Analysis → Prediction → Betting
- **Statistics aggregation**: Collecting metrics from multiple sources

## Troubleshooting

**Example won't run?**
- Ensure all dependencies are installed: `flutter pub get`
- Check Dart SDK version compatibility
- Verify import paths

**Unexpected results?**
- Remember: predictions are probabilistic, not deterministic
- RNG analysis requires sufficient data (minimum 37-100 spins)
- Betting outcomes are random in simulations

**Performance issues?**
- Reduce simulation counts for faster execution
- Use appropriate data structures
- Profile with `dart run --observe`

## Next Steps

After exploring these examples:
1. Review the agent/bot source code in `/lib/agents/` and `/lib/bots/`
2. Check unit tests in `/test/` for more usage patterns
3. Read the README files in each directory for detailed documentation
4. Build your own custom agents and bots

## Contributing Examples

To add your own example:
1. Follow the template above
2. Ensure it runs without errors
3. Add clear comments
4. Update this README
5. Submit a pull request

---

**Remember**: All examples are simulations only. No real money, no real gambling, educational purposes only.
