# Android Keystore Configuration

This directory contains documentation for managing Android keystores used in the CI/CD pipeline for signing release builds.

## Overview

For security reasons, we **DO NOT** commit keystore files or plaintext passwords to this repository. Instead, we store them as GitHub repository secrets and decode them during the CI build process.

## Creating a New Keystore

If you don't already have a release keystore, you can create one using the Java `keytool` utility:

```bash
keytool -genkey -v -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias
```

You will be prompted to:
- Set a keystore password (store this securely!)
- Set a key password (store this securely!)
- Provide information for the certificate (name, organization, location, etc.)

**Important:** Keep your keystore file and passwords in a secure location. If you lose them, you cannot update your app in the Play Store!

## Preparing Keystore for GitHub Secrets

### 1. Encode the Keystore to Base64

To store your keystore in GitHub Secrets, you need to encode it as a base64 string:

```bash
# On Linux/macOS (single line, no line breaks):
base64 -w 0 my-release-key.jks > keystore.base64.txt

# On macOS (alternative):
base64 -i my-release-key.jks -o keystore.base64.txt

# The output file will contain a long string like:
# /u3+7QAAAAIAAAABAAAAAQALbXkta2V5LWFsaWFzAAABj...
```

The `-w 0` flag (Linux) ensures no line breaks are inserted in the output.

### 2. Set Up GitHub Repository Secrets

Navigate to your repository on GitHub:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add the following four secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file | (contents of keystore.base64.txt) |
| `KEYSTORE_PASSWORD` | Password for the keystore | `myKeystorePassword123` |
| `KEY_ALIAS` | Alias of the key in the keystore | `my-key-alias` |
| `KEY_PASSWORD` | Password for the specific key | `myKeyPassword456` |

**Security Tips:**
- Never commit these values to the repository
- Use strong, unique passwords
- Limit access to repository secrets to trusted maintainers only
- Regularly audit who has access to repository settings

## Verifying Your Configuration

After setting up the secrets, you can verify the configuration by:

1. Pushing a commit to the `main` branch or opening a pull request
2. The GitHub Actions workflow will attempt to build the AAB
3. Check the workflow logs for any errors related to keystore or signing

## Rotating Keys

If you need to rotate your signing keys (security incident, key compromise, etc.):

1. **Create a new keystore** using the steps above
2. **Encode the new keystore** to base64
3. **Update the GitHub secrets** with new values
4. **Test the build** to ensure it works with the new keystore

**Warning:** If you change the signing key for an existing app in the Play Store, you cannot update that app anymore. You would need to publish it as a new app. Only rotate keys if absolutely necessary!

## Troubleshooting

### Build fails with "keystore not found"

- Verify that `KEYSTORE_BASE64` secret is set correctly
- Check that the base64 encoding was done without line breaks
- Review the workflow logs for decode errors

### Build fails with "incorrect password"

- Double-check `KEYSTORE_PASSWORD` and `KEY_PASSWORD` secrets
- Verify that you're using the correct passwords from when you created the keystore
- Ensure no extra spaces or characters were added to the secrets

### Build fails with "key alias not found"

- Verify that `KEY_ALIAS` matches the alias used when creating the keystore
- You can list aliases in a keystore with: `keytool -list -v -keystore my-release-key.jks`

## Local Development

For local development and testing, you can create a `key.properties` file in the `android/` directory:

```properties
storeFile=/path/to/your/keystore.jks
storePassword=your_keystore_password
keyAlias=your_key_alias
keyPassword=your_key_password
```

**Important:** The `key.properties` file is gitignored and should never be committed!

## Additional Resources

- [Android App Signing Documentation](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Flutter Android Build Configuration](https://docs.flutter.dev/deployment/android)
