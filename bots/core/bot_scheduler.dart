import 'dart:async';
import 'dart:io';
import 'bot_base.dart';

/// Configuración de un bot desde el registro
class BotConfig {
  final String name;
  final String emoji;
  final String role;
  final List<String> triggers;
  final List<String> capabilities;
  final BotPriority priority;
  final bool enabled;

  BotConfig({
    required this.name,
    required this.emoji,
    required this.role,
    required this.triggers,
    required this.capabilities,
    required this.priority,
    required this.enabled,
  });
}

/// Registro de bots del sistema
class BotRegistry {
  final Map<String, BotConfig> _configs = {};

  void register(String botId, BotConfig config) {
    _configs[botId] = config;
  }

  BotConfig? getConfig(String botName) {
    return _configs.entries
        .where((entry) => entry.value.name == botName)
        .map((entry) => entry.value)
        .firstOrNull;
  }

  List<BotConfig> getEnabledBots() {
    return _configs.values.where((config) => config.enabled).toList();
  }

  List<BotConfig> getBotsForTrigger(String trigger) {
    return _configs.values
        .where((config) => config.enabled && config.triggers.contains(trigger))
        .toList();
  }
}

/// Resultado del workflow
class WorkflowResult {
  final String workflowName;
  final DateTime startTime;
  final DateTime endTime;
  final List<BotExecutionRecord> executions;

  WorkflowResult({
    required this.workflowName,
    required this.startTime,
    required this.endTime,
    required this.executions,
  });

  Duration get duration => endTime.difference(startTime);

  int get totalBots => executions.length;
  int get successfulBots => executions.where((e) => e.result.success).length;
  int get failedBots => executions.where((e) => !e.result.success).length;

  bool get allSuccess => failedBots == 0;
  bool get anyFailure => failedBots > 0;
}

/// Registro de ejecución de un bot
class BotExecutionRecord {
  final String botName;
  final DateTime startTime;
  final DateTime endTime;
  final BotResult result;

  BotExecutionRecord({
    required this.botName,
    required this.startTime,
    required this.endTime,
    required this.result,
  });

  Duration get duration => endTime.difference(startTime);
}

/// Orquestador de bots
class BotScheduler {
  final List<AutomationBot> bots;
  final BotRegistry registry;

  BotScheduler(this.bots, this.registry);

  /// Ejecuta un workflow completo
  Future<WorkflowResult> executeWorkflow(WorkflowTrigger trigger) async {
    final startTime = DateTime.now();
    final executions = <BotExecutionRecord>[];

    print('\n${'=' * 60}');
    print('🤖 Bot Workflow Started: ${trigger.name}');
    print('${'=' * 60}\n');

    // Filtrar bots aplicables
    final applicableBots = _getApplicableBots(trigger.type);

    if (applicableBots.isEmpty) {
      print('ℹ️  No bots configured for trigger: ${trigger.type}\n');
      return WorkflowResult(
        workflowName: trigger.name,
        startTime: startTime,
        endTime: DateTime.now(),
        executions: [],
      );
    }

    print('📋 Bots to execute: ${applicableBots.length}');
    for (final bot in applicableBots) {
      print('   ${bot.emoji} ${bot.name} [${bot.priority.name}]');
    }
    print('');

    // Ejecutar bots en secuencia (críticos primero)
    for (final bot in applicableBots) {
      final botStartTime = DateTime.now();

      // Verificar si el bot puede ejecutarse
      if (!await bot.canExecute(trigger.context)) {
        print('⏭️  Skipping ${bot.name} (cannot execute in this context)\n');
        continue;
      }

      print('${'─' * 60}');
      print('▶️  Executing: ${bot.emoji} ${bot.name}');
      print('${'─' * 60}');

      final result = await bot.run(trigger.context);
      final botEndTime = DateTime.now();

      executions.add(BotExecutionRecord(
        botName: bot.name,
        startTime: botStartTime,
        endTime: botEndTime,
        result: result,
      ));

      if (!result.success) {
        // Si es crítico y falla, detener workflow
        if (bot.priority == BotPriority.critical) {
          print('\n❌ Critical bot failed. Stopping workflow.\n');
          break;
        } else {
          print('⚠️  Bot failed but continuing workflow (non-critical)\n');
        }
      } else {
        print('');
      }
    }

    final endTime = DateTime.now();
    final workflowResult = WorkflowResult(
      workflowName: trigger.name,
      startTime: startTime,
      endTime: endTime,
      executions: executions,
    );

    _printWorkflowSummary(workflowResult);

    return workflowResult;
  }

  /// Ejecuta bots en paralelo (solo bots no críticos)
  Future<WorkflowResult> executeWorkflowParallel(WorkflowTrigger trigger) async {
    final startTime = DateTime.now();
    final executions = <BotExecutionRecord>[];

    print('\n${'=' * 60}');
    print('🤖 Bot Workflow Started (Parallel): ${trigger.name}');
    print('${'=' * 60}\n');

    final applicableBots = _getApplicableBots(trigger.type);

    if (applicableBots.isEmpty) {
      print('ℹ️  No bots configured for trigger: ${trigger.type}\n');
      return WorkflowResult(
        workflowName: trigger.name,
        startTime: startTime,
        endTime: DateTime.now(),
        executions: [],
      );
    }

    // Separar críticos de no críticos
    final criticalBots = applicableBots
        .where((bot) => bot.priority == BotPriority.critical)
        .toList();
    final nonCriticalBots = applicableBots
        .where((bot) => bot.priority != BotPriority.critical)
        .toList();

    // Ejecutar críticos en secuencia
    for (final bot in criticalBots) {
      final botStartTime = DateTime.now();
      final result = await bot.run(trigger.context);
      final botEndTime = DateTime.now();

      executions.add(BotExecutionRecord(
        botName: bot.name,
        startTime: botStartTime,
        endTime: botEndTime,
        result: result,
      ));

      if (!result.success) {
        print('\n❌ Critical bot failed. Stopping workflow.\n');
        return WorkflowResult(
          workflowName: trigger.name,
          startTime: startTime,
          endTime: DateTime.now(),
          executions: executions,
        );
      }
    }

    // Ejecutar no críticos en paralelo
    if (nonCriticalBots.isNotEmpty) {
      final results = await Future.wait(
        nonCriticalBots.map((bot) async {
          final botStartTime = DateTime.now();
          final result = await bot.run(trigger.context);
          final botEndTime = DateTime.now();

          return BotExecutionRecord(
            botName: bot.name,
            startTime: botStartTime,
            endTime: botEndTime,
            result: result,
          );
        }),
      );

      executions.addAll(results);
    }

    final endTime = DateTime.now();
    final workflowResult = WorkflowResult(
      workflowName: trigger.name,
      startTime: startTime,
      endTime: endTime,
      executions: executions,
    );

    _printWorkflowSummary(workflowResult);

    return workflowResult;
  }

  List<AutomationBot> _getApplicableBots(String triggerType) {
    final applicableBots = bots.where((bot) {
      final config = registry.getConfig(bot.name);
      if (config == null) return false;
      return config.enabled && config.triggers.contains(triggerType);
    }).toList();

    // Ordenar por prioridad (críticos primero)
    applicableBots.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return applicableBots;
  }

  void _printWorkflowSummary(WorkflowResult result) {
    print('${'=' * 60}');
    print('📊 Workflow Summary');
    print('${'=' * 60}');
    print('Total Bots: ${result.totalBots}');
    print('✅ Successful: ${result.successfulBots}');
    print('❌ Failed: ${result.failedBots}');
    print('⏱️  Duration: ${result.duration.inSeconds}s');
    print('${'=' * 60}');

    if (result.allSuccess) {
      print('🎉 Workflow completed successfully!\n');
    } else {
      print('⚠️  Workflow completed with failures.\n');
      
      // Listar bots fallidos
      for (final execution in result.executions.where((e) => !e.result.success)) {
        print('❌ ${execution.botName}: ${execution.result.message}');
      }
      print('');
    }
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}
