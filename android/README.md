# Android Build Configuration

This directory contains the complete Android build configuration for the Tokyo Roulette app.

## Configuration Files Created

### Gradle Build Files
- `build.gradle` - Root build configuration with Kotlin 1.9.22 and AGP 8.1.4
- `app/build.gradle` - App module configuration with:
  - Package: `com.tokyoapps.roulette`
  - compileSdkVersion: 34
  - minSdkVersion: 23
  - targetSdkVersion: 34
  - MultiDex enabled
  - Debug signing for quick testing

### Gradle Configuration
- `settings.gradle` - Plugin management and Flutter integration
- `gradle.properties` - JVM settings (4GB heap) and Android X configuration
- `gradle/wrapper/` - Gradle 8.3 wrapper files
- `gradlew` / `gradlew.bat` - Gradle wrapper scripts

### Resources
- `app/src/main/res/values/styles.xml` - Light theme configuration
- `app/src/main/res/values-night/styles.xml` - Dark theme configuration
- `app/src/main/res/drawable/launch_background.xml` - Splash screen
- `app/src/main/res/mipmap-*/ic_launcher.png` - App icons for all densities

### Kotlin Source
- `app/src/main/kotlin/com/tokyoapps/roulette/MainActivity.kt` - Main Flutter activity

## Building the APK

### Prerequisites
1. Install Flutter SDK
2. Create `local.properties` file with Flutter SDK path:
   ```properties
   flutter.sdk=/path/to/flutter
   ```

### Quick Build
Run the build script from the project root:
```bash
./build-apk.sh
```

### Manual Build
```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## Signing Configuration

Currently uses the Android debug keystore for quick testing:
- Location: `~/.android/debug.keystore`
- Password: `android`
- Key alias: `androiddebugkey`

**For production**, create a proper keystore and update the signing configuration in `app/build.gradle`.

## Package Structure

The app uses the package name: `com.tokyoapps.roulette`

Main activity path: `com.tokyoapps.roulette.MainActivity`

## Notes

- Firebase and Stripe are commented out in `lib/main.dart` to allow building without configuration
- The debug keystore allows building without creating a production keystore
- MultiDex is enabled to support the app's dependencies
