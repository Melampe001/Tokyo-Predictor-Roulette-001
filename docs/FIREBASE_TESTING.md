# 🧪 Firebase Testing Guide for Tokyo Roulette Predictor

Guide for testing Firebase integration using emulators and mocks.

## 📋 Table of Contents

1. [Firebase Emulator Setup](#firebase-emulator-setup)
2. [Running Emulators](#running-emulators)
3. [Connecting App to Emulators](#connecting-app-to-emulators)
4. [Testing Each Service](#testing-each-service)
5. [Unit Testing with Mocks](#unit-testing-with-mocks)
6. [Integration Testing](#integration-testing)
7. [CI/CD Testing](#cicd-testing)

---

## Firebase Emulator Setup

### Install Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Verify installation
firebase --version

# Login to Firebase
firebase login
```

### Initialize Emulators

```bash
# Navigate to project root
cd /path/to/Tokyo-Predictor-Roulette-001

# Initialize Firebase (if not already done)
firebase init

# Select emulators to install:
# - Authentication Emulator
# - Firestore Emulator
# - Storage Emulator
# - Functions Emulator (optional)

# Configure emulator ports (default):
# - Auth: 9099
# - Firestore: 8080
# - Storage: 9199
# - UI: 4000
```

This will create/update `firebase.json` with emulator configuration (already done in this project).

---

## Running Emulators

### Start All Emulators

```bash
# Start all configured emulators
firebase emulators:start

# Start with data import
firebase emulators:start --import=./firebase-data

# Start with export on exit
firebase emulators:start --export-on-exit=./firebase-data
```

### Start Specific Emulators

```bash
# Only Auth and Firestore
firebase emulators:start --only auth,firestore

# Only Storage
firebase emulators:start --only storage
```

### Emulator UI

Once emulators are running, access the UI at:
- http://localhost:4000

Features:
- View Authentication users
- Browse Firestore collections
- Monitor Storage files
- View logs and requests

---

## Connecting App to Emulators

### Development Environment

Create `lib/firebase_emulator_config.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseEmulatorConfig {
  static Future<void> connectToEmulators() async {
    if (kDebugMode) {
      const useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: false);
      
      if (useEmulator) {
        // Auth Emulator
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        
        // Firestore Emulator
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        
        // Storage Emulator
        await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
        
        debugPrint('🔥 Connected to Firebase Emulators');
      }
    }
  }
}
```

### Update main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_emulator_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Connect to emulators in debug mode
  await FirebaseEmulatorConfig.connectToEmulators();
  
  runApp(const MyApp());
}
```

### Run App with Emulator

```bash
# Run with emulator flag
flutter run --dart-define=USE_EMULATOR=true

# Or add to launch.json (VS Code)
{
  "configurations": [
    {
      "name": "Flutter with Emulator",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=USE_EMULATOR=true"
      ]
    }
  ]
}
```

---

## Testing Each Service

### 1. Authentication Emulator

**Features:**
- No real emails sent
- No real passwords required
- Instant user creation
- Can view all users in UI

**Test Cases:**

```dart
// Test sign up
await authService.signUpWithEmail('test@example.com', 'password123');

// Test sign in
await authService.signInWithEmail('test@example.com', 'password123');

// Test anonymous auth
await authService.signInAnonymously();

// Verify in Emulator UI:
// http://localhost:4000/auth
```

### 2. Firestore Emulator

**Features:**
- No actual database usage
- Instant writes
- Can export/import data
- Security rules can be tested

**Test Cases:**

```dart
// Test create user
await firestoreService.createUser('user123', {
  'email': 'test@example.com',
  'displayName': 'Test User',
});

// Test save prediction
await firestoreService.savePrediction({
  'userId': 'user123',
  'predictedNumber': 7,
  'betAmount': 10.0,
  'result': 'pending',
});

// Test query
final predictions = await firestoreService.getRecentPredictions('user123', 10);

// Verify in Emulator UI:
// http://localhost:4000/firestore
```

### 3. Storage Emulator

**Features:**
- Local file storage
- Can test uploads/downloads
- Security rules can be tested

**Test Cases:**

```dart
// Test upload avatar
final file = File('/path/to/image.jpg');
final url = await storageService.uploadUserAvatar('user123', file);

// Test download
final data = await storageService.downloadData('users/user123/avatars/avatar.jpg');

// Test delete
await storageService.deleteUserAvatar('user123');

// Verify in Emulator UI:
// http://localhost:4000/storage
```

---

## Unit Testing with Mocks

### Setup Test Environment

**`test/helpers/firebase_mocks.dart`:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseCoreMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'test-api-key',
            'appId': 'test-app-id',
            'messagingSenderId': 'test-sender-id',
            'projectId': 'test-project-id',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    return null;
  });
}

Future<void> initializeFirebaseForTest() async {
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
}
```

### Example Unit Test

**`test/services/auth_service_test.dart`:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tokyo_roulette_predicciones/services/auth_service.dart';
import '../helpers/firebase_mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUpAll(() async {
    await initializeFirebaseForTest();
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService();
  });

  group('AuthService', () {
    test('signInWithEmail returns user on success', () async {
      // Arrange
      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      // Note: Need to inject mock in actual service
      // For now, this demonstrates the testing pattern

      // Assert
      expect(mockUser, isNotNull);
    });
  });
}
```

### Generate Mocks

```bash
# Install mockito
flutter pub add --dev mockito
flutter pub add --dev build_runner

# Generate mocks
flutter pub run build_runner build
```

---

## Integration Testing

### Setup Integration Tests

Create `integration_test/firebase_integration_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tokyo_roulette_predicciones/main.dart';
import 'package:tokyo_roulette_predicciones/services/auth_service.dart';
import 'package:tokyo_roulette_predicciones/services/firestore_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Integration', () {
    late AuthService authService;
    late FirestoreService firestoreService;

    setUpAll(() async {
      await Firebase.initializeApp();
      authService = AuthService();
      firestoreService = FirestoreService();
    });

    testWidgets('Complete user flow', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test sign up
      final user = await authService.signUpWithEmail(
        'integration.test@example.com',
        'Test123!',
      );
      expect(user, isNotNull);

      // Test create user profile
      await firestoreService.createUser(user!.uid, {
        'email': user.email,
        'displayName': 'Integration Test User',
      });

      // Test save prediction
      final predictionId = await firestoreService.savePrediction({
        'userId': user.uid,
        'predictedNumber': 7,
        'betAmount': 10.0,
        'result': 'pending',
      });
      expect(predictionId, isNotEmpty);

      // Cleanup
      await authService.deleteAccount();
    });
  });
}
```

### Run Integration Tests

```bash
# Run with emulator
firebase emulators:exec --only auth,firestore \
  'flutter test integration_test/firebase_integration_test.dart'

# Or manually:
# Terminal 1: firebase emulators:start
# Terminal 2: flutter test integration_test/
```

---

## CI/CD Testing

### GitHub Actions with Emulator

Create `.github/workflows/firebase-test.yml`:

```yaml
name: Firebase Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      
      - name: Install Firebase CLI
        run: npm install -g firebase-tools
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Start Firebase Emulators
        run: |
          firebase emulators:start --only auth,firestore &
          sleep 10  # Wait for emulators to start
      
      - name: Run tests with emulator
        run: flutter test --dart-define=USE_EMULATOR=true
      
      - name: Stop emulators
        if: always()
        run: pkill -f firebase
```

---

## Testing Checklist

Before deploying to production:

### Authentication
- [ ] Email sign up works
- [ ] Email sign in works
- [ ] Google Sign-In works
- [ ] Anonymous auth works
- [ ] Password reset works
- [ ] Email verification works
- [ ] Sign out works

### Firestore
- [ ] User creation works
- [ ] Prediction saving works
- [ ] Session tracking works
- [ ] Queries return correct data
- [ ] Real-time updates work
- [ ] Security rules are enforced

### Storage
- [ ] Avatar upload works
- [ ] File download works
- [ ] File deletion works
- [ ] Security rules are enforced

### Analytics
- [ ] Events are logged
- [ ] User properties are set
- [ ] Screen views are tracked

### Notifications
- [ ] Token is generated
- [ ] Foreground messages work
- [ ] Background messages work
- [ ] Topic subscription works

### Remote Config
- [ ] Values are fetched
- [ ] Defaults are set
- [ ] Feature flags work

### Crashlytics
- [ ] Crashes are reported
- [ ] Non-fatal errors are logged
- [ ] Custom logs are recorded

### Performance
- [ ] Traces are recorded
- [ ] Metrics are tracked

---

## Troubleshooting Emulator Issues

### Emulator won't start

```bash
# Check if ports are in use
lsof -i :9099  # Auth
lsof -i :8080  # Firestore
lsof -i :9199  # Storage

# Kill processes on ports
kill -9 $(lsof -t -i :9099)

# Reset emulator data
rm -rf ~/.config/firebase/emulators
```

### App not connecting to emulator

- Ensure emulators are running: `firebase emulators:start`
- Check `USE_EMULATOR` flag is set: `--dart-define=USE_EMULATOR=true`
- Verify localhost/127.0.0.1 (use 10.0.2.2 for Android emulator)
- Check firewall/antivirus settings

### Data persistence

```bash
# Export emulator data
firebase emulators:export ./firebase-data

# Import emulator data
firebase emulators:start --import=./firebase-data
```

---

## Resources

- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- [Testing with Firebase](https://firebase.google.com/docs/emulator-suite/connect_and_prototype)
- [FlutterFire Testing](https://firebase.flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

---

**Happy Testing! 🧪**
