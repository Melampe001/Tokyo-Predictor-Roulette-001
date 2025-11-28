# Tokyo Predictor Roulette

<p align="center">
  <img src="assets/images/icon.png" alt="Tokyo Predictor Roulette" width="120"/>
</p>

<p align="center">
  <strong>Educational Roulette Simulator by TokyoApps/TokRaggcorp</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#build">Build</a> •
  <a href="#qa-testing">QA Testing</a> •
  <a href="#release">Release</a> •
  <a href="#contact">Contact</a>
</p>

---

## App Information

| Field | Value |
|-------|-------|
| **App Name** | Tokyo Predictor Roulette |
| **Package** | `com.tokraggcorp.tokyopredictorroulett` |
| **Developer** | TokyoApps/TokRaggcorp |
| **Support Email** | tokraagcorp@gmail.com |
| **Version** | 1.0.0 |

## Description

Tokyo Predictor Roulette is an **educational simulator** for roulette with predictions, secure RNG, Martingale strategy advisor, and a freemium model. Includes Stripe integration for payments and Firebase for remote configurations.

⚠️ **DISCLAIMER**: This is a **simulation and educational application ONLY**. It does NOT promote real gambling. No real money is involved.

## Features

- 🎰 **European Roulette Simulation** - Authentic 0-36 wheel simulation
- 🔮 **Prediction System** - Educational prediction based on history
- 📊 **Martingale Strategy Advisor** - Learn betting strategies
- 🔐 **Secure RNG** - Cryptographically secure random number generation
- 💳 **Freemium Model** - Stripe integration for premium features
- 🔥 **Firebase Backend** - Remote config and analytics
- 📱 **Multi-language Support** - Internationalization ready

## Installation

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / VS Code
- JDK 17 or higher

### Setup

```bash
# Clone the repository
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# Get dependencies
flutter pub get

# Run the app (development)
flutter run
```

## Build

### Debug APK

```bash
flutter build apk --debug
```

### Release APK

```bash
flutter build apk --release
```

### App Bundle (Play Store)

```bash
flutter build appbundle --release
```

### Build Outputs

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

## Keystore Configuration

For signing release builds, configure your keystore:

### Option 1: key.properties (Local Development)

Create `android/key.properties`:

```properties
storeFile=/path/to/your/keystore.jks
storePassword=your_keystore_password
keyAlias=your_key_alias
keyPassword=your_key_password
```

### Option 2: Environment Variables (CI/CD)

Set the following secrets in GitHub Actions:

| Secret | Description |
|--------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded keystore file |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key password |

⚠️ **SECURITY**: Never commit `key.properties` or keystore files to the repository.

## QA Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Analysis

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/ test/
```

### Manual QA Checklist

- [ ] App launches without crashes
- [ ] Login/registration flow works
- [ ] Roulette spin generates valid numbers (0-36)
- [ ] History tracking is accurate
- [ ] UI elements are responsive
- [ ] No hardcoded credentials in logs
- [ ] Network requests use HTTPS

## CI/CD

The repository includes automated workflows:

| Workflow | File | Purpose |
|----------|------|---------|
| **CI Pipeline** | `.github/workflows/ci.yml` | Test, Lint, Build APK/AAB |
| **Build APK** | `.github/workflows/build-apk.yml` | Build release APK |

### CI Pipeline Jobs

1. **Analyze & Lint** - Code analysis and formatting check
2. **Run Tests** - Unit and widget tests with coverage
3. **Build Release APK** - Generate signed APK
4. **Build Release AAB** - Generate App Bundle for Play Store

## Release Process

### Pre-Release Checklist

- [ ] All tests passing
- [ ] Code review completed
- [ ] Version bumped in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Privacy policy reviewed
- [ ] Screenshots updated
- [ ] Store listing updated

### Play Store Submission

1. Generate signed AAB: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Fill in store listing with screenshots
4. Submit for review

### Required Play Store Assets

- Feature graphic (1024x500)
- Screenshots (phone + tablet)
- App icon (512x512)
- Privacy policy URL
- Content rating questionnaire

## Project Structure

```
tokyo-predictor-roulette/
├── android/                    # Android platform code
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml
├── assets/                     # App assets
│   └── images/                 # Icons and splash screen
├── docs/                       # Documentation
│   └── hojas-menbretadas-tokyo/  # Official stationery
├── lib/                        # Dart source code
│   ├── main.dart              # App entry point
│   └── roulette_logic.dart    # Roulette game logic
├── test/                       # Test files
├── .github/workflows/          # CI/CD workflows
├── privacy-policy.md           # Privacy policy
├── SECURITY.md                 # Security policy
├── pubspec.yaml               # Dependencies
└── README.md                  # This file
```

## Documentation

| Document | Description |
|----------|-------------|
| [Privacy Policy](privacy-policy.md) | Data collection and usage policy |
| [Security Policy](SECURITY.md) | Security guidelines and vulnerability reporting |
| [Stationery](docs/hojas-menbretadas-tokyo/) | Official brand stationery |

## Contact

**Developer**: TokyoApps/TokRaggcorp  
**Support Email**: tokraagcorp@gmail.com  
**Package**: com.tokraggcorp.tokyopredictorroulett

For bug reports, feature requests, or security issues:
- 📧 Email: tokraagcorp@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

## License

© 2024 TokyoApps/TokRaggcorp. All rights reserved.

---

## Development Phases

### ✅ Phase 1: Definition & Planning
- [x] Project scope and objectives defined
- [x] Requirements and deliverables identified
- [x] Roadmap with milestones created
- [x] Task assignments completed

### ✅ Phase 2: Technical Design & Documentation
- [x] Technical documentation (architecture, flow, APIs)
- [x] Dependencies and resources reviewed
- [x] Design validated and feedback received

### ✅ Phase 3: Incremental Development
- [x] Features implemented per roadmap
- [x] Code reviews and PRs following checklist
- [x] Documentation updated with changes

### ✅ Phase 4: Testing
- [x] Unit and functional tests executed
- [x] Requirements and acceptance criteria validated
- [x] Bugs detected and fixed

### ✅ Phase 5: Deployment & Release
- [x] Release environment prepared
- [x] Lessons learned documented
- [x] Deliverables presented and phase closed
