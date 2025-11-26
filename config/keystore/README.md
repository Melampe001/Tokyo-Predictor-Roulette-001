# Android Keystore Configuration Guide

This directory contains documentation for setting up secure Android keystore handling in GitHub Actions.

## Overview

To build signed Android App Bundles (AAB) in CI/CD, you need to configure keystore credentials as GitHub repository secrets. This approach ensures that:

- ✅ No plaintext keystores are committed to the repository
- ✅ Sensitive signing credentials remain secure
- ✅ AAB files are properly signed for Google Play Store distribution
- ✅ Keystore files are temporarily restored during builds and securely cleaned up

## Prerequisites

You need a Java keystore (`.jks` or `.keystore` file) for signing your Android application.

### Creating a New Keystore

If you don't have a keystore yet, create one using the `keytool` command:

```bash
keytool -genkey -v \
  -keystore my-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias my-key-alias
```

You'll be prompted to set:
- **Keystore password**: Password for the keystore file
- **Key password**: Password for the specific key alias
- **Distinguished Name**: Your name, organization, etc.

**Important**: Store your keystore file and passwords securely. If you lose them, you cannot update your app on Google Play Store!

## Step 1: Encode Your Keystore to Base64

Convert your keystore file to a base64-encoded string:

### Using base64 (Linux/macOS):
```bash
base64 -w 0 my-release-key.jks > keystore-base64.txt
```

### Using base64 (macOS alternative):
```bash
base64 -i my-release-key.jks -o keystore-base64.txt
```

### Using OpenSSL (cross-platform):
```bash
openssl base64 -in my-release-key.jks -out keystore-base64.txt -A
```

The output file `keystore-base64.txt` will contain a long string of characters. This is your base64-encoded keystore.

## Step 2: Configure GitHub Repository Secrets

Navigate to your GitHub repository and add the following secrets:

**Settings → Secrets and variables → Actions → New repository secret**

Add these four secrets:

### 1. KEYSTORE_BASE64
- **Value**: The entire contents of `keystore-base64.txt` (the base64-encoded keystore)
- **Description**: Base64-encoded Android release keystore

### 2. KEYSTORE_PASSWORD
- **Value**: The password you set when creating the keystore
- **Description**: Password for the keystore file

### 3. KEY_ALIAS
- **Value**: The alias you used when creating the keystore (e.g., `my-key-alias`)
- **Description**: Alias of the signing key in the keystore

### 4. KEY_PASSWORD
- **Value**: The password for the specific key alias (often same as keystore password)
- **Description**: Password for the signing key

## Step 3: Verify Secrets

After adding all secrets, verify they appear in:
**Settings → Secrets and variables → Actions**

You should see:
- ✅ KEYSTORE_BASE64
- ✅ KEYSTORE_PASSWORD
- ✅ KEY_ALIAS
- ✅ KEY_PASSWORD

## Security Best Practices

### DO:
✅ Keep your keystore file in a secure location (password manager, encrypted storage)
✅ Use different passwords for keystore and key if possible
✅ Regularly backup your keystore file
✅ Limit access to repository secrets to trusted team members only
✅ Rotate secrets if you suspect they've been compromised

### DON'T:
❌ Commit keystore files to version control (add `*.jks`, `*.keystore` to `.gitignore`)
❌ Share keystore passwords in plaintext (email, chat, documents)
❌ Use weak or common passwords
❌ Keep keystore files on shared or unsecured systems

## Keystore Rotation

If you need to rotate your keystore or secrets:

1. **Generate a new keystore** (only if the old one is compromised)
   ```bash
   keytool -genkey -v -keystore my-new-release-key.jks ...
   ```

2. **Update GitHub secrets** with new base64-encoded keystore and passwords
   - Go to Settings → Secrets and variables → Actions
   - Click on each secret and update its value

3. **Verify the workflow** by triggering a build

**Note**: If you're already publishing to Google Play Store, rotating the keystore will require you to publish the app as a new application. Google Play uses the signing key as the app's identity.

## Troubleshooting

### Build fails with "keystore not found"
- Verify `KEYSTORE_BASE64` secret is correctly set
- Check that base64 encoding was done correctly (no line breaks with `-w 0` or `-A` flag)

### Build fails with "incorrect password"
- Verify `KEYSTORE_PASSWORD` and `KEY_PASSWORD` match your keystore
- Check that you're using the correct alias with `KEY_ALIAS`

### Base64 decode errors
- Ensure you used the `-w 0` flag (Linux) or `-A` flag (OpenSSL) to create a single-line output
- Verify no extra whitespace or characters were added when copying the secret

## Additional Resources

- [Android App Signing Documentation](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Flutter Build AppBundle](https://docs.flutter.dev/deployment/android#build-an-app-bundle)

## Support

For issues with the CI/CD workflow, see [docs/ci/android-aab-workflow.md](../../docs/ci/android-aab-workflow.md)
