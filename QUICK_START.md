# Quick Start Guide - Building the APK

## Prerequisites

1. **Install Flutter SDK**
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Install Android SDK**
   - Flutter will prompt you to install Android toolchain
   - Or install Android Studio which includes Android SDK

3. **Verify Installation**
   ```bash
   flutter doctor
   ```
   Ensure all checks pass for Flutter and Android toolchain.

## Setup Steps

### 1. Create local.properties file

Create the file `android/local.properties` with your Flutter SDK path:

**Linux/Mac:**
```properties
flutter.sdk=/Users/your-username/flutter
# Or wherever you installed Flutter
```

**Windows:**
```properties
flutter.sdk=C:\\Users\\your-username\\flutter
# Use double backslashes or forward slashes
```

To find your Flutter SDK path:
```bash
which flutter  # Mac/Linux
where flutter  # Windows
```

### 2. Get Dependencies

```bash
flutter pub get
```

### 3. Build the APK

**Using the build script (recommended):**
```bash
chmod +x build-apk.sh  # First time only
./build-apk.sh
```

**Or manually:**
```bash
flutter clean
flutter pub get
flutter build apk --release --no-tree-shake-icons
```

### 4. Find Your APK

The release APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Testing the APK

### Install on Device
```bash
# Connect Android device via USB with USB debugging enabled
flutter install

# Or use adb directly
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Install on Emulator
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Install APK
flutter install
```

## Troubleshooting

### "Flutter SDK not found"
- Ensure `android/local.properties` exists with correct path
- Check Flutter is in your PATH: `flutter --version`

### "Android SDK not found"
- Run `flutter doctor` to install Android toolchain
- Or set `sdk.dir` in `local.properties`:
  ```properties
  sdk.dir=/path/to/android/sdk
  ```

### Build fails with "Out of Memory"
- Increase Gradle memory in `android/gradle.properties`:
  ```properties
  org.gradle.jvmargs=-Xmx6G -XX:MaxMetaspaceSize=2G
  ```

### Signing errors
- Current config uses debug keystore at `~/.android/debug.keystore`
- If missing, run any Android project once to generate it
- Or create with: `keytool -genkey -v -keystore debug.keystore -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000 -storepass android -keypass android`

## Build Variants

### Release APK (current setup)
```bash
flutter build apk --release
```
- Optimized and minified
- Signed with debug keystore (replace for production)
- File: `app-release.apk`

### Debug APK
```bash
flutter build apk --debug
```
- Includes debug symbols
- Larger file size
- File: `app-debug.apk`

### App Bundle (for Google Play)
```bash
flutter build appbundle --release
```
- Optimized for Play Store
- File: `app-release.aab`
- **Requires production keystore**

## Next Steps for Production

1. **Create Production Keystore:**
   ```bash
   keytool -genkey -v -keystore ~/tokyo-roulette-key.jks -alias tokyo-roulette -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Update android/app/build.gradle:**
   Replace debug signing with production keystore path and credentials

3. **Configure Firebase:**
   - Run `flutterfire configure`
   - Uncomment Firebase initialization in `lib/main.dart`

4. **Configure Stripe:**
   - Add publishable key
   - Uncomment Stripe initialization in `lib/main.dart`

5. **Update App Icon:**
   - Replace icons in `android/app/src/main/res/mipmap-*/`
   - Or use flutter_launcher_icons package

## Support

- Flutter Docs: https://flutter.dev/docs
- Android Docs: https://developer.android.com
- Issue Tracker: See repository issues

---

**Ready to build!** 🚀

Run `./build-apk.sh` and your APK will be ready in minutes!
