import 'dart:io';
import '../test_runner.dart';

/// Reporter que genera un reporte HTML
class HtmlReporter implements TestReporter {
  final String outputPath;
  final StringBuffer _html = StringBuffer();
  DateTime? _startTime;

  HtmlReporter({this.outputPath = 'test_results.html'});

  @override
  void onTestStart(String moduleName, String testName) {
    // No-op para HTML
  }

  @override
  void onTestComplete(String moduleName, String testName, TestResult result) {
    // Se agregará al módulo completo
  }

  @override
  void onModuleStart(String moduleName) {
    _startTime ??= DateTime.now();
  }

  @override
  void onModuleComplete(String moduleName, ModuleTestResult result) {
    // Se agregará al reporte final
  }

  @override
  void onAllTestsComplete(TestResults results) {
    _generateHtml(results);

    final file = File(outputPath);
    file.writeAsStringSync(_html.toString());

    print('📄 HTML report saved to: $outputPath');
  }

  void _generateHtml(TestResults results) {
    _html.writeln('''
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Results - Vercel Style</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #000;
            color: #fff;
            padding: 40px 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        .header {
            border-bottom: 1px solid #333;
            padding-bottom: 20px;
            margin-bottom: 40px;
        }
        h1 { font-size: 2.5em; margin-bottom: 10px; }
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat {
            background: #111;
            border: 1px solid #333;
            border-radius: 8px;
            padding: 20px;
        }
        .stat-value {
            font-size: 2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label { color: #888; font-size: 0.9em; }
        .passed { color: #00ff00; }
        .failed { color: #ff0000; }
        .module {
            background: #111;
            border: 1px solid #333;
            border-radius: 8px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        .module-header {
            padding: 20px;
            border-bottom: 1px solid #333;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .module-name { font-size: 1.3em; font-weight: bold; }
        .module-stats { color: #888; }
        .test {
            padding: 15px 20px;
            border-bottom: 1px solid #222;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .test:last-child { border-bottom: none; }
        .test-name { flex: 1; }
        .test-duration { color: #888; margin-right: 10px; }
        .test-status { font-size: 1.2em; }
        .error {
            background: #1a0000;
            border-left: 3px solid #ff0000;
            padding: 10px;
            margin-top: 10px;
            font-family: monospace;
            font-size: 0.9em;
            color: #ff6b6b;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔮 Test Results</h1>
            <p>Vercel-Style Testing Report</p>
        </div>

        <div class="summary">
            <div class="stat">
                <div class="stat-value">${results.total}</div>
                <div class="stat-label">Total Tests</div>
            </div>
            <div class="stat">
                <div class="stat-value passed">${results.passed}</div>
                <div class="stat-label">Passed (${results.passPercentage.toStringAsFixed(1)}%)</div>
            </div>
            <div class="stat">
                <div class="stat-value failed">${results.failed}</div>
                <div class="stat-label">Failed</div>
            </div>
            <div class="stat">
                <div class="stat-value">${_formatDuration(results.totalDuration)}</div>
                <div class="stat-label">Duration</div>
            </div>
        </div>
''');

    for (final moduleResult in results.moduleResults) {
      _html.writeln('''
        <div class="module">
            <div class="module-header">
                <div class="module-name">${moduleResult.module.name}</div>
                <div class="module-stats">
                    ${moduleResult.passed}/${moduleResult.results.length} passed • ${moduleResult.duration.inMilliseconds}ms
                </div>
            </div>
''');

      for (final test in moduleResult.results) {
        final icon = test.passed ? '✅' : '❌';
        _html.writeln('''
            <div class="test">
                <div class="test-name">${test.name}</div>
                <div class="test-duration">${test.duration.inMilliseconds}ms</div>
                <div class="test-status">${icon}</div>
            </div>
''');

        if (!test.passed && test.error != null) {
          _html.writeln('''
            <div class="error">${_escapeHtml(test.error!)}</div>
''');
        }
      }

      _html.writeln('        </div>');
    }

    _html.writeln('''
    </div>
</body>
</html>
''');
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
