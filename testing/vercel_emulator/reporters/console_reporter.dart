import 'dart:io';
import '../test_runner.dart';

/// Reporter estilo Vercel para consola
class VercelStyleReporter implements TestReporter {
  final bool verbose;
  
  VercelStyleReporter({this.verbose = false});

  @override
  void onTestStart(String moduleName, String testName) {
    stdout.write('⏳ Running $moduleName › $testName...');
  }

  @override
  void onTestComplete(String moduleName, String testName, TestResult result) {
    final icon = result.passed ? '✅' : '❌';
    final duration = '${result.duration.inMilliseconds}ms';

    stdout.write('\r$icon $moduleName › $testName ($duration)\n');

    if (!result.passed) {
      _printError(result.error, result.stackTrace);
    }
  }

  @override
  void onModuleStart(String moduleName) {
    print('\n🔧 Starting module: $moduleName');
    print('─' * 60);
  }

  @override
  void onModuleComplete(String moduleName, ModuleTestResult result) {
    final icon = result.allPassed ? '✅' : '❌';
    print('─' * 60);
    print('$icon Module $moduleName completed:');
    print('   Passed: ${result.passed}/${result.results.length}');
    print('   Duration: ${result.duration.inMilliseconds}ms');
    print('');
  }

  @override
  void onAllTestsComplete(TestResults results) {
    print('\n' + '═' * 60);
    print('📊 Test Summary (Vercel Style)');
    print('═' * 60);
    print('Total Tests: ${results.total}');
    print('✅ Passed: ${results.passed} (${results.passPercentage.toStringAsFixed(1)}%)');
    print('❌ Failed: ${results.failed}');
    print('⏱️  Duration: ${_formatDuration(results.totalDuration)}');
    print('═' * 60);

    if (results.failed == 0) {
      print('🎉 All tests passed! Ready to deploy.\n');
    } else {
      print('⚠️  Some tests failed. Fix them before deployment.\n');
      
      // Mostrar resumen de fallos
      for (final moduleResult in results.moduleResults) {
        final failedTests = moduleResult.results.where((r) => !r.passed);
        if (failedTests.isNotEmpty) {
          print('\n❌ Failed tests in ${moduleResult.module.name}:');
          for (final test in failedTests) {
            print('   • ${test.name}');
            if (verbose && test.error != null) {
              print('     ${test.error}');
            }
          }
        }
      }
      print('');
    }
  }

  void _printError(String? error, StackTrace? stackTrace) {
    if (error != null) {
      print('   Error: $error');
      if (verbose && stackTrace != null) {
        print('   Stack trace:');
        final lines = stackTrace.toString().split('\n').take(5);
        for (final line in lines) {
          print('     $line');
        }
      }
    }
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
}
