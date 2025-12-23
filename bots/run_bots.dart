#!/usr/bin/env dart

import 'dart:io';
import 'core/bot_base.dart';
import 'core/bot_scheduler.dart';
import 'specialized/atlas_build_bot.dart';
import 'specialized/oracle_test_bot.dart';
import 'specialized/sentinel_security_bot.dart';
import 'specialized/scout_dependency_bot.dart';
import 'specialized/zen_code_quality_bot.dart';
import 'specialized/phoenix_deploy_bot.dart';
import 'specialized/mercury_docs_bot.dart';
import 'specialized/guardian_monitor_bot.dart';

/// Script principal para ejecutar el sistema de bots
void main(List<String> args) async {
  print('🤖 Tokyo Roulette - Bot Automation System');
  print('═' * 60);
  print('');

  // Parsear argumentos
  final trigger = _parseTrigger(args);
  final parallel = args.contains('--parallel');
  final botFilter = _getBotFilter(args);

  // Crear registro de bots
  final registry = _createRegistry();

  // Crear bots
  var bots = <AutomationBot>[
    AtlasBuildBot(),
    OracleTestBot(),
    SentinelSecurityBot(),
    ScoutDependencyBot(),
    ZenCodeQualityBot(),
    PhoenixDeployBot(),
    MercuryDocsBot(),
    GuardianMonitorBot(),
  ];

  // Filtrar bots si se especificó
  if (botFilter != null) {
    bots = bots.where((bot) => 
      bot.name.toLowerCase().contains(botFilter.toLowerCase())
    ).toList();
    
    if (bots.isEmpty) {
      print('❌ No bots found matching: $botFilter');
      exit(1);
    }
  }

  // Crear scheduler
  final scheduler = BotScheduler(bots, registry);

  print('📋 Configuration:');
  print('   Trigger: ${trigger.name}');
  print('   Execution: ${parallel ? "Parallel" : "Sequential"}');
  print('   Bots: ${bots.length}');
  if (botFilter != null) {
    print('   Filter: $botFilter');
  }
  print('');

  try {
    final result = parallel
        ? await scheduler.executeWorkflowParallel(trigger)
        : await scheduler.executeWorkflow(trigger);

    // Determinar código de salida
    final exitCode = result.allSuccess ? 0 : 1;

    if (exitCode == 0) {
      print('✅ All bots completed successfully!');
    } else {
      print('❌ Some bots failed.');
    }

    exit(exitCode);
  } catch (e, st) {
    print('❌ Fatal error running bots:');
    print(e);
    print(st);
    exit(2);
  }
}

WorkflowTrigger _parseTrigger(List<String> args) {
  if (args.contains('--push')) {
    return WorkflowTrigger.push();
  } else if (args.contains('--pr')) {
    return WorkflowTrigger.pullRequest();
  } else if (args.contains('--release')) {
    return WorkflowTrigger.release();
  } else if (args.contains('--schedule')) {
    return WorkflowTrigger.schedule('0 0 * * *');
  } else {
    // Por defecto, usar push
    return WorkflowTrigger.push();
  }
}

String? _getBotFilter(List<String> args) {
  final filterIndex = args.indexOf('--bot');
  if (filterIndex != -1 && filterIndex + 1 < args.length) {
    return args[filterIndex + 1];
  }
  return null;
}

BotRegistry _createRegistry() {
  final registry = BotRegistry();

  // Registrar Atlas
  registry.register('atlas', BotConfig(
    name: 'Atlas Build Bot',
    emoji: '🏗️',
    role: 'Build System Manager',
    triggers: ['on_push', 'on_pr'],
    capabilities: ['flutter_build', 'android_build', 'web_build', 'artifact_generation'],
    priority: BotPriority.high,
    enabled: true,
  ));

  // Registrar Oracle
  registry.register('oracle', BotConfig(
    name: 'Oracle Test Bot',
    emoji: '🔮',
    role: 'Testing Oracle',
    triggers: ['on_push', 'on_pr', 'schedule'],
    capabilities: ['unit_tests', 'widget_tests', 'integration_tests', 'coverage_reports'],
    priority: BotPriority.critical,
    enabled: true,
  ));

  // Registrar Sentinel
  registry.register('sentinel', BotConfig(
    name: 'Sentinel Security Bot',
    emoji: '🛡️',
    role: 'Security Guardian',
    triggers: ['on_push', 'on_pr', 'schedule'],
    capabilities: ['dependency_scan', 'code_analysis', 'secret_detection', 'vulnerability_check'],
    priority: BotPriority.critical,
    enabled: true,
  ));

  // Registrar Scout
  registry.register('scout', BotConfig(
    name: 'Scout Dependency Bot',
    emoji: '🔍',
    role: 'Dependency Scout',
    triggers: ['schedule'],
    capabilities: ['dependency_updates', 'compatibility_check', 'license_audit'],
    priority: BotPriority.medium,
    enabled: true,
  ));

  // Registrar Zen
  registry.register('zen', BotConfig(
    name: 'Zen Code Quality Bot',
    emoji: '☯️',
    role: 'Code Quality Master',
    triggers: ['on_push', 'on_pr'],
    capabilities: ['linting', 'formatting', 'complexity_analysis', 'code_smells_detection'],
    priority: BotPriority.high,
    enabled: true,
  ));

  // Registrar Phoenix
  registry.register('phoenix', BotConfig(
    name: 'Phoenix Deploy Bot',
    emoji: '🔥',
    role: 'Deployment Orchestrator',
    triggers: ['on_release'],
    capabilities: ['staging_deploy', 'production_deploy', 'rollback', 'health_checks'],
    priority: BotPriority.critical,
    enabled: true,
  ));

  // Registrar Mercury
  registry.register('mercury', BotConfig(
    name: 'Mercury Docs Bot',
    emoji: '📚',
    role: 'Documentation Curator',
    triggers: ['on_push', 'on_pr', 'schedule'],
    capabilities: ['doc_generation', 'api_docs', 'changelog_update', 'readme_sync'],
    priority: BotPriority.medium,
    enabled: true,
  ));

  // Registrar Guardian
  registry.register('guardian', BotConfig(
    name: 'Guardian Monitor Bot',
    emoji: '👁️',
    role: 'System Monitor',
    triggers: ['schedule'],
    capabilities: ['health_monitoring', 'performance_tracking', 'error_reporting', 'alerting'],
    priority: BotPriority.high,
    enabled: true,
  ));

  return registry;
}
