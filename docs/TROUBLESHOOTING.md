# 🔧 Troubleshooting Guide

Common issues, errors, and solutions for Tokyo Roulette Predicciones development and deployment.

## 📋 Table of Contents

- [Build Failures](#build-failures)
- [Firebase Issues](#firebase-issues)
- [Keystore and Signing](#keystore-and-signing)
- [Dependency Conflicts](#dependency-conflicts)
- [Android SDK Issues](#android-sdk-issues)
- [Flutter Version Problems](#flutter-version-problems)
- [Runtime Errors](#runtime-errors)
- [CI/CD Failures](#cicd-failures)
- [FAQ](#faq)
- [Getting Help](#getting-help)

## 🔨 Build Failures

### Error: Gradle build failed

**Symptoms:**
```
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':app:processDebugResources'.
```

**Solutions:**

**1. Clean and rebuild:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**2. Check Gradle version:**

Edit `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

**3. Update Gradle plugin:**

Edit `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.android.tools.build:gradle:7.3.0'
}
```

**4. Increase memory:**

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

### Error: Execution failed for task ':app:lintVitalRelease'

**Symptoms:**
```
> Lint found fatal errors while assembling a release target.
```

**Solutions:**

**1. Disable lint errors for release:**

Edit `android/app/build.gradle`:
```gradle
android {
    lintOptions {
        checkReleaseBuilds false
        // Or use:
        abortOnError false
    }
}
```

**2. Fix lint issues:**
```bash
cd android
./gradlew lint
# Review report in app/build/reports/lint-results.html
```

### Error: Minimum supported Gradle version

**Symptoms:**
```
The project requires Gradle 7.0 or newer. Current version is 6.x
```

**Solution:**

```bash
cd android
./gradlew wrapper --gradle-version 7.5
cd ..
flutter clean
flutter build apk
```

### Error: Out of memory during build

**Symptoms:**
```
Expiring Daemon because JVM heap space is exhausted
```

**Solution:**

**Method 1 - Increase heap size:**

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=1024m
```

**Method 2 - Disable parallel builds temporarily:**
```properties
org.gradle.parallel=false
```

**Method 3 - Close other applications to free memory**

### Error: Android SDK not found

**Symptoms:**
```
Android SDK not found. Define location with ANDROID_HOME environment variable
```

**Solution:**

```bash
# Find SDK location
flutter doctor -v

# Set ANDROID_HOME
# Linux/macOS (add to ~/.bashrc or ~/.zshrc):
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Windows (System Environment Variables):
ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk

# Verify
echo $ANDROID_HOME  # Should show SDK path
```

### Error: Build tools revision X.X.X is obsolete

**Solution:**

```bash
# Update Android SDK
flutter doctor --android-licenses
sdkmanager --update

# Or use Android Studio:
# Tools → SDK Manager → SDK Tools → Update Build Tools
```

## 🔥 Firebase Issues

### Error: google-services.json not found

**Symptoms:**
```
File google-services.json is missing. The Google Services Plugin cannot function without it.
```

**Solution:**

**1. Download from Firebase Console:**
- Go to [Firebase Console](https://console.firebase.google.com/)
- Select your project
- Click gear icon → Project settings
- Scroll to "Your apps"
- Click Download google-services.json

**2. Place in correct location:**
```bash
cp ~/Downloads/google-services.json android/app/
```

**3. Verify placement:**
```
android/
  app/
    google-services.json  ← Should be here
    src/
    build.gradle
```

### Error: FirebaseOptions not found

**Symptoms:**
```
Error: 'DefaultFirebaseOptions' isn't defined
```

**Solution:**

**1. Generate Firebase options:**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

**2. Uncomment Firebase initialization in main.dart:**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Error: Firebase initialization failed

**Symptoms:**
```
[core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Solution:**

```dart
// Ensure Firebase is initialized before use
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const MyApp());
}
```

### Error: Permission denied (Firebase)

**Symptoms:**
```
FirebaseException: Permission denied. Missing or insufficient permissions.
```

**Solution:**

**1. Check Firestore security rules:**

In Firebase Console → Firestore Database → Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write for authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**2. For development/testing (INSECURE - don't use in production):**
```javascript
match /{document=**} {
  allow read, write: if true;
}
```

## 🔐 Keystore and Signing

### Error: keystore file not found

**Symptoms:**
```
Keystore file '/path/to/keystore.jks' not found
```

**Solution:**

**1. Generate keystore:**
```bash
./scripts/keystore_manager.sh --generate
```

**2. Or manually:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

**3. Create key.properties:**

```bash
./scripts/keystore_manager.sh --create-properties
```

Or manually at `android/key.properties`:
```properties
storeFile=/full/path/to/upload-keystore.jks
storePassword=your_keystore_password
keyAlias=upload
keyPassword=your_key_password
```

### Error: Wrong keystore password

**Symptoms:**
```
Keystore was tampered with, or password was incorrect
```

**Solution:**

**1. Verify password:**
Try entering password manually when prompted

**2. Reset keystore (LAST RESORT):**
```bash
# Generate new keystore
./scripts/keystore_manager.sh --generate

# Update key.properties with new credentials
# ⚠️ You can't update existing published app with new keystore
```

### Error: Key alias not found

**Symptoms:**
```
Alias 'upload' does not exist in the keystore
```

**Solution:**

**1. List aliases in keystore:**
```bash
keytool -list -v -keystore ~/upload-keystore.jks
```

**2. Update key.properties with correct alias:**
```properties
keyAlias=correct_alias_name
```

### Error: Unsigned APK

**Symptoms:**
APK built but not signed for release

**Solution:**

**Check build.gradle configuration:**

`android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## 📦 Dependency Conflicts

### Error: Version solving failed

**Symptoms:**
```
Because package_a depends on package_b ^1.0.0 and package_c depends on package_b ^2.0.0,
package_a is incompatible with package_c.
```

**Solutions:**

**1. Update all dependencies:**
```bash
flutter pub upgrade
```

**2. Check for outdated packages:**
```bash
flutter pub outdated
```

**3. Use dependency overrides (temporary):**

In `pubspec.yaml`:
```yaml
dependency_overrides:
  package_b: ^2.0.0
```

**4. Clear pub cache:**
```bash
flutter pub cache repair
rm pubspec.lock
flutter pub get
```

### Error: Package not found

**Symptoms:**
```
Could not find package package_name at https://pub.dev
```

**Solutions:**

**1. Check package name spelling**

**2. Check package exists:**
Visit https://pub.dev/packages/package_name

**3. Check internet connection:**
```bash
ping pub.dev
```

**4. Clear cache and retry:**
```bash
flutter pub cache repair
flutter pub get
```

### Error: Git dependency not accessible

**Symptoms:**
```
Git error. Command: git clone --mirror
```

**Solution:**

```yaml
# Ensure Git URL is correct in pubspec.yaml
dependencies:
  my_package:
    git:
      url: https://github.com/user/repo.git
      ref: main  # or specific branch/tag

# For private repos, use SSH:
  my_package:
    git:
      url: git@github.com:user/repo.git
```

## 📱 Android SDK Issues

### Error: Android SDK not up to date

**Symptoms:**
```
✗ Android toolchain - develop for Android devices
  ✗ Android SDK not up to date
```

**Solution:**

```bash
# Accept licenses
flutter doctor --android-licenses

# Update SDK
sdkmanager --update

# Install required components
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

### Error: Android SDK build-tools not found

**Solution:**

```bash
# List installed build-tools
sdkmanager --list | grep build-tools

# Install specific version
sdkmanager "build-tools;33.0.0"

# Or use Android Studio:
# Tools → SDK Manager → SDK Tools → Android SDK Build-Tools
```

### Error: JAVA_HOME not set

**Symptoms:**
```
ERROR: JAVA_HOME is not set and no 'java' command could be found
```

**Solution:**

```bash
# Find Java installation
# macOS
/usr/libexec/java_home -V

# Linux
update-alternatives --list java

# Set JAVA_HOME
# Linux/macOS (add to ~/.bashrc or ~/.zshrc):
export JAVA_HOME=/path/to/jdk
export PATH=$PATH:$JAVA_HOME/bin

# Windows (System Environment Variables):
JAVA_HOME=C:\Program Files\Java\jdk-11

# Verify
echo $JAVA_HOME
java -version
```

## 🔄 Flutter Version Problems

### Error: Flutter version mismatch

**Symptoms:**
```
The current Flutter SDK version is X.X.X
This project requires Flutter SDK version >=Y.Y.Y
```

**Solution:**

**1. Check required version:**
See `pubspec.yaml`:
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
```

**2. Update Flutter:**
```bash
flutter upgrade

# Or switch to specific version
flutter version X.X.X
```

**3. Check current version:**
```bash
flutter --version
```

### Error: Flutter command not found after update

**Solution:**

```bash
# Re-add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Or reinstall Flutter
git clone https://github.com/flutter/flutter.git -b stable
```

### Error: Dart SDK version mismatch

**Solution:**

```bash
# Dart comes with Flutter, update Flutter
flutter upgrade

# Verify Dart version
dart --version
```

## 💥 Runtime Errors

### Error: RenderFlex overflow

**Symptoms:**
```
A RenderFlex overflowed by X pixels on the right
```

**Solution:**

**1. Wrap in SingleChildScrollView:**
```dart
SingleChildScrollView(
  child: Column(
    children: [...],
  ),
)
```

**2. Use Flexible or Expanded:**
```dart
Row(
  children: [
    Flexible(
      child: Text('Long text...'),
    ),
  ],
)
```

**3. Constrain size:**
```dart
SizedBox(
  width: MediaQuery.of(context).size.width * 0.8,
  child: Text('Long text...'),
)
```

### Error: setState called after dispose

**Symptoms:**
```
setState() called after dispose()
```

**Solution:**

```dart
void _updateData() async {
  final data = await fetchData();
  
  // Check if widget is still mounted
  if (mounted) {
    setState(() {
      _data = data;
    });
  }
}

@override
void dispose() {
  // Cancel subscriptions
  _subscription?.cancel();
  _controller?.dispose();
  super.dispose();
}
```

### Error: Null check operator used on null value

**Symptoms:**
```
Null check operator used on a null value
```

**Solution:**

```dart
// ❌ Don't use ! without checking
final value = myVariable!;

// ✅ Check for null first
if (myVariable != null) {
  final value = myVariable!;
}

// ✅ Use null-aware operators
final value = myVariable ?? defaultValue;
final result = myObject?.method();
```

### Error: Bad state: No element

**Symptoms:**
```
Bad state: No element
```

**Solution:**

```dart
// ❌ Don't use .first on potentially empty list
final first = list.first;

// ✅ Check if list is not empty
if (list.isNotEmpty) {
  final first = list.first;
}

// ✅ Use firstWhere with orElse
final item = list.firstWhere(
  (e) => e.id == targetId,
  orElse: () => defaultItem,
);
```

### Error: Type cast error

**Symptoms:**
```
type 'String' is not a subtype of type 'int'
```

**Solution:**

```dart
// ❌ Unsafe cast
final number = json['value'] as int;

// ✅ Safe parsing
final number = int.tryParse(json['value'].toString()) ?? 0;

// ✅ Type check before cast
if (json['value'] is int) {
  final number = json['value'] as int;
}
```

## 🤖 CI/CD Failures

### Error: CI build fails but local build succeeds

**Possible causes:**

**1. Environment differences:**
```bash
# Check CI Flutter version
# Compare with local
flutter --version
```

**2. Missing files:**
```bash
# Ensure all required files are committed
git status
```

**3. Platform-specific issues:**
```yaml
# In .github/workflows/ci.yml
runs-on: ubuntu-latest  # vs macOS-latest
```

**4. Secrets not configured:**
- Check GitHub repository secrets
- Verify secret names match workflow

### Error: Tests pass locally but fail in CI

**Solutions:**

**1. Run tests exactly as CI does:**
```bash
flutter test --coverage
flutter analyze --no-fatal-infos
```

**2. Check for timing issues:**
```dart
// Use pumpAndSettle instead of pump
await tester.pumpAndSettle();
```

**3. Ensure tests are deterministic:**
```dart
// Don't rely on current time, random values, etc.
// Use mocks and fixtures
```

### Error: Artifact upload failed

**Check workflow file:**
```yaml
- name: Upload APK
  uses: actions/upload-artifact@v3
  with:
    name: app-release
    path: build/app/outputs/flutter-apk/app-release.apk
```

**Verify APK exists:**
```bash
ls -la build/app/outputs/flutter-apk/
```

## ❓ FAQ

### Q: Why is my app size so large?

**A: Several reasons:**

**1. Not using --release:**
```bash
# Debug APK is 40-60MB larger
flutter build apk --release
```

**2. Not using app bundle:**
```bash
# App bundles generate optimized APKs per device
flutter build appbundle
```

**3. Unused packages:**
```bash
# Remove unused dependencies from pubspec.yaml
flutter pub get
```

**4. Large assets:**
```bash
# Optimize images
# Use vector graphics where possible
# Consider lazy loading assets
```

### Q: How do I reset my development environment?

**A: Complete reset:**
```bash
# Stop all Flutter processes
flutter doctor --kill

# Clean project
flutter clean

# Clear pub cache
flutter pub cache clean

# Remove pubspec.lock
rm pubspec.lock

# Reinstall dependencies
flutter pub get

# Restart IDE
```

### Q: Why is hot reload not working?

**A: Possible solutions:**

**1. Hot restart instead:**
```
Press R (capital) for hot restart
```

**2. Some changes require restart:**
- Changes to `main()`
- Changes to global variables
- Native code changes

**3. Restart app:**
```bash
flutter run
```

### Q: How do I debug release builds?

**A: Use profile mode:**
```bash
# Profile mode: optimized but debuggable
flutter run --profile

# Can't debug release mode directly
# Release mode removes debug info
```

### Q: App crashes immediately after install

**A: Check:**

**1. Permissions in AndroidManifest.xml**

**2. ProGuard rules (if enabled):**

Add to `android/app/proguard-rules.pro`:
```
-keep class io.flutter.** { *; }
-keep class com.your.app.** { *; }
```

**3. Check crash logs:**
```bash
adb logcat | grep -i flutter
```

## 🆘 Getting Help

### Before Asking for Help

1. **Search existing issues:**
   - [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
   - [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

2. **Check Flutter documentation:**
   - [Flutter Troubleshooting](https://docs.flutter.dev/testing/common-errors)

3. **Run Flutter doctor:**
   ```bash
   flutter doctor -v
   ```

4. **Gather error information:**
   - Full error message
   - Stack trace
   - Steps to reproduce
   - Flutter/Dart versions
   - Device/OS information

### How to Report an Issue

**1. Create a new issue with:**

**Title:** Clear, descriptive summary
```
[Bug] App crashes when spinning with Martingale enabled
```

**Description:**
```markdown
## Description
App crashes immediately when clicking "Girar" button while Martingale strategy is active.

## Steps to Reproduce
1. Open app
2. Login with any email
3. Open settings (gear icon)
4. Enable Martingale
5. Click "Girar" button
6. App crashes

## Expected Behavior
Spin should complete and show result

## Actual Behavior
App crashes with error: [paste error]

## Environment
- Flutter version: 3.16.0
- Dart version: 3.2.0
- Device: Samsung Galaxy S21
- OS: Android 13
- App version: 1.0.0

## Stack Trace
```
[paste stack trace]
```

## Screenshots
[attach screenshots if applicable]

## Additional Context
Only happens with Martingale enabled. Works fine with Martingale disabled.
```

### Where to Get Help

**Project-specific:**
- [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- [GitHub Discussions](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)

**Flutter community:**
- [Flutter Discord](https://discord.gg/flutter)
- [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

**Documentation:**
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)
- [Project Docs](.)

## 📚 Additional Resources

- [Flutter Common Errors](https://docs.flutter.dev/testing/common-errors)
- [Android Developer Troubleshooting](https://developer.android.com/studio/troubleshoot)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

---

**Still stuck?** Open an [issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues) with details about your problem.

**Last Updated:** December 2024
