# 🚀 Getting Started Guide

Welcome to Tokyo Roulette Predicciones! This guide will help you set up your development environment and get the app running locally.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Building for Production](#building-for-production)
- [Common Setup Issues](#common-setup-issues)
- [First-Time Developer Walkthrough](#first-time-developer-walkthrough)
- [Next Steps](#next-steps)

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

#### 1. Flutter SDK (3.0 or higher)

**Windows:**
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\src\flutter
# Add C:\src\flutter\bin to PATH
```

**macOS/Linux:**
```bash
# Using git
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Or using snap (Linux only)
sudo snap install flutter --classic
```

**Verify installation:**
```bash
flutter --version
# Should show Flutter 3.0.0 or higher
```

#### 2. Dart SDK (3.0 or higher)

Dart comes bundled with Flutter, but verify:
```bash
dart --version
# Should show Dart 3.0.0 or higher
```

#### 3. Development Tools

**Android Studio** (recommended) or **VS Code**

**Android Studio:**
- Download from https://developer.android.com/studio
- Install Flutter and Dart plugins
- Configure Android SDK (API 21 or higher)

**VS Code:**
```bash
# Install Flutter and Dart extensions
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
```

#### 4. Java Development Kit (JDK 11+)

**Check if installed:**
```bash
java -version
```

**Install if needed:**
- Windows: Download from https://adoptium.net/
- macOS: `brew install openjdk@11`
- Linux: `sudo apt-get install openjdk-11-jdk`

#### 5. Git

```bash
# Verify Git installation
git --version

# Configure Git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Optional Tools

- **Android Emulator**: For testing without physical device
- **Xcode** (macOS only): For iOS development
- **Firebase CLI**: For Firebase integration (optional feature)

## 📦 Installation

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git

# Navigate to project directory
cd Tokyo-Predictor-Roulette-001
```

### Step 2: Verify Flutter Setup

Run Flutter doctor to check your setup:

```bash
flutter doctor -v
```

**Expected output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on ...)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2023.x)
[✓] VS Code (version 1.x.x)
[✓] Connected device (1 available)
[✓] Network resources
```

**Fix any issues** reported by Flutter doctor before proceeding.

### Step 3: Install Dependencies

```bash
# Get all Flutter packages
flutter pub get
```

**Expected output:**
```
Running "flutter pub get" in Tokyo-Predictor-Roulette-001...
Resolving dependencies... 
+ firebase_core 2.24.2
+ flutter_stripe 10.0.0
+ ...
Got dependencies!
```

### Step 4: Configure Android

#### Accept Android Licenses

```bash
flutter doctor --android-licenses
# Accept all licenses by typing 'y'
```

#### Verify Android SDK

```bash
# Check Android SDK location
flutter config --android-sdk

# Should show path like: /Users/you/Library/Android/sdk
```

### Step 5: Set Up a Device

#### Option A: Physical Device

**Android:**
1. Enable Developer Options on your device
   - Go to Settings → About Phone
   - Tap Build Number 7 times
2. Enable USB Debugging
   - Settings → Developer Options → USB Debugging
3. Connect device via USB
4. Verify connection:
   ```bash
   flutter devices
   # Should show your device
   ```

**iOS (macOS only):**
1. Connect iPhone/iPad via USB
2. Trust the computer on your device
3. Run: `flutter devices`

#### Option B: Emulator

**Android Emulator:**
```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>

# Or use Android Studio:
# Tools → Device Manager → Create Device
```

**iOS Simulator (macOS only):**
```bash
# Launch default simulator
open -a Simulator

# Or use Xcode:
# Xcode → Open Developer Tool → Simulator
```

## 🏃 Running the App

### Quick Start

```bash
# Ensure a device is connected
flutter devices

# Run the app in debug mode
flutter run
```

**Expected output:**
```
Launching lib/main.dart on <device> in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app-debug.apk.
Installing build/app/outputs/flutter-apk/app-debug.apk...
Debug service listening on ws://127.0.0.1:xxxxx/
```

### Run Options

**Debug mode (default):**
```bash
flutter run
# Hot reload enabled (press 'r')
# Hot restart enabled (press 'R')
```

**Profile mode (for performance testing):**
```bash
flutter run --profile
```

**Release mode (optimized):**
```bash
flutter run --release
```

**Specific device:**
```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Hot Reload During Development

While the app is running in debug mode:
- Press **r** to hot reload (fast, preserves state)
- Press **R** to hot restart (slower, resets state)
- Press **q** to quit
- Press **p** to display performance overlay
- Press **o** to toggle platform (Android/iOS styles)

## 🔨 Building for Production

### Build APK (Android)

**Standard APK:**
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**Split APKs (smaller size):**
```bash
flutter build apk --split-per-abi
```

Output:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (x86 64-bit)

### Build App Bundle (Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

**Note:** App bundles are recommended for Google Play Store as they generate optimized APKs per device configuration.

### Signing Configuration

For release builds, you need to configure signing. See:
- [Release Process Documentation](RELEASE_PROCESS.md)
- Quick setup: `./scripts/keystore_manager.sh --generate`

## ⚠️ Common Setup Issues

### Issue 1: Flutter Command Not Found

**Problem:**
```bash
flutter: command not found
```

**Solution:**
```bash
# Add Flutter to PATH
# Linux/macOS (add to ~/.bashrc or ~/.zshrc):
export PATH="$PATH:/path/to/flutter/bin"

# Windows (Environment Variables):
# Add C:\path\to\flutter\bin to PATH
```

### Issue 2: Android SDK Not Found

**Problem:**
```
✗ Android toolchain - Android SDK not found
```

**Solution:**
```bash
# Download Android command line tools
# From: https://developer.android.com/studio#command-tools

# Set ANDROID_HOME environment variable
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS/Linux
# Windows: set ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk

# Accept licenses
flutter doctor --android-licenses
```

### Issue 3: Gradle Build Failures

**Problem:**
```
FAILURE: Build failed with an exception.
```

**Solutions:**

**A. Clear Gradle cache:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**B. Update Gradle wrapper:**
```bash
cd android
./gradlew wrapper --gradle-version 7.5
```

**C. Check Java version:**
```bash
java -version
# Should be JDK 11 or higher
```

### Issue 4: Dependency Conflicts

**Problem:**
```
Because package_a requires package_b ^1.0.0...
```

**Solution:**
```bash
# Update dependencies
flutter pub upgrade

# Clear pub cache if needed
flutter pub cache repair

# Force dependency resolution
rm pubspec.lock
flutter pub get
```

### Issue 5: Device Not Recognized

**Android:**
```bash
# Check USB connection
adb devices

# Restart adb if no devices shown
adb kill-server
adb start-server
```

**iOS:**
```bash
# Trust the computer on your iOS device
# Restart Xcode if issues persist
```

### Issue 6: Hot Reload Not Working

**Solution:**
```bash
# Stop the app (press 'q')
# Clean and restart
flutter clean
flutter pub get
flutter run
```

### Issue 7: Out of Memory During Build

**Problem:**
```
Expiring Daemon because JVM heap space is exhausted
```

**Solution:**

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError
```

## 👨‍💻 First-Time Developer Walkthrough

### Your First Run (5 minutes)

**Step 1: Verify everything is working**
```bash
cd Tokyo-Predictor-Roulette-001
flutter doctor
flutter pub get
```

**Step 2: Connect a device or emulator**
```bash
flutter devices
# You should see at least one device
```

**Step 3: Run the app**
```bash
flutter run
```

**Step 4: Interact with the app**
1. Enter an email on the login screen
2. Click "Continuar"
3. Press "Girar" to spin the roulette
4. Observe the result and balance changes

**Step 5: Try hot reload**
1. Open `lib/main.dart`
2. Find the login screen text
3. Change "Login" to "Iniciar Sesión"
4. Press **r** in the terminal
5. See the change instantly!

### Understanding the Project Structure

```
Tokyo-Predictor-Roulette-001/
├── lib/
│   ├── main.dart              # UI screens and widgets
│   └── roulette_logic.dart    # Business logic
├── test/
│   ├── widget_test.dart       # UI tests
│   └── roulette_logic_test.dart # Unit tests
├── android/                    # Android native code
├── assets/                     # Images and resources
├── docs/                       # Documentation
└── pubspec.yaml               # Dependencies
```

### Your First Code Change

Let's make a simple change to understand the workflow:

**1. Create a new branch:**
```bash
git checkout -b feature/my-first-change
```

**2. Modify the app:**

Open `lib/main.dart` and find the balance display. Change the initial balance:

```dart
// Find this line (around line 180)
double _balance = 1000.0;

// Change to:
double _balance = 2000.0;
```

**3. Test your change:**
```bash
# Hot reload to see changes (if app is running)
# Or restart:
flutter run
```

**4. Run tests:**
```bash
flutter test
```

**5. Check code quality:**
```bash
flutter analyze
```

**6. Format code:**
```bash
dart format lib/ test/
```

**7. Commit your change:**
```bash
git add lib/main.dart
git commit -m "feat: increase initial balance to 2000"
```

### Run the Test Suite

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/roulette_logic_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🎓 Next Steps

Now that you're set up, explore:

### 1. **Learn the Architecture**
Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand:
- Project structure
- Design patterns
- Data flow
- State management

### 2. **Understand the Features**
Check [USER_GUIDE.md](USER_GUIDE.md) for:
- How the roulette works
- Prediction system
- Martingale strategy
- UI features

### 3. **Contribute**
See [CONTRIBUTING.md](../CONTRIBUTING.md) for:
- Coding standards
- Git workflow
- PR process
- Testing requirements

### 4. **Set Up Firebase (Optional)**
Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md) to enable:
- User authentication
- Remote configuration
- Cloud storage

### 5. **Explore CI/CD**
Learn about automation in [CI_CD_SETUP.md](CI_CD_SETUP.md):
- GitHub Actions workflows
- Automated builds
- Testing pipeline
- Release process

### 6. **Common Development Tasks**

**Add a new dependency:**
```bash
flutter pub add package_name
```

**Update dependencies:**
```bash
flutter pub upgrade
```

**Check for outdated packages:**
```bash
flutter pub outdated
```

**Generate icons:**
```bash
# Add flutter_launcher_icons to dev_dependencies
flutter pub run flutter_launcher_icons:main
```

**Build and run tests in watch mode:**
```bash
flutter test --watch
```

## 📚 Helpful Resources

### Official Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/ui/widgets)

### Learning Resources
- [Flutter by Example](https://flutterbyexample.com/)
- [Flutter Crash Course](https://www.youtube.com/watch?v=x0uinJvhNxI)
- [Dart Tutorial](https://dart.dev/tutorials)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

### Project-Specific
- [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- [GitHub Discussions](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)

## 💡 Pro Tips

### Speed Up Development

1. **Use Hot Reload Effectively**
   - For UI changes: Use hot reload (r)
   - For logic changes: May need hot restart (R)

2. **Enable Flutter DevTools**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

3. **Use IDE Shortcuts**
   - **VS Code**: `Cmd/Ctrl + Shift + P` → "Flutter: Hot Reload"
   - **Android Studio**: `Cmd/Ctrl + \` for hot reload

4. **Optimize Build Times**
   - Close unnecessary apps
   - Increase Gradle memory (see Issue 7 above)
   - Use `--no-sound-null-safety` if needed (temporary)

5. **Debug Efficiently**
   - Use `debugPrint()` instead of `print()`
   - Use Flutter DevTools Inspector
   - Set breakpoints in your IDE

### Best Practices

1. **Always run tests before committing**
   ```bash
   flutter test && flutter analyze
   ```

2. **Keep dependencies updated**
   ```bash
   flutter pub upgrade
   ```

3. **Use version control effectively**
   - Commit often with clear messages
   - Create feature branches
   - Don't commit `pubspec.lock` conflicts

4. **Monitor app size**
   ```bash
   flutter build apk --analyze-size
   ```

5. **Profile before optimizing**
   ```bash
   flutter run --profile
   ```

## 🆘 Getting Help

If you're stuck:

1. **Check this documentation**
   - Especially [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

2. **Search existing issues**
   - [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

3. **Ask the community**
   - Create a new GitHub issue
   - Include error messages and steps to reproduce

4. **Review Flutter documentation**
   - [Flutter Troubleshooting](https://docs.flutter.dev/testing/common-errors)

5. **Check Flutter doctor**
   ```bash
   flutter doctor -v
   ```

## ✅ Setup Complete!

Congratulations! You're ready to start developing. 🎉

**Quick checklist:**
- [ ] Flutter SDK installed and working
- [ ] Project cloned and dependencies installed
- [ ] App runs successfully on a device/emulator
- [ ] Tests pass: `flutter test`
- [ ] Linter passes: `flutter analyze`
- [ ] Hot reload working

**Ready to contribute?** Check [CONTRIBUTING.md](../CONTRIBUTING.md) to get started!

---

**Need help?** Open an [issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues) or check the [documentation](.).

**Last Updated:** December 2024
