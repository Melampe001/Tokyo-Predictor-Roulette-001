# 🚀 Quick Start Guide

Bienvenido a Tokyo Roulette Predictor. Esta guía te ayudará a comenzar rápidamente.

## ⚡ Inicio Rápido

### 1. Clonar el Repositorio

```bash
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Ejecutar Tests

```bash
# Tests tradicionales de Flutter
flutter test

# O usar el emulador Vercel-style
dart testing/vercel_emulator/run_tests.dart
```

### 4. Ejecutar la Aplicación

```bash
flutter run
```

## 🧪 Ejecutar el Sistema de Testing

### Vercel Emulator
```bash
# Ejecución estándar
dart testing/vercel_emulator/run_tests.dart

# Modo verbose
dart testing/vercel_emulator/run_tests.dart --verbose

# Secuencial (para debugging)
dart testing/vercel_emulator/run_tests.dart --sequential
```

Los resultados se guardan en `test-results/`:
- `test_results.html` - Reporte visual
- `test_results.json` - Datos estructurados

## 🤖 Ejecutar Bots de Automatización

### Bots Individuales
```bash
# Bot de construcción
dart bots/run_bots.dart --push --bot atlas

# Bot de testing
dart bots/run_bots.dart --push --bot oracle

# Bot de seguridad
dart bots/run_bots.dart --push --bot sentinel
```

### Workflows Completos
```bash
# Workflow de push/PR (paralelo)
dart bots/run_bots.dart --push --parallel

# Workflow de release
dart bots/run_bots.dart --release
```

## 🏗️ Build de la Aplicación

### Android APK
```bash
flutter build apk --release
```

El APK se genera en: `build/app/outputs/flutter-apk/app-release.apk`

### Web
```bash
flutter build web --release
```

Los archivos web se generan en: `build/web/`

## 📊 Ver Reportes

### Reporte HTML de Tests
```bash
# Después de ejecutar tests
open test-results/test_results.html
```

### Coverage Report
```bash
flutter test --coverage
# Instalar lcov si no lo tienes
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔍 Análisis de Código

```bash
# Análisis estático
flutter analyze

# Formateo de código
dart format .

# Verificar formateo
dart format --set-exit-if-changed .
```

## 🔐 Configurar Firebase (Opcional)

1. Instala Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Configura FlutterFire:
```bash
flutterfire configure
```

3. Sigue las instrucciones para conectar tu proyecto

## 💳 Configurar Stripe (Opcional)

1. Crea una cuenta en [Stripe](https://stripe.com)
2. Obtén tus claves de API
3. Configura las variables de entorno:
```bash
export STRIPE_PUBLISHABLE_KEY="tu_clave_aqui"
```

**⚠️ IMPORTANTE**: Nunca commits las claves en el código

## 📚 Próximos Pasos

- 📖 Lee la [Documentación Completa](../README.md)
- 🧪 Aprende sobre el [Sistema de Testing](../testing/vercel-emulator.md)
- 🤖 Explora el [Sistema de Bots](../bots/bot-system-overview.md)
- 🏗️ Revisa la [Arquitectura](../architecture/system-overview.md)

## 🆘 Problemas Comunes

### Flutter no encontrado
```bash
# Verifica la instalación
flutter doctor
```

### Dependencias no se instalan
```bash
# Limpia y reinstala
flutter clean
flutter pub get
```

### Tests fallan
```bash
# Ejecuta en modo verbose para más detalles
dart testing/vercel_emulator/run_tests.dart --verbose
```

## 📞 Soporte

- 🐛 [Reportar Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- 💬 [Discusiones](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)
- 📧 Ver README principal para contacto

---

¡Listo para comenzar! 🚀
