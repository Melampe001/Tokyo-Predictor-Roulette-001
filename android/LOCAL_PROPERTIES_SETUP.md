# Configuración Local de Desarrollo

Este documento explica cómo configurar el archivo `local.properties` necesario para compilar el proyecto Android.

## Archivo local.properties

El archivo `local.properties` debe estar ubicado en el directorio `android/` y contiene la ruta al SDK de Flutter y Android.

### Ubicación
```
android/local.properties
```

### Contenido Requerido

```properties
# Ruta al SDK de Flutter
# Windows: flutter.sdk=C:\\Users\\TuUsuario\\flutter
# Linux/macOS: flutter.sdk=/home/TuUsuario/flutter
flutter.sdk=/ruta/a/tu/flutter/sdk

# Ruta al SDK de Android (opcional, Android Studio lo configura automáticamente)
# Windows: sdk.dir=C:\\Users\\TuUsuario\\AppData\\Local\\Android\\sdk
# Linux: sdk.dir=/home/TuUsuario/Android/Sdk
# macOS: sdk.dir=/Users/TuUsuario/Library/Android/sdk
sdk.dir=/ruta/a/tu/android/sdk
```

### Generación Automática

Flutter genera automáticamente este archivo cuando ejecutas:

```bash
flutter pub get
```

o

```bash
flutter build apk
```

### Notas Importantes

⚠️ **NUNCA** commits este archivo al repositorio. Ya está incluido en `.gitignore`.

✅ Este archivo es específico de cada máquina de desarrollo.

✅ Cada desarrollador debe tener su propia copia con sus rutas locales.

## Configuración de Keystore (Opcional)

Para firmar la APK en modo release, necesitas crear un archivo `key.properties` en el directorio raíz del proyecto.

### Ubicación
```
android/key.properties
```

### Contenido

```properties
storePassword=tu_password_del_keystore
keyPassword=tu_password_de_la_key
keyAlias=tu_alias
storeFile=/ruta/absoluta/a/tu/keystore.jks
```

### Generar un Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

### Notas sobre Keystore

⚠️ **NUNCA** commits el archivo `key.properties` o el keystore al repositorio.

✅ Guarda el keystore en un lugar seguro.

✅ Haz backup del keystore y las contraseñas - si los pierdes, no podrás actualizar tu app.

✅ Para CI/CD, usa variables de entorno o secretos de GitHub en lugar de archivos.

## Variables de Entorno para CI/CD

Para compilaciones automáticas en CI/CD (GitHub Actions, etc.), puedes usar variables de entorno:

### Variables de Flutter
- `FLUTTER_ROOT` o `FLUTTER_HOME`: Ruta al SDK de Flutter

### Variables de Android
- `ANDROID_HOME` o `ANDROID_SDK_ROOT`: Ruta al SDK de Android

### Variables de Keystore
- `ANDROID_KEYSTORE_PATH`: Ruta al archivo keystore
- `KEYSTORE_PASSWORD`: Contraseña del keystore
- `KEY_ALIAS`: Alias de la key
- `KEY_PASSWORD`: Contraseña de la key

## Verificación de Configuración

Para verificar que tu configuración es correcta:

```bash
# Verificar Flutter
flutter doctor

# Obtener dependencias
flutter pub get

# Verificar build de Android
flutter build apk --debug
```

Si todo está configurado correctamente, deberías ver una compilación exitosa.

## Solución de Problemas

### Error: "flutter.sdk not set in local.properties"

**Solución**: Ejecuta `flutter pub get` en el directorio raíz del proyecto.

### Error: "Android SDK not found"

**Solución**: 
1. Instala Android Studio
2. Configura el SDK de Android desde Android Studio > Settings > Appearance & Behavior > System Settings > Android SDK
3. Ejecuta `flutter doctor --android-licenses` para aceptar las licencias

### Error al firmar APK

**Solución**: Verifica que el archivo `key.properties` existe y contiene las rutas y contraseñas correctas.

## Recursos Adicionales

- [Documentación oficial de Flutter](https://flutter.dev/docs/get-started/install)
- [Configuración de Android para Flutter](https://flutter.dev/docs/deployment/android)
- [Firma de apps Android](https://developer.android.com/studio/publish/app-signing)
