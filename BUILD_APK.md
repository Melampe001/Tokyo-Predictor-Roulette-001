# Guía para Construir APK

Esta guía explica cómo construir la APK de Tokyo Roulette Predicciones.

## Prerrequisitos

1. **Flutter SDK** instalado (versión 3.0.0 o superior)
2. **Android SDK** con las siguientes herramientas:
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Platform API 34 (o superior)
3. **Java JDK** 8 o superior

## Configuración Inicial

### 1. Configurar Android SDK

Crea el archivo `android/local.properties` basado en la plantilla:

```properties
sdk.dir=/ruta/a/tu/android/sdk
flutter.sdk=/ruta/a/tu/flutter/sdk
flutter.versionCode=1
flutter.versionName=1.0.0
```

**Nota:** Este archivo no debe ser commiteado al repositorio (ya está en .gitignore).

### 2. Instalar Dependencias

```bash
flutter pub get
```

## Construir APK en Modo Debug

Para probar la aplicación localmente:

```bash
flutter build apk --debug
```

La APK se generará en: `build/app/outputs/flutter-apk/app-debug.apk`

## Construir APK en Modo Release

### Opción A: Sin Firma (Para Pruebas)

```bash
flutter build apk --release
```

**Advertencia:** Esta APK usará firma de debug. No usar para distribución.

### Opción B: Con Firma (Para Producción)

#### Paso 1: Crear Keystore

Si aún no tienes un keystore, créalo con:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**IMPORTANTE:** Guarda el keystore en un lugar seguro y **NUNCA** lo commitees al repositorio.

#### Paso 2: Configurar Firma

**Opción 2A: Usando key.properties (Desarrollo Local)**

Crea el archivo `android/key.properties` en la raíz del proyecto:

```properties
storeFile=/ruta/completa/a/tu/upload-keystore.jks
storePassword=tu_password_del_keystore
keyAlias=upload
keyPassword=tu_password_de_la_key
```

**Opción 2B: Usando Variables de Entorno (CI/CD)**

Define estas variables de entorno:

```bash
export ANDROID_KEYSTORE_PATH=/ruta/a/keystore.jks
export KEYSTORE_PASSWORD=tu_password_del_keystore
export KEY_ALIAS=upload
export KEY_PASSWORD=tu_password_de_la_key
```

#### Paso 3: Construir APK Firmada

```bash
flutter build apk --release
```

La APK firmada se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## Construir App Bundle (Recomendado para Google Play)

Para publicar en Google Play Store, usa App Bundle en lugar de APK:

```bash
flutter build appbundle --release
```

El bundle se generará en: `build/app/outputs/bundle/release/app-release.aab`

## Construir APK Split por ABI (Opcional)

Para reducir el tamaño, puedes generar APKs separadas por arquitectura:

```bash
flutter build apk --release --split-per-abi
```

Esto generará múltiples APKs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

## Verificar la APK

### Ver Información de la APK

```bash
# Con bundletool (si usaste appbundle)
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=my_app.apks --mode=universal

# Con aapt (si usaste apk)
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

### Probar la APK

```bash
# Instalar en dispositivo conectado
flutter install

# O usar adb directamente
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Solución de Problemas

### Error: "No se encuentra el Android SDK"

Asegúrate de que `android/local.properties` tenga la ruta correcta al SDK.

### Error: "Keystore not found"

Verifica que:
1. El archivo keystore existe en la ruta especificada
2. La ruta en `key.properties` o variables de entorno es absoluta
3. Tienes permisos de lectura en el archivo

### Error: "Gradle build failed"

1. Limpia el proyecto: `flutter clean`
2. Vuelve a obtener dependencias: `flutter pub get`
3. Intenta construir de nuevo

### Error: "Minimum SDK version"

Si obtienes errores relacionados con la versión mínima del SDK, asegúrate de que tu `android/app/build.gradle` tenga:

```gradle
defaultConfig {
    minSdk 23  // Android 6.0 o superior
    targetSdk 34
}
```

## Configuración de Firebase (Opcional)

Si vas a usar Firebase:

1. Crea un proyecto en Firebase Console
2. Descarga `google-services.json` y colócalo en `android/app/`
3. Descomenta las líneas relacionadas con Firebase en:
   - `android/build.gradle`
   - `android/app/build.gradle`
   - `lib/main.dart`
4. Configura Firebase: `flutterfire configure`

## Optimizaciones

### Reducir Tamaño de la APK

1. **Usar ProGuard/R8** (ya configurado en modo release)
2. **Remover recursos no usados:** Ya está habilitado con `shrinkResources true`
3. **Comprimir recursos:** Android Gradle Plugin lo hace automáticamente
4. **Split APKs por ABI:** Usa `--split-per-abi` como se mostró arriba

### Mejorar Rendimiento

1. **Habilitar obfuscación:** Ya configurado en modo release
2. **Compilación AOT:** Flutter lo hace automáticamente en release
3. **Tree shaking:** Flutter elimina código no usado automáticamente

## Referencias

- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Android App Signing](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Prepare for Release](https://docs.flutter.dev/deployment/android)

## Seguridad

⚠️ **NUNCA** commits estos archivos al repositorio:
- `android/key.properties`
- Archivos `.jks` o `.keystore`
- `google-services.json` con claves reales
- Archivos `.env` con claves API

Todos estos archivos ya están excluidos en `.gitignore`.
