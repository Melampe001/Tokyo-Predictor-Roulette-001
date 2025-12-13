# Configuración de Firma de APK para Producción

## ⚠️ IMPORTANTE

El archivo `android/app/build.gradle` actualmente usa firma de debug para builds de release. Esto está bien para desarrollo y pruebas, pero **NO debe usarse para producción** (Google Play Store).

## Estado Actual

```gradle
buildTypes {
    release {
        signingConfig signingConfigs.debug  // ⚠️ Solo para desarrollo
    }
}
```

## Configuración para Producción

### Paso 1: Crear Keystore

Crea un keystore para firmar tu app:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Te pedirá:
- Contraseña del keystore
- Tu nombre, organización, ciudad, etc.
- Contraseña del alias

**⚠️ IMPORTANTE:** Guarda estas contraseñas de forma segura. Si las pierdes, no podrás actualizar tu app en Play Store.

### Paso 2: Crear key.properties

Crea el archivo `android/key.properties` (NO lo incluyas en Git):

```properties
storePassword=tu_contraseña_del_keystore
keyPassword=tu_contraseña_del_alias
keyAlias=upload
storeFile=/ruta/completa/a/upload-keystore.jks
```

### Paso 3: Agregar key.properties al .gitignore

Verifica que esté en `.gitignore`:

```
/android/key.properties
```

### Paso 4: Configurar build.gradle

Modifica `android/app/build.gradle`:

```gradle
// Antes de android {
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... configuración existente ...
    
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
            // Opcional: habilitar minificación y ofuscación
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### Paso 5: Construir APK Firmado

```bash
flutter build apk --release
```

El APK firmado estará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

## App Bundle (Recomendado para Play Store)

Google Play recomienda usar Android App Bundle (.aab) en lugar de APK:

```bash
flutter build appbundle --release
```

El bundle estará en:
```
build/app/outputs/bundle/release/app-release.aab
```

## Verificar Firma

Para verificar que el APK está correctamente firmado:

```bash
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

Deberías ver información de tu certificado, NO el certificado de debug de Android.

## Seguridad

### ✅ Hacer:
- Guardar el keystore en un lugar seguro (respaldo en múltiples ubicaciones)
- Usar contraseñas fuertes
- NO incluir key.properties en Git
- Usar variables de entorno en CI/CD
- Guardar las contraseñas en un gestor de contraseñas

### ❌ NO Hacer:
- NO pierdas el keystore o las contraseñas
- NO incluyas el keystore en Git
- NO compartas el keystore públicamente
- NO uses el certificado de debug en producción
- NO publiques key.properties

## CI/CD

Para firmar automáticamente en GitHub Actions:

1. Convierte el keystore a base64:
```bash
base64 -i upload-keystore.jks -o keystore.txt
```

2. Agrega secrets en GitHub:
   - `KEYSTORE_BASE64` - Contenido del archivo keystore.txt
   - `KEYSTORE_PASSWORD` - Contraseña del keystore
   - `KEY_ALIAS` - Alias de la key
   - `KEY_PASSWORD` - Contraseña del alias

3. Modifica el workflow para decodificar y usar el keystore

## Troubleshooting

### Error: "keytool: command not found"
Instala Java JDK o usa la ruta completa:
```bash
$JAVA_HOME/bin/keytool
```

### Error: "Certificate chain not found for: upload"
Verifica que el alias sea correcto en key.properties

### Error: "Invalid keystore format"
El keystore puede estar corrupto. Crea uno nuevo.

### Play Store rechaza el APK
Asegúrate de:
- Usar firma de release (no debug)
- Incrementar versionCode en pubspec.yaml
- El applicationId coincide con el de Play Console

## Recursos

- [Documentación oficial Flutter - Android Release](https://docs.flutter.dev/deployment/android)
- [Guía de firma de Android](https://developer.android.com/studio/publish/app-signing)
- [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

## Checklist Antes de Publicar

- [ ] Keystore creado y respaldado
- [ ] key.properties configurado (no en Git)
- [ ] build.gradle actualizado con signing config
- [ ] APK/AAB construido con firma de release
- [ ] Firma verificada con keytool
- [ ] versionCode incrementado
- [ ] Tested en dispositivos reales
- [ ] Screenshots preparados para Play Store
- [ ] Política de privacidad disponible
