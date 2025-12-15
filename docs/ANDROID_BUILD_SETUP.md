# Configuración de Build de Android - APK Release

## ✅ Configuración Completada

Este documento describe la configuración mínima implementada para generar una APK release funcional del proyecto Tokyo Roulette Predictor.

## 📋 Archivos Configurados

### 1. Configuración de Gradle

#### `android/build.gradle` (root)
- Kotlin version: 1.9.22
- Android Gradle Plugin: 8.1.4
- Repositorios: Google y Maven Central
- Configuración simplificada sin dependencias innecesarias

#### `android/app/build.gradle`
- **Namespace**: `com.tokyoapps.roulette`
- **ApplicationId**: `com.tokyoapps.roulette`
- **compileSdkVersion**: 34
- **minSdkVersion**: 23 (Android 6.0+)
- **targetSdkVersion**: 34
- **versionCode**: 1
- **versionName**: 1.0.0
- **Firma**: Usa debug keystore del sistema para simplificar (`~/.android/debug.keystore`)
- **Optimizaciones**: minifyEnabled = false (para build rápido)
- **Dependencias**: Solo androidx.multidex:2.0.1

#### `android/settings.gradle`
- Configuración simple y directa
- Carga el Flutter SDK desde local.properties
- Aplica el app_plugin_loader de Flutter

#### `android/gradle.properties`
- JVM args: -Xmx4G (4GB de memoria)
- AndroidX: enabled
- Jetifier: enabled

#### `android/gradle/wrapper/gradle-wrapper.properties`
- Gradle version: 8.4

### 2. Código y Recursos

#### MainActivity
- **Ubicación**: `android/app/src/main/kotlin/com/tokyoapps/roulette/MainActivity.kt`
- **Package**: `com.tokyoapps.roulette`
- Implementación simple que extiende `FlutterActivity`

#### AndroidManifest.xml
- Package: `com.tokyoapps.roulette`
- Permisos: INTERNET
- Temas: LaunchTheme y NormalTheme configurados
- Flutter embedding: v2

#### Recursos de UI

**Temas (`res/values/styles.xml` y `res/values-night/styles.xml`)**:
- LaunchTheme: Pantalla de inicio (light/dark)
- NormalTheme: Tema principal de la app (light/dark)

**Launcher Icons**:
- Adaptive icon para Android 8.0+ (API 26+) en `mipmap-anydpi-v26/`
- PNG fallbacks en todas las densidades:
  - mipmap-mdpi: 48x48
  - mipmap-hdpi: 72x72
  - mipmap-xhdpi: 96x96
  - mipmap-xxhdpi: 144x144
  - mipmap-xxxhdpi: 192x192
- Color base: #3F51B5 (azul material)

## 🚀 Cómo Generar la APK Release

### Prerrequisitos
- Flutter SDK instalado y configurado
- Android SDK instalado
- JDK 8 o superior

### Comandos

```bash
# Navegar al directorio del proyecto
cd /path/to/Tokyo-Predictor-Roulette-001

# Limpiar build anterior (opcional)
flutter clean

# Obtener dependencias
flutter pub get

# Generar APK release
flutter build apk --release

# La APK se generará en:
# build/app/outputs/flutter-apk/app-release.apk
```

### Verificación del Build

```bash
# Verificar que la APK fue creada
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Obtener información de la APK
flutter build apk --release --verbose
```

## 📱 Instalación en Dispositivo

### Método 1: ADB
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Método 2: Transferencia Manual
1. Copiar el archivo `app-release.apk` al dispositivo
2. Habilitar "Instalación desde fuentes desconocidas" en el dispositivo
3. Abrir el archivo APK en el dispositivo para instalarlo

## ⚠️ ADVERTENCIA IMPORTANTE DE SEGURIDAD

### ⚠️ Debug Keystore - SOLO PARA TESTING

La configuración actual usa el **debug keystore** del sistema para firmar la release APK.

**🚨 ESTO ES EXTREMADAMENTE INSEGURO PARA PRODUCCIÓN 🚨**

- Las credenciales del debug keystore son públicas y conocidas
- Cualquiera puede crear una APK que reemplace tu app
- **NUNCA distribuyas esta APK a usuarios finales**
- **NUNCA la subas a Google Play Store**

**Esta configuración es SOLO para desarrollo y testing rápido.**

---

## ⚠️ Notas Importantes

### Firma de la APK
La configuración actual usa el **debug keystore** del sistema para firmar la release APK. Esto es **solo para testing**.

**Para producción**, necesitarás:

1. Crear un keystore de producción:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

2. Crear `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

3. Actualizar `android/app/build.gradle`:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

### Optimizaciones Deshabilitadas
- **minifyEnabled**: false
- **shrinkResources**: false

Para producción, considera habilitarlas para reducir el tamaño de la APK:
```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### Firebase y Stripe
La configuración actual **NO incluye** Firebase ni Stripe. Para habilitarlos:

1. Agregar `google-services.json` en `android/app/`
2. Descomentar las líneas de Firebase en `android/build.gradle` y `android/app/build.gradle`
3. Configurar las API keys de Stripe según la documentación

## 🧪 Testing

Antes de distribuir, prueba:
- ✅ La APK se instala correctamente
- ✅ La app inicia sin crashes
- ✅ Todas las funcionalidades principales funcionan
- ✅ Los permisos (INTERNET) funcionan correctamente
- ✅ El icono del launcher se muestra correctamente

## 📝 Checklist de Éxito

- [x] `flutter build apk --release` completa sin errores
- [x] APK se genera en `build/app/outputs/flutter-apk/app-release.apk`
- [ ] APK es instalable en dispositivo Android (requiere testing manual)
- [ ] App inicia correctamente (requiere testing manual)

## 🔧 Solución de Problemas

### Error: "Flutter SDK not found"
Verifica que `android/local.properties` contiene:
```properties
flutter.sdk=/path/to/flutter
```

### Error: Gradle version mismatch
Asegúrate de usar las versiones especificadas:
- Gradle: 8.4
- Android Gradle Plugin: 8.1.4
- Kotlin: 1.9.22

### Error de firma
Verifica que el debug keystore existe:
```bash
ls -la ~/.android/debug.keystore
```

Si no existe, Flutter lo creará automáticamente al hacer el primer build.

## 📚 Referencias

- [Flutter Build Documentation](https://docs.flutter.dev/deployment/android)
- [Android Signing Documentation](https://developer.android.com/studio/publish/app-signing)
- [Gradle Plugin Documentation](https://developer.android.com/build)
