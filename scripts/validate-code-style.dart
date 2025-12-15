#!/usr/bin/env dart
// Code style validator for Tokyo Roulette Predictor
// Checks naming conventions, documentation, TODOs, and more

import 'dart:io';

void main() async {
  print('\x1B[34m🔍 Validating code style...\x1B[0m');
  print('=' * 50);

  final validator = CodeStyleValidator();
  await validator.validate();

  print('=' * 50);
  if (validator.hasErrors) {
    print('\x1B[31m❌ Code style validation failed!\x1B[0m');
    print('Fix the issues above before committing.');
    exit(1);
  } else if (validator.hasWarnings) {
    print('\x1B[33m⚠️  Code style validation passed with warnings\x1B[0m');
    exit(0);
  } else {
    print('\x1B[32m✅ Code style validation passed!\x1B[0m');
    exit(0);
  }
}

class CodeStyleValidator {
  bool hasErrors = false;
  bool hasWarnings = false;
  int errorCount = 0;
  int warningCount = 0;
  int todoCount = 0;
  int filesChecked = 0;

  Future<void> validate() async {
    await checkNamingConventions();
    await checkPublicApiDocumentation();
    await checkTodoComments();
    await checkTestCoverage();
  }

  Future<void> checkNamingConventions() async {
    print('\n\x1B[34m📝 Checking naming conventions...\x1B[0m');

    final libFiles = await _findDartFiles('lib');
    final testFiles = await _findDartFiles('test');
    final allFiles = [...libFiles, ...testFiles];

    for (final file in allFiles) {
      filesChecked++;
      final content = await File(file).readAsString();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final lineNum = i + 1;

        // Check class names (should be PascalCase - starts with uppercase)
        final classMatch = RegExp(r'class\s+([A-Za-z_][a-zA-Z0-9_]*)').firstMatch(line);
        if (classMatch != null) {
          final className = classMatch.group(1)!;
          if (!_isPascalCase(className)) {
            _reportError(file, lineNum, 'Class name should be PascalCase (start with uppercase): $className');
          }
        }

        // Check for snake_case in variable/method names (should be camelCase)
        final methodMatch = RegExp(r'^\s*(void|int|double|String|bool|Future|dynamic)\s+([a-z][a-zA-Z0-9]*_[a-zA-Z0-9_]*)\s*\(').firstMatch(line);
        if (methodMatch != null) {
          final methodName = methodMatch.group(2)!;
          if (!methodName.startsWith('_')) { // Allow private methods with underscores
            _reportWarning(file, lineNum, 'Method name should be camelCase, not snake_case: $methodName');
          }
        }
      }
    }

    if (errorCount == 0 && warningCount == 0) {
      print('\x1B[32m✓ Naming conventions look good\x1B[0m');
    }
  }

  Future<void> checkPublicApiDocumentation() async {
    print('\n\x1B[34m📚 Checking public API documentation...\x1B[0m');

    final libFiles = await _findDartFiles('lib');
    int undocumentedApis = 0;

    for (final file in libFiles) {
      final content = await File(file).readAsString();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        final lineNum = i + 1;

        // Check for public classes without documentation
        if (RegExp(r'^class\s+[A-Z]').hasMatch(line)) {
          // Look back for documentation
          if (i == 0 || !lines[i - 1].trim().startsWith('///')) {
            _reportWarning(file, lineNum, 'Public class should have documentation comment (///)');
            undocumentedApis++;
          }
        }

        // Check for public methods without documentation (more accurate check)
        final methodPattern = RegExp(r'^\s*(int|double|String|bool|void|Future|dynamic)\s+([a-z][a-zA-Z0-9]*)\s*\(');
        final methodMatch = methodPattern.firstMatch(line);
        if (methodMatch != null) {
          final methodName = methodMatch.group(2)!;
          // Only check public methods (not starting with _)
          if (!methodName.startsWith('_')) {
            // Look back for documentation
            if (i == 0 || !lines[i - 1].trim().startsWith('///')) {
              _reportWarning(file, lineNum, 'Public method should have documentation comment (///)');
              undocumentedApis++;
            }
          }
        }
      }
    }

    if (undocumentedApis == 0) {
      print('\x1B[32m✓ Public APIs are documented\x1B[0m');
    } else {
      print('\x1B[33m⚠️  Found $undocumentedApis undocumented public APIs\x1B[0m');
    }
  }

  Future<void> checkTodoComments() async {
    print('\n\x1B[34m📋 Checking TODO comments...\x1B[0m');

    final libFiles = await _findDartFiles('lib');
    final testFiles = await _findDartFiles('test');
    final allFiles = [...libFiles, ...testFiles];

    final todos = <String>[];

    for (final file in allFiles) {
      final content = await File(file).readAsString();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('TODO') || line.contains('FIXME')) {
          todos.add('$file:${i + 1}: ${line.trim()}');
          todoCount++;
        }
      }
    }

    if (todos.isEmpty) {
      print('\x1B[32m✓ No TODO comments found\x1B[0m');
    } else {
      print('\x1B[33m⚠️  Found ${todos.length} TODO/FIXME comment(s):\x1B[0m');
      for (final todo in todos.take(5)) {
        print('  $todo');
      }
      if (todos.length > 5) {
        print('  ... and ${todos.length - 5} more');
      }
    }
  }

  Future<void> checkTestCoverage() async {
    print('\n\x1B[34m🧪 Checking test coverage...\x1B[0m');

    final libFiles = await _findDartFiles('lib');
    final testFiles = await _findDartFiles('test');

    // Check if main logic files have corresponding test files
    final missingTests = <String>[];

    for (final libFile in libFiles) {
      if (libFile.contains('main.dart')) continue; // Skip main.dart

      final fileName = libFile.split('/').last;
      final testFileName = fileName.replaceAll('.dart', '_test.dart');

      final hasTest = testFiles.any((testFile) => testFile.endsWith(testFileName));

      if (!hasTest && !fileName.startsWith('generated_')) {
        missingTests.add(fileName);
      }
    }

    if (missingTests.isEmpty) {
      print('\x1B[32m✓ All logic files have corresponding test files\x1B[0m');
    } else {
      print('\x1B[33m⚠️  The following files may be missing tests:\x1B[0m');
      for (final file in missingTests) {
        print('  - $file');
      }
    }
  }

  Future<List<String>> _findDartFiles(String directory) async {
    final files = <String>[];
    final dir = Directory(directory);

    if (!await dir.exists()) {
      return files;
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Skip generated files
        if (!entity.path.contains('.g.dart') &&
            !entity.path.contains('.freezed.dart') &&
            !entity.path.contains('generated_plugin_registrant.dart')) {
          files.add(entity.path);
        }
      }
    }

    return files;
  }

  bool _isPascalCase(String name) {
    return RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(name);
  }

  void _reportError(String file, int line, String message) {
    print('\x1B[31m✗ $file:$line - $message\x1B[0m');
    hasErrors = true;
    errorCount++;
  }

  void _reportWarning(String file, int line, String message) {
    print('\x1B[33m⚠️  $file:$line - $message\x1B[0m');
    hasWarnings = true;
    warningCount++;
  }
}
