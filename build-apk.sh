#!/bin/bash
set -e
echo "🚀 BUILD APK ACELERADO"
flutter clean
flutter pub get
flutter build apk --release --no-tree-shake-icons
echo "✅ APK generada en: build/app/outputs/flutter-apk/app-release.apk"
ls -lh build/app/outputs/flutter-apk/app-release.apk
