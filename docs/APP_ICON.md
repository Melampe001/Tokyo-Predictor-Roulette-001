# App Icon Configuration

## Current Status

The app currently references `@mipmap/ic_launcher` in the AndroidManifest.xml but no icon files are present.

## To Add App Icons

### Option 1: Using flutter_launcher_icons (Recommended)

1. Add to `pubspec.yaml` under `dev_dependencies`:
```yaml
flutter_launcher_icons: ^0.13.1
```

2. Add icon configuration to `pubspec.yaml`:
```yaml
flutter_icons:
  android: true
  ios: false
  image_path: "assets/images/app_icon.png"
```

3. Place your icon image (1024x1024 PNG) in `assets/images/app_icon.png`

4. Run the generator:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Option 2: Manual Icon Creation

Create icons for different densities and place them in:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

### Option 3: Use Android Asset Studio

1. Visit [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html)
2. Upload your icon or create one
3. Download the generated ZIP
4. Extract and copy the mipmap folders to `android/app/src/main/res/`

## Default Behavior

Currently, the app will use Flutter's default icon when built. The app will still compile and run without a custom icon.
