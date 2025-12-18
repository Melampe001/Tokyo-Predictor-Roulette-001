import 'dart:async';

/// Resultados de una prueba individual
class TestResult {
  final String name;
  final bool passed;
  final Duration duration;
  final String? error;
  final StackTrace? stackTrace;

  TestResult({
    required this.name,
    required this.passed,
    required this.duration,
    this.error,
    this.stackTrace,
  });

  bool get isSuccess => passed;
  bool get isFailure => !passed;
}

/// Resultados agregados de todos los tests
class TestResults {
  final List<ModuleTestResult> moduleResults;
  final DateTime startTime;
  final DateTime endTime;

  TestResults({
    required this.moduleResults,
    required this.startTime,
    required this.endTime,
  });

  int get total => moduleResults.fold(
      0, (sum, module) => sum + module.results.length);

  int get passed => moduleResults.fold(
      0, (sum, module) => sum + module.results.where((r) => r.passed).length);

  int get failed => total - passed;

  double get passPercentage => total > 0 ? (passed / total * 100) : 0;

  Duration get totalDuration => endTime.difference(startTime);

  static TestResults aggregate(List<ModuleTestResult> results) {
    final now = DateTime.now();
    return TestResults(
      moduleResults: results,
      startTime: now.subtract(
        Duration(
          milliseconds: results.fold(
            0,
            (sum, r) => sum + r.duration.inMilliseconds,
          ),
        ),
      ),
      endTime: now,
    );
  }
}

/// Resultado de pruebas de un módulo
class ModuleTestResult {
  final TestModule module;
  final Duration duration;
  final List<TestResult> results;
  final TestStatus status;

  ModuleTestResult({
    required this.module,
    required this.duration,
    required this.results,
    required this.status,
  });

  int get passed => results.where((r) => r.passed).length;
  int get failed => results.where((r) => !r.passed).length;
  bool get allPassed => failed == 0;
}

enum TestStatus {
  passed,
  failed,
  skipped,
}

/// Definición de una prueba individual
class Test {
  final String name;
  final Future<void> Function() run;
  final Duration timeout;

  Test({
    required this.name,
    required this.run,
    this.timeout = const Duration(seconds: 30),
  });
}

/// Módulo de pruebas base
abstract class TestModule {
  String get name;
  List<Test> get tests;
  bool get enabled => true;
  bool get critical => false;
  Duration get timeout => const Duration(minutes: 5);

  Future<void> setup() async {}
  Future<void> teardown() async {}
}

/// Reporter de resultados de pruebas
abstract class TestReporter {
  void onTestStart(String moduleName, String testName);
  void onTestComplete(String moduleName, String testName, TestResult result);
  void onModuleStart(String moduleName);
  void onModuleComplete(String moduleName, ModuleTestResult result);
  void onAllTestsComplete(TestResults results);
}

/// Emulador de testing estilo Vercel
/// Ejecuta pruebas modulares con reporting en tiempo real
class VercelEmulator {
  final List<TestModule> modules;
  final TestReporter reporter;

  VercelEmulator({
    required this.modules,
    required this.reporter,
  });

  /// Ejecuta todos los tests en paralelo como Vercel
  Future<TestResults> runAllTests() async {
    final startTime = DateTime.now();

    // Filtrar módulos habilitados
    final enabledModules = modules.where((m) => m.enabled).toList();

    // Ejecutar tests en paralelo
    final results = await Future.wait(
      enabledModules.map((module) => _runModuleTests(module)),
    );

    final endTime = DateTime.now();

    final testResults = TestResults(
      moduleResults: results,
      startTime: startTime,
      endTime: endTime,
    );

    reporter.onAllTestsComplete(testResults);

    return testResults;
  }

  /// Ejecuta los tests de un módulo específico
  Future<ModuleTestResult> _runModuleTests(TestModule module) async {
    final startTime = DateTime.now();
    final results = <TestResult>[];

    reporter.onModuleStart(module.name);

    try {
      // Setup del módulo
      await module.setup();

      // Ejecutar cada test
      for (final test in module.tests) {
        reporter.onTestStart(module.name, test.name);

        final testStartTime = DateTime.now();
        String? error;
        StackTrace? stackTrace;
        bool passed = false;

        try {
          await test.run().timeout(test.timeout);
          passed = true;
        } catch (e, st) {
          error = e.toString();
          stackTrace = st;
        }

        final testDuration = DateTime.now().difference(testStartTime);
        final result = TestResult(
          name: test.name,
          passed: passed,
          duration: testDuration,
          error: error,
          stackTrace: stackTrace,
        );

        results.add(result);
        reporter.onTestComplete(module.name, test.name, result);
      }

      // Teardown del módulo
      await module.teardown();
    } catch (e) {
      // Error en setup/teardown
      print('Error in module ${module.name}: $e');
    }

    final duration = DateTime.now().difference(startTime);
    final allPassed = results.every((r) => r.passed);

    final moduleResult = ModuleTestResult(
      module: module,
      duration: duration,
      results: results,
      status: allPassed ? TestStatus.passed : TestStatus.failed,
    );

    reporter.onModuleComplete(module.name, moduleResult);

    return moduleResult;
  }

  /// Ejecuta tests de forma secuencial (para debugging)
  Future<TestResults> runAllTestsSequential() async {
    final startTime = DateTime.now();
    final results = <ModuleTestResult>[];

    final enabledModules = modules.where((m) => m.enabled).toList();

    for (final module in enabledModules) {
      final result = await _runModuleTests(module);
      results.add(result);

      // Si es crítico y falla, detener ejecución
      if (module.critical && result.status == TestStatus.failed) {
        print('❌ Critical module ${module.name} failed. Stopping tests.');
        break;
      }
    }

    final endTime = DateTime.now();

    final testResults = TestResults(
      moduleResults: results,
      startTime: startTime,
      endTime: endTime,
    );

    reporter.onAllTestsComplete(testResults);

    return testResults;
  }
}
