/// Base bot interface and abstract class
/// All bots should extend this to ensure consistent structure and capabilities

import 'logger.dart';
import 'monitoring.dart';

/// Bot state enumeration
enum BotState {
  idle,
  active,
  paused,
  stopped,
  error,
}

/// Base bot interface defining core capabilities
abstract class BaseBot {
  /// Unique identifier for the bot
  String get id;

  /// Human-readable name for the bot
  String get name;

  /// Current state of the bot
  BotState get state;

  /// Logger instance for this bot
  Logger get logger;

  /// Monitor instance for this bot
  Monitor get monitor;

  /// Initialize the bot with configuration
  Future<void> initialize(Map<String, dynamic>? config);

  /// Execute bot action/task
  Future<void> execute();

  /// Stop the bot execution
  Future<void> stop();

  /// Pause the bot execution
  Future<void> pause();

  /// Resume the bot from paused state
  Future<void> resume();

  /// Reset bot to initial state
  Future<void> reset();

  /// Get bot status and metrics
  Map<String, dynamic> getStatus();
}

/// Abstract implementation of BaseBot with common functionality
abstract class AbstractBot implements BaseBot {
  @override
  final String id;

  @override
  final String name;

  @override
  BotState state = BotState.idle;

  @override
  late final Logger logger;

  @override
  late final Monitor monitor;

  Map<String, dynamic>? _config;

  AbstractBot({
    required this.id,
    required this.name,
    LogLevel logLevel = LogLevel.info,
  }) {
    logger = Logger('Bot:$name', minLevel: logLevel);
    monitor = Monitor('Bot:$name');
  }

  @override
  Future<void> initialize(Map<String, dynamic>? config) async {
    logger.info('Initializing bot: $name');
    _config = config;
    state = BotState.idle;
    monitor.recordCounter('initialize_count', 1);
  }

  @override
  Future<void> execute() async {
    if (state == BotState.active) {
      logger.warning('Bot already executing');
      return;
    }
    logger.info('Executing bot: $name');
    state = BotState.active;
    monitor.recordCounter('execute_count', 1);
  }

  @override
  Future<void> stop() async {
    logger.info('Stopping bot: $name');
    state = BotState.stopped;
    monitor.recordCounter('stop_count', 1);
  }

  @override
  Future<void> pause() async {
    if (state != BotState.active) {
      logger.warning('Cannot pause bot that is not active');
      return;
    }
    logger.info('Pausing bot: $name');
    state = BotState.paused;
    monitor.recordCounter('pause_count', 1);
  }

  @override
  Future<void> resume() async {
    if (state != BotState.paused) {
      logger.warning('Cannot resume bot that is not paused');
      return;
    }
    logger.info('Resuming bot: $name');
    state = BotState.active;
    monitor.recordCounter('resume_count', 1);
  }

  @override
  Future<void> reset() async {
    logger.info('Resetting bot: $name');
    state = BotState.idle;
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
