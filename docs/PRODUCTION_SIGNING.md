# 🔐 Production Signing Configuration Guide

## ⚠️ IMPORTANT: Current Status

**The project currently uses DEBUG signing for release builds.**  
This is acceptable for development/testing but **MUST be changed before production release**.

## 🎯 Why This Matters

- **Debug keystores are publicly known** - anyone can sign APKs with the same key
- **Google Play requires production signatures** - debug-signed APKs will be rejected
- **Security risk** - Users cannot verify authenticity of updates
- **Cannot publish** - Release distribution requires proper signing

## 📋 Step-by-Step Setup

### Step 1: Generate Production Keystore

Run this command in your project root:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**You will be prompted for:**
- Keystore password (choose a strong password, save it securely)
- Key password (can be same as keystore password)
- Your name / organization details

**⚠️ CRITICAL: Store these passwords securely!**
- Use a password manager
- Never commit passwords to git
- Backup the keystore file securely (but NOT in git)

### Step 2: Create key.properties File

Create `android/key.properties` with:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

**⚠️ This file is automatically ignored by git (.gitignore)**

### Step 3: Update build.gradle

Edit `android/app/build.gradle`:

**Find this section (around line 52):**
```gradle
signingConfigs {
    debug {
        storeFile file('debug.keystore')
        storePassword 'android'
        keyAlias 'androiddebugkey'
        keyPassword 'android'
    }
    // Para release, crear keystore con:
    // keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    // y configurar key.properties
}
```

**Replace with:**
```gradle
// Load keystore properties
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    debug {
        storeFile file('debug.keystore')
        storePassword 'android'
        keyAlias 'androiddebugkey'
        keyPassword 'android'
    }
    
    release {
        if (keystorePropertiesFile.exists()) {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

**Find this section (around line 64):**
```gradle
buildTypes {
    release {
        signingConfig signingConfigs.debug  // ⚠️ CHANGE THIS
        // TODO: Cambiar a signingConfig signingConfigs.release cuando tengas keystore
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

**Change to:**
```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release  // ✅ FIXED
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
    debug {
        signingConfig signingConfigs.debug
    }
}
```

### Step 4: Verify Configuration

Build a release APK to verify:

```bash
flutter build apk --release
```

Check the signature:

```bash
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

You should see your certificate details (not the Android debug certificate).

### Step 5: Backup Keystore Securely

**CRITICAL: Backup your keystore file!**

If you lose the keystore, you **cannot update your app** on Google Play.

**Recommended backup locations:**
- 🔐 Password manager with file attachments
- 💾 Encrypted USB drive (offline)
- ☁️ Encrypted cloud storage (separate from code repo)
- 🏢 Company secure vault

**⚠️ NEVER:**
- Commit keystore to git
- Email keystore
- Store on public cloud without encryption
- Share with unauthorized people

## 🔒 Security Best Practices

### 1. Password Strength
```
❌ Weak: password123
✅ Strong: K9#mP2$vL8@nQ5!xR7
```

Use a password manager to generate and store.

### 2. Key Validity
- Default: 10,000 days (~27 years)
- Google Play requires validity past 2033
- Our command generates keys valid until ~2052

### 3. Access Control
- Limit who has access to keystore
- Use different keys for different apps
- Consider using Google Play App Signing (recommended)

### 4. CI/CD Integration

For GitHub Actions, use secrets:

```yaml
# .github/workflows/release.yml
- name: Build Release APK
  env:
    KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
    KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
    KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
  run: |
    echo "$KEYSTORE_BASE64" | base64 -d > android/app/upload-keystore.jks
    echo "storePassword=$KEYSTORE_PASSWORD" > android/key.properties
    echo "keyPassword=$KEY_PASSWORD" >> android/key.properties
    echo "keyAlias=upload" >> android/key.properties
    echo "storeFile=upload-keystore.jks" >> android/key.properties
    flutter build apk --release
```

**Add these secrets in GitHub:**
1. Go to Settings → Secrets → Actions
2. Add `KEYSTORE_BASE64`: `base64 android/app/upload-keystore.jks`
3. Add `KEYSTORE_PASSWORD`: your keystore password
4. Add `KEY_PASSWORD`: your key password

## 🎯 Google Play App Signing (Recommended)

Google Play offers **App Signing** where Google manages your signing key:

**Benefits:**
- Google securely stores your key
- You upload an "upload key" instead
- Google signs the final APK/AAB
- Can reset upload key if lost

**Setup:**
1. Opt-in to Google Play App Signing (one-time, irreversible)
2. Generate upload key (same process as above)
3. Upload your upload certificate to Google Play
4. Google generates and manages the signing key

**More info:** https://support.google.com/googleplay/android-developer/answer/9842756

## ✅ Verification Checklist

Before releasing:

- [ ] Production keystore generated
- [ ] key.properties created and NOT in git
- [ ] build.gradle updated to use release signing
- [ ] Test build with `flutter build apk --release` succeeds
- [ ] Verified signature with `keytool -printcert`
- [ ] Keystore backed up securely (offline)
- [ ] Passwords stored in password manager
- [ ] Team members with access documented
- [ ] CI/CD secrets configured (if applicable)
- [ ] Tested APK installation on device

## 🆘 Troubleshooting

### Error: "keystore file does not exist"
```
Check: android/key.properties has correct path
Should be: storeFile=upload-keystore.jks
Not: storeFile=/absolute/path/to/upload-keystore.jks
```

### Error: "keystore password was incorrect"
```
Verify password in key.properties matches keystore password
Check for extra spaces or special characters
```

### Error: "key does not exist"
```
Verify keyAlias in key.properties matches alias used during generation
Default: upload
```

### Build works locally but fails in CI/CD
```
Ensure keystore and key.properties are available in CI environment
Use secrets/environment variables
Never commit keystore to git
```

## 📚 Additional Resources

- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Flutter Deployment](https://docs.flutter.dev/deployment/android)
- [Google Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)
- [Keytool Documentation](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html)

## 📞 Support

If you encounter issues:
1. Check this guide first
2. Review Android documentation
3. Open an issue in the repository (do NOT include passwords/keys)
4. Contact the development team

---

**Last Updated:** 2025-12-15  
**Version:** 1.0  
**Status:** ⚠️ ACTION REQUIRED - Setup production signing before release
