# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

## Release build and CI

### Generate Android Keystore

To create a signed release build, first generate a keystore:

```bash
keytool -genkey -v -keystore ~/release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

Follow the prompts to set your keystore password, key password, and provide your information.

### Configure Local Signing

1. Copy the example properties file:
   ```bash
   cp android/key.properties.example android/key.properties
   ```

2. Edit `android/key.properties` with your actual keystore information:
   ```properties
   storeFile=/path/to/your-release-key.jks
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyAlias=YOUR_KEY_ALIAS
   keyPassword=YOUR_KEY_PASSWORD
   ```

3. Build the release bundle:
   ```bash
   flutter build appbundle --release
   ```

### GitHub Actions CI Setup

To enable automated builds via GitHub Actions:

1. **Encode your keystore to base64:**
   ```bash
   base64 -i /path/to/your-release-key.jks | pbcopy
   # On Linux: base64 -w 0 /path/to/your-release-key.jks
   ```

2. **Set GitHub repository secrets** (Settings → Secrets and variables → Actions):
   - `KEYSTORE_BASE64`: The base64-encoded keystore from step 1
   - `KEYSTORE_PASSWORD`: Your keystore password
   - `KEY_ALIAS`: Your key alias
   - `KEY_PASSWORD`: Your key password

3. The workflow will run automatically on pushes to `main` or can be triggered manually via workflow_dispatch.

### Version Management

Version information is managed in `pubspec.yaml`:

```yaml
version: 1.2.4+5  # format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

To increment the version:
1. Update the version in `pubspec.yaml`
2. Commit and push - the CI workflow will automatically use the new version

The build number (after the `+`) becomes `versionCode` in Android, and the version name (before the `+`) becomes `versionName`.

**Disclaimer**: Solo simulación. No promueve gambling real.
