/// Core logging utilities for agents and bots
/// Provides centralized logging with different levels and structured output

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Logger interface for structured logging across all agents and bots
class Logger {
  final String name;
  final LogLevel minLevel;
  final void Function(String message)? customHandler;

  Logger(
    this.name, {
    this.minLevel = LogLevel.info,
    this.customHandler,
  });

  void debug(String message) => _log(LogLevel.debug, message);
  void info(String message) => _log(LogLevel.info, message);
  void warning(String message) => _log(LogLevel.warning, message);
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message);
    if (error != null) {
      _log(LogLevel.error, 'Error details: $error');
    }
    if (stackTrace != null) {
      _log(LogLevel.error, 'Stack trace: $stackTrace');
    }
  }

  void _log(LogLevel level, String message) {
    if (level.index < minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final logMessage = '[$timestamp] [$levelStr] [$name] $message';

    if (customHandler != null) {
      customHandler!(logMessage);
    } else {
      print(logMessage);
    }
  }
}
