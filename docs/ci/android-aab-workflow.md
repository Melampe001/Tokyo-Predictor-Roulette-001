# Android AAB Build Workflow

This document describes the GitHub Actions workflow for building signed Android App Bundle (AAB) files without committing keystores or secrets to the repository.

## Overview

The `android-aab.yml` workflow automates the process of building signed AAB artifacts for Android applications. It securely handles keystore files and signing credentials using GitHub Secrets, ensuring that sensitive information never appears in the repository or build logs.

## Workflow Features

- ✅ Automated builds on push to `main` and pull requests
- ✅ Java 17 (Temurin distribution) setup
- ✅ Android SDK components installation
- ✅ Secure keystore handling (base64-encoded secret)
- ✅ Automatic secret validation with clear error messages
- ✅ Secret masking in logs
- ✅ AAB artifact upload
- ✅ Automatic keystore cleanup after build

## How the Workflow Works

### 1. Trigger Events

The workflow runs automatically on:
- **Push to main branch**: Builds when code is merged to main
- **Pull requests targeting main**: Validates builds before merging

You can also manually trigger the workflow from the Actions tab if needed.

### 2. Build Steps

1. **Checkout code**: Retrieves the repository code
2. **Set up JDK 17**: Installs Temurin Java 17 distribution
3. **Validate secrets**: Checks that all required secrets are configured
   - Fails fast with clear error messages if secrets are missing
4. **Install Android SDK**: Installs platform tools, Android 33 SDK, and build tools
5. **Decode keystore**: Runs `scripts/decode-keystore.sh` to:
   - Decode the base64-encoded keystore
   - Write it to a temporary file with secure permissions (600)
   - Return the keystore file path
6. **Build AAB**: Runs `./gradlew bundleRelease` with signing properties:
   - Passes keystore path and credentials via Gradle system properties
   - Masks sensitive values in logs
7. **Upload artifact**: Uploads the generated AAB file as a workflow artifact
8. **Cleanup**: Removes the temporary keystore file (runs even if build fails)

### 3. Required Secrets

Before running this workflow, you must configure these GitHub repository secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file | (long base64 string) |
| `KEYSTORE_PASSWORD` | Keystore file password | `MyStrongPassword123` |
| `KEY_ALIAS` | Key alias in the keystore | `my-release-key` |
| `KEY_PASSWORD` | Password for the specific key | `MyKeyPassword456` |

📖 **See detailed setup instructions**: [config/keystore/README.md](../../config/keystore/README.md)

## How to Trigger the Workflow

### Automatic Triggers

The workflow runs automatically when:
1. You push commits to the `main` branch
2. You open or update a pull request targeting `main`

### Manual Trigger

1. Go to your repository on GitHub
2. Click the **Actions** tab
3. Select **Build Android AAB** from the workflows list
4. Click **Run workflow**
5. Select the branch and click **Run workflow**

## Accessing Build Artifacts

After a successful build:

1. Go to the **Actions** tab in your repository
2. Click on the completed workflow run
3. Scroll to the **Artifacts** section at the bottom
4. Download **app-release-aab** artifact

The downloaded artifact will contain your signed AAB file ready for upload to Google Play Console.

## Security Considerations

### What Makes This Workflow Secure?

- ✅ **No keystore in repository**: Keystore is stored as a GitHub secret, never committed
- ✅ **No plaintext passwords**: All credentials are stored as encrypted secrets
- ✅ **Secret masking**: Sensitive values are automatically masked in logs
- ✅ **Restrictive permissions**: Keystore file has 600 permissions (owner read/write only)
- ✅ **Automatic cleanup**: Temporary keystore is deleted after build
- ✅ **Validation checks**: Workflow fails fast if secrets are missing or invalid

### Best Practices

1. **Limit secret access**: Only grant repository secret access to trusted team members
2. **Use strong passwords**: Ensure keystore and key passwords are strong and unique
3. **Backup securely**: Keep an offline backup of your keystore in a secure location
4. **Rotate regularly**: Consider rotating signing keys periodically (requires new keystore)
5. **Monitor workflows**: Review workflow runs for any unusual activity

## Troubleshooting

### Common Issues

**Workflow fails: "KEYSTORE_BASE64 secret is not set"**
- Solution: Configure the required secret in repository settings
- See: [config/keystore/README.md](../../config/keystore/README.md)

**Workflow fails: "Failed to decode KEYSTORE_BASE64"**
- Solution: Re-encode your keystore using `base64 -w 0 my-release-key.jks`
- Ensure no extra whitespace or line breaks

**Build fails: "./gradlew: Permission denied"**
- Solution: Ensure `gradlew` has execute permissions in the repository
- Run: `git update-index --chmod=+x gradlew`

**Build fails: "Keystore was tampered with, or password was incorrect"**
- Solution: Verify `KEYSTORE_PASSWORD` secret matches your actual keystore password

**AAB artifact not uploaded**
- Solution: Check that `app/build/outputs/bundle/release/*.aab` path is correct
- Verify the build completed successfully before artifact upload step

## Local Testing

To test the signing process locally before pushing:

1. Create a `key.properties` file in the Android project root (DO NOT commit):
   ```properties
   storeFile=/path/to/my-release-key.jks
   storePassword=your-keystore-password
   keyAlias=your-key-alias
   keyPassword=your-key-password
   ```

2. Run the Gradle build locally:
   ```bash
   ./gradlew bundleRelease
   ```

3. Verify the AAB is created at `app/build/outputs/bundle/release/`

**Important**: Add `key.properties` to `.gitignore` to prevent accidental commits!

## References

- [Android App Bundle Documentation](https://developer.android.com/guide/app-bundle)
- [Sign your app](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
