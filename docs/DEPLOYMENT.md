# 🚀 Deployment Guide

Complete guide for deploying Tokyo Roulette Predicciones to production environments.

## 📋 Table of Contents

- [Overview](#overview)
- [Building Release APK/AAB](#building-release-apkaab)
- [Signing Configuration](#signing-configuration)
- [Google Play Store Submission](#google-play-store-submission)
- [App Store Assets](#app-store-assets)
- [Version Management](#version-management)
- [Beta Testing](#beta-testing)
- [Release Checklist](#release-checklist)
- [Post-Deployment Monitoring](#post-deployment-monitoring)

## 🎯 Overview

### Deployment Targets

**Current:**
- ✅ Android (Google Play Store)
- ✅ APK direct distribution

**Future:**
- 📋 iOS (App Store)
- 📋 Web deployment

### Release Types

1. **Internal Testing**: Team only
2. **Closed Beta**: Selected testers
3. **Open Beta**: Public beta channel
4. **Production**: Full public release

## 📦 Building Release APK/AAB

### Prerequisites

Before building:

```bash
# 1. Update dependencies
flutter pub get
flutter pub upgrade

# 2. Run tests
flutter test

# 3. Analyze code
flutter analyze

# 4. Format code
dart format .
```

### Build APK (Direct Distribution)

**Standard APK** (all architectures):
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**Split APK** (recommended, smaller size):
```bash
flutter build apk --split-per-abi --release
```

Outputs:
- `app-armeabi-v7a-release.apk` (~25MB) - 32-bit ARM devices
- `app-arm64-v8a-release.apk` (~28MB) - 64-bit ARM devices (most common)
- `app-x86_64-release.apk` (~30MB) - x86 emulators/tablets

**Benefits of split APKs:**
- Smaller download size (30% reduction)
- Faster installation
- Less storage on device

**Drawback:**
- Need to manage multiple files
- Play Store handles this automatically with App Bundle

### Build App Bundle (Google Play Store)

**Recommended for Play Store:**
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

**Advantages:**
- Play Store generates optimized APKs per device
- Smallest possible download for users
- Support for on-demand features
- Dynamic delivery

**Size comparison:**
- AAB file: ~35MB
- Generated APK per device: ~20-25MB

### Build with Environment Variables

```bash
# Pass environment variables
flutter build apk --release \
  --dart-define=ENVIRONMENT=production \
  --dart-define=API_URL=https://api.example.com

# Access in code:
// const environment = String.fromEnvironment('ENVIRONMENT');
```

### Build Options

```bash
# Obfuscate code (security)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Shrink resources (smaller size)
flutter build apk --release --shrink

# Target specific ABI
flutter build apk --release --target-platform android-arm64

# Verbose output
flutter build apk --release --verbose

# Analyze size
flutter build apk --release --analyze-size
```

## 🔐 Signing Configuration

### Quick Setup (Automated)

```bash
# Generate keystore
./scripts/keystore_manager.sh --generate

# Create key.properties
./scripts/keystore_manager.sh --create-properties

# Verify setup
./scripts/keystore_manager.sh --check-gradle
```

### Manual Setup

**1. Generate Keystore:**

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

**Important prompts:**
- Store password: Choose strong password
- Key password: Can be same as store password
- CN (Name): Your name or company
- OU, O, L, ST, C: Organization details (can skip)

**2. Create key.properties:**

Create `android/key.properties`:
```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=YourStorePassword
keyAlias=upload
keyPassword=YourKeyPassword
```

**⚠️ Security:**
- Never commit key.properties or keystore to Git
- Already in .gitignore
- Store backups securely

**3. Configure build.gradle:**

File: `android/app/build.gradle`

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
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
            // ... other settings
        }
    }
}
```

**4. Test signing:**

```bash
flutter build apk --release

# Verify signed
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

### CI/CD Signing

For GitHub Actions, use secrets:

**1. Convert keystore to base64:**
```bash
base64 -i upload-keystore.jks | pbcopy  # macOS
base64 upload-keystore.jks | xclip  # Linux
```

**2. Add GitHub secrets:**
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore
- `KEYSTORE_PASSWORD`: Store password
- `KEY_ALIAS`: Key alias
- `KEY_PASSWORD`: Key password

**3. Workflow uses these automatically**

See [CI_CD_SETUP.md](CI_CD_SETUP.md) for details.

## 📱 Google Play Store Submission

### 1. Create Google Play Console Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Pay one-time $25 registration fee
3. Accept Developer Distribution Agreement
4. Complete account details

### 2. Create App

1. Click "Create app"
2. Fill in:
   - App name: "Tokyo Roulette Predicciones"
   - Default language: Spanish (or your language)
   - App/Game: Game
   - Free/Paid: Free
3. Accept declarations

### 3. Set Up App Details

**Store Listing:**
- App name: Tokyo Roulette Predicciones
- Short description (80 chars):
  ```
  Simulador educativo de ruleta con predicciones y estrategia Martingale
  ```
- Full description (4000 chars):
  ```
  🎰 Tokyo Roulette Predicciones
  
  Simulador educativo de ruleta europea con sistema de predicciones
  inteligentes y estrategia Martingale.
  
  ✨ CARACTERÍSTICAS:
  • Ruleta europea completa (0-36)
  • Sistema de predicciones basado en frecuencia
  • Estrategia Martingale automática
  • Balance virtual para práctica
  • Historial visual de giros
  • Interfaz moderna y fácil de usar
  
  📚 EDUCATIVO:
  Esta app es exclusivamente educativa y de simulación.
  No promueve juegos de azar reales ni permite apuestas con dinero real.
  
  [Continue with more details...]
  ```
- App icon: 512x512 PNG
- Feature graphic: 1024x500 PNG/JPEG
- Screenshots: See [App Store Assets](#app-store-assets)
- Privacy policy URL
- Support email
- Category: Casino (Games)

**Main Store Listing:**
- Translation for each language you support

**App Content:**
- Privacy policy
- Ads: No (if no ads)
- Content rating questionnaire
- Target age: 18+ (gambling simulation)
- News app: No
- COVID-19: No
- Data safety: Complete form

### 4. Set Up Release

**Production Release:**

1. Go to "Production" → "Create new release"
2. Upload AAB file
3. Add release notes:
   ```
   🎉 Version 1.0.0 - Initial Release
   
   • Simulador de ruleta europea (0-36)
   • Sistema de predicciones
   • Estrategia Martingale
   • Balance virtual $1000
   • Historial de 20 giros
   • Interfaz intuitiva
   ```
4. Review countries (default: all countries)
5. Save → Review release → Start rollout

**Staged Rollout (Recommended):**
- Start with 5% of users
- Increase gradually: 10% → 25% → 50% → 100%
- Monitor crash rate and reviews
- Halt if issues detected

### 5. Testing Tracks

**Internal Testing:**
- Upload AAB
- Add testers (up to 100 email addresses)
- Instant updates
- No review process

**Closed Testing:**
- Upload AAB
- Create email list or Google Group
- Share opt-in URL with testers
- Requires review (faster than production)

**Open Testing:**
- Public beta channel
- Anyone can join
- Listed on Play Store
- Get feedback before production

**Workflow:**
```
Internal (Team) → Closed (Beta testers) → Open (Public beta) → Production
```

### 6. Play Store Review

**Timeline:**
- First submission: 3-7 days
- Updates: 1-3 days

**Common rejection reasons:**
- Incomplete store listing
- Misleading description
- Missing privacy policy
- Content rating issues
- Technical issues (crashes)
- Policy violations

**Best practices:**
- Complete all required fields
- Provide detailed description
- Upload quality screenshots
- Test thoroughly
- Follow [Play Policy](https://play.google.com/about/developer-content-policy/)

## 🖼️ App Store Assets

### Required Assets

**App Icon:**
- Size: 512 x 512 pixels
- Format: PNG (no transparency)
- Requirements:
  - Clear and recognizable
  - No text (minimal text okay)
  - Rounded corners applied by system

**Feature Graphic:**
- Size: 1024 x 500 pixels
- Format: PNG or JPEG
- Use: Featured on Play Store

**Screenshots (4-8 required):**
- Phone: 16:9 ratio
  - Min: 320px
  - Max: 3840px
- 7-inch tablet: 16:9 ratio
- 10-inch tablet: 16:9 or 16:10

**Recommended screenshot sizes:**
- 1080 x 1920 (portrait)
- 1920 x 1080 (landscape)

### Taking Screenshots

**From emulator:**
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run

# Take screenshot (Camera icon in emulator)
# Or use ADB:
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png
```

**From physical device:**
- Use device screenshot function
- Transfer to computer via USB

### Screenshot Content

Capture key screens:
1. **Login screen** - First impression
2. **Main game screen** - Core gameplay
3. **Spin result** - Action shot
4. **History display** - Feature highlight
5. **Settings/Martingale** - Strategy feature
6. **Predictions** - AI feature

**Tips:**
- Use consistent device/resolution
- Show actual gameplay
- Add text overlay explaining features (optional)
- Use in-app screenshots (not mockups)
- Landscape + Portrait orientations

### Promo Video (Optional)

- Length: 30-120 seconds
- YouTube URL required
- Show gameplay
- Explain features
- Add captions
- Professional but authentic

## 📊 Version Management

### Semantic Versioning

Format: `MAJOR.MINOR.PATCH+BUILD`

Example: `1.2.3+45`
- MAJOR: 1 (breaking changes)
- MINOR: 2 (new features)
- PATCH: 3 (bug fixes)
- BUILD: 45 (Play Store build number)

### Using version_manager.sh

```bash
# Check current version
./scripts/version_manager.sh current

# Increment patch (1.0.0 → 1.0.1)
./scripts/version_manager.sh patch

# Increment minor (1.0.0 → 1.1.0)
./scripts/version_manager.sh minor

# Increment major (1.0.0 → 2.0.0)
./scripts/version_manager.sh major

# Set specific version
./scripts/version_manager.sh set 2.1.0
```

### Version Guidelines

**Major (X.0.0):**
- Complete redesign
- Breaking API changes
- Major feature overhaul

**Minor (1.X.0):**
- New features
- Significant improvements
- New game modes

**Patch (1.0.X):**
- Bug fixes
- Performance improvements
- Minor UI tweaks

### Build Numbers

- Must always increase
- Never reuse build number
- Play Store tracks this

Example progression:
```
1.0.0+1   (Initial release)
1.0.1+2   (Bug fix)
1.0.2+3   (Another fix)
1.1.0+4   (New feature)
1.1.1+5   (Fix)
2.0.0+6   (Major update)
```

## 🧪 Beta Testing

### Internal Testing Program

**Setup:**
1. Play Console → Testing → Internal testing
2. Create release → Upload AAB
3. Add testers by email
4. Testers receive opt-in link

**Benefits:**
- Instant updates (no review)
- Up to 100 testers
- Full crash reports
- Pre-launch testing

**Use for:**
- Team testing
- Quick iterations
- Feature validation

### Closed Beta

**Setup:**
1. Testing → Closed testing
2. Create track (e.g., "Beta")
3. Upload AAB
4. Create email list or Google Group
5. Share opt-in URL

**Benefits:**
- Wider testing audience
- Real user feedback
- Crash/bug reports
- Usage analytics

**Recruiting testers:**
- Friends and family
- Community members
- Social media
- Testing communities

### Open Beta

**Setup:**
1. Testing → Open testing
2. Upload AAB
3. Make public
4. Share Play Store link

**Benefits:**
- Anyone can join
- Large-scale testing
- Public feedback
- Soft launch strategy

**Promotion:**
```markdown
🎰 Join Tokyo Roulette Beta!

Help us test new features and improvements.

👉 Join Beta: [Play Store Link]

What you'll get:
✅ Early access to new features
✅ Direct feedback to developers
✅ Shape the app's future

Requirements:
📱 Android 5.0 or higher
🇪🇸 Spanish speakers preferred
⏱️ 5 minutes to test
```

### Collecting Feedback

**In-app feedback:**
```dart
// Add feedback button
IconButton(
  icon: Icon(Icons.feedback),
  onPressed: () => launchUrl('mailto:feedback@example.com'),
)
```

**Google Form:**
Create feedback survey with:
- What feature did you test?
- Did it work as expected?
- Any bugs encountered?
- Suggestions for improvement
- Overall rating

**Channels:**
- In-app feedback form
- Email: feedback@example.com
- Play Store reviews
- Discord/Slack community
- GitHub issues

## ✅ Release Checklist

### Pre-Release

- [ ] All tests passing (`flutter test`)
- [ ] No lint errors (`flutter analyze`)
- [ ] Code formatted (`dart format .`)
- [ ] Version bumped in pubspec.yaml
- [ ] CHANGELOG.md updated
- [ ] Release notes written
- [ ] Screenshots updated
- [ ] Privacy policy current
- [ ] Keystore backup secured
- [ ] Firebase config production-ready
- [ ] API keys production versions
- [ ] Feature flags configured

### Build

- [ ] Clean build (`flutter clean`)
- [ ] Dependencies updated (`flutter pub get`)
- [ ] Build AAB (`flutter build appbundle --release`)
- [ ] Verify signing (jarsigner)
- [ ] Test on real device
- [ ] Check app size
- [ ] Test offline functionality
- [ ] Test on different devices/OS versions

### Play Store

- [ ] Upload AAB
- [ ] Release notes added (all languages)
- [ ] Screenshots current
- [ ] Store listing accurate
- [ ] Content rating current
- [ ] Data safety form complete
- [ ] Countries selected
- [ ] Pricing confirmed (free)
- [ ] Rollout percentage set (5-10% initially)

### Post-Release

- [ ] Monitor crash reports
- [ ] Watch user reviews
- [ ] Track install metrics
- [ ] Check analytics
- [ ] Respond to feedback
- [ ] Plan next release
- [ ] Tag release in Git
- [ ] Update documentation
- [ ] Announce release (social media, blog)

## 📈 Post-Deployment Monitoring

### Play Console Metrics

**Dashboard:**
- Installs (daily/monthly)
- Uninstalls
- Active devices
- User ratings
- Crash rate
- ANR (Application Not Responding) rate

**Target metrics:**
- Crash-free sessions: >99%
- ANR rate: <0.5%
- 1-day retention: >40%
- 7-day retention: >20%
- Average rating: >4.0

### Crash Monitoring

**View crashes:**
1. Play Console → Quality → Android vitals → Crashes & ANRs
2. Review stack traces
3. Prioritize by affected users

**Categories:**
- Crash: App stopped unexpectedly
- ANR: App not responding (5+ seconds)
- Native crash: C/C++ code issue

**Response time:**
- Critical (affects >5% users): Fix within 24h
- High (affects 1-5%): Fix within 3 days
- Medium (affects <1%): Fix in next release
- Low (rare): Track and monitor

### User Reviews

**Monitor:**
- New reviews daily
- Rating trends
- Common complaints
- Feature requests

**Response strategy:**
- Respond within 48 hours
- Thank positive reviews
- Address negative reviews professionally
- Explain fixes for bugs
- Note feature requests

**Example responses:**
```
Positive (5 stars):
"¡Gracias por tu reseña positiva! Nos alegra que disfrutes la app. 
Pronto lanzaremos nuevas funciones. 🎰"

Negative (1-2 stars):
"Lamentamos tu experiencia. El bug que mencionas fue corregido en 
la versión 1.0.1 que acabamos de lanzar. Por favor actualiza y 
avísanos si persiste el problema. Gracias por tu paciencia."

Feature request:
"¡Excelente idea! Estamos considerando agregar [feature] en una 
próxima actualización. Mantente atento a nuestras novedades."
```

### Analytics

**Key metrics:**
- Daily Active Users (DAU)
- Monthly Active Users (MAU)
- Session length
- Sessions per user
- Feature usage
- Conversion rate (if monetized)

**Firebase Analytics (when integrated):**
```dart
// Track key events
analytics.logEvent('roulette_spin', {
  'result': 17,
  'bet': 10.0,
  'balance': 1050.0,
});

analytics.logEvent('martingale_enabled');
analytics.logEvent('game_reset');
```

### Hotfix Process

**When to hotfix:**
- Critical crash affecting >5% users
- Security vulnerability
- Data loss bug
- Payment/monetization broken

**Process:**
1. Fix bug in hotfix branch
2. Test thoroughly
3. Bump patch version (1.0.1 → 1.0.2)
4. Build and test
5. Upload to Play Store
6. Request expedited review (if critical)
7. Set 100% rollout
8. Monitor closely

**Timeline:**
- Emergency fix: Same day
- Critical fix: 1-2 days
- Important fix: 3-5 days

### Rollout Strategy

**Staged rollout:**
```
Day 1:  5% rollout
Day 2:  10% if stable
Day 3:  25% if stable
Day 5:  50% if stable
Day 7:  100% if stable
```

**Halt if:**
- Crash rate increases >1%
- Negative reviews spike
- Critical bug reported
- ANR rate increases

**Recovery:**
1. Halt rollout
2. Investigate issue
3. Release hotfix
4. Resume rollout

## 📚 Related Documentation

- [Release Process](RELEASE_PROCESS.md) - Detailed release procedures
- [CI/CD Setup](CI_CD_SETUP.md) - Automated deployment
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues
- [Testing Guide](TESTING.md) - Testing strategies

## 🆘 Need Help?

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

---

**Last Updated:** December 2024
