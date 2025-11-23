# Android AAB Build Workflow

This document describes the GitHub Actions workflow for building signed Android App Bundle (AAB) files for the Tokyo Predictor Roulette application.

## Overview

The `android-aab.yml` workflow automates the process of building and signing Android AAB files in a secure manner, without storing sensitive keystore files or passwords in the repository.

## Workflow File

- **Location:** `.github/workflows/android-aab.yml`
- **Triggers:**
  - Push to `main` branch
  - Pull requests targeting `main` branch

## How It Works

### 1. Environment Setup

The workflow sets up the build environment with:
- **Ubuntu latest** runner
- **Java 17** (Temurin distribution) for Android builds
- **Flutter SDK** (stable channel) for the app framework

### 2. Secret Verification

Before attempting to build, the workflow verifies that all required secrets are configured:
- `KEYSTORE_BASE64` - Base64-encoded keystore file
- `KEYSTORE_PASSWORD` - Keystore password
- `KEY_ALIAS` - Key alias in the keystore
- `KEY_PASSWORD` - Key password

If any secret is missing, the workflow fails immediately with a clear error message.

### 3. Keystore Restoration

The workflow uses the `scripts/decode-keystore.sh` helper script to:
1. Decode the base64-encoded keystore from the `KEYSTORE_BASE64` secret
2. Write it to a temporary file
3. Set restrictive permissions (600 - owner read/write only)
4. Return the path to the decoded keystore

### 4. AAB Build

The workflow runs `flutter build appbundle --release` with the following environment variables:
- `ANDROID_KEYSTORE_PATH` - Path to the decoded keystore
- `KEYSTORE_PASSWORD` - Keystore password (masked in logs)
- `KEY_ALIAS` - Key alias
- `KEY_PASSWORD` - Key password (masked in logs)

The Flutter build process reads these environment variables and uses them to sign the AAB.

### 5. Artifact Upload

The signed AAB file is uploaded as a workflow artifact:
- **Artifact name:** `android-release-aab`
- **File:** `build/app/outputs/bundle/release/app-release.aab`
- **Retention:** 30 days

### 6. Cleanup

The workflow always removes the temporary keystore file, even if the build fails.

## Required Secrets

You must configure the following repository secrets before the workflow can run successfully. See [config/keystore/README.md](../../config/keystore/README.md) for detailed setup instructions.

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `KEYSTORE_BASE64` | Base64-encoded Android keystore file | ✅ Yes |
| `KEYSTORE_PASSWORD` | Password for the keystore | ✅ Yes |
| `KEY_ALIAS` | Alias of the signing key | ✅ Yes |
| `KEY_PASSWORD` | Password for the signing key | ✅ Yes |

## Triggering a Build

### Automatic Triggers

The workflow runs automatically when:

1. **Code is pushed to main:**
   ```bash
   git push origin main
   ```

2. **A pull request is opened or updated:**
   ```bash
   # Create a new branch and push
   git checkout -b feature/my-feature
   git push origin feature/my-feature
   # Then open a PR on GitHub
   ```

### Manual Trigger

You can also manually trigger the workflow from the GitHub Actions UI:

1. Go to **Actions** tab in the repository
2. Select **Build Android AAB** workflow
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

## Downloading Build Artifacts

After a successful workflow run:

1. Navigate to the **Actions** tab
2. Click on the specific workflow run
3. Scroll to the **Artifacts** section at the bottom
4. Download the `android-release-aab` artifact (ZIP file)
5. Extract to get `app-release.aab`

## Local Development

To build AAB files locally without the CI workflow:

### Option 1: Using Environment Variables

```bash
export ANDROID_KEYSTORE_PATH=/path/to/your/keystore.jks
export KEYSTORE_PASSWORD=your_keystore_password
export KEY_ALIAS=your_key_alias
export KEY_PASSWORD=your_key_password

flutter build appbundle --release
```

### Option 2: Using key.properties File

Create `android/key.properties`:

```properties
storeFile=/path/to/your/keystore.jks
storePassword=your_keystore_password
keyAlias=your_key_alias
keyPassword=your_key_password
```

Then run:

```bash
flutter build appbundle --release
```

**Note:** Never commit `key.properties` to the repository!

## Workflow Security Features

### Secret Masking

Sensitive values (passwords) are automatically masked in workflow logs using `::add-mask::` annotations. This prevents accidental exposure in build logs.

### Restrictive Permissions

The temporary keystore file is created with `600` permissions (owner read/write only), preventing other users on the runner from accessing it.

### Automatic Cleanup

The keystore file is always deleted after the build, even if the build fails, using the `if: always()` condition.

### Fail-Fast Validation

The workflow validates all required secrets before attempting to decode the keystore or build the AAB, providing clear error messages if anything is missing.

## Troubleshooting

### Workflow fails at "Verify required secrets"

**Cause:** One or more required secrets are not configured.

**Solution:** 
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Verify all four secrets are present: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`
3. See [config/keystore/README.md](../../config/keystore/README.md) for setup instructions

### Workflow fails at "Decode and restore keystore"

**Cause:** The base64-encoded keystore is invalid or corrupted.

**Solution:**
1. Re-encode your keystore: `base64 -w 0 my-release-key.jks > keystore.base64.txt`
2. Update the `KEYSTORE_BASE64` secret with the new value
3. Ensure the base64 string has no line breaks

### Workflow fails at "Build Android AAB"

**Cause:** Incorrect keystore password, key alias, or key password.

**Solution:**
1. Verify the passwords match your keystore
2. List aliases in your keystore: `keytool -list -v -keystore my-release-key.jks`
3. Update the secrets with correct values

### AAB artifact not uploaded

**Cause:** Build failed or AAB was not created at the expected path.

**Solution:**
1. Check workflow logs for build errors
2. Verify Flutter build configuration in `android/app/build.gradle`
3. Ensure signing configuration is properly set up

## Related Documentation

- [Keystore Configuration Guide](../../config/keystore/README.md) - Setting up keystores and secrets
- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android) - Official Flutter documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - GitHub Actions reference

## Support

If you encounter issues not covered in this documentation:

1. Check the [workflow file](.github/workflows/android-aab.yml) for the latest configuration
2. Review the [decode-keystore.sh script](../../scripts/decode-keystore.sh) for keystore handling
3. Open an issue in the repository with workflow logs and error messages
