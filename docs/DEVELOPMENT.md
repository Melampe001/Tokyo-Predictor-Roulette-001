# 💻 Development Guide

This guide covers day-to-day development workflows, coding standards, and best practices for Tokyo Roulette Predicciones.

## 📋 Table of Contents

- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Git Workflow](#git-workflow)
- [Testing](#testing)
- [Linting and Code Quality](#linting-and-code-quality)
- [Debugging](#debugging)
- [State Management](#state-management)
- [Dependency Management](#dependency-management)
- [Common Development Tasks](#common-development-tasks)

## 📁 Project Structure

### Overview

```
Tokyo-Predictor-Roulette-001/
├── .github/
│   ├── workflows/          # CI/CD pipelines
│   │   ├── ci.yml         # Continuous integration
│   │   ├── release.yml    # Release automation
│   │   ├── pr-checks.yml  # Pull request checks
│   │   └── ...
│   └── dependabot.yml     # Dependency updates
├── android/                # Android native code
│   ├── app/
│   │   ├── build.gradle   # App-level Gradle config
│   │   └── src/main/
│   │       └── AndroidManifest.xml
│   └── gradle.properties  # Gradle settings
├── assets/                 # Static resources
│   └── images/            # Image assets
├── docs/                   # Documentation
│   ├── ARCHITECTURE.md    # System architecture
│   ├── FIREBASE_SETUP.md  # Firebase integration
│   ├── USER_GUIDE.md      # User manual
│   └── ...
├── lib/                    # Dart application code
│   ├── main.dart          # Entry point & UI
│   └── roulette_logic.dart # Business logic
├── linux/                  # Linux platform code (optional)
├── scripts/                # Build and automation scripts
│   ├── health_agent.py    # Project health checker
│   ├── keystore_manager.sh # Keystore management
│   └── ...
├── test/                   # Test files
│   ├── widget_test.dart   # UI tests
│   └── roulette_logic_test.dart # Unit tests
├── .gitignore             # Git ignore rules
├── analysis_options.yaml  # Linter configuration
├── pubspec.yaml          # Dependencies & metadata
├── README.md             # Project overview
├── CONTRIBUTING.md       # Contribution guide
├── CHANGELOG.md          # Version history
└── LICENSE               # MIT license

```

### Key Directories

#### `lib/` - Application Source Code

Currently organized as a simple structure:
- `main.dart`: Contains UI screens (LoginScreen, MainScreen)
- `roulette_logic.dart`: Business logic (RouletteLogic, MartingaleAdvisor)

**Recommended Structure for Future Growth:**
```
lib/
├── main.dart                  # App entry point
├── screens/                   # Full-page screens
│   ├── login_screen.dart
│   └── main_screen.dart
├── widgets/                   # Reusable UI components
│   ├── roulette_wheel.dart
│   ├── bet_display.dart
│   └── history_display.dart
├── logic/                     # Business logic
│   ├── roulette_logic.dart
│   └── martingale_advisor.dart
├── models/                    # Data models
│   └── game_state.dart
├── services/                  # External services
│   ├── firebase_service.dart
│   ├── storage_service.dart
│   └── analytics_service.dart
├── utils/                     # Utilities
│   ├── constants.dart
│   └── helpers.dart
└── theme/                     # Theme and styling
    └── app_theme.dart
```

#### `test/` - Test Files

Mirror the structure of `lib/`:
```
test/
├── widget_test.dart           # UI/Widget tests
├── roulette_logic_test.dart   # Unit tests for logic
└── integration_test/          # Integration tests (future)
    └── app_test.dart
```

#### `android/` - Android Platform Code

Key files:
- `app/build.gradle`: Android build configuration
- `app/src/main/AndroidManifest.xml`: App permissions and metadata
- `key.properties`: Signing configuration (local, not committed)

#### `.github/workflows/` - CI/CD

Automated workflows:
- `ci.yml`: Runs on every push/PR (lint, test, build)
- `release.yml`: Triggered by version tags (v*.*.*)
- `pr-checks.yml`: Additional PR validation
- `project-health-check.yml`: Weekly health audit

## 📝 Coding Standards

### Dart Style Guide

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

#### Naming Conventions

```dart
// Classes: PascalCase
class RouletteLogic { }
class MartingaleAdvisor { }

// Variables and methods: camelCase
int currentNumber = 0;
void spinWheel() { }

// Constants: camelCase (not SCREAMING_CASE)
const double initialBalance = 1000.0;
const int maxHistorySize = 20;

// Private members: leading underscore
double _balance = 0.0;
void _updateUI() { }

// Files: snake_case
// main.dart
// roulette_logic.dart
// martingale_advisor.dart
```

#### Code Formatting

**String Literals:**
```dart
// ✅ Use single quotes for strings
const String appName = 'Tokyo Roulette';

// ❌ Avoid double quotes (unless interpolating)
const String appName = "Tokyo Roulette";

// ✅ Use double quotes for interpolation
final message = "Welcome, $userName!";
```

**Trailing Commas:**
```dart
// ✅ Always use trailing commas for better diffs
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Line 1'),
      Text('Line 2'),  // <-- trailing comma
    ],  // <-- trailing comma
  );
}
```

**Line Length:**
```dart
// ✅ Keep lines under 80-100 characters
final longMessage = 'This is a very long message that should '
    'be split across multiple lines for readability';

// ✅ Break method chains
final result = someObject
    .method1()
    .method2()
    .method3();
```

**Const Constructors:**
```dart
// ✅ Use const where possible for performance
const Text('Static text')
const SizedBox(height: 16)
const Icon(Icons.casino)

// ❌ Avoid unnecessary non-const widgets
Text('Static text')  // Should be const
```

#### Documentation Comments

Use `///` for public APIs:

```dart
/// Generates a random roulette number using cryptographically secure RNG.
///
/// Returns an integer between 0 and 36, inclusive, representing
/// a number on a standard European roulette wheel.
///
/// Example:
/// ```dart
/// final logic = RouletteLogic();
/// final number = logic.generateSpin();  // 0-36
/// ```
///
/// See also:
/// - [predictNext] for getting prediction suggestions
int generateSpin() {
  return wheel[rng.nextInt(wheel.length)];
}
```

Use `//` for implementation comments:

```dart
// Calculate new balance based on bet outcome
// Red/Black pays 1:1, Direct number pays 35:1
final winnings = isDirectHit ? bet * 35 : bet;
```

### Flutter Widget Best Practices

#### Prefer Composition Over Inheritance

```dart
// ✅ Compose smaller widgets
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(),
        UserName(),
        UserBio(),
      ],
    );
  }
}

// ❌ Avoid large, monolithic widgets
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 200 lines of widget code...
      ],
    );
  }
}
```

#### Extract Widgets Wisely

```dart
// ✅ Extract when reused or complex
class _SpinButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  
  const _SpinButton({required this.onPressed, required this.enabled});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: const Text('Girar'),
    );
  }
}

// ❌ Don't over-extract simple widgets
// No need to extract `Text('Hello')` to a separate widget
```

#### Use Keys Appropriately

```dart
// ✅ Use keys for lists with changing order
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),  // Stable key
      title: Text(items[index].name),
    );
  },
)
```

### Error Handling

```dart
// ✅ Catch specific exceptions
try {
  final result = await riskyOperation();
} on NetworkException catch (e) {
  showError('Network error: ${e.message}');
} on FormatException catch (e) {
  showError('Invalid data format');
} catch (e) {
  debugPrint('Unexpected error: $e');
  showError('An unexpected error occurred');
}

// ✅ Always validate user input
void updateBet(String input) {
  final bet = double.tryParse(input);
  if (bet == null || bet <= 0 || bet > _balance) {
    throw ArgumentError('Invalid bet amount');
  }
  _currentBet = bet;
}

// ✅ Use Result types for expected failures
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}
```

## 🌳 Git Workflow

### Branch Strategy

**Main Branches:**
- `main`: Production-ready code
- `develop` (optional): Integration branch for features

**Supporting Branches:**
- `feature/*`: New features (`feature/add-statistics`)
- `fix/*`: Bug fixes (`fix/balance-calculation`)
- `hotfix/*`: Urgent production fixes (`hotfix/critical-crash`)
- `refactor/*`: Code refactoring (`refactor/extract-services`)
- `docs/*`: Documentation updates (`docs/improve-readme`)
- `test/*`: Test additions (`test/add-martingale-tests`)

### Workflow Steps

**1. Start New Work:**
```bash
# Update main
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/my-feature

# Or use git flow syntax
git flow feature start my-feature
```

**2. Make Changes:**
```bash
# Make your changes
# Edit files...

# Check status
git status

# Stage changes
git add lib/main.dart test/widget_test.dart

# Or stage all
git add .
```

**3. Commit Changes:**
```bash
# Follow Conventional Commits
git commit -m "feat: add statistics dashboard"
git commit -m "fix: correct balance calculation"
git commit -m "docs: update API documentation"
git commit -m "test: add martingale edge cases"
git commit -m "refactor: extract roulette service"
git commit -m "chore: update dependencies"
```

**Commit Message Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, semicolons)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance (dependencies, config)
- `perf`: Performance improvement
- `ci`: CI/CD changes

**Examples:**
```bash
feat(roulette): add European wheel support

Implements a full European roulette wheel with numbers 0-36.
Uses cryptographically secure random number generation.

Closes #123

---

fix(martingale): correct bet doubling logic

The previous implementation didn't reset to base bet after win.
This fix ensures proper Martingale behavior.

Fixes #456

---

docs(api): document RouletteLogic methods

Adds comprehensive dartdoc comments to all public methods
with examples and parameter descriptions.
```

**4. Push Changes:**
```bash
# Push to remote
git push origin feature/my-feature

# First time pushing
git push -u origin feature/my-feature
```

**5. Create Pull Request:**

On GitHub, create a PR from your feature branch to `main`:
- Use descriptive title
- Fill out PR template
- Add screenshots for UI changes
- Link related issues
- Request reviewers

### Keeping Branch Updated

```bash
# Fetch latest changes
git fetch origin

# Rebase on main (preferred)
git checkout feature/my-feature
git rebase origin/main

# Or merge main into feature
git merge origin/main

# Resolve conflicts if any
# Edit conflicting files...
git add .
git rebase --continue  # or git merge --continue
```

### Code Review Process

**As Author:**
1. Ensure CI passes (tests, lint, build)
2. Self-review your changes
3. Respond to reviewer comments
4. Push additional commits to address feedback
5. Request re-review after changes

**As Reviewer:**
1. Check CI status first
2. Review code for:
   - Correctness
   - Code quality
   - Test coverage
   - Documentation
   - Security issues
3. Leave constructive comments
4. Approve or request changes

## 🧪 Testing

### Test Organization

```dart
// ✅ Organize tests with groups
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('RouletteLogic', () {
    late RouletteLogic roulette;

    setUp(() {
      roulette = RouletteLogic();
    });

    group('generateSpin', () {
      test('returns number between 0 and 36', () {
        final result = roulette.generateSpin();
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThanOrEqualTo(36));
      });

      test('returns different values over multiple spins', () {
        final spins = List.generate(100, (_) => roulette.generateSpin());
        final uniqueSpins = spins.toSet();
        expect(uniqueSpins.length, greaterThan(1));
      });
    });

    group('predictNext', () {
      test('returns null when history is empty', () {
        expect(roulette.predictNext(), isNull);
      });

      test('returns most frequent number', () {
        roulette.addToHistory(7);
        roulette.addToHistory(7);
        roulette.addToHistory(7);
        roulette.addToHistory(15);
        
        expect(roulette.predictNext(), equals(7));
      });
    });
  });
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/roulette_logic_test.dart

# With coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Watch mode (re-run on changes)
flutter test --watch

# Verbose output
flutter test --verbose

# Update golden files (for widget tests)
flutter test --update-goldens
```

### Test-Driven Development (TDD)

**Red-Green-Refactor Cycle:**

1. **Red**: Write a failing test
```dart
test('calculates winnings for direct hit', () {
  final advisor = MartingaleAdvisor();
  final winnings = advisor.calculateWinnings(bet: 10, isDirectHit: true);
  expect(winnings, equals(350));  // FAILS - method doesn't exist
});
```

2. **Green**: Make it pass (minimal code)
```dart
double calculateWinnings({required double bet, required bool isDirectHit}) {
  return isDirectHit ? bet * 35 : bet;
}
```

3. **Refactor**: Improve code quality
```dart
double calculateWinnings({required double bet, required bool isDirectHit}) {
  const directHitMultiplier = 35;
  const evenMoneyMultiplier = 1;
  
  final multiplier = isDirectHit ? directHitMultiplier : evenMoneyMultiplier;
  return bet * multiplier;
}
```

### Widget Testing

```dart
testWidgets('spin button updates result', (WidgetTester tester) async {
  // Build widget
  await tester.pumpWidget(const MaterialApp(home: MainScreen()));
  
  // Find widgets
  final spinButton = find.text('Girar');
  expect(spinButton, findsOneWidget);
  
  // Interact
  await tester.tap(spinButton);
  await tester.pump();  // Rebuild
  
  // Verify
  expect(find.text('Resultado:'), findsOneWidget);
});
```

### Mocking

```dart
// Using mockito
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([RouletteService])
void main() {
  test('handles service error gracefully', () async {
    final mockService = MockRouletteService();
    
    when(mockService.spin())
        .thenThrow(NetworkException('Connection failed'));
    
    final controller = RouletteController(mockService);
    await controller.spin();
    
    expect(controller.error, isNotNull);
  });
}
```

## 🔍 Linting and Code Quality

### Running the Linter

```bash
# Analyze all code
flutter analyze

# Treat all issues as errors (CI mode)
flutter analyze --fatal-infos

# Analyze specific file
flutter analyze lib/main.dart

# Watch mode
flutter analyze --watch
```

### Linter Configuration

Edit `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    # Style
    - prefer_single_quotes
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_unnecessary_containers
    
    # Error prevention
    - always_declare_return_types
    - avoid_print
    - avoid_returning_null_for_void
    - cancel_subscriptions
    - close_sinks
    
    # Best practices
    - use_key_in_widget_constructors
    - sized_box_for_whitespace
    - prefer_final_fields
```

### Auto-Fix Issues

```bash
# Format code
dart format lib/ test/

# Check formatting without modifying
dart format --set-exit-if-changed lib/

# Fix some linter issues automatically
dart fix --apply
```

### Pre-Commit Checks

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash

echo "Running pre-commit checks..."

# Format check
dart format --set-exit-if-changed lib/ test/
if [ $? -ne 0 ]; then
  echo "❌ Code not formatted. Run: dart format ."
  exit 1
fi

# Analyze
flutter analyze --no-fatal-infos
if [ $? -ne 0 ]; then
  echo "❌ Linter errors found"
  exit 1
fi

# Tests
flutter test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed"
  exit 1
fi

echo "✅ Pre-commit checks passed"
exit 0
```

## 🐛 Debugging

### Print Debugging

```dart
// ✅ Use debugPrint for development
debugPrint('Balance: $_balance');

// ✅ Conditional debug output
assert(() {
  debugPrint('Debug mode: Balance calculation details');
  return true;
}());

// ❌ Avoid print() - causes lint errors
print('Balance: $_balance');
```

### Flutter DevTools

**Launch DevTools:**
```bash
# Start app in debug mode
flutter run

# In another terminal
flutter pub global activate devtools
flutter pub global run devtools
```

**DevTools Features:**
- **Inspector**: Widget tree visualization
- **Timeline**: Performance profiling
- **Memory**: Memory usage and leaks
- **Network**: HTTP request monitoring
- **Logging**: Console output

### Debugging in IDE

**VS Code:**
1. Set breakpoints (click left of line number)
2. Press F5 or Run → Start Debugging
3. Use Debug Console for expressions

**Android Studio:**
1. Set breakpoints (click left gutter)
2. Click Debug button or Shift+F9
3. Use Debug panel for stack traces

**Useful Breakpoints:**
```dart
// Conditional breakpoint
if (balance < 0) {
  debugger();  // Pause here when condition is true
}

// Log point (doesn't pause)
debugPrint('Spin result: $result');
```

### Common Debugging Scenarios

**UI not updating:**
```dart
// ✅ Ensure setState is called
void _updateBalance(double amount) {
  setState(() {
    _balance += amount;
  });
}

// ✅ Check widget is StatefulWidget, not StatelessWidget
class MyWidget extends StatefulWidget {  // Not StatelessWidget
  // ...
}
```

**Async issues:**
```dart
// ✅ Await async operations
Future<void> _loadData() async {
  final data = await fetchData();  // Don't forget await
  setState(() {
    _data = data;
  });
}

// ✅ Handle errors
try {
  await riskyOperation();
} catch (e) {
  debugPrint('Error: $e');
}
```

**Performance issues:**
```bash
# Run in profile mode
flutter run --profile

# Use performance overlay
# In app: Press 'p' key

# Analyze build times
flutter run --trace-startup
```

## 🔄 State Management

### Current Approach: StatefulWidget + setState

The app currently uses simple state management:

```dart
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _balance = 1000.0;
  int? _currentNumber;
  List<int> _history = [];
  
  void _spin() {
    setState(() {
      _currentNumber = roulette.generateSpin();
      _history.add(_currentNumber!);
      _balance -= _currentBet;
    });
  }
}
```

### When to Use setState

**✅ Good for:**
- Simple, localized state
- Single-screen apps
- Prototypes

**❌ Consider alternatives when:**
- State shared across multiple screens
- Complex state logic
- Need to test business logic separately

### Future State Management Options

**Provider (Recommended for growth):**
```dart
// 1. Create provider
class GameState extends ChangeNotifier {
  double _balance = 1000.0;
  double get balance => _balance;
  
  void updateBalance(double amount) {
    _balance += amount;
    notifyListeners();
  }
}

// 2. Provide at app level
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MyApp(),
    ),
  );
}

// 3. Consume in widgets
class BalanceDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final balance = context.watch<GameState>().balance;
    return Text('Balance: \$${balance.toStringAsFixed(2)}');
  }
}
```

**Riverpod (More advanced):**
```dart
final gameStateProvider = StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(),
);

// In widget
final game State = ref.watch(gameStateProvider);
```

**Bloc (For complex apps):**
```dart
// Events
abstract class GameEvent {}
class SpinWheel extends GameEvent {}

// States
abstract class GameState {}
class SpinResult extends GameState {
  final int number;
  SpinResult(this.number);
}

// Bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<SpinWheel>((event, emit) {
      final result = roulette.generateSpin();
      emit(SpinResult(result));
    });
  }
}
```

## 📦 Dependency Management

### Adding Dependencies

```bash
# Add to dependencies
flutter pub add package_name

# Add to dev_dependencies
flutter pub add --dev package_name

# Add specific version
flutter pub add package_name:^1.0.0
```

**Always check security:**
```bash
# For supported ecosystems (npm, pip, etc.)
# The gh-advisory-database tool will check during PR
```

### Updating Dependencies

```bash
# Update all to latest compatible versions
flutter pub upgrade

# Update specific package
flutter pub upgrade package_name

# Check for outdated packages
flutter pub outdated

# Show dependency tree
flutter pub deps
```

### Version Constraints

In `pubspec.yaml`:
```yaml
dependencies:
  # Caret syntax: ^1.0.0 allows >=1.0.0 <2.0.0
  firebase_core: ^2.24.2
  
  # Range constraint
  intl: '>=0.18.0 <0.19.0'
  
  # Exact version (use sparingly)
  some_package: 1.2.3
  
  # Any version (avoid in production)
  dev_package: any
```

### Handling Dependency Conflicts

```bash
# Clear pub cache
flutter pub cache clean

# Remove pubspec.lock and reinstall
rm pubspec.lock
flutter pub get

# Force resolution with specific versions in pubspec.yaml
dependency_overrides:
  conflicting_package: ^2.0.0
```

## 🛠️ Common Development Tasks

### Creating a New Screen

**1. Create the file:**
```bash
touch lib/screens/statistics_screen.dart
```

**2. Implement the screen:**
```dart
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: Center(
        child: Text('Statistics content'),
      ),
    );
  }
}
```

**3. Add navigation:**
```dart
// In main screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const StatisticsScreen(),
  ),
);
```

**4. Write tests:**
```dart
testWidgets('StatisticsScreen shows title', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: StatisticsScreen()),
  );
  
  expect(find.text('Estadísticas'), findsOneWidget);
});
```

### Adding a New Service

**1. Create service file:**
```dart
// lib/services/analytics_service.dart
abstract class AnalyticsService {
  Future<void> logEvent(String name, Map<String, dynamic> parameters);
  Future<void> setUserProperty(String name, String value);
}

class FirebaseAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    // Implementation
  }
  
  @override
  Future<void> setUserProperty(String name, String value) async {
    // Implementation
  }
}
```

**2. Add tests:**
```dart
// test/services/analytics_service_test.dart
void main() {
  group('FirebaseAnalyticsService', () {
    test('logs event successfully', () async {
      final service = FirebaseAnalyticsService();
      await service.logEvent('spin', {'result': 7});
      // Verify
    });
  });
}
```

**3. Inject into widgets:**
```dart
class MyApp extends StatelessWidget {
  final AnalyticsService analytics;
  
  const MyApp({required this.analytics, super.key});
  
  // Use analytics in app
}
```

### Optimizing Build Performance

```bash
# Clean build
flutter clean
flutter pub get

# Build with tree-shake-icons
flutter build apk --tree-shake-icons

# Analyze app size
flutter build apk --analyze-size

# Profile performance
flutter run --profile
# Then use DevTools
```

**Code optimizations:**
```dart
// ✅ Use const constructors
const Text('Hello')
const SizedBox(height: 16)

// ✅ Extract expensive builds
@override
Widget build(BuildContext context) {
  // Expensive widget only rebuilds when needed
  return ExpensiveWidget();
}

// ✅ Use RepaintBoundary for complex widgets
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)

// ✅ Lazy load images
Image.network(url, loadingBuilder: ...)
```

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
- [State Management Guide](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)

## ✅ Development Checklist

Before committing:
- [ ] Code formatted: `dart format .`
- [ ] No lint errors: `flutter analyze`
- [ ] Tests pass: `flutter test`
- [ ] Changes tested manually
- [ ] Documentation updated
- [ ] Commit message follows conventions
- [ ] No secrets committed

Before creating PR:
- [ ] Branch up to date with main
- [ ] All tests pass
- [ ] Screenshots added (UI changes)
- [ ] PR template filled out
- [ ] Linked related issues
- [ ] Self-reviewed changes

---

**Questions?** Check [CONTRIBUTING.md](../CONTRIBUTING.md) or open an [issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues).

**Last Updated:** December 2024
