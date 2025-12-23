# Firebase Setup Guide - Tokyo Roulette Predictor

Complete guide for setting up Firebase integration in the Tokyo Roulette Predictor app.

## ⚠️ Important Note

Firebase has been **fully integrated** into the codebase with comprehensive services for Authentication, Firestore, Analytics, Remote Config, Cloud Messaging, Crashlytics, and Performance Monitoring.

## 📦 What's Already Implemented

All Firebase services are implemented and ready to use:

✅ **Authentication** - Email/Password, Google Sign-In, Anonymous auth  
✅ **Cloud Firestore** - Full CRUD operations, real-time listeners  
✅ **Analytics** - Comprehensive event tracking  
✅ **Cloud Messaging** - Push notifications with FCM  
✅ **Remote Config** - Dynamic configuration  
✅ **Crashlytics** - Error reporting and crash analytics  
✅ **Performance Monitoring** - App performance tracking  
✅ **Security Rules** - Firestore and Storage rules configured  

## 🚀 Quick Start

1. **Install Firebase CLI**:
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

2. **Configure Firebase**:
```bash
firebase login
flutterfire configure
```

3. **Deploy Security Rules**:
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

4. **Enable Services** in Firebase Console:
   - Authentication (Email, Google, Anonymous)
   - Cloud Firestore
   - Cloud Messaging
   - Remote Config
   - Analytics, Crashlytics, Performance (auto-enabled)

5. **Update Android Config**: Uncomment Firebase plugin lines in `android/build.gradle` and `android/app/build.gradle`

## 📚 Full Documentation

See `docs/FIREBASE_SETUP.md` for complete setup instructions.

## 🔐 Security

- All sensitive files (google-services.json) are in `.gitignore`
- Security rules deployed for Firestore and Storage
- No hardcoded API keys in codebase

---

**Ready to use!** Just configure your Firebase project and run the app.
