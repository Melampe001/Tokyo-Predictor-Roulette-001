# 🧪 Testing Guide

Comprehensive guide to testing Tokyo Roulette Predicciones, covering philosophy, strategies, and best practices.

## 📋 Table of Contents

- [Testing Philosophy](#testing-philosophy)
- [Test Types](#test-types)
- [Writing Unit Tests](#writing-unit-tests)
- [Writing Widget Tests](#writing-widget-tests)
- [Writing Integration Tests](#writing-integration-tests)
- [Code Coverage](#code-coverage)
- [Mocking Strategies](#mocking-strategies)
- [Test Fixtures and Helpers](#test-fixtures-and-helpers)
- [CI Testing Process](#ci-testing-process)
- [Best Practices](#best-practices)

## 🎯 Testing Philosophy

### Core Principles

**1. Test Behavior, Not Implementation**
```dart
// ✅ Good: Tests what the function does
test('updates balance after win', () {
  game.processWin(100);
  expect(game.balance, equals(1100));
});

// ❌ Bad: Tests how it's implemented
test('calls _updateBalance method', () {
  game.processWin(100);
  verify(game._updateBalance).called(1);  // Too coupled to implementation
});
```

**2. Write Tests First (TDD)**
- Write failing test
- Write minimal code to pass
- Refactor while keeping tests green

**3. Keep Tests Simple**
- One assertion per test (when possible)
- Clear test names
- Easy to understand purpose

**4. Fast Tests**
- Unit tests should run in milliseconds
- Widget tests in seconds
- Integration tests in minutes

**5. Deterministic Tests**
- Same input → same output
- No flaky tests
- Proper cleanup in tearDown

### Test Pyramid

```
     /\        Integration Tests (Few)
    /  \       - Full user flows
   /____\      - End-to-end scenarios
  /      \     
 /________\    Widget Tests (Some)
/          \   - UI components
/            \  - User interactions
/______________\ 
                Unit Tests (Many)
                - Business logic
                - Calculations
                - Data transformations
```

**Target Distribution:**
- 70% Unit tests
- 20% Widget tests  
- 10% Integration tests

## 📊 Test Types

### 1. Unit Tests

Test individual functions, methods, and classes in isolation.

**What to test:**
- Business logic (RouletteLogic, MartingaleAdvisor)
- Data calculations
- Utilities and helpers
- Edge cases and error handling

**Example:**
```dart
test('generateSpin returns valid number', () {
  final roulette = RouletteLogic();
  final result = roulette.generateSpin();
  
  expect(result, greaterThanOrEqualTo(0));
  expect(result, lessThanOrEqualTo(36));
});
```

### 2. Widget Tests

Test UI components and their interactions.

**What to test:**
- Widget rendering
- User interactions (tap, scroll, input)
- Navigation
- State updates reflected in UI

**Example:**
```dart
testWidgets('spin button triggers result display', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  
  await tester.tap(find.text('Girar'));
  await tester.pump();
  
  expect(find.text('Resultado:'), findsOneWidget);
});
```

### 3. Integration Tests

Test complete user flows across multiple screens.

**What to test:**
- Login → Play → View stats flow
- Payment flow
- Multi-screen workflows
- Real device features

**Example:**
```dart
// integration_test/app_test.dart
testWidgets('complete game flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Login
  await tester.enterText(find.byType(TextField), 'test@example.com');
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
  
  // Play
  await tester.tap(find.text('Girar'));
  await tester.pumpAndSettle();
  
  // Verify
  expect(find.text('Resultado:'), findsOneWidget);
});
```

## ✍️ Writing Unit Tests

### Test Structure (AAA Pattern)

```dart
test('description of what is being tested', () {
  // Arrange: Set up test data and dependencies
  final roulette = RouletteLogic();
  final history = [7, 7, 7, 15];
  for (final number in history) {
    roulette.addToHistory(number);
  }
  
  // Act: Execute the code under test
  final prediction = roulette.predictNext();
  
  // Assert: Verify the results
  expect(prediction, equals(7));
});
```

### Grouping Tests

```dart
void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;
    
    setUp(() {
      roulette = RouletteLogic();
    });
    
    group('generateSpin', () {
      test('returns number in valid range', () {
        final result = roulette.generateSpin();
        expect(result, inInclusiveRange(0, 36));
      });
      
      test('generates different values', () {
        final spins = List.generate(100, (_) => roulette.generateSpin());
        expect(spins.toSet().length, greaterThan(10));
      });
    });
    
    group('predictNext', () {
      test('returns null when history empty', () {
        expect(roulette.predictNext(), isNull);
      });
      
      test('returns most frequent number', () {
        roulette.addToHistory(7);
        roulette.addToHistory(7);
        roulette.addToHistory(15);
        
        expect(roulette.predictNext(), equals(7));
      });
    });
  });
}
```

### Testing Edge Cases

```dart
group('edge cases', () {
  test('handles empty history', () {
    expect(roulette.predictNext(), isNull);
  });
  
  test('handles single spin', () {
    roulette.addToHistory(17);
    expect(roulette.predictNext(), equals(17));
  });
  
  test('handles tie in frequencies', () {
    roulette.addToHistory(7);
    roulette.addToHistory(15);
    final prediction = roulette.predictNext();
    expect([7, 15], contains(prediction));
  });
  
  test('handles maximum history size', () {
    for (int i = 0; i < 25; i++) {
      roulette.addToHistory(i % 37);
    }
    expect(roulette.history.length, lessThanOrEqualTo(20));
  });
});
```

### Testing Error Conditions

```dart
group('error handling', () {
  test('throws on negative bet', () {
    final advisor = MartingaleAdvisor();
    expect(
      () => advisor.updateBet(-10),
      throwsA(isA<ArgumentError>()),
    );
  });
  
  test('throws on invalid email format', () {
    expect(
      () => validateEmail('invalid-email'),
      throwsFormatException,
    );
  });
});
```

### Async Tests

```dart
test('loads user data', () async {
  final service = UserService();
  
  final user = await service.loadUser('user-id');
  
  expect(user.name, equals('Test User'));
});

test('handles timeout', () async {
  final service = UserService(timeout: Duration(seconds: 1));
  
  expect(
    () async => await service.loadUser('slow-user'),
    throwsA(isA<TimeoutException>()),
  );
});
```

## 🖼️ Writing Widget Tests

### Basic Widget Test

```dart
testWidgets('shows login screen', (WidgetTester tester) async {
  // Build the widget
  await tester.pumpWidget(
    const MaterialApp(home: LoginScreen()),
  );
  
  // Verify elements exist
  expect(find.text('Login'), findsOneWidget);
  expect(find.byType(TextField), findsOneWidget);
  expect(find.text('Continuar'), findsOneWidget);
});
```

### Testing User Interactions

```dart
testWidgets('validates email input', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  
  // Enter invalid email
  await tester.enterText(find.byType(TextField), 'invalid');
  await tester.tap(find.text('Continuar'));
  await tester.pump();
  
  // Verify error message
  expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
  
  // Enter valid email
  await tester.enterText(find.byType(TextField), 'test@example.com');
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.byType(MainScreen), findsOneWidget);
});
```

### Testing Navigation

```dart
testWidgets('navigates to settings', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  
  // Open settings
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();
  
  // Verify dialog appears
  expect(find.text('Configuración'), findsOneWidget);
  expect(find.text('Activar Martingale'), findsOneWidget);
});
```

### Testing Scrolling

```dart
testWidgets('scrolls history list', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  
  // Find scrollable
  final listFinder = find.byType(ListView);
  
  // Scroll
  await tester.drag(listFinder, const Offset(0, -300));
  await tester.pump();
  
  // Verify scroll happened
  expect(tester.getTopLeft(listFinder).dy, lessThan(0));
});
```

### Testing State Changes

```dart
testWidgets('balance updates after spin', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  
  // Get initial balance
  final initialBalance = find.textContaining('\$1000.00');
  expect(initialBalance, findsOneWidget);
  
  // Spin
  await tester.tap(find.text('Girar'));
  await tester.pump();
  
  // Verify balance changed
  expect(initialBalance, findsNothing);
  expect(find.textContaining('\$'), findsOneWidget);
});
```

### Finding Widgets

```dart
// By text
find.text('Girar')

// By key
find.byKey(const Key('spin-button'))

// By type
find.byType(ElevatedButton)

// By icon
find.byIcon(Icons.casino)

// By widget instance
find.byWidget(myWidget)

// Descendants
find.descendant(
  of: find.byType(Card),
  matching: find.text('Balance'),
)

// Combinations
find.widgetWithText(ElevatedButton, 'Girar')
```

### Matchers

```dart
expect(find.text('Hello'), findsOneWidget);
expect(find.text('Missing'), findsNothing);
expect(find.byType(Card), findsNWidgets(3));
expect(find.text('Button'), findsWidgets);
expect(find.text('Rare'), findsAtLeastNWidgets(1));
```

## 🔗 Writing Integration Tests

### Setup

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

**Create test:**
```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('end-to-end test', () {
    testWidgets('complete game session', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Login flow
      await tester.enterText(
        find.byType(TextField),
        'test@example.com',
      );
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      
      // Play multiple rounds
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Girar'));
        await tester.pumpAndSettle();
      }
      
      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      
      // Enable Martingale
      await tester.tap(find.text('Activar Martingale'));
      await tester.pumpAndSettle();
      
      // Close dialog
      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();
      
      // Verify Martingale is active
      expect(find.text('Martingale Activa'), findsOneWidget);
    });
  });
}
```

### Running Integration Tests

```bash
# Run on connected device
flutter test integration_test/app_test.dart

# Run on specific device
flutter test integration_test/app_test.dart -d <device-id>

# Generate test report
flutter test integration_test --reporter json > test-results.json
```

## 📈 Code Coverage

### Generating Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Coverage Goals

**Target coverage:**
- **Overall**: ≥80%
- **Business logic**: ≥90%
- **UI code**: ≥70%
- **Utilities**: ≥85%

### Excluding Files from Coverage

```dart
// coverage:ignore-file  // Ignore entire file

void myFunction() {
  // coverage:ignore-start
  debugPrint('This is not covered');
  // coverage:ignore-end
  
  // coverage:ignore-line
  print('This line is not covered');
}
```

### Viewing Coverage in CI

GitHub Actions workflow includes coverage reporting:
```yaml
- name: Test with coverage
  run: flutter test --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    file: coverage/lcov.info
```

## 🎭 Mocking Strategies

### Using Mockito

**1. Add dependency:**
```yaml
dev_dependencies:
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

**2. Generate mocks:**
```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Define interface
abstract class RouletteService {
  int spin();
  Future<void> saveHistory(List<int> history);
}

// Generate mocks
@GenerateMocks([RouletteService])
void main() {}
```

**3. Run code generation:**
```bash
flutter pub run build_runner build
```

**4. Use in tests:**
```dart
import 'roulette_service_test.mocks.dart';

void main() {
  test('controller uses service', () {
    final mockService = MockRouletteService();
    final controller = RouletteController(mockService);
    
    when(mockService.spin()).thenReturn(17);
    
    final result = controller.performSpin();
    
    expect(result, equals(17));
    verify(mockService.spin()).called(1);
  });
  
  test('handles service error', () {
    final mockService = MockRouletteService();
    
    when(mockService.spin()).thenThrow(Exception('Service error'));
    
    final controller = RouletteController(mockService);
    
    expect(() => controller.performSpin(), throwsException);
  });
}
```

### Manual Mocks

```dart
class MockRouletteLogic implements RouletteLogic {
  int _nextSpin = 7;
  
  void setNextSpin(int value) {
    _nextSpin = value;
  }
  
  @override
  int generateSpin() => _nextSpin;
  
  @override
  int? predictNext() => null;
  
  // ... implement other methods
}

// Use in test
test('specific spin result', () {
  final mock = MockRouletteLogic();
  mock.setNextSpin(17);
  
  expect(mock.generateSpin(), equals(17));
});
```

### Fake Implementation

```dart
class FakeRouletteService implements RouletteService {
  final List<int> _history = [];
  
  @override
  int spin() {
    final result = Random().nextInt(37);
    _history.add(result);
    return result;
  }
  
  @override
  Future<void> saveHistory(List<int> history) async {
    _history.addAll(history);
  }
  
  List<int> get history => List.unmodifiable(_history);
}
```

## 🛠️ Test Fixtures and Helpers

### Test Data Fixtures

```dart
// test/fixtures/test_data.dart
class TestData {
  static const validEmail = 'test@example.com';
  static const invalidEmail = 'invalid-email';
  
  static List<int> sampleHistory = [7, 15, 22, 7, 33, 7];
  
  static RouletteLogic createRouletteWithHistory() {
    final roulette = RouletteLogic();
    for (final number in sampleHistory) {
      roulette.addToHistory(number);
    }
    return roulette;
  }
}

// Use in tests
test('prediction works with sample data', () {
  final roulette = TestData.createRouletteWithHistory();
  expect(roulette.predictNext(), equals(7));
});
```

### Test Helpers

```dart
// test/helpers/test_helpers.dart
extension WidgetTesterExtensions on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
  }
  
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }
  
  Future<void> enterTextAndSubmit(String text) async {
    await enterText(find.byType(TextField), text);
    await testTextInput.receiveAction(TextInputAction.done);
    await pumpAndSettle();
  }
}

// Use in tests
testWidgets('login flow', (tester) async {
  await tester.pumpApp(const LoginScreen());
  await tester.enterTextAndSubmit('test@example.com');
  expect(find.byType(MainScreen), findsOneWidget);
});
```

### Custom Matchers

```dart
// test/matchers/custom_matchers.dart
Matcher inInclusiveRange(num min, num max) {
  return _InRangeMatcher(min, max);
}

class _InRangeMatcher extends Matcher {
  final num min;
  final num max;
  
  _InRangeMatcher(this.min, this.max);
  
  @override
  bool matches(dynamic item, Map matchState) {
    return item is num && item >= min && item <= max;
  }
  
  @override
  Description describe(Description description) {
    return description.add('a number between $min and $max inclusive');
  }
}

// Use in tests
expect(17, inInclusiveRange(0, 36));
```

## ⚙️ CI Testing Process

### GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run analyzer
        run: flutter analyze
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### Local Pre-Push Testing

```bash
#!/bin/bash
# scripts/pre-push-tests.sh

echo "Running pre-push checks..."

# Format check
echo "Checking format..."
dart format --set-exit-if-changed lib/ test/ || exit 1

# Analyze
echo "Running analyzer..."
flutter analyze --no-fatal-infos || exit 1

# Tests
echo "Running tests..."
flutter test || exit 1

echo "✅ All checks passed!"
```

Make executable and use:
```bash
chmod +x scripts/pre-push-tests.sh
./scripts/pre-push-tests.sh
```

## 📋 Best Practices

### 1. Test Naming

```dart
// ✅ Descriptive names
test('generateSpin returns number between 0 and 36')
test('predictNext returns most frequent number from history')
test('Martingale doubles bet after loss')

// ❌ Vague names
test('test1')
test('it works')
test('spin test')
```

### 2. One Concept Per Test

```dart
// ✅ Single responsibility
test('updates balance after win', () { ... });
test('shows win message', () { ... });
test('adds to win streak', () { ... });

// ❌ Multiple concepts
test('handles win', () {
  // Updates balance
  // Shows message  
  // Updates streak
  // Plays sound
});
```

### 3. Arrange-Act-Assert

```dart
test('description', () {
  // Arrange: Setup
  final roulette = RouletteLogic();
  
  // Act: Execute
  final result = roulette.generateSpin();
  
  // Assert: Verify
  expect(result, inInclusiveRange(0, 36));
});
```

### 4. Use setUp and tearDown

```dart
group('RouletteLogic', () {
  late RouletteLogic roulette;
  
  setUp(() {
    roulette = RouletteLogic();
  });
  
  tearDown() {
    // Cleanup if needed
  });
  
  test('test 1', () { ... });
  test('test 2', () { ... });
});
```

### 5. Don't Test Implementation Details

```dart
// ✅ Test behavior
test('balance decreases by bet amount', () {
  game.placeBet(10);
  expect(game.balance, equals(990));
});

// ❌ Test implementation
test('_updateBalance is called', () {
  game.placeBet(10);
  verify(game._updateBalance).called(1);
});
```

### 6. Make Tests Independent

```dart
// ✅ Each test is independent
test('test 1', () {
  final roulette = RouletteLogic();
  // ...
});

test('test 2', () {
  final roulette = RouletteLogic();
  // ...
});

// ❌ Tests depend on each other
late RouletteLogic roulette;

test('test 1', () {
  roulette = RouletteLogic();
  roulette.spin();
});

test('test 2', () {
  // Depends on test 1 having run
  expect(roulette.history.length, equals(1));
});
```

### 7. Test Edge Cases

```dart
group('edge cases', () {
  test('empty input');
  test('null input');
  test('maximum value');
  test('minimum value');
  test('negative value');
  test('zero value');
  test('very large value');
  test('special characters');
});
```

### 8. Use Descriptive Variables

```dart
// ✅ Clear intent
test('returns most frequent number', () {
  final mostFrequentNumber = 7;
  final lessFrequentNumber = 15;
  
  roulette.addToHistory(mostFrequentNumber);
  roulette.addToHistory(mostFrequentNumber);
  roulette.addToHistory(lessFrequentNumber);
  
  expect(roulette.predictNext(), equals(mostFrequentNumber));
});
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Test-Driven Development](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)

## ✅ Testing Checklist

Before committing:
- [ ] All tests pass locally
- [ ] New code has tests
- [ ] Coverage ≥80%
- [ ] Tests follow naming conventions
- [ ] No flaky tests
- [ ] No skipped tests (unless documented)

---

**Questions about testing?** Check [CONTRIBUTING.md](../CONTRIBUTING.md) or open an [issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues).

**Last Updated:** December 2024
