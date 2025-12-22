# Copilot Instructions for Tokyo Roulette Predictor

## Project Overview
This is a Flutter/Dart educational roulette simulator with predictions, RNG (Random Number Generator), Martingale strategy implementation, and a freemium model. The app includes integrations with Stripe for payments and Firebase for remote configurations.

**Important**: This is an educational simulator only - it does not promote real gambling.

## Technology Stack
- **Framework**: Flutter (SDK >=3.0.0 <4.0.0)
- **Language**: Dart
- **Key Dependencies**:
  - `flutter_stripe`: Payment processing
  - `firebase_core`, `firebase_remote_config`, `cloud_firestore`, `firebase_auth`, `firebase_messaging`: Firebase integrations
  - `in_app_purchase`: In-app purchase support
  - `fl_chart`: Data visualization
  - `shared_preferences`: Local storage
  - `intl`: Internationalization
  - `device_info_plus`: Device information
  - `url_launcher`: External URL handling

## Project Structure
- `lib/`: Main application code
  - `main.dart`: Application entry point
  - `roulette_logic.dart`: Core roulette logic and predictions
- `test/`: Unit and widget tests
- `android/`: Android-specific configuration
- `docs/`: Documentation files
- `assets/images/`: Image assets

## Development Workflow

### Setup
1. Clone the repository: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

### Building
- **Development**: `flutter run`
- **Release APK**: `flutter build apk --release`
- **Testing**: `flutter test`

### Linting and Code Quality
- **Analyze code**: `flutter analyze --no-fatal-infos`
  - The project uses `package:flutter_lints/flutter.yaml`
  - Configuration is in `analysis_options.yaml`
- **Format code**: `dart format .`
- **Check formatting**: `dart format --set-exit-if-changed .`

### Testing
- Unit tests are located in the `test/` directory
- Run all tests with: `flutter test`
- Run specific test: `flutter test test/roulette_logic_test.dart`
- Run with coverage: `flutter test --coverage`
- Integration tests use the `integration_test` package

### CI/CD Workflows
The repository has automated workflows in `.github/workflows/`:
- **build-apk.yml**: Builds Android APK on push/PR to main
- **project-health-check.yml**: Weekly project health audits
- All workflows run `flutter analyze` and tests automatically

## Code Style and Conventions
- Follow Dart's official style guide
- Use meaningful variable and function names (Spanish comments are acceptable as the project is in Spanish)
- Keep functions focused and single-purpose
- Document complex algorithms, especially in `roulette_logic.dart`

## Firebase Configuration
The app uses Firebase for:
- **Remote Config**: Dynamic updates every 4 months
- **Firestore**: Email storage
- **Authentication**: User authentication for email handling
- **Messaging**: Push notifications for invitations

Ensure Firebase configuration files are properly set up before running.

## Stripe Integration
- Payment processing is handled through `flutter_stripe`
- Test mode should be used for development
- Never commit API keys or secrets to the repository

## Security Considerations
- **API Keys**: Never commit Firebase or Stripe API keys. Use environment variables or secure configuration management
- **Sensitive Data**: Handle user emails and payment information according to GDPR and privacy best practices
- **Authentication**: Use Firebase Auth for secure user authentication
- **Input Validation**: Validate all user inputs, especially in payment and betting logic

## Common Tasks

### Adding a New Feature
1. Create a new branch from `main`
2. Implement the feature in the appropriate file(s)
3. Add tests for the new functionality
4. Run tests: `flutter test`
5. Build and verify: `flutter run`
6. Submit a pull request

### Updating Dependencies
1. Update `pubspec.yaml`
2. Run `flutter pub get`
3. Test thoroughly to ensure compatibility
4. Check for security vulnerabilities in new dependencies

### Modifying Roulette Logic
- The core logic is in `lib/roulette_logic.dart`
- Ensure RNG remains truly random
- Document any changes to prediction algorithms
- Maintain the educational nature of the simulator

## Language and Localization
- The project supports internationalization via the `intl` package
- Primary language is Spanish
- Comments and documentation can be in Spanish or English
- UI text should be localized where appropriate

## Best Practices for AI Assistance
- When making changes, always consider the educational purpose of the app
- Maintain clear separation between free and premium features
- Ensure Firebase and Stripe integrations remain secure
- Test payment flows thoroughly in test mode before production
- Keep the disclaimer visible that this is a simulator, not real gambling

## Custom Agents
This repository has specialized custom agents available in `.github/agents/`:
- **repository-setup-agent**: Expert in complete repository setup with 110% perfection standards
- **security-agent**: Specialist in security reviews for educational Flutter apps

When working on tasks related to these domains, consider leveraging these specialized agents for better results.

## Project Health System
The repository includes an automated health check system:
- **Script**: `scripts/health_agent.py`
- **Run manually**: `python scripts/health_agent.py --full-scan`
- **Automated**: Runs weekly via GitHub Actions
- **Reports**: Generated in `reports/` directory
- The health score is monitored and should be kept above 70/100

## Using Ecosystem Tools

### Always prefer using Flutter/Dart tools for automation:

**Package Management:**
```bash
# Add dependencies (ALWAYS use pub add, not manual pubspec.yaml edits for new deps)
flutter pub add <package_name>
flutter pub add --dev <package_name>  # for dev dependencies

# Update dependencies
flutter pub upgrade
flutter pub outdated  # Check for outdated packages
```

**Code Generation:**
```bash
# For generated files (if using build_runner, json_serializable, etc.)
flutter pub run build_runner build
flutter pub run build_runner watch  # Continuous generation
```

**Platform Setup:**
```bash
# Create platform-specific code
flutter create --platforms=android,ios .
flutter create --org com.yourcompany --project-name app_name .
```

### Never manually edit these generated files:
- `*.g.dart` - Generated by build_runner
- `*.freezed.dart` - Generated by freezed
- `pubspec.lock` - Managed by pub
- `.flutter-plugins` and `.flutter-plugins-dependencies`

## Testing Strategy

### Test Organization
Tests are organized by type:
- **Unit tests** (`test/`): Test individual functions and classes
  - `roulette_logic_test.dart`: Tests for core roulette logic
  - Focus on testing pure functions and business logic
- **Widget tests** (`test/`): Test UI components in isolation
  - `widget_test.dart`: Tests for UI components
  - Use `WidgetTester` for pumping widgets and interactions
- **Integration tests** (future): Would go in `integration_test/`
  - Test complete user flows

### Running Tests

**Run all tests:**
```bash
flutter test
```

**Run specific test file:**
```bash
flutter test test/roulette_logic_test.dart
flutter test test/widget_test.dart
```

**Run with coverage:**
```bash
flutter test --coverage
# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # or your browser
```

**Run tests in watch mode:**
```bash
flutter test --watch
```

**Run tests with verbose output:**
```bash
flutter test --verbose
```

### Test Naming Conventions
Follow the AAA pattern (Arrange, Act, Assert):
```dart
test('generateSpin returns valid number between 0 and 36', () {
  // Arrange
  final roulette = RouletteLogic();
  
  // Act
  final result = roulette.generateSpin();
  
  // Assert
  expect(result, greaterThanOrEqualTo(0));
  expect(result, lessThanOrEqualTo(36));
});
```

### When to Add Tests
- **Always** add tests for new features
- **Always** add tests when fixing bugs (test the fix)
- Update tests when modifying existing functionality
- Widget tests for any UI changes
- Integration tests for critical user flows (future)

## Build and Release Process

### Development Builds
```bash
# Run in debug mode (hot reload enabled)
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run with specific flavor (if configured)
flutter run --flavor dev
flutter run --flavor prod
```

### Release Builds

**Android APK:**
```bash
# Build release APK
flutter build apk --release

# Build split APKs (smaller downloads)
flutter build apk --split-per-abi

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (recommended for Play Store):**
```bash
flutter build appbundle --release
# AAB location: build/app/outputs/bundle/release/app-release.aab
```

### Build Troubleshooting

**Clean build artifacts:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Check for build issues:**
```bash
flutter doctor -v  # Detailed system check
flutter doctor --android-licenses  # Accept Android licenses
```

**Gradle issues:**
```bash
cd android
./gradlew clean
./gradlew build --info  # Detailed build output
cd ..
```

## Code Quality and Linting

### Linting Commands

**Analyze all code:**
```bash
flutter analyze
```

**Analyze without treating infos as errors:**
```bash
flutter analyze --no-fatal-infos
```

**Format code:**
```bash
# Format all Dart files
dart format .

# Check formatting without modifying
dart format --set-exit-if-changed .

# Format specific files
dart format lib/ test/
```

### Lint Configuration
The project uses `flutter_lints` package with custom rules in `analysis_options.yaml`:
- Prefer single quotes for strings
- Always declare return types
- Avoid print statements (use proper logging)
- Close sinks and cancel subscriptions
- Prefer final fields where possible

### Pre-commit Checklist
Before committing code:
1. Run `flutter analyze --no-fatal-infos` (must pass)
2. Run `dart format .` (auto-format)
3. Run `flutter test` (all tests must pass)
4. Review changed files for unintended modifications
5. Ensure no sensitive data (API keys, secrets) in code

## Security Best Practices

### Critical Security Rules

**1. NEVER commit secrets or API keys:**
```dart
// ❌ BAD - Hardcoded API key
const stripeKey = 'sk_live_1234567890abcdef';

// ✅ GOOD - Use environment variables
const stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');

// ✅ GOOD - Use secure configuration
final stripeKey = await SecureStorage.read('stripe_key');
```

**2. Always use Random.secure() for gambling/gaming:**
```dart
// ❌ BAD - Predictable random
final rng = Random();

// ✅ GOOD - Cryptographically secure random
final rng = Random.secure();
```

**3. Validate all user inputs:**
```dart
// ✅ GOOD - Validate before using
void updateBet(String input) {
  final bet = double.tryParse(input);
  if (bet == null || bet <= 0 || bet > maxBet) {
    throw ArgumentError('Invalid bet amount');
  }
  _currentBet = bet;
}
```

**4. Sanitize data before displaying:**
```dart
// When displaying user input or external data
import 'package:html_escape/html_escape.dart';
final escaped = HtmlEscape().convert(userInput);
```

**5. Firebase Security Rules:**
Ensure Firebase security rules are properly configured:
- Never allow unrestricted read/write access
- Validate data structure and types
- Use authentication for sensitive operations
- Implement rate limiting

**6. Handle sensitive user data properly:**
- Follow GDPR for EU users
- Implement proper data encryption
- Provide data deletion mechanisms
- Log privacy-sensitive operations carefully

### Security Checklist for PRs
- [ ] No hardcoded API keys or secrets
- [ ] All user inputs are validated
- [ ] Using `Random.secure()` for random number generation
- [ ] Firebase rules are restrictive
- [ ] No sensitive data in logs
- [ ] Authentication is properly implemented
- [ ] Payment flows are secure (test mode for development)

## Firebase Configuration

### Setup Process
1. Create Firebase project at console.firebase.google.com
2. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. Configure Firebase: `flutterfire configure`
4. This generates `firebase_options.dart` (DO NOT commit if it contains secrets)

### Firebase Services Used

**Remote Config:**
- Updates app behavior without redeployment
- Refresh interval: Every 4 months
- Use for feature flags and dynamic values

**Firestore:**
- Stores user emails for notifications
- Implement proper security rules
- Use offline persistence for better UX

**Authentication:**
- Email authentication for user identification
- Anonymous auth for guest users (if implemented)
- Handle auth state changes properly

**Cloud Messaging:**
- Push notifications for user invitations
- Handle notification permissions properly
- Test on both Android and iOS

### Firebase Best Practices
```dart
// Initialize Firebase early
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Handle Firebase errors gracefully
try {
  await FirebaseFirestore.instance.collection('users').add(data);
} on FirebaseException catch (e) {
  print('Firebase error: ${e.code} - ${e.message}');
  // Show user-friendly error message
} catch (e) {
  print('Unexpected error: $e');
}

// Use offline persistence
await FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

## Stripe Integration

### Setup for Development
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ALWAYS use test keys in development
  const stripeKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_...',  // Test key only
  );
  
  if (stripeKey.isNotEmpty) {
    Stripe.publishableKey = stripeKey;
  }
  
  runApp(const MyApp());
}
```

### Payment Best Practices
- **Never** store card details directly
- Always use Stripe's tokenization
- Test payment flows in test mode
- Handle payment errors gracefully
- Implement proper retry logic
- Log payment attempts for debugging (no sensitive data)
- Show clear error messages to users

## Async/Await Patterns in Flutter

### Common Patterns

**1. Async initialization:**
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final data = await fetchData();
      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }
}
```

**2. Handle futures in UI:**
```dart
// Use FutureBuilder for one-time async operations
FutureBuilder<Data>(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    if (!snapshot.hasData) return CircularProgressIndicator();
    return DataWidget(data: snapshot.data!);
  },
)

// Use StreamBuilder for continuous updates
StreamBuilder<Event>(
  stream: eventStream,
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    if (!snapshot.hasData) return Text('Waiting...');
    return EventWidget(event: snapshot.data!);
  },
)
```

**3. Always check mounted before setState:**
```dart
Future<void> _updateData() async {
  final data = await fetchData();
  if (mounted) {  // ✅ Always check mounted
    setState(() {
      _data = data;
    });
  }
}
```

## Platform-Specific Code

### Android Configuration
Key files:
- `android/app/build.gradle`: App-level Gradle config
- `android/app/src/main/AndroidManifest.xml`: App manifest
- `android/gradle.properties`: Gradle properties
- `android/key.properties`: Signing configuration (NEVER commit)

**Minimum SDK:** Android 5.0 (API 21) or higher
**Target SDK:** Latest stable Android version

### iOS Configuration (if supporting iOS)
Key files:
- `ios/Runner/Info.plist`: App configuration
- `ios/Podfile`: CocoaPods dependencies

### Adding Permissions

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

**iOS (Info.plist):**
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for...</string>
```

## Common Flutter Issues and Solutions

### Hot Reload Not Working
```bash
# Stop and restart
r  # Hot reload
R  # Hot restart (more thorough)
q  # Quit

# If still not working
flutter clean
flutter pub get
flutter run
```

### Build Failures
```bash
# Clear all caches and rebuild
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter pub upgrade
flutter run
```

### Dependency Conflicts
```bash
# See dependency tree
flutter pub deps

# Update specific package
flutter pub upgrade <package_name>

# Force resolution
# Edit pubspec.yaml to specify exact versions
```

### Performance Issues
```bash
# Profile app performance
flutter run --profile

# Check for performance issues
flutter analyze --performance
```

## Troubleshooting CI/CD

### Build APK Workflow Issues

**Check workflow logs:**
1. Go to Actions tab in GitHub
2. Select the failed workflow run
3. Check each step for errors

**Common issues:**
- **Gradle timeout:** Increase timeout or check network
- **Signing issues:** Ensure keystore is properly configured
- **Dependency conflicts:** Run `flutter pub upgrade` locally first
- **Lint failures:** Fix all `flutter analyze` issues before pushing

**Local testing of CI:**
```bash
# Run same commands as CI locally
flutter --version
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release
```

## Code Patterns and Examples

### Good vs Bad Patterns

**State Management:**
```dart
// ❌ BAD - Mutable state without proper handling
class BadState {
  List<int> numbers = [];
  void addNumber(int n) => numbers.add(n);
}

// ✅ GOOD - Immutable state or proper encapsulation
class GoodState {
  final List<int> _numbers = [];
  List<int> get numbers => List.unmodifiable(_numbers);
  void addNumber(int n) {
    _numbers.add(n);
    notifyListeners();  // If using ChangeNotifier
  }
}
```

**Error Handling:**
```dart
// ❌ BAD - Silent failure
void processData(String data) {
  try {
    final parsed = int.parse(data);
    // ...
  } catch (e) {
    // Silent - bad!
  }
}

// ✅ GOOD - Proper error handling
void processData(String data) {
  try {
    final parsed = int.parse(data);
    // ...
  } on FormatException catch (e) {
    debugPrint('Invalid data format: $e');
    throw ArgumentError('Data must be a valid number');
  } catch (e) {
    debugPrint('Unexpected error: $e');
    rethrow;
  }
}
```

**Widget Building:**
```dart
// ❌ BAD - Building in build method
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Card(  // Creating new widgets on each scroll
        child: ExpensiveWidget(items[index]),
      );
    },
  );
}

// ✅ GOOD - Using const and keys
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Card(
        key: ValueKey(items[index].id),  // Stable key
        child: const OptimizedWidget(),  // Const where possible
      );
    },
  );
}
```

## Contributing to This Repository

### Before Starting Work
1. Check existing issues and PRs
2. Comment on the issue you want to work on
3. Wait for assignment/approval
4. Fork and create a feature branch

### Branch Naming
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Code refactoring
- `test/description` - Test additions/fixes

### Commit Message Format
Follow Conventional Commits:
```
feat: add user authentication with Firebase
fix: correct balance calculation in Martingale
docs: update README with Firebase setup
test: add tests for RouletteLogic.predictNext()
refactor: extract color logic to separate method
chore: update dependencies to latest versions
```

### Pull Request Process
1. Ensure all tests pass: `flutter test`
2. Run linter: `flutter analyze`
3. Format code: `dart format .`
4. Update documentation if needed
5. Add screenshots for UI changes
6. Fill out PR template completely
7. Link related issues
8. Request review from maintainers

## Educational Purpose Reminder

**This is a simulator for educational purposes only.**

When making changes:
- Maintain the educational disclaimer prominently
- Don't add features that could encourage real gambling
- Keep RNG truly random (Random.secure())
- Clearly mark this as simulation throughout UI
- Include responsible gambling resources

## Additional Resources

### Flutter Documentation
- [Official Flutter Docs](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/ui/widgets)

### Project Documentation
- [User Guide](../docs/USER_GUIDE.md)
- [Architecture](../docs/ARCHITECTURE.md)
- [Firebase Setup](../docs/FIREBASE_SETUP.md)
- [Health Agent](../docs/HEALTH_AGENT.md)
- [Contributing Guide](../CONTRIBUTING.md)

### Tools and Libraries
- [Stripe Flutter Plugin](https://pub.dev/packages/flutter_stripe)
- [Firebase Flutter](https://firebase.flutter.dev/)
- [FL Chart](https://pub.dev/packages/fl_chart)

---

**Last Updated:** December 2024
**Maintained by:** Tokyo Roulette Predictor Team
