# 🌍 Localization (i18n) Guide

Guide for internationalizing and localizing Tokyo Roulette Predicciones.

## 📋 Table of Contents

- [Overview](#overview)
- [Setup Process](#setup-process)
- [Adding New Languages](#adding-new-languages)
- [Translation Workflow](#translation-workflow)
- [Date and Time Formatting](#date-and-time-formatting)
- [Number and Currency Formatting](#number-and-currency-formatting)
- [RTL Support](#rtl-support)
- [Best Practices](#best-practices)

## 🎯 Overview

### Current Status

The app is currently in **Spanish only**. This guide prepares for future multilingual support.

### Supported Languages (Planned)

- 🇪🇸 Spanish (es) - Current
- 🇺🇸 English (en) - Planned
- 🇵🇹 Portuguese (pt) - Planned
- 🇫🇷 French (fr) - Planned
- 🇩🇪 German (de) - Planned

## 🚀 Setup Process

### Method 1: Flutter Intl (Recommended)

**1. Add dependencies:**
```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

dev_dependencies:
  flutter_localizations:
    sdk: flutter
```

**2. Enable l10n in pubspec.yaml:**
```yaml
flutter:
  generate: true
```

**3. Create l10n.yaml:**
```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**4. Create ARB files:**

Create `lib/l10n/app_en.arb`:
```json
{
  "@@locale": "en",
  "appTitle": "Tokyo Roulette Predictions",
  "@appTitle": {
    "description": "The title of the application"
  },
  "login": "Login",
  "email": "Email",
  "continue": "Continue",
  "spin": "Spin",
  "result": "Result",
  "balance": "Balance",
  "prediction": "Prediction",
  "settings": "Settings",
  "enableMartingale": "Enable Martingale",
  "martingaleActive": "Martingale Active",
  "reset": "Reset",
  "history": "History",
  "disclaimer": "This is an educational simulator only. Does not promote real gambling."
}
```

Create `lib/l10n/app_es.arb`:
```json
{
  "@@locale": "es",
  "appTitle": "Tokyo Roulette Predicciones",
  "login": "Iniciar Sesión",
  "email": "Correo Electrónico",
  "continue": "Continuar",
  "spin": "Girar",
  "result": "Resultado",
  "balance": "Balance",
  "prediction": "Predicción",
  "settings": "Configuración",
  "enableMartingale": "Activar Martingale",
  "martingaleActive": "Martingale Activa",
  "reset": "Reiniciar",
  "history": "Historial",
  "disclaimer": "Este es un simulador educativo solamente. No promueve juegos de azar reales."
}
```

**5. Generate localizations:**
```bash
flutter gen-l10n
```

**6. Configure app:**
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localization delegates
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported locales
      supportedLocales: [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('pt', ''), // Portuguese
        Locale('fr', ''), // French
        Locale('de', ''), // German
      ],
      
      // App content
      home: HomeScreen(),
    );
  }
}
```

**7. Use in widgets:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: l10n.email),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.continue),
          ),
        ],
      ),
    );
  }
}
```

### Method 2: Easy Localization Package

**Alternative approach (simpler for small apps):**
```yaml
dependencies:
  easy_localization: ^3.0.3
```

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: Locale('es'),
      child: MyApp(),
    ),
  );
}

// Usage
Text('login').tr()
```

## ➕ Adding New Languages

### Step 1: Create ARB File

Create `lib/l10n/app_pt.arb` for Portuguese:
```json
{
  "@@locale": "pt",
  "appTitle": "Tokyo Roulette Previsões",
  "login": "Entrar",
  "email": "E-mail",
  "continue": "Continuar",
  "spin": "Girar",
  "result": "Resultado",
  "balance": "Saldo",
  "prediction": "Previsão",
  "settings": "Configurações",
  "enableMartingale": "Ativar Martingale",
  "martingaleActive": "Martingale Ativa",
  "reset": "Reiniciar",
  "history": "Histórico",
  "disclaimer": "Este é apenas um simulador educacional. Não promove jogos de azar reais."
}
```

### Step 2: Add to Supported Locales

```dart
supportedLocales: [
  Locale('en'),
  Locale('es'),
  Locale('pt'),  // New language
],
```

### Step 3: Regenerate

```bash
flutter gen-l10n
flutter run
```

### Step 4: Test

Change device language or use:
```dart
// Force specific locale for testing
MaterialApp(
  locale: Locale('pt'),
  // ...
)
```

## 🔄 Translation Workflow

### 1. Extract Strings

Create a list of all user-facing strings:
```bash
# Manually review code for hardcoded strings
grep -r "Text(" lib/ | grep -v "Text(l10n."
```

### 2. Add to Template

Add new strings to `app_en.arb`:
```json
{
  "winAmount": "You won ${amount}!",
  "@winAmount": {
    "description": "Message shown when user wins",
    "placeholders": {
      "amount": {
        "type": "String",
        "example": "$50"
      }
    }
  }
}
```

### 3. Translate

Send to translators or translate manually:
- Professional: Gengo, One Hour Translation
- Community: Crowdin, Lokalise
- Manual: Native speakers

### 4. Review

Have native speakers review translations:
- Context correct?
- Natural phrasing?
- No typos or grammar errors?

### 5. Test

Test each language:
- UI text fits (no overflow)
- Translations make sense
- Special characters display correctly

## 📅 Date and Time Formatting

### Using intl Package

```dart
import 'package:intl/intl.dart';

// Date formatting
final now = DateTime.now();

// Automatic locale
final formatted = DateFormat.yMMMd().format(now);
// English: Jan 15, 2024
// Spanish: 15 ene 2024

// Specific locale
final spanish = DateFormat.yMMMd('es').format(now);

// Time formatting
final time = DateFormat.jm().format(now);
// English: 3:30 PM
// Spanish: 15:30

// Custom format
final custom = DateFormat('EEEE, d MMMM y', 'es').format(now);
// "lunes, 15 enero 2024"
```

### Common Date Formats

```dart
// Short date: 1/15/2024
DateFormat.yMd()

// Medium date: Jan 15, 2024
DateFormat.yMMMd()

// Long date: January 15, 2024
DateFormat.yMMMMd()

// Full: Monday, January 15, 2024
DateFormat.yMMMMEEEEd()

// Time: 3:30 PM
DateFormat.jm()

// Date and time: Jan 15, 2024 3:30 PM
DateFormat.yMMMd().add_jm()
```

## 💰 Number and Currency Formatting

### Number Formatting

```dart
import 'package:intl/intl.dart';

// Integer
final count = 1234567;
final formatted = NumberFormat.decimalPattern().format(count);
// English: 1,234,567
// Spanish: 1.234.567

// Decimal
final balance = 1234.56;
final decimal = NumberFormat.decimalPattern().format(balance);
// English: 1,234.56
// Spanish: 1.234,56

// Compact
final compact = NumberFormat.compact().format(1500000);
// English: 1.5M
// Spanish: 1,5 M
```

### Currency Formatting

```dart
// Currency with locale
final usd = NumberFormat.currency(locale: 'en_US', symbol: '\$');
print(usd.format(1234.56));  // $1,234.56

final eur = NumberFormat.currency(locale: 'es_ES', symbol: '€');
print(eur.format(1234.56));  // 1.234,56 €

// Currency with code
final withCode = NumberFormat.simpleCurrency(name: 'USD');
print(withCode.format(1234.56));  // US$1,234.56
```

### In the App

```dart
// Balance display
final balance = 1234.56;
final locale = Localizations.localeOf(context);
final formatted = NumberFormat.currency(
  locale: locale.toString(),
  symbol: '\$',
  decimalDigits: 2,
).format(balance);

Text(formatted);  // Automatically formatted per locale
```

## 🔄 RTL (Right-to-Left) Support

### Enable RTL

**Automatic (Flutter handles):**
```dart
MaterialApp(
  localizationsDelegates: [...],
  supportedLocales: [
    Locale('en'),
    Locale('ar'),  // Arabic (RTL)
    Locale('he'),  // Hebrew (RTL)
  ],
)
```

### Test RTL Layout

**Force RTL for testing:**
```dart
MaterialApp(
  builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl,  // Force RTL
      child: child!,
    );
  },
)
```

### RTL-Aware Widgets

**Use directional padding:**
```dart
// ❌ Bad - always left
Padding(
  padding: EdgeInsets.only(left: 16),
  child: Text('Hello'),
)

// ✅ Good - RTL aware
Padding(
  padding: EdgeInsetsDirectional.only(start: 16),
  child: Text('Hello'),
)
```

**Use directional alignment:**
```dart
// ❌ Bad
Align(alignment: Alignment.centerLeft)

// ✅ Good
Align(alignment: AlignmentDirectional.centerStart)
```

**Check direction in code:**
```dart
final isRTL = Directionality.of(context) == TextDirection.rtl;

if (isRTL) {
  // RTL-specific logic
}
```

## 📚 Best Practices

### 1. Avoid Hardcoded Strings

```dart
// ❌ Bad
Text('Login')

// ✅ Good
Text(AppLocalizations.of(context)!.login)
```

### 2. Use Placeholders

```dart
// ARB file
{
  "welcome": "Welcome, {name}!",
  "@welcome": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}

// Usage
Text(l10n.welcome('John'))
```

### 3. Handle Plurals

```dart
// ARB file
{
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}

// Usage
Text(l10n.itemCount(items.length))
```

### 4. Keep Strings Short

- UI space is limited
- Translations may be longer
- Plan for 30% text expansion

### 5. Provide Context

```json
{
  "save": "Save",
  "@save": {
    "description": "Button to save user settings"
  }
}
```

### 6. Test All Languages

- UI doesn't overflow
- Text is readable
- Special characters work
- Numbers/dates format correctly

## 🔗 Related Documentation

- [Development](DEVELOPMENT.md) - Adding localization to features
- [Testing](TESTING.md) - Testing localized strings
- [UI/UX Guidelines](UI_UX_GUIDELINES.md) - Design for multiple languages

## 📚 Additional Resources

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Intl Package](https://pub.dev/packages/intl)
- [ARB Format Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Easy Localization](https://pub.dev/packages/easy_localization)

---

**Last Updated:** December 2024
