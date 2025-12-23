# Test Directory

This directory contains all automated tests for the Tokyo Roulette Predictor application.

## 📁 Directory Structure

```
test/
├── unit/                       # Unit tests for business logic
│   ├── roulette_logic_test.dart    # Tests for RouletteLogic & MartingaleAdvisor
│   └── validators_test.dart         # Tests for validation utilities
├── widget/                     # Widget tests for UI components
│   ├── login_screen_test.dart      # Tests for LoginScreen widget
│   └── main_screen_test.dart       # Tests for MainScreen widget
├── fixtures/                   # Test data and fixtures
│   ├── user_fixtures.dart          # User-related test data
│   └── roulette_fixtures.dart      # Game-related test data
├── helpers/                    # Test utilities and helpers
│   └── widget_tester_extension.dart # WidgetTester extensions
├── performance/                # Performance and benchmark tests
│   └── roulette_performance_test.dart
├── golden/                     # Golden/screenshot tests (future)
├── mocks/                      # Mock objects (future)
├── coverage_helper_test.dart   # Coverage tracking helper
├── roulette_logic_test.dart    # Legacy test (kept for compatibility)
└── widget_test.dart            # Legacy test (kept for compatibility)
```

## 🏃 Running Tests

### All Tests
```bash
flutter test
```

### Specific Test Category
```bash
flutter test test/unit/          # Unit tests only
flutter test test/widget/        # Widget tests only
flutter test test/performance/   # Performance tests only
```

### With Coverage
```bash
flutter test --coverage
```

### Using Scripts
```bash
./scripts/test.sh                # Complete test suite with coverage
./scripts/test_unit.sh           # Unit tests only
./scripts/test_widget.sh         # Widget tests only
./scripts/test_integration.sh    # Integration tests
```

## 📊 Test Statistics

- **Unit Tests**: 170+ test cases
  - RouletteLogic: 87 tests
  - Validators: 80+ tests
- **Widget Tests**: 100+ test cases
  - LoginScreen: 40+ tests
  - MainScreen: 60+ tests
- **Integration Tests**: 10+ scenarios
- **Performance Tests**: 15+ benchmarks

## 🎯 Coverage Goals

- Overall: >80%
- Business Logic: >90%
- UI Components: >70%

## 📚 More Information

See [TESTING.md](../docs/TESTING.md) for comprehensive testing documentation including:
- How to write tests
- Best practices
- Troubleshooting
- CI/CD integration

## 🔗 Integration Tests

Integration tests are located in the separate `integration_test/` directory at the project root:
```
integration_test/
└── app_test.dart    # End-to-end user flow tests
```

Run integration tests with:
```bash
flutter test integration_test/
```

## 🧪 Test Naming Convention

Tests follow these naming patterns:
- `*_test.dart` - All test files
- `test('description', () {})` - Individual test cases
- `group('GroupName', () {})` - Grouped related tests

## 💡 Quick Tips

1. **Run tests before committing**: Always ensure tests pass locally
2. **Write tests for new features**: Every new feature should have tests
3. **Fix broken tests immediately**: Don't let tests stay red
4. **Keep tests fast**: Tests should run quickly for rapid feedback
5. **Make tests independent**: Tests should not depend on each other
6. **Use fixtures**: Reuse test data from fixtures/ directory
7. **Use helpers**: Utilize helpers for common test patterns

## 🐛 Debugging Tests

### Run a single test
```bash
flutter test test/unit/roulette_logic_test.dart
```

### Run with verbose output
```bash
flutter test --verbose
```

### Debug in VS Code
1. Open test file
2. Click "Debug" above the test
3. Set breakpoints as needed

## 📝 Contributing

When adding new tests:
1. Place them in the appropriate directory
2. Follow existing test patterns
3. Add test data to fixtures if reusable
4. Update this README if adding new categories
5. Ensure all tests pass before committing

## ✅ Test Checklist

Before merging code:
- [ ] All tests pass
- [ ] New features have tests
- [ ] Coverage hasn't decreased
- [ ] No flaky tests
- [ ] Tests are well-documented
