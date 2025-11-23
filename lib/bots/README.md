# Bots

This directory contains automated bots for betting, testing, and casino integration. All bots are **mock/template implementations** - they do not connect to real casinos or use real money.

## Available Bots

### BettingBot (`betting_bot.dart`)
**Purpose**: Automated betting logic with various strategies (simulation only).

**Features**:
- Multiple betting strategies (Martingale, Fibonacci, D'Alembert, Labouchere, etc.)
- Bankroll management
- Bet history tracking
- Performance statistics
- Risk management

**Strategies**:
- **Martingale**: Double bet after loss
- **Reverse Martingale**: Double bet after win
- **D'Alembert**: Increase/decrease by base bet unit
- **Fibonacci**: Follow Fibonacci sequence
- **Flat**: Same bet every time
- **Labouchere**: Cancellation system

**Usage**:
```dart
final bot = BettingBot();
await bot.initialize({
  'strategy': 'martingale',
  'base_bet': 10.0,
  'bankroll': 500.0,
  'max_bet': 100.0,
});

final bet = bot.calculateNextBet(betType: 'red');
final result = bot.processBetResult(bet, won: true);
print('Profit: ${result.profit}');
```

### ApiIntegrationBot (`api_integration_bot.dart`)
**Purpose**: Template for external casino/API integration (mock implementation).

**Features**:
- Authentication simulation
- Mock API calls (spin, place bet, get balance, get history)
- Request logging
- Webhook handling
- Extension points for real API integration

**Usage**:
```dart
final bot = ApiIntegrationBot();
await bot.initialize({
  'api_endpoint': 'https://api.example.com',
  'api_key': 'your-key',
});

final authResponse = await bot.authenticate(
  username: 'user',
  password: 'pass',
);

final spinResponse = await bot.requestSpin();
```

**Note**: All methods are currently mocked. Replace with real HTTP calls for production use.

### TestBot (`test_bot.dart`)
**Purpose**: Automated testing and validation of agents/bots.

**Features**:
- Multiple test scenarios
- Basic simulation tests
- Strategy validation
- Prediction accuracy testing
- Stress testing
- Edge case testing

**Test Scenarios**:
- Basic simulation (100 spins)
- Strategy validation (all betting strategies)
- Prediction accuracy
- Stress test (10,000 spins)
- Edge cases

**Usage**:
```dart
final bot = TestBot();
await bot.initialize(null);
await bot.execute(); // Runs all tests

final summary = bot.getTestSummary();
print('Passed: ${summary['passed']}/${summary['total']}');
```

### CasinoMockBot (`casino_mock_bot.dart`)
**Purpose**: Simulates casino operations for testing (no real money).

**Features**:
- Session management
- Bet processing with realistic payouts
- Balance tracking
- Transaction history
- Deposits/withdrawals (simulated)
- Casino statistics

**Usage**:
```dart
final casino = CasinoMockBot();
await casino.initialize({'roulette_type': 'european'});
await casino.execute();

final session = casino.createSession(
  userId: 'user123',
  initialBalance: 1000.0,
);

final result = await casino.processBet(
  sessionId: session.sessionId,
  betType: 'red',
  betValue: 'red',
  amount: 50.0,
);

print('Won: ${result['won']}, Payout: ${result['payout']}');
```

## Common Features

All bots inherit from `AbstractBot` and provide:
- Lifecycle management (initialize, execute, stop, pause, resume, reset)
- Structured logging
- Metrics collection
- State management
- Status reporting

## Important Disclaimers

⚠️ **NO REAL GAMBLING**
- All bots are templates and simulations only
- No real money is involved
- No connections to real casinos
- For educational and testing purposes only

⚠️ **NOT FINANCIAL ADVICE**
- Betting strategies are for demonstration only
- Do not use for real gambling decisions
- House always has edge in roulette

## Extension Points

Each bot includes TODO comments for:
- Real API integration
- Advanced risk management
- Production-ready features
- Security enhancements
- Performance optimizations

## Testing

Unit tests for all bots are in `/test/bots/`:
```bash
flutter test test/bots/
```

## Integration Examples

See `/lib/examples/complete_workflow_example.dart` for examples of integrating multiple bots and agents together.

## Architecture

```
BaseBot (interface)
    ↓
AbstractBot (common implementation)
    ↓
[Specific Bots] (domain logic)
```

## Best Practices

1. Always use mock/simulation mode
2. Never connect to real gambling services
3. Handle errors gracefully
4. Monitor bot performance with metrics
5. Test thoroughly before deployment
6. Keep clear separation between simulation and production code
7. Use dependency injection for testability

## Security Considerations

- Never store real API keys in code
- Use environment variables for sensitive data
- Implement rate limiting
- Add request validation
- Use secure random number generation
- Log security events
