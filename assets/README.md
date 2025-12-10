# Tokyo Predictor Roulette - Assets

This folder contains the app assets including icons and splash screens.

## Required Assets

### App Icon
- `icon.png` - Main app icon (1024x1024 recommended)
- Generated adaptive icons will be placed in `android/app/src/main/res/`

### Splash Screen
- `splash.png` - Splash screen background

## Icon Generation

To generate Android adaptive icons, use the `flutter_launcher_icons` package:

```bash
flutter pub add flutter_launcher_icons --dev
flutter pub run flutter_launcher_icons
```

## Asset Configuration

Assets are configured in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

## Brand Guidelines

- Primary Color: Tokyo Red (#E60012)
- Secondary Color: Dark Blue (#1A237E)
- Background: White (#FFFFFF)

## Contact

For brand assets, contact: tokraagcorp@gmail.com

---
© 2024 TokyoApps/TokRaggcorp
