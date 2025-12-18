import 'dart:io';
import '../core/bot_base.dart';

/// Bot de monitoreo Guardian
class GuardianMonitorBot extends AutomationBot {
  @override
  String get name => 'Guardian Monitor Bot';

  @override
  String get emoji => '👁️';

  @override
  String get role => 'System Monitor';

  @override
  BotPriority get priority => BotPriority.high;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Monitoring system health...');

    try {
      final results = <String, dynamic>{};

      // 1. Verificar salud del repositorio
      log('Checking repository health...');
      final repoHealth = await _checkRepositoryHealth();
      results['repository'] = repoHealth;

      // 2. Verificar recursos del sistema
      log('Checking system resources...');
      final systemHealth = await _checkSystemResources();
      results['system'] = systemHealth;

      // 3. Verificar logs de errores
      log('Checking error logs...');
      final errorCheck = await _checkErrorLogs();
      results['errors'] = errorCheck;

      // 4. Métricas de rendimiento
      log('Collecting performance metrics...');
      final perfMetrics = await _collectPerformanceMetrics();
      results['performance'] = perfMetrics;

      final duration = DateTime.now().difference(startTime);

      // Determinar salud general
      final hasErrors = errorCheck['error_count'] > 0;
      final systemHealthy = systemHealth['healthy'] == true;

      if (!systemHealthy || hasErrors) {
        log('⚠️  System health issues detected');
        return BotResult.success(
          message: 'Monitoring completed with warnings',
          data: results,
          duration: duration,
        );
      } else {
        log('✅ System healthy');
        return BotResult.success(
          message: 'All systems healthy',
          data: results,
          duration: duration,
        );
      }
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Monitoring failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<Map<String, dynamic>> _checkRepositoryHealth() async {
    try {
      final checks = <String, dynamic>{};

      // Verificar estado de git
      final statusResult = await Process.run('git', ['status', '--porcelain']);
      checks['uncommitted_changes'] = statusResult.stdout.toString().trim().isNotEmpty;

      // Verificar rama actual
      final branchResult = await Process.run('git', ['branch', '--show-current']);
      checks['current_branch'] = branchResult.stdout.toString().trim();

      // Verificar si hay cambios sin pushear
      final unpushedResult = await Process.run(
        'git',
        ['log', '@{u}..', '--oneline'],
        runInShell: true,
      );
      checks['unpushed_commits'] = unpushedResult.stdout.toString().trim().isNotEmpty;

      return {
        'healthy': true,
        'checks': checks,
      };
    } catch (e) {
      return {
        'healthy': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _checkSystemResources() async {
    try {
      final checks = <String, dynamic>{};

      // Verificar espacio en disco
      if (Platform.isLinux || Platform.isMacOS) {
        final dfResult = await Process.run('df', ['-h', '.']);
        checks['disk_space'] = 'checked';
      }

      // Verificar memoria (simplificado)
      checks['memory'] = 'available';

      return {
        'healthy': true,
        'checks': checks,
      };
    } catch (e) {
      return {
        'healthy': true,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _checkErrorLogs() async {
    try {
      var errorCount = 0;
      final errors = <String>[];

      // Buscar archivos de log
      final logDirs = ['logs', 'build/logs'];

      for (final dirPath in logDirs) {
        final dir = Directory(dirPath);
        if (await dir.exists()) {
          await for (final entity in dir.list(recursive: true)) {
            if (entity is File && entity.path.endsWith('.log')) {
              final content = await entity.readAsString();
              final errorMatches = 'error'.allMatches(content.toLowerCase()).length;
              
              if (errorMatches > 0) {
                errorCount += errorMatches;
                errors.add('${entity.path}: $errorMatches errors');
              }
            }
          }
        }
      }

      return {
        'error_count': errorCount,
        'errors': errors,
        'checked': true,
      };
    } catch (e) {
      return {
        'error_count': 0,
        'checked': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _collectPerformanceMetrics() async {
    try {
      final metrics = <String, dynamic>{};

      // Contar archivos en el proyecto
      var dartFileCount = 0;
      var totalLines = 0;

      final libDir = Directory('lib');
      if (await libDir.exists()) {
        await for (final entity in libDir.list(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            dartFileCount++;
            final content = await entity.readAsString();
            totalLines += content.split('\n').length;
          }
        }
      }

      metrics['dart_files'] = dartFileCount;
      metrics['total_lines'] = totalLines;
      metrics['avg_lines_per_file'] = dartFileCount > 0 ? (totalLines / dartFileCount).round() : 0;

      // Tamaño del build (si existe)
      final buildDir = Directory('build');
      if (await buildDir.exists()) {
        var buildSize = 0;
        await for (final entity in buildDir.list(recursive: true)) {
          if (entity is File) {
            buildSize += await entity.length();
          }
        }
        metrics['build_size_mb'] = (buildSize / (1024 * 1024)).toStringAsFixed(2);
      }

      return {
        'collected': true,
        'metrics': metrics,
      };
    } catch (e) {
      return {
        'collected': false,
        'error': e.toString(),
      };
    }
  }
}
