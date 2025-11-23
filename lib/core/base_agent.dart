/// Base agent interface and abstract class
/// All agents should extend this to ensure consistent structure and capabilities

import 'logger.dart';
import 'monitoring.dart';

/// Agent state enumeration
enum AgentState {
  idle,
  running,
  paused,
  stopped,
  error,
}

/// Base agent interface defining core capabilities
abstract class BaseAgent {
  /// Unique identifier for the agent
  String get id;

  /// Human-readable name for the agent
  String get name;

  /// Current state of the agent
  AgentState get state;

  /// Logger instance for this agent
  Logger get logger;

  /// Monitor instance for this agent
  Monitor get monitor;

  /// Initialize the agent with configuration
  Future<void> initialize(Map<String, dynamic>? config);

  /// Start the agent execution
  Future<void> start();

  /// Stop the agent execution
  Future<void> stop();

  /// Pause the agent execution
  Future<void> pause();

  /// Resume the agent from paused state
  Future<void> resume();

  /// Reset agent to initial state
  Future<void> reset();

  /// Get agent status and metrics
  Map<String, dynamic> getStatus();
}

/// Abstract implementation of BaseAgent with common functionality
abstract class AbstractAgent implements BaseAgent {
  @override
  final String id;

  @override
  final String name;

  @override
  AgentState state = AgentState.idle;

  @override
  late final Logger logger;

  @override
  late final Monitor monitor;

  Map<String, dynamic>? _config;

  AbstractAgent({
    required this.id,
    required this.name,
    LogLevel logLevel = LogLevel.info,
  }) {
    logger = Logger('Agent:$name', minLevel: logLevel);
    monitor = Monitor('Agent:$name');
  }

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    logger.info('Initializing agent: $name');
    _config = config;
    state = AgentState.idle;
    monitor.recordCounter('initialize_count', 1);
  }

  @override
  Future<void> start() async {
    if (state == AgentState.running) {
      logger.warning('Agent already running');
      return;
    }
    logger.info('Starting agent: $name');
    state = AgentState.running;
    monitor.recordCounter('start_count', 1);
  }

  @override
  Future<void> stop() async {
    logger.info('Stopping agent: $name');
    state = AgentState.stopped;
    monitor.recordCounter('stop_count', 1);
  }

  @override
  Future<void> pause() async {
    if (state != AgentState.running) {
      logger.warning('Cannot pause agent that is not running');
      return;
    }
    logger.info('Pausing agent: $name');
    state = AgentState.paused;
    monitor.recordCounter('pause_count', 1);
  }

  @override
  Future<void> resume() async {
    if (state != AgentState.paused) {
      logger.warning('Cannot resume agent that is not paused');
      return;
    }
    logger.info('Resuming agent: $name');
    state = AgentState.running;
    monitor.recordCounter('resume_count', 1);
  }

  @override
  Future<void> reset() async {
    logger.info('Resetting agent: $name');
    state = AgentState.idle;
    monitor.clear();
    monitor.recordCounter('reset_count', 1);
  }

  @override
  Map<String, dynamic> getStatus() {
    return {
      'id': id,
      'name': name,
      'state': state.toString(),
      'config': _config,
      'metrics_summary': monitor.getSummary(),
    };
  }

  /// Get current configuration
  Map<String, dynamic>? get config => _config;
}
