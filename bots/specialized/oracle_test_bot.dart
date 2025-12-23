import 'dart:io';
import '../core/bot_base.dart';

/// Bot de testing Oracle
class OracleTestBot extends AutomationBot {
  @override
  String get name => 'Oracle Test Bot';

  @override
  String get emoji => '🔮';

  @override
  String get role => 'Testing Oracle';

  @override
  BotPriority get priority => BotPriority.critical;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Consulting the Oracle...');

    try {
      final results = <String, dynamic>{};

      // 1. Run Flutter Tests
      log('Running Flutter tests...');
      final testResult = await _runFlutterTests();
      results['flutter_tests'] = testResult;

      if (testResult['failed'] > 0) {
        final duration = DateTime.now().difference(startTime);
        return BotResult.failure(
          message: 'Tests failed: ${testResult['failed']} failures',
          data: results,
          duration: duration,
        );
      }

      // 2. Run Vercel Emulator (si está disponible)
      if (context.getConfig<bool>('run_vercel_emulator', defaultValue: false)) {
        log('Running Vercel-style emulator tests...');
        final vercelResult = await _runVercelEmulator();
        results['vercel_tests'] = vercelResult;
      }

      // 3. Generate Coverage (si está configurado)
      if (context.getConfig<bool>('generate_coverage', defaultValue: false)) {
        log('Generating coverage report...');
        final coverageResult = await _generateCoverage();
        results['coverage'] = coverageResult;
      }

      final duration = DateTime.now().difference(startTime);
      log('✅ All tests passed (${testResult['total']} tests)');

      return BotResult.success(
        message: 'All tests passed',
        data: results,
        duration: duration,
      );
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Test execution failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<Map<String, dynamic>> _runFlutterTests() async {
    try {
      final result = await Process.run(
        'flutter',
        ['test', '--no-pub'],
      );

      // Parsear resultados (simplificado)
      final output = result.stdout.toString();
      
      // Buscar patrones en la salida
      final allTestsPassed = result.exitCode == 0;
      
      return {
        'status': allTestsPassed ? 'passed' : 'failed',
        'total': _countTests(output),
        'passed': allTestsPassed ? _countTests(output) : 0,
        'failed': allTestsPassed ? 0 : 1,
        'output': output,
      };
    } catch (e) {
      return {
        'status': 'error',
        'total': 0,
        'passed': 0,
        'failed': 1,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _runVercelEmulator() async {
    try {
      // Ejecutar el script del Vercel Emulator
      final scriptPath = 'testing/vercel_emulator/run_tests.dart';
      final scriptFile = File(scriptPath);

      if (!await scriptFile.exists()) {
        return {
          'status': 'skipped',
          'message': 'Vercel emulator not found',
        };
      }

      final result = await Process.run(
        'dart',
        [scriptPath],
      );

      return {
        'status': result.exitCode == 0 ? 'passed' : 'failed',
        'exit_code': result.exitCode,
        'output': result.stdout.toString(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _generateCoverage() async {
    try {
      final result = await Process.run(
        'flutter',
        ['test', '--coverage'],
      );

      if (result.exitCode == 0) {
        // Leer archivo de cobertura
        final coverageFile = File('coverage/lcov.info');
        
        if (await coverageFile.exists()) {
          final content = await coverageFile.readAsString();
          final coverage = _parseCoverage(content);

          return {
            'status': 'success',
            'coverage_percentage': coverage,
            'report_path': 'coverage/lcov.info',
          };
        }
      }

      return {
        'status': 'failed',
        'error': 'Coverage generation failed',
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  int _countTests(String output) {
    // Buscar líneas que indiquen tests ejecutados
    final testPattern = RegExp(r'All tests passed!|(\d+) tests? passed');
    final match = testPattern.firstMatch(output);
    
    if (match != null && match.group(1) != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    
    // Si encontramos "All tests passed", asumimos al menos 1
    if (output.contains('All tests passed')) {
      return 1;
    }
    
    return 0;
  }

  double _parseCoverage(String lcovContent) {
    // Parseo simple de cobertura desde LCOV
    final linesHit = RegExp(r'LH:(\d+)');
    final linesFound = RegExp(r'LF:(\d+)');

    var totalHit = 0;
    var totalFound = 0;

    for (final match in linesHit.allMatches(lcovContent)) {
      totalHit += int.parse(match.group(1)!);
    }

    for (final match in linesFound.allMatches(lcovContent)) {
      totalFound += int.parse(match.group(1)!);
    }

    if (totalFound == 0) return 0.0;
    return (totalHit / totalFound * 100);
  }
}
