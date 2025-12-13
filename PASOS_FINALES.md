# 🎯 Pasos Finales para Construir tu APK

## ✅ ¡Todo está Listo!

El proyecto está completamente configurado. Solo necesitas completar estos 3 pasos:

---

## 📋 PASO 1: Configurar Firebase

### Instalar FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

### Ejecutar configuración:
```bash
flutterfire configure
```

Esto generará automáticamente `lib/firebase_options.dart` con tus credenciales reales.

### Descargar google-services.json:
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a Configuración del proyecto > Tus apps
4. Descarga `google-services.json`
5. Colócalo en `android/app/google-services.json` (reemplazando el placeholder)

**Documentación completa:** Ver `docs/CONFIGURACION.md`

---

## 📋 PASO 2: Configurar Stripe

### Obtener clave de Stripe:
1. Ve a [Stripe Dashboard](https://dashboard.stripe.com/)
2. Developers > API keys
3. Copia tu "Publishable key" (empieza con `pk_test_`)

### Actualizar en el código:
Abre `lib/main.dart` y en la línea 9, reemplaza:
```dart
Stripe.publishableKey = 'tu_publishable_key_de_stripe';
```

Con tu clave real:
```dart
Stripe.publishableKey = 'pk_test_tu_clave_aqui';
```

**Documentación completa:** Ver `docs/CONFIGURACION.md`

---

## 📋 PASO 3: Construir APK

### Para desarrollo/testing:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

### Para producción (Google Play):
1. Sigue la guía en `docs/FIRMA_APK.md` para configurar firma de release
2. Construye el App Bundle:
```bash
flutter build appbundle --release
```

---

## 🎨 Opcional: Agregar Icono Personalizado

Ver guía completa en `docs/APP_ICON.md`

Opción rápida con flutter_launcher_icons:
1. Agrega a `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_icons:
  android: true
  image_path: "assets/images/app_icon.png"
```

2. Coloca tu icono (1024x1024) en `assets/images/app_icon.png`
3. Ejecuta:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

---

## ✅ Verificación

Antes de construir, verifica:

```bash
# Análisis de código
flutter analyze

# Tests
flutter test

# Formato
dart format --set-exit-if-changed .
```

---

## 📚 Documentación Disponible

- `README.md` - Información general del proyecto
- `docs/CONFIGURACION.md` - Guía completa Firebase y Stripe
- `docs/FIRMA_APK.md` - Configuración de firma para producción
- `docs/APP_ICON.md` - Guía de iconos
- `docs/RESUMEN_CAMBIOS.md` - Resumen completo de cambios

---

## 🆘 ¿Problemas?

### Error de Firebase
```bash
flutterfire configure
```

### Error de dependencias
```bash
flutter clean
flutter pub get
```

### Error de build
Ver logs completos y consultar `docs/CONFIGURACION.md`

---

## 🚀 ¡Listo para Construir!

Una vez completados los 3 pasos, tu APK estará listo para:
- ✅ Instalar en dispositivos Android
- ✅ Distribuir para testing
- ✅ Publicar en Google Play Store (con firma de producción)

**¡Buena suerte con tu app Tokyo Roulette!** 🎰
