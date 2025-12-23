#!/usr/bin/env dart

import 'dart:io';
import 'test_runner.dart';
import 'reporters/console_reporter.dart';
import 'reporters/html_reporter.dart';
import 'reporters/json_reporter.dart';
import 'modules/ui_module_test.dart';
import 'modules/ml_module_test.dart';
import 'modules/data_module_test.dart';
import 'modules/integration_module_test.dart';

/// Script principal para ejecutar el Vercel Emulator
void main(List<String> args) async {
  print('🚀 Tokyo Roulette - Vercel Style Test Emulator');
  print('═' * 60);
  print('');

  final verbose = args.contains('--verbose') || args.contains('-v');
  final parallel = !args.contains('--sequential');
  final outputDir = args.contains('--output') && args.indexOf('--output') + 1 < args.length
      ? args[args.indexOf('--output') + 1]
      : 'test-results';

  // Crear directorio de salida
  final dir = Directory(outputDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // Configurar módulos de prueba
  final modules = <TestModule>[
    UIModuleTest(),
    MLModuleTest(),
    DataModuleTest(),
    IntegrationModuleTest(),
  ];

  // Configurar reporters
  final consoleReporter = VercelStyleReporter(verbose: verbose);
  final htmlReporter = HtmlReporter(
    outputPath: '$outputDir/test_results.html',
  );
  final jsonReporter = JsonReporter(
    outputPath: '$outputDir/test_results.json',
  );

  // Crear reporter compuesto
  final compositeReporter = CompositeReporter([
    consoleReporter,
    htmlReporter,
    jsonReporter,
  ]);

  // Crear y ejecutar emulador
  final emulator = VercelEmulator(
    modules: modules,
    reporter: compositeReporter,
  );

  print('📝 Configuration:');
  print('   Modules: ${modules.length}');
  print('   Parallel: $parallel');
  print('   Output: $outputDir');
  print('   Verbose: $verbose');
  print('');

  try {
    final results = parallel
        ? await emulator.runAllTests()
        : await emulator.runAllTestsSequential();

    // Determinar código de salida
    final exitCode = results.failed == 0 ? 0 : 1;

    if (exitCode == 0) {
      print('✅ All tests passed! System ready for deployment.');
    } else {
      print('❌ Some tests failed. Please fix before deploying.');
    }

    exit(exitCode);
  } catch (e, st) {
    print('❌ Fatal error running tests:');
    print(e);
    if (verbose) {
      print(st);
    }
    exit(2);
  }
}

/// Reporter compuesto que delega a múltiples reporters
class CompositeReporter implements TestReporter {
  final List<TestReporter> reporters;

  CompositeReporter(this.reporters);

  @override
  void onTestStart(String moduleName, String testName) {
    for (final reporter in reporters) {
      reporter.onTestStart(moduleName, testName);
    }
  }

  @override
  void onTestComplete(String moduleName, String testName, TestResult result) {
    for (final reporter in reporters) {
      reporter.onTestComplete(moduleName, testName, result);
    }
  }

  @override
  void onModuleStart(String moduleName) {
    for (final reporter in reporters) {
      reporter.onModuleStart(moduleName);
    }
  }

  @override
  void onModuleComplete(String moduleName, ModuleTestResult result) {
    for (final reporter in reporters) {
      reporter.onModuleComplete(moduleName, result);
    }
  }

  @override
  void onAllTestsComplete(TestResults results) {
    for (final reporter in reporters) {
      reporter.onAllTestsComplete(results);
    }
  }
}
