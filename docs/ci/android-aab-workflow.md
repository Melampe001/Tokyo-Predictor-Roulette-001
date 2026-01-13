# Android AAB Build Workflow Documentation

This document explains the GitHub Actions workflow for building signed Android App Bundles (AAB) securely.

## Overview

The `android-aab.yml` workflow automates the process of building a signed Android App Bundle (AAB) for release distribution on Google Play Store. The workflow uses GitHub Secrets to securely handle the keystore and signing credentials without committing sensitive files to the repository.

## Workflow File Location

`.github/workflows/android-aab.yml`

## Triggers

The workflow runs automatically on:

- **Push to `main` branch**: Builds are triggered whenever code is pushed to the main branch
- **Pull requests targeting `main` branch**: Validates that PRs can build successfully before merging

## Required Secrets

Before the workflow can run successfully, you must configure the following GitHub repository secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `KEYSTORE_BASE64` | Base64-encoded Android keystore file | `MIIKXwIBAzCC...` (long string) |
| `KEYSTORE_PASSWORD` | Password for the keystore file | `my-secure-password` |
| `KEY_ALIAS` | Alias of the signing key in the keystore | `my-key-alias` |
| `KEY_PASSWORD` | Password for the signing key | `my-key-password` |

**📖 For detailed instructions on creating and configuring these secrets, see:** [config/keystore/README.md](../../config/keystore/README.md)

## Android Project Configuration

The workflow creates a `key.properties` file during the build process with the signing credentials. Your Android project's `build.gradle` file should be configured to read from this file.

If you haven't configured signing yet, add this to `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
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

This configuration allows the workflow to provide signing credentials via the temporary `key.properties` file.

## Workflow Steps

### 1. Checkout Code
Uses `actions/checkout@v4` to clone the repository.

### 2. Validate Required Secrets
Validates that all four required secrets are configured. The build fails fast with a clear error message if any secret is missing.

### 3. Set Up JDK 17
Configures Java Development Kit 17 (Temurin distribution) required for Android builds.

### 4. Setup Flutter
Installs Flutter SDK on the build environment.

### 5. Install Flutter Dependencies
Runs `flutter pub get` to install all dependencies defined in `pubspec.yaml`.

### 6. Decode and Setup Keystore
- Executes the `scripts/decode-keystore.sh` script
- Decodes the base64-encoded keystore from `KEYSTORE_BASE64` secret
- Writes the keystore to a secure temporary file with `chmod 600` permissions
- Masks the keystore path in logs for security
- Validates that the keystore file was created successfully

### 7. Install Android SDK Components
Installs required Android SDK components:
- Platform tools
- Android API 34 platform
- Build tools 34.0.0

These are necessary for building the AAB.

### 8. Build AAB with Signing
- Builds the release AAB using `flutter build appbundle`
- Passes signing credentials via environment variables
- Masks all secrets in workflow logs
- Validates that the AAB was created successfully
- Build number is automatically set to the GitHub Actions run number

### 9. Upload AAB Artifact
Uploads the built AAB file as a workflow artifact:
- **Artifact name**: `app-release-aab`
- **Path**: `build/app/outputs/bundle/release/app-release.aab`
- **Retention**: 30 days

### 10. Clean Up Keystore
- Securely removes the temporary keystore file using `shred` (or `rm` as fallback)
- Removes temporary files
- Runs even if previous steps fail (`if: always()`)

## How to Trigger a Build

### Automatic Triggers

1. **On Push to Main**:
   ```bash
   git checkout main
   git add .
   git commit -m "Your changes"
   git push origin main
   ```

2. **On Pull Request**:
   - Create a pull request targeting the `main` branch
   - The workflow runs automatically on PR creation and updates

### Manual Trigger

To manually trigger the workflow (requires adding `workflow_dispatch` trigger):

1. Go to: **Actions** → **Build Android AAB (Secure)** → **Run workflow**
2. Select the branch and click **Run workflow**

*Note: The current workflow doesn't have `workflow_dispatch` enabled. To add it, include it in the workflow triggers.*

## Downloading Built AAB

After a successful build:

1. Navigate to the workflow run: **Actions** → Select the run
2. Scroll to **Artifacts** section at the bottom
3. Download `app-release-aab` artifact
4. Extract the ZIP file to get `app-release.aab`

## Build Artifacts

The workflow produces:

- **AAB File**: `app-release.aab` - Ready for upload to Google Play Console
- **Retention**: Available for 30 days after the build

## Security Features

### Secret Masking
All sensitive values are masked in workflow logs:
- Keystore path
- Keystore password
- Key alias
- Key password

This prevents accidental exposure in build logs.

### Temporary Keystore
The keystore is:
- Decoded to a temporary location (`/tmp/android-keystore-<pid>`)
- Created with restrictive permissions (`chmod 600`)
- Securely deleted after the build completes
- Never committed to the repository

### Fail-Fast Validation
The workflow validates required secrets at the start and fails immediately with clear error messages if any are missing.

### Secure Cleanup
The cleanup step:
- Uses `shred` to securely overwrite the keystore file before deletion
- Runs even if the build fails (`if: always()`)
- Removes all temporary files

## Troubleshooting

### Build fails: "Missing required secret"
**Problem**: One or more required secrets are not configured.

**Solution**: 
1. Go to **Settings → Secrets and variables → Actions**
2. Add the missing secret(s)
3. See [config/keystore/README.md](../../config/keystore/README.md) for details

### Build fails: "Failed to decode base64 keystore"
**Problem**: The `KEYSTORE_BASE64` secret contains invalid data.

**Solution**:
1. Re-encode your keystore using: `base64 -w 0 my-release-key.jks`
2. Update the `KEYSTORE_BASE64` secret with the new value
3. Ensure there are no line breaks or extra whitespace

### Build fails: "Keystore file not found"
**Problem**: The decode script failed to create the keystore file.

**Solution**:
1. Check the workflow logs for error messages from `decode-keystore.sh`
2. Verify `KEYSTORE_BASE64` is correctly encoded
3. Ensure the script has execute permissions (already set in repository)

### Build fails: "incorrect password"
**Problem**: The signing credentials don't match the keystore.

**Solution**:
1. Verify `KEYSTORE_PASSWORD` matches your keystore password
2. Verify `KEY_PASSWORD` matches the key password
3. Verify `KEY_ALIAS` matches the alias used in the keystore

### AAB not uploaded
**Problem**: The build succeeded but no artifact is available.

**Solution**:
1. Check workflow logs for the "Upload AAB artifact" step
2. Verify the AAB was built: check "Build AAB with signing" step output
3. Ensure the build path is correct: `build/app/outputs/bundle/release/app-release.aab`

## Workflow Configuration

### Customizing the Build

To customize the workflow, edit `.github/workflows/android-aab.yml`:

**Change Android SDK version**:
```yaml
"platforms;android-34" → "platforms;android-33"
"build-tools;34.0.0" → "build-tools;33.0.0"
```

**Change artifact retention**:
```yaml
retention-days: 30 → retention-days: 90
```

**Add manual trigger**:
```yaml
on:
  workflow_dispatch:  # Add this line
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

## Related Documentation

- **Keystore Setup Guide**: [config/keystore/README.md](../../config/keystore/README.md)
- **Flutter Build Documentation**: https://docs.flutter.dev/deployment/android
- **GitHub Actions Secrets**: https://docs.github.com/en/actions/security-guides/encrypted-secrets

## Support

For issues or questions:
1. Check the [troubleshooting section](#troubleshooting) above
2. Review workflow logs in GitHub Actions
3. Consult the [keystore README](../../config/keystore/README.md)
4. Open an issue in the repository with workflow logs attached

## Best Practices

1. **Never commit keystore files** - Always use base64-encoded secrets
2. **Regularly backup your keystore** - Store it securely offline
3. **Rotate secrets periodically** - Update credentials if compromised
4. **Monitor workflow runs** - Check for failed builds regularly
5. **Test PRs before merging** - The workflow validates PRs automatically
6. **Keep dependencies updated** - Regularly update Flutter and Android SDK versions

## Version History

- **v1.0**: Initial implementation with secure keystore handling and AAB build support
