# ⚙️ CI/CD Configuration - Tokyo Roulette Predictor

This document describes how to configure and use the CI/CD system with GitHub Actions.

## 📋 Table of Contents

1. [Overview](#overview)
2. [CI/CD Workflow](#cicd-workflow)
3. [Secrets Configuration](#secrets-configuration)
4. [How to Trigger Builds](#how-to-trigger-builds)
5. [Download Artifacts](#download-artifacts)
6. [Create Releases](#create-releases)
7. [Keystore Management](#keystore-management)
8. [Troubleshooting](#troubleshooting)

---

## Overview

The project uses a unified CI/CD workflow in `.github/workflows/ci-cd.yml` that handles:

1. **Build and Test** (on push/PR to main and develop)
   - Code analysis and linting
   - Unit tests with coverage
   - Build debug APK
   - Upload artifacts

2. **Release** (only on push to main)
   - Decode keystore from GitHub Secrets
   - Build signed release APK
   - Build signed App Bundle (AAB)
   - Upload signed artifacts
   - Create GitHub Release (if tag is pushed)

### Additional Workflows

- **CI** - `.github/workflows/ci.yml` - Comprehensive CI checks
- **PR Checks** - `.github/workflows/pr-checks.yml` - PR-specific validations
- **CodeQL** - `.github/workflows/codeql.yml` - Security scanning

---

## CI/CD Workflow

The unified CI/CD workflow (`.github/workflows/ci-cd.yml`) provides automated building, testing, and releasing.

### Build and Test Job

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Push of tags matching `v*.*.*`

**What it does**:
1. ✅ Checkout code
2. ✅ Setup Java 17 (required for Android builds)
3. ✅ Setup Flutter (latest stable)
4. ✅ Setup Python 3.11 (for automation scripts)
5. ✅ Install Python dependencies (if requirements.txt exists)
6. ✅ Run `flutter doctor -v`
7. ✅ Get Flutter dependencies (`flutter pub get`)
8. ✅ Analyze code (`flutter analyze`)
9. ✅ Run tests (`flutter test --coverage`)
10. ✅ Upload coverage to Codecov
11. ✅ Build debug APK
12. ✅ Upload debug APK as artifact (7-day retention)

**Artifacts generated**:
- `debug-apk-{sha}`: Debug APK for testing (7 days retention)
- Coverage report uploaded to Codecov

**Example execution**:
```bash
# On any push to main or develop, or PR creation
git add .
git commit -m "feat: add new feature"
git push origin main
# Workflow runs automatically
```

### Release Job

**Triggers**:
- Push to `main` branch only (not PRs, not develop)
- Runs after build-and-test job succeeds

**Requirements**:
- GitHub Secrets must be configured (see [Secrets Configuration](#secrets-configuration))
- `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`

**What it does**:
1. ✅ Checkout code
2. ✅ Setup Java 17 and Flutter
3. ✅ Get Flutter dependencies
4. ✅ Decode keystore from GitHub Secrets
5. ✅ Create `key.properties` file with signing credentials
6. ✅ Build release APK (`flutter build apk --release`)
7. ✅ Build App Bundle AAB (`flutter build appbundle --release`)
8. ✅ Generate SHA-256 checksums
9. ✅ Upload release APK as artifact (30-day retention)
10. ✅ Upload release AAB as artifact (30-day retention)
11. ✅ Create GitHub Release (if tag was pushed)

**Artifacts generated**:
- `release-apk-{sha}`: Signed release APK + SHA-256 checksum (30 days)
- `release-aab-{sha}`: Signed App Bundle + SHA-256 checksum (30 days)

**Example execution**:
```bash
# Push to main triggers release build
git push origin main

# Push a tag to create a GitHub Release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
# Release job runs and creates a GitHub Release with APK/AAB attached
```

---

## Secrets Configuration

The **Release** job requires GitHub Secrets to sign APKs and AABs with your keystore.

### Step 1: Generate Keystore (if you don't have one)

You can use the provided script:

```bash
./scripts/keystore_manager.sh --generate
```

Or manually using keytool:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Save the passwords you enter!** You'll need them for GitHub Secrets.

### Step 2: Encode Keystore to Base64

```bash
base64 upload-keystore.jks > keystore.base64.txt
```

Or on macOS:

```bash
base64 -i upload-keystore.jks -o keystore.base64.txt
```

### Step 3: Add Secrets to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secrets:

| Name | Value | Description |
|------|-------|-------------|
| `KEYSTORE_BASE64` | Content of `keystore.base64.txt` | Base64-encoded keystore file |
| `KEYSTORE_PASSWORD` | Your keystore password | Password for the keystore |
| `KEY_ALIAS` | `upload` (or your alias) | Alias of the signing key |
| `KEY_PASSWORD` | Your key password | Password for the signing key |

**⚠️ IMPORTANT**: 
- **NEVER** commit the keystore or passwords to the repository
- Secrets are only accessible in workflows
- Secrets are not displayed in logs
- `.gitignore` already excludes `*.jks`, `*.keystore`, and `key.properties`

### Step 4: Verify Configuration

Once secrets are configured, the next push to `main` will use them:

```bash
# Push to main to trigger a signed release build
git push origin main

# Monitor at: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions
```

### Security Best Practices

- 🔒 Keep keystore backup in a secure location (not in git)
- 🔒 Rotate keystore only if compromised (requires re-signing all versions)
- 🔒 Never share passwords or keystore files
- 🔒 Use different keystores for debug and release builds

---

## How to Trigger Builds

### Automatic Triggers

The CI/CD workflow runs automatically on:

1. **Push to main or develop**:
   - Runs build-and-test job
   - If push is to main, also runs release job
   
2. **Pull request to main or develop**:
   - Runs build-and-test job only
   - No release artifacts created
   
3. **Push a tag (v*.*.*))**:
   - Runs both jobs
   - Creates a GitHub Release with signed APK/AAB

### Manual Triggers

You can also trigger workflows manually:

1. Go to **Actions** tab in GitHub
2. Select the **CI/CD** workflow
3. Click **Run workflow**
4. Choose the branch
5. Click **Run workflow** button

### Common Scenarios

**Scenario 1: Test changes before merging**
```bash
# Create a feature branch
git checkout -b feature/new-feature
git add .
git commit -m "feat: implement new feature"
git push origin feature/new-feature

# Create PR to main
# CI/CD runs build-and-test job automatically
# Download debug APK from artifacts to test
```

**Scenario 2: Merge to main and get signed release**
```bash
# After PR is approved and merged to main
# CI/CD runs both build-and-test and release jobs
# Download signed APK/AAB from artifacts
```

**Scenario 3: Create a new release**
```bash
# Update version in pubspec.yaml first
# Commit and push changes
git add pubspec.yaml
git commit -m "chore: bump version to 1.0.0"
git push origin main

# Create and push tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# CI/CD creates a GitHub Release with signed APK/AAB
# Check: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases
```

---

## Download Artifacts

Artifacts are files generated by the workflow runs (APKs, AABs, checksums).

### How to Download

1. Go to **Actions** tab: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions
2. Click on the workflow run you're interested in
3. Scroll down to the **Artifacts** section
4. Click on the artifact name to download

### Available Artifacts

| Artifact Name | Contents | Retention | When Created |
|--------------|----------|-----------|--------------|
| `debug-apk-{sha}` | Debug APK | 7 days | Every build-and-test run |
| `release-apk-{sha}` | Signed APK + SHA-256 | 30 days | Push to main only |
| `release-aab-{sha}` | Signed AAB + SHA-256 | 30 days | Push to main only |

### Verify Integrity

After downloading a release artifact, verify its integrity:

```bash
# Extract the artifact ZIP
unzip release-apk-*.zip

# Verify the checksum
sha256sum -c app-release.apk.sha256

# Expected output: app-release.apk: OK
```

### Install Debug APK

```bash
# Install on connected device
adb install app-debug.apk

# Or drag and drop to emulator
```

---

## Create Releases

Creating a GitHub Release makes your APK/AAB easily downloadable by users.

### Automatic Release Creation

The CI/CD workflow automatically creates a GitHub Release when you push a tag:

```bash
# 1. Update version in pubspec.yaml
flutter pub get  # Updates pubspec.lock

# 2. Commit version change
git add pubspec.yaml pubspec.lock
git commit -m "chore: bump version to 1.2.3"

# 3. Push to main
git push origin main

# 4. Create and push tag
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3

# 5. Wait for workflow to complete
# Release will be at: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases
```

### Release Contents

Each GitHub Release includes:

- **Signed APK**: For direct Android installation
- **Signed AAB**: For Google Play Store submission
- **SHA-256 checksums**: For integrity verification
- **Automatically generated release notes**: Based on commits since last release
- **Custom description**: Educational notice and installation instructions

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (1.1.0): New features (backwards compatible)
- **PATCH** (1.1.1): Bug fixes

### Using the Version Manager Script

```bash
# Check current version
./scripts/version_manager.sh current

# Increment patch version (1.0.0 → 1.0.1)
./scripts/version_manager.sh patch

# Increment minor version (1.0.1 → 1.1.0)
./scripts/version_manager.sh minor

# Increment major version (1.1.0 → 2.0.0)
./scripts/version_manager.sh major
```

---

## Keystore Management

The keystore is used to sign release APKs and AABs, ensuring their authenticity.

### What is a Keystore?

A keystore is a binary file containing:
- Private key for signing
- Certificate identifying the developer
- Alias name for the key

**CRITICAL**: 
- ⚠️ If you lose the keystore, you cannot update the app on Play Store
- ⚠️ Keep secure backups in multiple locations
- ⚠️ Never commit to git (already in .gitignore)

### Generate a New Keystore

Using the provided script:

```bash
./scripts/keystore_manager.sh --generate
```

Or manually:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

You'll be prompted for:
- Keystore password (remember it!)
- Key password (remember it!)
- Name, organization, etc. (can be anything)

### Validate Your Keystore

```bash
# Using the script
./scripts/keystore_manager.sh --validate

# Or manually
keytool -list -v -keystore ~/upload-keystore.jks -alias upload
```

### Backup Your Keystore

```bash
# Create encrypted backup
cp ~/upload-keystore.jks ~/Dropbox/keystore-backup-$(date +%Y%m%d).jks

# Or use the script
./scripts/keystore_manager.sh --backup
```

Store backups in:
- 💾 Encrypted cloud storage (Dropbox, Google Drive, etc.)
- 💾 Password manager (as a secure note)
- 💾 Hardware USB drive in a safe location

### Configure for Local Builds

Create `android/key.properties` for local release builds:

```bash
./scripts/keystore_manager.sh --create-properties
```

Or manually:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

**Important**: This file is already in `.gitignore` and will never be committed.

---

## Troubleshooting

### Build Failures

#### "Flutter command not found"

Ensure the workflow uses `subosito/flutter-action@v2`:

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
    cache: true
```

#### "Keystore not found" during Release

Check that secrets are configured:

1. Go to: Settings → Secrets and variables → Actions
2. Verify these secrets exist:
   - `KEYSTORE_BASE64`
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`

If missing, follow [Secrets Configuration](#secrets-configuration).

#### "Tests failed" in CI but pass locally

Clean and rebuild:

```bash
flutter clean
flutter pub get
flutter test
```

Check for:
- Platform-specific tests (may fail on Linux CI)
- Timezone or locale dependencies
- Random test failures (flaky tests)

#### "Gradle build failed"

Common causes:
- Java version mismatch (workflow uses Java 17)
- Missing dependencies in build.gradle
- Corrupted Gradle cache

Local debugging:

```bash
cd android
./gradlew clean
./gradlew build --info
```

### Workflow Performance

#### Workflow is slow

Optimizations already implemented:
- ✅ Gradle caching enabled
- ✅ Flutter pub caching enabled
- ✅ Parallel job execution

Additional tips:
- Reduce test suite size
- Use `flutter test --plain` to reduce output
- Consider splitting into multiple workflows

#### Artifact upload fails

Check:
- File size limits (artifacts have size limits)
- Correct file paths in workflow
- Sufficient storage quota

### Release Issues

#### Release not created when tag pushed

Verify:
1. Tag follows format `v*.*.*` (e.g., v1.0.0, not 1.0.0)
2. Tag was pushed: `git push origin v1.0.0`
3. Workflow has permission: `contents: write`
4. No build failures in release job

#### APK not signed properly

Debug signing:

```bash
# Download release APK from artifacts
# Verify signature
jarsigner -verify -verbose -certs app-release.apk

# Expected: "jar verified."
```

Check:
- All 4 secrets are configured correctly
- Base64 decoding succeeded (check workflow logs)
- `key.properties` was created (check logs)

#### AAB generation fails

Ensure `build.gradle` has correct configuration:

```gradle
buildTypes {
    release {
        if (keystorePropertiesFile.exists()) {
            signingConfig signingConfigs.release
        }
        minifyEnabled true
        shrinkResources true
    }
}
```

### Secret Management

#### How to rotate keystore

⚠️ **Warning**: Rotating the keystore means you cannot update existing Play Store apps.

Only rotate if compromised:

1. Generate new keystore
2. Update GitHub Secrets with new values
3. Build and sign with new keystore
4. Upload as **new app** to Play Store (different package name)

#### Secret appears in logs

GitHub automatically masks secrets in logs. If you see exposure:

1. Delete the secret immediately
2. Generate new keystore
3. Update all secrets
4. Review workflow logs for the exposure source

### Local Testing

#### Simulate CI locally

Run the same commands as CI:

```bash
# Setup
flutter doctor -v
flutter pub get

# Lint
flutter analyze --no-fatal-infos

# Test
flutter test --coverage

# Build debug
flutter build apk --debug

# Build release (requires key.properties)
flutter build apk --release
```

#### Test signing locally

```bash
# Create key.properties first
./scripts/keystore_manager.sh --create-properties

# Build release
flutter build apk --release

# Verify signature
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

### Getting Help

If you encounter issues not covered here:

1. Check workflow logs in Actions tab
2. Search existing issues: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues
3. Create new issue with:
   - Workflow name and run ID
   - Error message from logs
   - Steps to reproduce
   - Expected vs actual behavior

---

## Best Practices

### 1. Frequent Commits

Make small, frequent commits to catch issues early:

```bash
git add .
git commit -m "feat: add feature X"
git push origin feature/new-feature
```

### 2. Branch Protection

Configure branch protection for `main`:

1. Settings → Branches → Branch protection rules
2. Protect `main` branch:
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Require pull request reviews before merging
   - ✅ Require conversation resolution

### 3. Review Artifacts Before Release

Always download and test artifacts:

```bash
# Download debug APK from PR
# Install on device
adb install app-debug.apk

# Test all functionality
# If OK, approve PR and merge
```

### 4. Maintain Test Coverage

Keep test coverage ≥80%:

```bash
# Generate coverage report
flutter test --coverage

# View in browser
./scripts/coverage_reporter.sh --html
# Opens coverage/html/index.html
```

### 5. Keep Secrets Secure

- 🔒 Rotate only if compromised
- 🔒 Never share passwords or keystore
- 🔒 Keep backups in secure location
- 🔒 Use different keystores for development/production

### 6. Monitor Workflow Runs

- 📊 Check Actions tab regularly
- 📊 Fix failing workflows promptly
- 📊 Review build times for optimization
- 📊 Clean up old artifacts periodically

---

## Workflow Status Badge

Add this badge to your README.md to show CI/CD status:

```markdown
![CI/CD](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions/workflows/ci-cd.yml/badge.svg)
```

This displays the current status of the CI/CD workflow.

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Semantic Versioning](https://semver.org/)
- [Gradle Build Cache](https://docs.gradle.org/current/userguide/build_cache.html)

---

## Quick Reference

### Common Commands

```bash
# View current version
./scripts/version_manager.sh current

# Bump version
./scripts/version_manager.sh patch

# Generate keystore
./scripts/keystore_manager.sh --generate

# Create key.properties
./scripts/keystore_manager.sh --create-properties

# Local release build
flutter build apk --release

# Verify signing
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk

# Create and push tag
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0
```

### Workflow URLs

- **Actions**: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/actions
- **Releases**: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases
- **Secrets**: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/settings/secrets/actions

---

**Last Updated**: December 2024  
**Document Version**: 2.0
