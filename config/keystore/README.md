# Keystore Configuration for Android AAB Builds

This document explains how to configure the required GitHub repository secrets for building signed Android AAB (Android App Bundle) files in CI/CD.

## Overview

To build signed Android AAB artifacts in GitHub Actions, you need to provide your keystore file and signing credentials as GitHub repository secrets. The keystore file is encoded in base64 to safely store it as a secret.

## Required GitHub Repository Secrets

You need to configure the following four secrets in your GitHub repository:

1. **KEYSTORE_BASE64** - Base64-encoded keystore file
2. **KEYSTORE_PASSWORD** - Password for the keystore file
3. **KEY_ALIAS** - Alias of the key in the keystore
4. **KEY_PASSWORD** - Password for the specific key

## How to Create and Encode Your Keystore

### Step 1: Create a Keystore (if you don't have one)

If you don't already have a keystore, create one using `keytool`:

```bash
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

You'll be prompted to set:
- Keystore password
- Key password
- Your name and organizational details

### Step 2: Encode the Keystore to Base64

On Linux/macOS, use the following command to encode your keystore:

```bash
base64 -w 0 my-release-key.jks
```

On Windows, use:

```powershell
certutil -encode my-release-key.jks keystore.b64
```

Then remove the header/footer lines and join all lines into a single string.

### Step 3: Add Secrets to GitHub Repository

1. Navigate to your repository on GitHub
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each of the four secrets:
   - Name: `KEYSTORE_BASE64`, Value: (paste the base64-encoded keystore)
   - Name: `KEYSTORE_PASSWORD`, Value: (your keystore password)
   - Name: `KEY_ALIAS`, Value: (your key alias)
   - Name: `KEY_PASSWORD`, Value: (your key password)

## Security Best Practices

⚠️ **IMPORTANT**: 
- **Never commit your keystore file or plaintext passwords to the repository**
- Store your keystore file securely offline (e.g., password manager, secure backup)
- Use strong passwords for both keystore and key
- Limit access to repository secrets to trusted team members only
- Rotate keys periodically if possible

## Verification

After configuring the secrets, the GitHub Actions workflow will automatically:
1. Validate that all required secrets are present
2. Decode the keystore from base64
3. Set secure file permissions (600)
4. Use the keystore to sign the AAB
5. Clean up the temporary keystore file after the build

## Troubleshooting

**Error: "KEYSTORE_BASE64 secret is not set"**
- Verify the secret name is exactly `KEYSTORE_BASE64` (case-sensitive)
- Check that the secret is set in the correct repository

**Error: "Failed to decode KEYSTORE_BASE64"**
- Verify the base64 encoding was done correctly
- Ensure no extra whitespace or line breaks were introduced
- Re-encode the keystore using `base64 -w 0` and update the secret

**Build fails with signing errors**
- Verify KEYSTORE_PASSWORD, KEY_ALIAS, and KEY_PASSWORD are correct
- Test signing locally with the same credentials first
