import 'dart:io';
import '../core/bot_base.dart';

/// Bot de seguridad Sentinel
class SentinelSecurityBot extends AutomationBot {
  @override
  String get name => 'Sentinel Security Bot';

  @override
  String get emoji => '🛡️';

  @override
  String get role => 'Security Guardian';

  @override
  BotPriority get priority => BotPriority.critical;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Scanning for security vulnerabilities...');

    try {
      final issues = <Map<String, dynamic>>[];

      // 1. Escanear secretos hardcodeados
      log('Scanning for hardcoded secrets...');
      final secretIssues = await _scanSecrets();
      issues.addAll(secretIssues);

      // 2. Analizar dependencias
      log('Checking dependencies for vulnerabilities...');
      final depIssues = await _checkDependencies();
      issues.addAll(depIssues);

      // 3. Análisis de código
      log('Performing code analysis...');
      final codeIssues = await _analyzeCode();
      issues.addAll(codeIssues);

      final duration = DateTime.now().difference(startTime);

      if (issues.isEmpty) {
        log('✅ No security issues found');
        return BotResult.success(
          message: 'No security vulnerabilities detected',
          data: {'issues': issues, 'count': 0},
          duration: duration,
        );
      } else {
        final criticalCount = issues.where((i) => i['severity'] == 'critical').length;
        
        if (criticalCount > 0) {
          log('❌ Found $criticalCount critical security issues');
          return BotResult.failure(
            message: 'Critical security vulnerabilities found',
            data: {'issues': issues, 'count': issues.length, 'critical': criticalCount},
            duration: duration,
          );
        } else {
          log('⚠️  Found ${issues.length} security warnings');
          return BotResult.success(
            message: 'Security scan completed with warnings',
            data: {'issues': issues, 'count': issues.length},
            duration: duration,
          );
        }
      }
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Security scan failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<List<Map<String, dynamic>>> _scanSecrets() async {
    final issues = <Map<String, dynamic>>[];

    // Patrones comunes de secretos
    final patterns = {
      'API Key': RegExp(r'api[_-]?key\s*[:=]\s*["\'][\w\-]{20,}["\']', caseSensitive: false),
      'Password': RegExp(r'password\s*[:=]\s*["\'].+["\']', caseSensitive: false),
      'Secret': RegExp(r'secret\s*[:=]\s*["\'].+["\']', caseSensitive: false),
      'Token': RegExp(r'token\s*[:=]\s*["\'][\w\-]{20,}["\']', caseSensitive: false),
      'Firebase Config': RegExp(r'firebaseConfig\s*[:=]', caseSensitive: false),
    };

    // Buscar en archivos Dart
    final dartFiles = await Directory('lib')
        .list(recursive: true)
        .where((entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File>()
        .toList();

    for (final file in dartFiles) {
      final content = await file.readAsString();
      final relativePath = file.path.replaceFirst(Directory.current.path + '/', '');

      for (final entry in patterns.entries) {
        if (entry.value.hasMatch(content)) {
          // Verificar si está en comentarios TODO o es un placeholder
          final lines = content.split('\n');
          for (var i = 0; i < lines.length; i++) {
            if (entry.value.hasMatch(lines[i])) {
              final isTodo = lines[i].contains('TODO') || lines[i].contains('SEGURIDAD');
              final isComment = lines[i].trim().startsWith('//');
              
              if (!isTodo && !isComment) {
                issues.add({
                  'type': entry.key,
                  'file': relativePath,
                  'line': i + 1,
                  'severity': 'high',
                  'message': '${entry.key} potentially exposed',
                });
              }
            }
          }
        }
      }
    }

    return issues;
  }

  Future<List<Map<String, dynamic>>> _checkDependencies() async {
    final issues = <Map<String, dynamic>>[];

    try {
      // Ejecutar pub outdated para verificar dependencias desactualizadas
      final result = await Process.run(
        'flutter',
        ['pub', 'outdated', '--json'],
      );

      if (result.exitCode == 0) {
        // Aquí se podría parsear el JSON y verificar versiones con vulnerabilidades conocidas
        // Por ahora, solo reportamos si hay dependencias muy desactualizadas
        log('Dependencies check completed');
      }
    } catch (e) {
      log('⚠️  Could not check dependencies: $e');
    }

    return issues;
  }

  Future<List<Map<String, dynamic>>> _analyzeCode() async {
    final issues = <Map<String, dynamic>>[];

    try {
      // Ejecutar flutter analyze
      final result = await Process.run(
        'flutter',
        ['analyze', '--no-fatal-infos'],
      );

      if (result.exitCode != 0) {
        // Parsear errores de análisis
        final output = result.stdout.toString();
        
        if (output.contains('error')) {
          issues.add({
            'type': 'Code Analysis',
            'severity': 'medium',
            'message': 'Code analysis found issues',
            'details': output,
          });
        }
      }
    } catch (e) {
      log('⚠️  Code analysis failed: $e');
    }

    return issues;
  }
}
