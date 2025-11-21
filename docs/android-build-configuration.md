# Android App Bundle (AAB) Build Configuration

## Overview
This document describes the Android build infrastructure for the Tokyo Roulette app, including keystore security and CI/CD workflow.

## Files Added/Modified

### Security Configuration
- **.gitignore**: Excludes sensitive keystore files (*.jks, key.properties, local.properties)
- **android/key.properties**: (Not committed) Local keystore configuration file

### Build Configuration
- **android/build.gradle**: Root-level Gradle configuration
- **android/settings.gradle**: Gradle settings with Flutter plugin integration
- **android/gradle.properties**: Gradle JVM and AndroidX configuration
- **android/app/build.gradle**: App-level build configuration with signing support
- **android/app/proguard-rules.pro**: ProGuard rules for release builds

### Android App Structure
- **android/app/src/main/kotlin/com/tokyo/roulette/predicciones/MainActivity.kt**: Main Flutter activity
- **android/app/src/main/AndroidManifest.xml**: Updated with proper Flutter configuration
- **android/app/src/main/res/**: Theme resources and launch backgrounds

### CI/CD
- **.github/workflows/android-build-aab.yml**: GitHub Actions workflow for AAB builds
- **Makefile**: Developer tools including `make fmt` for code formatting

### Documentation
- **README.md**: Updated with build instructions and security guidelines

## Keystore Security

### Local Development
1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore android/app/Tokyoapps.jks -keyalg RSA -keysize 2048 -validity 10000 -alias tokyokey
   ```

2. Create `android/key.properties`:
   ```properties
   storeFile=android/app/Tokyoapps.jks
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyAlias=tokyokey
   keyPassword=YOUR_KEY_PASSWORD
   ```

3. Build:
   ```bash
   flutter build appbundle --release
   ```

### CI/CD Configuration
The GitHub Actions workflow requires these secrets:
- **ANDROID_KEYSTORE_BASE64**: Base64-encoded keystore file
- **KEYSTORE_PASSWORD**: Keystore password
- **KEY_ALIAS**: Key alias (e.g., "tokyokey")
- **KEY_PASSWORD**: Key password

To encode the keystore:
```bash
base64 -i android/app/Tokyoapps.jks | pbcopy  # macOS
base64 android/app/Tokyoapps.jks | xclip      # Linux
```

## Build.gradle Configuration

The `android/app/build.gradle` file includes:
1. **Keystore properties loading**: Reads from `key.properties` file
2. **Environment variable fallback**: Uses environment variables in CI
3. **Signing configuration**: Configures release signing
4. **ProGuard**: Enables code minification and shrinking for release builds
5. **Firebase dependencies**: Includes Firebase SDK dependencies

## Security Best Practices

1. **Never commit keystore files** (*.jks, key.properties, local.properties)
2. **Store secrets in GitHub Secrets** for CI/CD
3. **Rotate keys** if they were ever committed to version control
4. **Use strong passwords** for keystore and key
5. **Backup keystore securely** - losing it means you can't update your app

## Workflow Triggers
- Push to `main` branch
- Manual dispatch via GitHub Actions UI

## Build Artifacts
- AAB file uploaded as GitHub Actions artifact
- Path: `build/app/outputs/bundle/release/app-release.aab`

## Troubleshooting

### Build fails with "keystore not found"
- Verify GitHub Secrets are configured correctly
- Check ANDROID_KEYSTORE_BASE64 is valid base64

### Build fails with "password incorrect"
- Verify KEYSTORE_PASSWORD and KEY_PASSWORD secrets
- Ensure passwords match those used when creating keystore

### Flutter dependencies fail
- Check pubspec.yaml dependencies are compatible
- Verify Flutter version in workflow matches requirements

## Developer Commands
```bash
make fmt      # Format Dart code
make clean    # Clean build artifacts
make test     # Run tests
make build    # Build APK
```

## References
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Flutter Build and Release](https://docs.flutter.dev/deployment/android)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
