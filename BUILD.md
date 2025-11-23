# Guía de Construcción del APK - Tokyo Roulette Predicciones

Esta guía detalla el proceso completo para generar el APK release de la aplicación Tokyo Roulette Predicciones.

## Tabla de Contenidos

1. [Preparativos](#preparativos)
2. [Proceso de Construcción Manual](#proceso-de-construcción-manual)
3. [Firma del APK](#firma-del-apk)
4. [Construcción Automatizada](#construcción-automatizada)
5. [Ubicación del APK](#ubicación-del-apk)
6. [Mejores Prácticas](#mejores-prácticas)
7. [Solución de Problemas](#solución-de-problemas)

---

## Preparativos

### 1. Requisitos Previos

Asegúrate de tener instalado lo siguiente:

- **Flutter SDK**: Versión 3.0.0 o superior
  ```bash
  flutter --version
  ```

- **Android SDK**: API level 21 (Android 5.0) o superior
  ```bash
  flutter doctor -v
  ```

- **Java JDK**: Version 11 o superior (requerido para el build de Android)

### 2. Verificar la Instalación

Ejecuta el siguiente comando para verificar que todo está configurado correctamente:

```bash
flutter doctor
```

Asegúrate de que todos los checks estén en verde o resuelve cualquier problema indicado.

### 3. Obtener Dependencias

Antes de construir el APK, instala todas las dependencias del proyecto:

```bash
flutter pub get
```

### 4. Ejecutar Pruebas (Recomendado)

Es una buena práctica ejecutar las pruebas antes de generar el APK de release:

```bash
# Ejecutar pruebas unitarias
flutter test

# Ejecutar pruebas de integración (si existen)
flutter test integration_test
```

### 5. Limpiar Builds Anteriores

Limpia cualquier build anterior para evitar problemas de cache:

```bash
flutter clean
flutter pub get
```

---

## Proceso de Construcción Manual

### Opción 1: APK Universal (Recomendado para pruebas)

Este comando genera un APK que funciona en todas las arquitecturas de dispositivos Android:

```bash
flutter build apk --release
```

### Opción 2: APK por Arquitectura (Optimizado para distribución)

Para generar APKs más pequeños y optimizados por arquitectura:

```bash
flutter build apk --release --split-per-abi
```

Esto generará archivos separados para:
- `app-armeabi-v7a-release.apk` (dispositivos ARM de 32 bits)
- `app-arm64-v8a-release.apk` (dispositivos ARM de 64 bits - mayoría de dispositivos modernos)
- `app-x86_64-release.apk` (emuladores y dispositivos x86)

### Opciones Adicionales de Build

```bash
# Build con ofuscación de código (mayor seguridad)
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols

# Build con target específico de Dart
flutter build apk --release --target=lib/main.dart

# Build con flavor específico (si tienes flavors configurados)
flutter build apk --release --flavor production
```

---

## Firma del APK

### Configuración de la Firma

Para distribuir tu aplicación en Google Play Store o mediante descarga directa, debes firmar el APK.

#### 1. Generar un Keystore (Solo la primera vez)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

**IMPORTANTE**: 
- Guarda la contraseña del keystore de forma segura
- Nunca compartas o subas el archivo `.jks` al repositorio
- Haz backup del keystore en un lugar seguro

#### 2. Configurar el Archivo key.properties

Crea un archivo `android/key.properties` con la siguiente estructura:

```properties
storePassword=tu_contraseña_del_keystore
keyPassword=tu_contraseña_de_la_clave
keyAlias=upload
storeFile=/ruta/absoluta/a/tu/upload-keystore.jks
```

**NOTA**: Este archivo está excluido en `.gitignore` por seguridad.

#### 3. Configurar build.gradle (Si no está configurado)

El archivo `android/app/build.gradle` debe incluir la configuración de firma:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Firma en CI/CD (GitHub Actions)

Para firmar el APK en CI/CD, usa variables de entorno en lugar de archivos locales:

1. Codifica el keystore en base64:
   ```bash
   base64 -i upload-keystore.jks | pbcopy  # macOS
   base64 -i upload-keystore.jks           # Linux
   ```

2. Agrega los siguientes secretos en GitHub (Settings > Secrets):
   - `ANDROID_KEYSTORE_BASE64`: Contenido del keystore en base64
   - `KEYSTORE_PASSWORD`: Contraseña del keystore
   - `KEY_ALIAS`: Alias de la clave (normalmente "upload")
   - `KEY_PASSWORD`: Contraseña de la clave

---

## Construcción Automatizada

### Usando el Script build-apk.sh

Este repositorio incluye un script automatizado para simplificar el proceso de build:

```bash
./build-apk.sh
```

El script realiza automáticamente:
1. Limpieza de builds anteriores
2. Instalación de dependencias
3. Ejecución de pruebas (opcional, comentar si no es necesario)
4. Construcción del APK release

Para ejecutar el script:

```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x build-apk.sh

# Ejecutar el script
./build-apk.sh
```

### Usando GitHub Actions

Cada push y pull request a las ramas `main` o ramas de features activa automáticamente el workflow de CI/CD que:

1. Configura el entorno Flutter
2. Instala dependencias
3. Ejecuta análisis de código y pruebas
4. Construye el APK release
5. Publica el APK como artefacto descargable

Puedes descargar el APK generado desde:
- GitHub Actions > Selecciona el workflow run > Artifacts > Descarga `app-release`

---

## Ubicación del APK

Después de ejecutar el build, los APKs se encuentran en:

### APK Universal
```
build/app/outputs/flutter-apk/app-release.apk
```

### APKs por Arquitectura
```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Información del Build
```
build/app/outputs/flutter-apk/output-metadata.json
```

---

## Mejores Prácticas

### 1. Versionado

Actualiza la versión en `pubspec.yaml` antes de cada release:

```yaml
version: 1.0.0+1  # formato: versión+buildNumber
```

- **versión**: Número de versión semántico (ej: 1.2.3)
- **buildNumber**: Número incremental del build (debe aumentar en cada release)

### 2. Ofuscación de Código

Para releases en producción, siempre usa ofuscación:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

Esto protege tu código contra ingeniería inversa.

### 3. Optimización del Tamaño

- Usa `--split-per-abi` para generar APKs más pequeños
- Elimina recursos no utilizados
- Comprime assets grandes
- Considera usar App Bundle (.aab) para Google Play Store:
  ```bash
  flutter build appbundle --release
  ```

### 4. Pruebas Antes del Release

- Ejecuta todas las pruebas unitarias y de integración
- Prueba el APK en dispositivos reales con diferentes versiones de Android
- Verifica la funcionalidad completa de la aplicación
- Revisa los permisos solicitados en el AndroidManifest.xml

### 5. Seguridad del Keystore

- **NUNCA** subas el keystore al repositorio
- Guarda backups del keystore en múltiples ubicaciones seguras
- Usa contraseñas fuertes y únicas
- Documenta la ubicación del keystore de forma segura

### 6. Configuración de ProGuard/R8

Para optimizar y ofuscar el código Java/Kotlin:

Crea/edita `android/app/proguard-rules.pro`:

```proguard
# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Stripe
-keep class com.stripe.** { *; }
```

---

## Solución de Problemas

### Error: "Gradle task assembleRelease failed"

**Solución**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Error: "Signing key not found"

**Solución**: Verifica que:
- El archivo `key.properties` existe en `android/`
- Las rutas en `key.properties` son absolutas y correctas
- El keystore tiene los permisos correctos

### Error: "Execution failed for task ':app:lintVitalRelease'"

**Solución**: Agrega esto en `android/app/build.gradle`:
```gradle
android {
    lintOptions {
        checkReleaseBuilds false
        abortOnError false
    }
}
```

### APK es demasiado grande

**Solución**:
- Usa `--split-per-abi` para generar APKs separados
- Revisa y elimina assets no utilizados
- Considera usar App Bundle en lugar de APK
- Habilita la compresión de recursos

### Error de dependencias

**Solución**:
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### Problemas con Firebase

**Solución**: Asegúrate de:
- Tener `google-services.json` en `android/app/`
- Configurar Firebase correctamente en `build.gradle`
- Ejecutar `flutterfire configure` si es necesario

---

## Recursos Adicionales

- [Documentación oficial de Flutter Build](https://docs.flutter.dev/deployment/android)
- [Guía de firma de aplicaciones Android](https://developer.android.com/studio/publish/app-signing)
- [Optimización del tamaño del APK](https://docs.flutter.dev/perf/app-size)
- [Guía de ProGuard para Flutter](https://docs.flutter.dev/deployment/android#enabling-proguard)

---

## Soporte

Si encuentras problemas durante el proceso de build, por favor:
1. Revisa esta documentación
2. Consulta los logs de error completos
3. Abre un issue en el repositorio con los detalles del problema
