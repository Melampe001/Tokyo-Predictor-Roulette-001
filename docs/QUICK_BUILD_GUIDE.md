# ⚡ Build APK Rápido - Quick Start

## 🚀 Generar APK Release (Testing)

```bash
flutter build apk --release
```

La APK se generará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

## ⚠️ ADVERTENCIA IMPORTANTE

**Esta configuración usa debug keystore - SOLO para testing/desarrollo**

🚨 **NUNCA** distribuir a usuarios finales  
🚨 **NUNCA** subir a Google Play Store  
🚨 **NUNCA** usar en producción  

Las credenciales del debug keystore son públicas y conocidas.

## 📝 Especificaciones

- **Package**: `com.tokyoapps.roulette`
- **minSdk**: 23 (Android 6.0+)
- **targetSdk**: 34 (Android 14)
- **Gradle**: 8.4
- **AGP**: 8.1.4
- **Kotlin**: 1.9.22

## 📚 Documentación Completa

Ver **[docs/ANDROID_BUILD_SETUP.md](./ANDROID_BUILD_SETUP.md)** para:
- Instrucciones detalladas
- Configuración de producción segura
- Solución de problemas
- Guía de optimizaciones

## 🔧 Instalación en Dispositivo

```bash
# Vía ADB
adb install build/app/outputs/flutter-apk/app-release.apk
```

O transferir el archivo APK manualmente al dispositivo.

## 📋 Archivos Configurados

✅ `android/build.gradle` - Configuración root  
✅ `android/app/build.gradle` - Configuración app  
✅ `android/settings.gradle` - Settings Gradle  
✅ `android/gradle.properties` - Propiedades Gradle  
✅ `android/gradle/wrapper/gradle-wrapper.properties` - Wrapper  
✅ `android/app/src/main/AndroidManifest.xml` - Manifest  
✅ `android/app/src/main/kotlin/.../MainActivity.kt` - Activity principal  
✅ `android/app/src/main/res/values/styles.xml` - Estilos  
✅ `android/app/src/main/res/mipmap-*/ic_launcher.png` - Iconos  

## 🎯 Para Producción

1. Crear keystore seguro:
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Crear `android/key.properties`
3. Actualizar `android/app/build.gradle`
4. Habilitar optimizaciones (minify, shrink)
5. Configurar Firebase y Stripe

Ver documentación completa para detalles.

---

**Configuración completada:** ✅  
**Última actualización:** 2025-12-15
