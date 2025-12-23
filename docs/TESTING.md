# Testing Guide - Tokyo Roulette Predictor

## 📋 Table of Contents
- [Testing Philosophy](#testing-philosophy)
- [Test Structure](#test-structure)
- [Running Tests](#running-tests)
- [Writing Tests](#writing-tests)
- [Test Coverage](#test-coverage)
- [Best Practices](#best-practices)
- [CI/CD Integration](#cicd-integration)
- [Troubleshooting](#troubleshooting)

## 🎯 Testing Philosophy

This project follows a comprehensive testing strategy:
- **Unit Tests**: Test individual functions and classes in isolation
- **Widget Tests**: Test UI components and their interactions
- **Integration Tests**: Test complete user flows end-to-end
- **Coverage Target**: >80% overall code coverage

### Why Testing Matters
- Ensures code quality and reliability
- Prevents regressions when adding new features
- Documents expected behavior
- Facilitates refactoring with confidence
- Catches bugs early in development

## 📁 Test Structure

```
test/
├── unit/                       # Unit tests
│   ├── roulette_logic_test.dart
│   └── validators_test.dart
├── widget/                     # Widget tests
│   ├── login_screen_test.dart
│   └── main_screen_test.dart
├── integration/                # Integration tests (future)
├── mocks/                      # Mock objects
├── fixtures/                   # Test data
│   ├── user_fixtures.dart
│   └── roulette_fixtures.dart
├── helpers/                    # Test utilities
│   └── widget_tester_extension.dart
├── golden/                     # Golden/screenshot tests (future)
└── performance/                # Performance tests (future)

integration_test/               # E2E integration tests
└── app_test.dart
```

## 🏃 Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/roulette_logic_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate HTML Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

### Run Integration Tests
```bash
flutter test integration_test/app_test.dart
```

### Run Tests in Watch Mode (requires external tool)
```bash
# Using flutter_test
flutter test --watch
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

### Using Test Scripts
We provide convenient scripts in the `scripts/` directory:

```bash
# Run all tests with coverage
./scripts/run_tests.sh

# Generate coverage report with HTML
./scripts/coverage_reporter.sh --html

# Run with specific coverage threshold
./scripts/coverage_reporter.sh --threshold 80
```

## ✍️ Writing Tests

### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    test('generateSpin returns valid number between 0 and 36', () {
      // Arrange
      final roulette = RouletteLogic();
      
      // Act
      final result = roulette.generateSpin();
      
      // Assert
      expect(result, greaterThanOrEqualTo(0));
      expect(result, lessThanOrEqualTo(36));
    });

    tearDown(() {
      // Cleanup if needed
    });
  });
}
```

### Widget Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('LoginScreen shows error with invalid email', (tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Act
    await tester.enterText(find.byType(TextField), 'invalid-email');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pump();

    // Assert
    expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
  });
}
```

### Integration Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete user flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(TextField), 'test@example.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Play game
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Historial Reciente'), findsOneWidget);
  });
}
```

### Using Test Fixtures

```dart
import '../fixtures/user_fixtures.dart';
import '../fixtures/roulette_fixtures.dart';

test('processes valid user data', () {
  final user = UserFixtures.validUser();
  expect(user['email'], 'test@example.com');
});

test('handles roulette history', () {
  final history = RouletteFixtures.shortHistory();
  expect(history.length, 5);
});
```

### Using Test Helpers

```dart
import '../helpers/widget_tester_extension.dart';

testWidgets('using helper extensions', (tester) async {
  await tester.pumpWidget(TestAppWrapper.wrap(MyWidget()));
  
  // Wait for widget to appear
  await tester.waitFor(find.text('Expected Text'));
  
  // Tap multiple times
  await tester.tapMultiple(find.byType(ElevatedButton), 3);
  
  // Check no exceptions
  tester.expectNoExceptions();
});
```

## 📊 Test Coverage

### Coverage Goals
- **Overall**: >80%
- **Services**: >90% (when implemented)
- **Models**: >95% (when implemented)
- **Business Logic**: >90%
- **Widgets**: >70%
- **UI Screens**: >60%

### Viewing Coverage

#### Command Line
```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

#### HTML Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### CI/CD
Coverage reports are automatically generated and uploaded to Codecov on every PR. Check the PR for coverage details.

### Excluding Files from Coverage

Files can be excluded from coverage in `analysis_options.yaml`:
```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

## 🎯 Best Practices

### Test Organization
- **Group related tests** using `group()`
- **Use descriptive test names** that explain what is being tested
- **Follow AAA pattern**: Arrange, Act, Assert
- **One assertion per test** when possible (or logically related assertions)

### Test Independence
- **Tests should not depend on each other**
- **Use `setUp()` and `tearDown()`** for initialization and cleanup
- **Don't share mutable state** between tests
- **Each test should be runnable in isolation**

### Test Naming
Use descriptive names that explain the scenario:
```dart
✅ Good:
test('generateSpin returns valid number between 0 and 36', () {});
test('shows error message when email is invalid', () {});

❌ Bad:
test('test1', () {});
test('it works', () {});
```

### Test Edge Cases
Always test:
- **Boundary conditions** (0, max values, empty lists)
- **Null values** (when applicable)
- **Invalid input**
- **Error scenarios**
- **Empty states**

Example:
```dart
test('handles empty history', () {
  expect(roulette.predictNext([]), greaterThanOrEqualTo(0));
});

test('handles maximum number', () {
  expect(Validators.isValidRouletteNumber(36), isTrue);
});

test('rejects out of range number', () {
  expect(Validators.isValidRouletteNumber(37), isFalse);
});
```

### Avoid Test Duplication
Use helper functions for common test patterns:
```dart
void testValidEmail(String email) {
  test('accepts $email', () {
    expect(Validators.isValidEmail(email), isTrue);
  });
}

UserFixtures.validEmails().forEach(testValidEmail);
```

### Use Matchers Effectively
Flutter Test provides powerful matchers:
```dart
expect(value, equals(42));
expect(value, greaterThan(0));
expect(value, lessThanOrEqualTo(100));
expect(value, isNull);
expect(value, isNotNull);
expect(list, isEmpty);
expect(list, hasLength(5));
expect(string, contains('test'));
expect(string, startsWith('Hello'));
```

### Widget Testing Tips
- **Use `pumpAndSettle()`** for animations
- **Use `pump()`** for single frame updates
- **Check for exceptions** with `tester.takeException()`
- **Use semantic finders** when possible: `find.text()`, `find.byType()`
- **Test loading states** and error states

### Integration Testing Tips
- **Test real user flows**
- **Use realistic delays** between actions
- **Test navigation**
- **Test state persistence**
- **Avoid over-mocking** - use real implementations when possible

## 🔄 CI/CD Integration

### GitHub Actions
Tests run automatically on:
- Every push to `main`, `develop`, or `copilot/**` branches
- Every pull request to `main` or `develop`

Workflow: `.github/workflows/ci.yml`

### Coverage Reporting
- Coverage reports are generated on every test run
- Reports are uploaded to Codecov
- Coverage badges are displayed in README

### Blocking Merges
Currently configured to:
- ✅ Run all tests (must pass)
- ✅ Generate coverage report
- ⚠️ Coverage drops are reported but don't block (can be configured to block)

## 🔧 Troubleshooting

### Common Issues

#### Tests Timing Out
```bash
# Increase timeout
flutter test --timeout=60s
```

#### Flaky Tests
- Add appropriate delays: `await Future.delayed(Duration(milliseconds: 100))`
- Use `pumpAndSettle()` instead of `pump()` for animations
- Check for race conditions
- Ensure test independence

#### Coverage Not Generating
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter test --coverage
```

#### Widget Not Found
```dart
// Wait for widget to appear
await tester.pumpAndSettle();

// Or use custom helper
await tester.waitFor(find.text('Expected Text'));
```

#### Import Errors
```dart
// Use relative imports in test files
import '../fixtures/user_fixtures.dart';

// Not absolute imports
// import 'package:tokyo_roulette_predicciones/test/fixtures/user_fixtures.dart';
```

### Getting Help
- Check Flutter Test documentation: https://docs.flutter.dev/testing
- Review existing tests in this project
- Ask in project discussions or issues

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://docs.flutter.dev/testing/integration-tests)

## 🎓 Testing Checklist

Before committing code:
- [ ] All tests pass locally
- [ ] New code has tests (unit/widget/integration as appropriate)
- [ ] Edge cases are tested
- [ ] Coverage hasn't decreased
- [ ] No flaky tests
- [ ] Tests are independent and isolated
- [ ] Test names are descriptive
- [ ] Mock data is used where appropriate

## 📝 Notes

- This is an educational simulator - tests should verify educational integrity
- RNG must use `Random.secure()` - tests verify this indirectly
- Tests ensure balance never goes negative
- Tests verify educational disclaimer is always visible
- Martingale strategy tests verify correct doubling behavior

---

**Last Updated**: December 2024  
**Maintained by**: Tokyo Roulette Predictor Team
