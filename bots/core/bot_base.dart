import 'dart:async';

/// Prioridad del bot
enum BotPriority {
  low,
  medium,
  high,
  critical,
}

/// Estado del bot
enum BotStatus {
  idle,
  running,
  success,
  failure,
  timeout,
}

/// Contexto de ejecución del bot
class BotContext {
  final String trigger;
  final Map<String, dynamic> config;
  final DateTime startTime;
  final Map<String, dynamic> metadata;

  BotContext({
    required this.trigger,
    required this.config,
    Map<String, dynamic>? metadata,
  })  : startTime = DateTime.now(),
        metadata = metadata ?? {};

  Duration get elapsed => DateTime.now().difference(startTime);

  T? getConfig<T>(String key, {T? defaultValue}) {
    return config[key] as T? ?? defaultValue;
  }
}

/// Resultado de la ejecución del bot
class BotResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final String? error;
  final StackTrace? stackTrace;
  final Duration duration;

  BotResult({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.stackTrace,
    required this.duration,
  });

  factory BotResult.success({
    String message = 'Operation completed successfully',
    Map<String, dynamic>? data,
    required Duration duration,
  }) {
    return BotResult(
      success: true,
      message: message,
      data: data,
      duration: duration,
    );
  }

  factory BotResult.failure({
    String message = 'Operation failed',
    Map<String, dynamic>? data,
    String? error,
    StackTrace? stackTrace,
    required Duration duration,
  }) {
    return BotResult(
      success: false,
      message: message,
      data: data,
      error: error,
      stackTrace: stackTrace,
      duration: duration,
    );
  }

  bool get isSuccess => success;
  bool get isFailure => !success;
}

/// Clase base para todos los bots
abstract class AutomationBot {
  /// Nombre del bot
  String get name;

  /// Emoji identificador
  String get emoji;

  /// Rol del bot
  String get role;

  /// Prioridad de ejecución
  BotPriority get priority;

  /// Estado actual del bot
  BotStatus status = BotStatus.idle;

  /// Timeout del bot (opcional)
  Duration get timeout => const Duration(minutes: 30);

  /// Ejecuta el bot
  Future<BotResult> execute(BotContext context);

  /// Determina si el bot puede ejecutarse en el contexto dado
  Future<bool> canExecute(BotContext context) async => true;

  /// Hook ejecutado al completarse exitosamente
  Future<void> onSuccess(BotResult result) async {
    log('✅ Completed successfully in ${result.duration.inSeconds}s');
  }

  /// Hook ejecutado al fallar
  Future<void> onFailure(BotResult result) async {
    log('❌ Failed: ${result.message}');
    if (result.error != null) {
      log('   Error: ${result.error}');
    }
  }

  /// Registra un mensaje
  void log(String message) {
    print('$emoji $name: $message');
  }

  /// Ejecuta el bot con manejo de errores y timeout
  Future<BotResult> run(BotContext context) async {
    final startTime = DateTime.now();
    status = BotStatus.running;

    log('Starting execution...');

    try {
      final result = await execute(context).timeout(
        timeout,
        onTimeout: () {
          status = BotStatus.timeout;
          return BotResult.failure(
            message: 'Bot execution timed out after ${timeout.inMinutes} minutes',
            duration: DateTime.now().difference(startTime),
          );
        },
      );

      status = result.success ? BotStatus.success : BotStatus.failure;

      if (result.success) {
        await onSuccess(result);
      } else {
        await onFailure(result);
      }

      return result;
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      status = BotStatus.failure;

      final result = BotResult.failure(
        message: 'Bot execution failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );

      await onFailure(result);
      return result;
    }
  }
}

/// Trigger de workflow
class WorkflowTrigger {
  final String name;
  final String type;
  final BotContext context;

  WorkflowTrigger({
    required this.name,
    required this.type,
    required this.context,
  });

  factory WorkflowTrigger.push({Map<String, dynamic>? metadata}) {
    return WorkflowTrigger(
      name: 'Push Event',
      type: 'on_push',
      context: BotContext(
        trigger: 'on_push',
        config: {},
        metadata: metadata,
      ),
    );
  }

  factory WorkflowTrigger.pullRequest({Map<String, dynamic>? metadata}) {
    return WorkflowTrigger(
      name: 'Pull Request Event',
      type: 'on_pr',
      context: BotContext(
        trigger: 'on_pr',
        config: {},
        metadata: metadata,
      ),
    );
  }

  factory WorkflowTrigger.schedule(String cron, {Map<String, dynamic>? metadata}) {
    return WorkflowTrigger(
      name: 'Scheduled Event',
      type: 'schedule',
      context: BotContext(
        trigger: 'schedule',
        config: {'cron': cron},
        metadata: metadata,
      ),
    );
  }

  factory WorkflowTrigger.release({Map<String, dynamic>? metadata}) {
    return WorkflowTrigger(
      name: 'Release Event',
      type: 'on_release',
      context: BotContext(
        trigger: 'on_release',
        config: {},
        metadata: metadata,
      ),
    );
  }
}
