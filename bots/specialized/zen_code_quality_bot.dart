import 'dart:io';
import '../core/bot_base.dart';

/// Bot de calidad de código Zen
class ZenCodeQualityBot extends AutomationBot {
  @override
  String get name => 'Zen Code Quality Bot';

  @override
  String get emoji => '☯️';

  @override
  String get role => 'Code Quality Master';

  @override
  BotPriority get priority => BotPriority.high;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Seeking code quality enlightenment...');

    try {
      final results = <String, dynamic>{};

      // 1. Linting
      log('Running linter...');
      final lintResult = await _runLinter();
      results['linting'] = lintResult;

      // 2. Formatting Check
      log('Checking code formatting...');
      final formatResult = await _checkFormatting();
      results['formatting'] = formatResult;

      // 3. Complexity Analysis (simplificado)
      log('Analyzing code complexity...');
      final complexityResult = await _analyzeComplexity();
      results['complexity'] = complexityResult;

      final duration = DateTime.now().difference(startTime);

      // Determinar si hay problemas críticos
      final hasErrors = lintResult['errors'] > 0;
      final hasFormatIssues = formatResult['needs_formatting'] == true;

      if (hasErrors) {
        log('❌ Found ${lintResult['errors']} linting errors');
        return BotResult.failure(
          message: 'Code quality issues found',
          data: results,
          duration: duration,
        );
      } else {
        log('✅ Code quality checks passed');
        return BotResult.success(
          message: 'Code meets quality standards',
          data: results,
          duration: duration,
        );
      }
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Code quality check failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<Map<String, dynamic>> _runLinter() async {
    try {
      final result = await Process.run(
        'flutter',
        ['analyze', '--no-fatal-infos'],
      );

      final output = result.stdout.toString();
      final errors = _countMatches(output, 'error');
      final warnings = _countMatches(output, 'warning');
      final infos = _countMatches(output, 'info');

      return {
        'status': result.exitCode == 0 ? 'passed' : 'failed',
        'errors': errors,
        'warnings': warnings,
        'infos': infos,
        'output': output,
      };
    } catch (e) {
      return {
        'status': 'error',
        'errors': 1,
        'warnings': 0,
        'infos': 0,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _checkFormatting() async {
    try {
      final result = await Process.run(
        'dart',
        ['format', '--set-exit-if-changed', '--output=none', 'lib', 'test'],
      );

      return {
        'needs_formatting': result.exitCode != 0,
        'message': result.exitCode != 0
            ? 'Some files need formatting'
            : 'All files properly formatted',
      };
    } catch (e) {
      return {
        'needs_formatting': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _analyzeComplexity() async {
    try {
      // Análisis simple de complejidad
      final dartFiles = await Directory('lib')
          .list(recursive: true)
          .where((entity) => entity is File && entity.path.endsWith('.dart'))
          .cast<File>()
          .toList();

      var totalLines = 0;
      var totalFiles = 0;
      var largeFiles = 0;

      for (final file in dartFiles) {
        final content = await file.readAsString();
        final lines = content.split('\n').length;
        totalLines += lines;
        totalFiles++;

        if (lines > 500) {
          largeFiles++;
          log('⚠️  Large file detected: ${file.path} ($lines lines)');
        }
      }

      final avgLinesPerFile = totalFiles > 0 ? (totalLines / totalFiles).round() : 0;

      return {
        'total_files': totalFiles,
        'total_lines': totalLines,
        'avg_lines_per_file': avgLinesPerFile,
        'large_files': largeFiles,
        'status': largeFiles > 0 ? 'warning' : 'good',
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  int _countMatches(String text, String pattern) {
    return RegExp(pattern, caseSensitive: false).allMatches(text).length;
  }
}
