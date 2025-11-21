# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

## Construir App Bundle (AAB) para Play Store

### Construcción Local
Para construir un App Bundle localmente, necesitas configurar el keystore:

1. Genera un keystore (si aún no tienes uno):
   ```bash
   keytool -genkey -v -keystore android/app/Tokyoapps.jks -keyalg RSA -keysize 2048 -validity 10000 -alias tokyokey
   ```

2. Crea el archivo `android/key.properties` con el siguiente contenido:
   ```properties
   storeFile=android/app/Tokyoapps.jks
   storePassword=TU_PASSWORD_DEL_KEYSTORE
   keyAlias=tokyokey
   keyPassword=TU_PASSWORD_DE_LA_KEY
   ```

3. Construye el App Bundle:
   ```bash
   flutter build appbundle --release
   ```

### Construcción con GitHub Actions (CI/CD)

El repositorio incluye un workflow de GitHub Actions que construye automáticamente el App Bundle cuando se hace push a la rama `main`.

**Configuración de Secrets Requeridos:**

Debes configurar los siguientes secrets en el repositorio de GitHub (Settings → Secrets and variables → Actions):

- `ANDROID_KEYSTORE_BASE64`: El keystore codificado en base64
  ```bash
  base64 -i android/app/Tokyoapps.jks | pbcopy  # macOS
  base64 android/app/Tokyoapps.jks | xclip      # Linux
  ```
- `KEYSTORE_PASSWORD`: La contraseña del keystore
- `KEY_ALIAS`: El alias de la key (ej: `tokyokey`)
- `KEY_PASSWORD`: La contraseña de la key

El workflow descargará y restaurará automáticamente el keystore desde los secrets, construirá el App Bundle y lo subirá como artifact.

**⚠️ Seguridad Importante:**
- **NUNCA** commitees `android/key.properties` ni archivos `.jks` al repositorio
- Los archivos sensibles están excluidos en `.gitignore`
- Si `android/local.properties` estuvo previamente comiteado, considera rotar las claves y limpiar el historial

## Formato de Código
Para formatear el código Dart antes de hacer commit:
```bash
make fmt
```

**Disclaimer**: Solo simulación. No promueve gambling real.
