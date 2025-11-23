# Core Library

This directory contains the foundational infrastructure for all agents and bots in the Tokyo Roulette Predictor system.

## Components

### logger.dart
**Purpose**: Centralized logging system with structured output and configurable log levels.

**Features**:
- Multiple log levels (debug, info, warning, error)
- Timestamps on all messages
- Structured format: `[timestamp] [level] [name] message`
- Custom log handlers support
- Error and stack trace logging

**Usage**:
```dart
final logger = Logger('MyComponent', minLevel: LogLevel.info);

logger.debug('Debug message');  // Won't show if minLevel is info
logger.info('Info message');
logger.warning('Warning message');
logger.error('Error occurred', exception, stackTrace);
```

**Custom Handler**:
```dart
final logger = Logger(
  'MyComponent',
  customHandler: (message) {
    // Send to external logging service
    externalLogger.log(message);
  },
);
```

### monitoring.dart
**Purpose**: Metrics collection and observability for performance tracking.

**Features**:
- Three metric types: counter, gauge, histogram
- Automatic timestamping
- Tag support for metric categorization
- Metric aggregation and summaries
- Callback hooks for metric events

**Usage**:
```dart
final monitor = Monitor('MyComponent');

// Record metrics
monitor.recordCounter('requests', 1);
monitor.recordGauge('temperature', 72.5);
monitor.recordHistogram('response_time', 150.0, tags: {'endpoint': '/api'});

// Get metrics
final allMetrics = monitor.metrics;
final summary = monitor.getSummary();

// Clear metrics
monitor.clear();
```

**Metric Types**:
- **Counter**: Cumulative values that only increase (e.g., request count)
- **Gauge**: Point-in-time values that can go up or down (e.g., memory usage)
- **Histogram**: Distribution of values over time (e.g., response times)

### base_agent.dart
**Purpose**: Base interface and abstract implementation for all agents.

**Features**:
- Standardized lifecycle management
- State machine (idle, running, paused, stopped, error)
- Integrated logging and monitoring
- Configuration management
- Status reporting

**Lifecycle**:
```
Initialize → Idle → Start → Running → Stop → Stopped
                      ↓           ↓
                    Pause → Paused
                              ↓
                           Resume
```

**Usage**:
```dart
class MyAgent extends AbstractAgent {
  MyAgent() : super(id: 'my-agent', name: 'MyAgent');
  
  @override
  Future<void> start() async {
    await super.start();
    // Custom start logic
  }
}

// Using the agent
final agent = MyAgent();
await agent.initialize(config);
await agent.start();
// ... do work
await agent.stop();
```

### base_bot.dart
**Purpose**: Base interface and abstract implementation for all bots.

**Features**:
- Similar to base_agent but designed for task-oriented execution
- Execute method instead of continuous running
- State machine (idle, active, paused, stopped, error)
- Integrated logging and monitoring

**Usage**:
```dart
class MyBot extends AbstractBot {
  MyBot() : super(id: 'my-bot', name: 'MyBot');
  
  @override
  Future<void> execute() async {
    await super.execute();
    // Task execution logic
  }
}

// Using the bot
final bot = MyBot();
await bot.initialize(config);
await bot.execute();
```

## Design Patterns

### Dependency Injection
All components support configuration through initialization:
```dart
await component.initialize({
  'param1': 'value1',
  'param2': 42,
});
```

### Template Method Pattern
Base classes provide structure, concrete implementations fill in specifics:
```dart
abstract class AbstractAgent {
  Future<void> start() async {
    // Common pre-start logic
    logger.info('Starting...');
    state = AgentState.running;
    // Subclass can override and call super
  }
}
```

### Observer Pattern
Monitoring supports callbacks for real-time observation:
```dart
final monitor = Monitor(
  'Component',
  onMetricCollected: (metric) {
    print('New metric: ${metric.name} = ${metric.value}');
  },
);
```

## Extension Points

All core components are designed for extension:

1. **Custom Agents**: Extend `AbstractAgent`
2. **Custom Bots**: Extend `AbstractBot`
3. **Custom Loggers**: Provide custom handlers
4. **Custom Metrics**: Add new metric types

## Best Practices

### Logging
1. Use appropriate log levels
2. Include context in messages
3. Log state transitions
4. Log errors with stack traces

### Monitoring
1. Record metrics at key points
2. Use tags for categorization
3. Clear metrics periodically
4. Monitor performance impact

### Lifecycle Management
1. Always initialize before use
2. Check state before operations
3. Clean up resources on stop
4. Handle state errors gracefully

### Configuration
1. Validate config in initialize()
2. Provide sensible defaults
3. Document required vs optional params
4. Type-check configuration values

## Error Handling

```dart
try {
  await agent.start();
} on StateError catch (e) {
  logger.error('Invalid state', e);
  // Handle state error
} catch (e, stack) {
  logger.error('Unexpected error', e, stack);
  agent.state = AgentState.error;
}
```

## Testing

Core components have no dependencies on Flutter and can be tested with pure Dart:

```dart
test('agent starts correctly', () async {
  final agent = MyAgent();
  await agent.initialize(null);
  await agent.start();
  expect(agent.state, AgentState.running);
});
```

## Architecture

```
┌─────────────────────────────────────┐
│         Core Infrastructure         │
├─────────────────────────────────────┤
│  Logger  │  Monitor  │  Base Classes│
└─────────────────────────────────────┘
              ↑
              │ Uses
              │
┌─────────────────────────────────────┐
│      Agents & Bots Layer            │
├─────────────────────────────────────┤
│  Predictor │ Analyzer │ Betting Bot │
└─────────────────────────────────────┘
```

## Thread Safety

⚠️ **Note**: Current implementation is not thread-safe. If using in multi-threaded contexts:
- Synchronize access to shared state
- Use locks for critical sections
- Consider using isolates for true parallelism

## Performance Considerations

- Logger: Minimal overhead, but custom handlers may add latency
- Monitor: In-memory storage, clear periodically to avoid memory growth
- Base classes: Lightweight, negligible overhead

## Future Enhancements

TODO items marked in code:
- [ ] Add distributed tracing support
- [ ] Implement log rotation
- [ ] Add metric persistence
- [ ] Support for async callbacks
- [ ] Health check endpoints
- [ ] Circuit breaker pattern

---

The core library provides the foundation for building robust, observable, and maintainable agents and bots.
