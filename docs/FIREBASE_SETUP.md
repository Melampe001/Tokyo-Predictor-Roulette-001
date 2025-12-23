# Firebase Complete Setup Guide

This is a comprehensive guide to configuring and using the Firebase integration in Tokyo Roulette Predictor.

## Quick Links
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Services Overview](#services-overview)
- [Troubleshooting](#troubleshooting)

## Quick Start

### 1. Install Tools
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase
```bash
firebase login
flutterfire configure
```

### 3. Deploy Rules
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

### 4. Enable Services in Firebase Console
- Authentication (Email/Password, Google, Anonymous)
- Cloud Firestore
- Cloud Storage
- Cloud Messaging

### 5. Update Code
Uncomment Firebase initialization lines in:
- `android/build.gradle` (classpaths)
- `android/app/build.gradle` (apply plugin lines)
- Update `lib/main.dart` to initialize Firebase services

## Detailed Setup

### Prerequisites

1. **Firebase Account**: [console.firebase.google.com](https://console.firebase.google.com)
2. **Firebase CLI**: `npm install -g firebase-tools`
3. **FlutterFire CLI**: `dart pub global activate flutterfire_cli`
4. **Flutter SDK**: Already installed

### Step 1: Create Firebase Project

1. Go to Firebase Console
2. Create new project: "tokyo-roulette-predictor"
3. Enable Google Analytics (recommended)
4. Note your project ID

### Step 2: Configure FlutterFire

```bash
# Navigate to project root
cd Tokyo-Predictor-Roulette-001

# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure

# Select your project
# Choose platforms: Android, iOS (as needed)
```

This generates:
- `lib/config/firebase_options.dart` (DO NOT commit)
- `android/app/google-services.json` (DO NOT commit)
- `ios/Runner/GoogleService-Info.plist` (DO NOT commit)

**Note**: These files are already in `.gitignore` for security.

### Step 3: Enable Firebase Services

#### Authentication
1. Go to Firebase Console → Authentication
2. Enable sign-in methods:
   - **Email/Password**: For email authentication
   - **Google**: For Google Sign-In (configure OAuth)
   - **Anonymous**: For guest access

#### Cloud Firestore
1. Go to Firestore Database
2. Create database in **production mode**
3. Choose your region (closest to users)
4. Deploy security rules: `firebase deploy --only firestore:rules`

#### Cloud Storage (Optional)
1. Go to Storage
2. Click "Get Started"
3. Choose same region as Firestore
4. Deploy security rules: `firebase deploy --only storage:rules`

#### Remote Config
1. Go to Remote Config
2. Add parameters (see table below)
3. Publish changes

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| min_bet_amount | Number | 1.0 | Minimum bet |
| max_bet_amount | Number | 1000.0 | Maximum bet |
| initial_balance | Number | 1000.0 | Starting balance |
| enable_martingale | Boolean | true | Enable strategy |
| maintenance_mode | Boolean | false | Maintenance flag |

### Step 4: Update Android Configuration

**android/build.gradle**:
Uncomment:
```gradle
classpath 'com.google.gms:google-services:4.4.0'
classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
classpath 'com.google.firebase:perf-plugin:1.4.2'
```

**android/app/build.gradle**:
Uncomment:
```gradle
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'
apply plugin: 'com.google.firebase.firebase-perf'
```

### Step 5: Initialize Firebase in App

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'services/firebase_auth_service.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';
import 'services/performance_service.dart';
import 'services/remote_config_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  final crashlytics = CrashlyticsService();
  await crashlytics.initialize();
  
  final analytics = AnalyticsService();
  await analytics.logAppOpen();
  
  final remoteConfig = RemoteConfigService();
  await remoteConfig.initialize();
  
  final notifications = NotificationService();
  await notifications.initialize();
  
  runApp(const MyApp());
}
```

### Step 6: Test Firebase Integration

1. Run the app: `flutter run`
2. Sign up a test user
3. Check Firebase Console:
   - Authentication: Verify user created
   - Firestore: Check data saved
   - Analytics: View events
   - Crashlytics: Verify initialization

## Services Overview

### Authentication Service
**File**: `lib/services/firebase_auth_service.dart`

Features:
- Email/Password authentication
- Google Sign-In
- Anonymous authentication
- Password reset
- Email verification
- Account linking

Usage:
```dart
final authService = FirebaseAuthService();

// Sign up
await authService.signUpWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

// Sign in
await authService.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

// Google Sign-In
await authService.signInWithGoogle();

// Anonymous
await authService.signInAnonymously();
```

### Firestore Service
**File**: `lib/services/firestore_service.dart`

Features:
- CRUD operations for users, predictions, game sessions
- Real-time listeners
- Pagination
- Batch operations
- Transactions

Usage:
```dart
final firestoreService = FirestoreService();

// Create user
await firestoreService.createUser(userModel);

// Get predictions
final predictions = await firestoreService.getUserPredictions(
  userId,
  limit: 20,
);

// Listen to changes
firestoreService.listenToUser(userId).listen((user) {
  // Handle user updates
});
```

### Analytics Service
**File**: `lib/services/analytics_service.dart`

Features:
- Event tracking (app_open, user_signup, prediction_made, etc.)
- User properties
- Screen tracking
- Custom parameters

Usage:
```dart
final analytics = AnalyticsService();

// Log events
await analytics.logAppOpen();
await analytics.logPredictionMade(
  predictedNumber: 7,
  betAmount: 10.0,
);

// Set user properties
await analytics.setTotalPredictions(50);
await analytics.setWinRate(0.45);
```

### Notification Service
**File**: `lib/services/notification_service.dart`

Features:
- FCM token management
- Foreground/background notifications
- Topic subscriptions
- Local notifications

Usage:
```dart
final notifications = NotificationService();

// Initialize
await notifications.initialize();

// Subscribe to topics
await notifications.subscribeToDailyChallenges();

// Get FCM token
final token = notifications.fcmToken;
```

### Remote Config Service
**File**: `lib/services/remote_config_service.dart`

Features:
- Dynamic configuration
- Feature flags
- A/B testing
- Fetch and activate

Usage:
```dart
final remoteConfig = RemoteConfigService();

// Initialize
await remoteConfig.initialize();

// Get values
final minBet = remoteConfig.minBetAmount;
final maxBet = remoteConfig.maxBetAmount;
final isMaintenanceMode = remoteConfig.isMaintenanceMode;
```

### Crashlytics Service
**File**: `lib/services/crashlytics_service.dart`

Features:
- Automatic crash reporting
- Custom error logging
- User identification
- Custom keys

Usage:
```dart
final crashlytics = CrashlyticsService();

// Log error
await crashlytics.logError(
  exception,
  stackTrace,
  reason: 'User action failed',
);

// Set user ID
await crashlytics.setUserId(userId);

// Set custom key
await crashlytics.setCustomKey('game_level', 5);
```

### Performance Service
**File**: `lib/services/performance_service.dart`

Features:
- Custom traces
- HTTP metrics
- Screen rendering traces
- Operation timing

Usage:
```dart
final performance = PerformanceService();

// Trace operation
await performance.traceOperation(
  'load_data',
  () async {
    // Your operation
  },
);

// Manual trace
final trace = await performance.startScreenLoadTrace('HomeScreen');
// ... do work ...
await performance.stopTrace(trace);
```

## Security

### Firestore Rules
Located in `firestore.rules`. Key rules:
- Users can only read/write their own data
- Predictions require authentication
- Game sessions are private
- Input validation on create operations

Deploy: `firebase deploy --only firestore:rules`

### Storage Rules
Located in `storage.rules`. Key rules:
- Profile pictures are public read
- Only owners can upload
- File size limits enforced
- Only images allowed

Deploy: `firebase deploy --only storage:rules`

### API Keys
- Never commit `google-services.json`
- Never commit `firebase_options.dart` (if using actual keys)
- Use environment variables for CI/CD
- All sensitive files in `.gitignore`

## Troubleshooting

### Firebase Not Initializing
**Problem**: App crashes on startup

**Solutions**:
1. Check `firebase_options.dart` exists in `lib/config/`
2. Verify `Firebase.initializeApp()` called before `runApp()`
3. Run `flutterfire configure` again
4. Clean build: `flutter clean && flutter pub get`

### Authentication Errors
**Problem**: Sign-in fails

**Solutions**:
1. Enable authentication method in Firebase Console
2. For Google Sign-In: Configure OAuth consent screen
3. For Google Sign-In on Android: Add SHA-1 fingerprint
4. Check network connectivity
5. Verify email format is valid

### Firestore Permission Denied
**Problem**: Cannot read/write to Firestore

**Solutions**:
1. Deploy security rules: `firebase deploy --only firestore:rules`
2. Ensure user is authenticated
3. Check user ID matches document owner
4. Review rules in Firebase Console

### Google Sign-In Not Working (Android)
**Problem**: Google Sign-In button doesn't work

**Solutions**:
1. Get SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
2. Add SHA-1 in Firebase Console → Project Settings → Your App
3. Download new `google-services.json`
4. Add to `android/app/`
5. Rebuild app

### Build Errors After Adding Firebase
**Problem**: Gradle build fails

**Solutions**:
1. Check `google-services.json` is in `android/app/`
2. Verify Firebase plugin lines are uncommented
3. Update Gradle version if needed
4. Clean and rebuild:
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   flutter build apk
   ```

### FCM Not Receiving Notifications
**Problem**: Push notifications don't arrive

**Solutions**:
1. Request notification permission
2. Get FCM token and verify it's saved
3. Test with Firebase Console → Cloud Messaging → Send test message
4. Check app is not in battery saver mode
5. Verify notification channel is created (Android)

## Testing

### Local Testing with Emulator
```bash
# Install Firebase emulators
firebase init emulators

# Start emulators
firebase emulators:start

# In app, connect to emulators (debug mode only):
if (kDebugMode) {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
}
```

### Testing Checklist
- [ ] User can sign up with email
- [ ] User can sign in with email
- [ ] User can reset password
- [ ] Google Sign-In works
- [ ] Anonymous sign-in works
- [ ] Data saves to Firestore
- [ ] Data retrieved from Firestore
- [ ] Real-time updates work
- [ ] Analytics events logged
- [ ] Remote Config values fetched
- [ ] Push notifications received
- [ ] App doesn't crash (Crashlytics)
- [ ] Performance traces visible

## Deployment Checklist

Before production deployment:

- [ ] Firebase project created
- [ ] All services enabled
- [ ] Security rules deployed
- [ ] Remote Config configured
- [ ] SHA-1 fingerprint added (Android)
- [ ] OAuth consent configured (Google Sign-In)
- [ ] Release keystore configured
- [ ] ProGuard rules added (if minifying)
- [ ] Budget alerts configured
- [ ] Test on real devices
- [ ] All sensitive files in `.gitignore`
- [ ] Documentation updated

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Firebase Console](https://console.firebase.google.com)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)

## Support

For issues:
1. Check this documentation
2. Review Firebase Console logs
3. Check Crashlytics dashboard
4. Review FlutterFire GitHub issues
5. Contact project maintainers

---

**Last Updated**: December 2024  
**Version**: 1.0.0
