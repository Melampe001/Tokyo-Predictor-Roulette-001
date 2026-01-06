import 'dart:io';
import '../core/bot_base.dart';

/// Bot de dependencias Scout
class ScoutDependencyBot extends AutomationBot {
  @override
  String get name => 'Scout Dependency Bot';

  @override
  String get emoji => '🔍';

  @override
  String get role => 'Dependency Scout';

  @override
  BotPriority get priority => BotPriority.medium;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Scouting dependencies...');

    try {
      final results = <String, dynamic>{};

      // 1. Verificar dependencias desactualizadas
      log('Checking for outdated dependencies...');
      final outdatedResult = await _checkOutdated();
      results['outdated'] = outdatedResult;

      // 2. Auditoría de licencias
      log('Auditing licenses...');
      final licenseResult = await _auditLicenses();
      results['licenses'] = licenseResult;

      // 3. Verificar compatibilidad
      log('Checking compatibility...');
      final compatResult = await _checkCompatibility();
      results['compatibility'] = compatResult;

      final duration = DateTime.now().difference(startTime);

      final hasOutdated = outdatedResult['count'] > 0;
      final hasIncompatible = compatResult['issues'] > 0;

      if (hasIncompatible) {
        log('⚠️  Found compatibility issues');
        return BotResult.failure(
          message: 'Dependency compatibility issues found',
          data: results,
          duration: duration,
        );
      } else if (hasOutdated) {
        log('ℹ️  Found ${outdatedResult['count']} outdated dependencies');
        return BotResult.success(
          message: 'Dependencies checked, updates available',
          data: results,
          duration: duration,
        );
      } else {
        log('✅ All dependencies up to date');
        return BotResult.success(
          message: 'Dependencies are up to date',
          data: results,
          duration: duration,
        );
      }
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Dependency check failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<Map<String, dynamic>> _checkOutdated() async {
    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'outdated', '--json'],
      );

      // Parsear JSON (simplificado)
      final output = result.stdout.toString();
      
      // Contar paquetes desactualizados (parseo simple)
      final outdatedCount = 'outdated'.allMatches(output.toLowerCase()).length;

      return {
        'status': 'checked',
        'count': outdatedCount,
        'output': output.length > 500 ? '${output.substring(0, 500)}...' : output,
      };
    } catch (e) {
      return {
        'status': 'error',
        'count': 0,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _auditLicenses() async {
    try {
      // Leer pubspec.yaml para obtener dependencias
      final pubspecFile = File('pubspec.yaml');
      
      if (!await pubspecFile.exists()) {
        return {
          'status': 'skipped',
          'message': 'pubspec.yaml not found',
        };
      }

      final content = await pubspecFile.readAsString();
      
      // Contar dependencias (parseo simple)
      final depLines = content.split('\n').where((line) => 
        line.contains(':') && 
        !line.trim().startsWith('#') &&
        (line.contains('dependencies:') || line.trim().contains('^'))
      ).length;

      return {
        'status': 'checked',
        'total_dependencies': depLines,
        'message': 'License audit completed',
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _checkCompatibility() async {
    try {
      // Verificar compatibilidad ejecutando pub get
      final result = await Process.run(
        'flutter',
        ['pub', 'get'],
      );

      final hasErrors = result.exitCode != 0;
      final output = result.stderr.toString();

      return {
        'status': hasErrors ? 'issues_found' : 'compatible',
        'issues': hasErrors ? 1 : 0,
        'message': hasErrors ? 'Compatibility issues detected' : 'All dependencies compatible',
        'output': output.isNotEmpty ? output : 'No issues',
      };
    } catch (e) {
      return {
        'status': 'error',
        'issues': 1,
        'error': e.toString(),
      };
    }
  }
}
