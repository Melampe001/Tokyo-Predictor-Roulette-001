# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

## Construir App Bundle (AAB)
El workflow de GitHub Actions genera automáticamente el App Bundle (AAB) firmado cuando se hace push a la rama `main`.

### Secretos requeridos para GitHub Actions
Para que el workflow de construcción de AAB funcione, debes configurar los siguientes secrets en GitHub:

- `ANDROID_KEYSTORE_BASE64`: El archivo .jks del keystore codificado en base64
  - Para generar: `base64 -w 0 android/app/Tokyoapps.jks > keystore.txt`
- `KEYSTORE_PASSWORD`: Contraseña del keystore
- `KEY_ALIAS`: Alias de la clave en el keystore
- `KEY_PASSWORD`: Contraseña de la clave

**Importante**: Nunca subas archivos `.jks`, `key.properties` o `local.properties` al repositorio. Estos archivos están incluidos en `.gitignore`.

**Disclaimer**: Solo simulación. No promueve gambling real.
// BEGIN: Carga de propiedades de keystore con fallback a variables de entorno
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
} else {
    // Fallback: leer desde variables de entorno (definir en CI)
    keystoreProperties.setProperty('storeFile', System.getenv('ANDROID_KEYSTORE_PATH') ?: '')
    keystoreProperties.setProperty('storePassword', System.getenv('KEYSTORE_PASSWORD') ?: '')
    keystoreProperties.setProperty('keyAlias', System.getenv('KEY_ALIAS') ?: '')
    keystoreProperties.setProperty('keyPassword', System.getenv('KEY_PASSWORD') ?: '')
}
// END
