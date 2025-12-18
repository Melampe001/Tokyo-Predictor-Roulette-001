import 'dart:convert';
import 'dart:io';
import '../test_runner.dart';

/// Reporter que genera un reporte JSON
class JsonReporter implements TestReporter {
  final String outputPath;
  final List<Map<String, dynamic>> _events = [];

  JsonReporter({this.outputPath = 'test_results.json'});

  @override
  void onTestStart(String moduleName, String testName) {
    _events.add({
      'type': 'test_start',
      'module': moduleName,
      'test': testName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void onTestComplete(String moduleName, String testName, TestResult result) {
    _events.add({
      'type': 'test_complete',
      'module': moduleName,
      'test': testName,
      'passed': result.passed,
      'duration_ms': result.duration.inMilliseconds,
      'error': result.error,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void onModuleStart(String moduleName) {
    _events.add({
      'type': 'module_start',
      'module': moduleName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void onModuleComplete(String moduleName, ModuleTestResult result) {
    _events.add({
      'type': 'module_complete',
      'module': moduleName,
      'passed': result.passed,
      'failed': result.failed,
      'total': result.results.length,
      'duration_ms': result.duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void onAllTestsComplete(TestResults results) {
    final report = {
      'summary': {
        'total': results.total,
        'passed': results.passed,
        'failed': results.failed,
        'pass_percentage': results.passPercentage,
        'duration_ms': results.totalDuration.inMilliseconds,
        'start_time': results.startTime.toIso8601String(),
        'end_time': results.endTime.toIso8601String(),
      },
      'modules': results.moduleResults.map((m) => {
        'name': m.module.name,
        'passed': m.passed,
        'failed': m.failed,
        'total': m.results.length,
        'duration_ms': m.duration.inMilliseconds,
        'status': m.status.toString(),
        'tests': m.results.map((t) => {
          'name': t.name,
          'passed': t.passed,
          'duration_ms': t.duration.inMilliseconds,
          'error': t.error,
        }).toList(),
      }).toList(),
      'events': _events,
      'generated_at': DateTime.now().toIso8601String(),
    };

    // Guardar a archivo
    final file = File(outputPath);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(report),
    );

    print('📄 JSON report saved to: $outputPath');
  }
}
