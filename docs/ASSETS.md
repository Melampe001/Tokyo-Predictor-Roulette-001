# 🖼️ Assets and Resources Documentation

Guide for managing assets, images, icons, and other resources in Tokyo Roulette Predicciones.

## 📋 Table of Contents

- [Asset Organization](#asset-organization)
- [Image Guidelines](#image-guidelines)
- [Icon Management](#icon-management)
- [Font Usage](#font-usage)
- [How to Add New Assets](#how-to-add-new-assets)
- [Asset Optimization](#asset-optimization)

## 📁 Asset Organization

### Current Structure

```
assets/
└── images/
    ├── logo.png
    ├── wheel.png
    └── ...
```

### Recommended Structure

```
assets/
├── images/
│   ├── logos/
│   │   ├── logo.png
│   │   ├── logo_dark.png
│   │   └── splash.png
│   ├── ui/
│   │   ├── roulette_wheel.png
│   │   ├── background.png
│   │   └── chip.png
│   ├── 2.0x/           # 2x resolution
│   │   └── ...
│   └── 3.0x/           # 3x resolution
│       └── ...
├── icons/
│   ├── icon.png        # App icon
│   └── adaptive/
│       ├── foreground.png
│       └── background.png
├── fonts/
│   ├── Roboto-Regular.ttf
│   └── Roboto-Bold.ttf
└── animations/
    └── spin.json       # Lottie animations
```

### Declaring Assets

**pubspec.yaml:**
```yaml
flutter:
  uses-material-design: true
  
  assets:
    # Images
    - assets/images/
    - assets/images/logos/
    - assets/images/ui/
    
    # Icons (if custom)
    - assets/icons/
    
    # Animations
    - assets/animations/
  
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
```

## 🖼️ Image Guidelines

### Image Formats

**PNG (Portable Network Graphics)**
- Use for: Logos, icons, simple graphics
- Pros: Transparency, lossless
- Cons: Larger file size

**JPEG (Joint Photographic Experts Group)**
- Use for: Photos, complex images
- Pros: Small file size
- Cons: No transparency, lossy

**WebP (Modern format)**
- Use for: All images (if supported)
- Pros: Best compression, transparency
- Cons: Requires recent Flutter version

### Resolution Guidelines

Provide multiple resolutions for different screen densities:

**Directory structure:**
```
assets/images/
  logo.png          # 1x (mdpi) - baseline
  2.0x/
    logo.png        # 2x (xhdpi) - standard phones
  3.0x/
    logo.png        # 3x (xxhdpi) - high-end phones
```

**Size examples:**
```
Baseline (1x):  100x100 px
2x resolution:  200x200 px
3x resolution:  300x300 px
```

**Usage in code:**
```dart
// Flutter automatically selects correct resolution
Image.asset('assets/images/logo.png')
```

### Image Sizes

**Recommended dimensions:**
- **App icon**: 512x512 px (source)
- **Splash screen**: 1080x1920 px (portrait)
- **Roulette wheel**: 300x300 px (1x), scale up
- **UI elements**: Based on design specs

**Keep images reasonable:**
- Hero images: Max 1920x1080 px
- Thumbnails: Max 200x200 px
- Icons: 24x24, 48x48, 96x96 px

## 🎨 Icon Management

### Material Icons

**Using built-in icons (preferred):**
```dart
Icon(Icons.casino)
Icon(Icons.settings)
Icon(Icons.history)
Icon(Icons.casino_outlined)
Icon(Icons.casino_rounded)
```

**Browse available icons:**
- [Material Icons Gallery](https://fonts.google.com/icons)
- [Flutter Icon Browser](https://api.flutter.dev/flutter/material/Icons-class.html)

### Custom Icons

**Using custom icon fonts:**
```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: CustomIcons
      fonts:
        - asset: assets/fonts/CustomIcons.ttf
```

```dart
// Create IconData
static const IconData rouletteWheel = IconData(
  0xe900,
  fontFamily: 'CustomIcons',
);

// Use in app
Icon(CustomIcons.rouletteWheel)
```

**Using custom icon package:**
```bash
flutter pub add flutter_launcher_icons
```

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icons/foreground.png"
```

```bash
# Generate icons
flutter pub run flutter_launcher_icons:main
```

### Icon Sizes

**Standard sizes:**
- 16x16 px: Tiny icons
- 24x24 px: Standard UI icons (default)
- 32x32 px: Larger icons
- 48x48 px: App bar icons
- 96x96 px: Large feature icons

## 🔤 Font Usage

### System Fonts

**Using default fonts:**
```dart
// Uses system default (Roboto on Android, San Francisco on iOS)
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```

### Custom Fonts

**Add to pubspec.yaml:**
```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-Italic.ttf
          style: italic
```

**Use in code:**
```dart
// Specific text
Text(
  'Hello',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// App-wide theme
MaterialApp(
  theme: ThemeData(
    fontFamily: 'Poppins',
  ),
)
```

### Font Licensing

**Free fonts:**
- [Google Fonts](https://fonts.google.com/) - Open source
- [Font Squirrel](https://www.fontsquirrel.com/) - Commercial-friendly

**⚠️ Always check license:**
- Personal use vs commercial use
- Attribution requirements
- Modification rights

## ➕ How to Add New Assets

### Step 1: Prepare Asset

```bash
# Example: Adding new logo
# 1. Create images at different resolutions
#    logo.png (100x100)
#    logo@2x.png (200x200)
#    logo@3x.png (300x300)

# 2. Optimize images
#    Use ImageOptim (Mac), TinyPNG (web), or CLI tools
```

### Step 2: Add to Project

```bash
# Place files in appropriate directory
mkdir -p assets/images/logos
cp logo.png assets/images/logos/
mkdir -p assets/images/logos/2.0x
cp logo@2x.png assets/images/logos/2.0x/logo.png
mkdir -p assets/images/logos/3.0x
cp logo@3x.png assets/images/logos/3.0x/logo.png
```

### Step 3: Declare in pubspec.yaml

```yaml
flutter:
  assets:
    - assets/images/logos/
```

### Step 4: Use in Code

```dart
Image.asset(
  'assets/images/logos/logo.png',
  width: 100,
  height: 100,
)
```

### Step 5: Test

```bash
# Hot reload to see changes
flutter run
# Press 'r' for hot reload
```

## 🔧 Asset Optimization

### Image Optimization Tools

**Online tools:**
- [TinyPNG](https://tinypng.com/) - PNG/JPEG compression
- [Squoosh](https://squoosh.app/) - Google's image optimizer
- [ImageOptim Online](https://imageoptim.com/online)

**Command-line tools:**
```bash
# PNG optimization
optipng -o7 image.png
pngquant --quality=65-80 image.png

# JPEG optimization
jpegoptim --max=85 image.jpg

# WebP conversion
cwebp -q 80 input.png -o output.webp
```

**Automated optimization:**
```bash
# Install dependencies
npm install -g imagemin-cli

# Optimize all images
imagemin assets/images/*.png --out-dir=assets/images/optimized
```

### Vector Graphics

**Using SVG (with flutter_svg package):**
```yaml
dependencies:
  flutter_svg: ^2.0.9
```

```dart
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/images/icon.svg',
  width: 100,
  height: 100,
  color: Colors.blue,  // Can tint SVG
)
```

**Benefits:**
- Scales without quality loss
- Small file size
- Can change colors programmatically

### Loading Performance

**Precache images:**
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  // Precache images for faster loading
  precacheImage(
    AssetImage('assets/images/roulette_wheel.png'),
    context,
  );
}
```

**Lazy load images:**
```dart
// Only load when needed
FutureBuilder(
  future: precacheImage(AssetImage('assets/images/large.png'), context),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return Image.asset('assets/images/large.png');
    }
    return CircularProgressIndicator();
  },
)
```

## 📋 Asset Checklist

Before adding assets:
- [ ] Image optimized (compressed)
- [ ] Multiple resolutions provided (1x, 2x, 3x)
- [ ] Proper format chosen (PNG/JPEG/WebP)
- [ ] Reasonable file size (<500KB per image)
- [ ] License checked and documented
- [ ] Declared in pubspec.yaml
- [ ] Tested on multiple devices
- [ ] No unused assets in project

## 🎨 Design Resources

### Asset Sources

**Free resources:**
- [Unsplash](https://unsplash.com/) - Free photos
- [Pexels](https://www.pexels.com/) - Free photos/videos
- [Flaticon](https://www.flaticon.com/) - Free icons
- [Font Awesome](https://fontawesome.com/) - Icon fonts
- [LottieFiles](https://lottiefiles.com/) - Animations

**Design tools:**
- [Figma](https://figma.com/) - UI design
- [Adobe XD](https://www.adobe.com/products/xd.html) - UI design
- [Sketch](https://www.sketch.com/) - UI design (Mac only)

## 🔗 Related Documentation

- [Performance](PERFORMANCE.md) - Asset optimization techniques
- [UI/UX Guidelines](UI_UX_GUIDELINES.md) - Design system
- [Development](DEVELOPMENT.md) - Using assets in code

---

**Last Updated:** December 2024
