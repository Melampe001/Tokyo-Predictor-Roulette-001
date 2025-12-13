# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Requisitos

- Flutter SDK 3.0.0 o superior
- Android Studio (para desarrollo Android)
- Java JDK 17
- Cuenta de Firebase (para configuración)
- Cuenta de Stripe (para pagos)

## Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Configura Firebase:
   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Descarga `google-services.json` para Android y colócalo en `android/app/`
   - Ejecuta `flutterfire configure` para generar `lib/firebase_options.dart` con tus credenciales reales
   - Actualiza las claves en `lib/firebase_options.dart`

4. Configura Stripe:
   - Obtén tu clave pública de [Stripe Dashboard](https://dashboard.stripe.com/)
   - Reemplaza `'tu_publishable_key_de_stripe'` en `lib/main.dart` con tu clave real

5. Ejecuta la aplicación:
```bash
flutter run
```

## Construir APK

Para construir el APK de lanzamiento:

```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## Estructura del Proyecto

```
lib/
  ├── main.dart              # Punto de entrada, UI principal
  ├── roulette_logic.dart    # Lógica de ruleta y estrategia Martingale
  └── firebase_options.dart  # Configuración de Firebase

android/
  └── app/
      ├── build.gradle       # Configuración de construcción Android
      ├── google-services.json  # Configuración de Firebase (reemplazar)
      └── src/main/
          ├── AndroidManifest.xml
          └── kotlin/        # Código nativo Kotlin
```

## Funcionalidades

- ✅ Simulación de ruleta europea (0-36)
- ✅ Generador de números aleatorios seguro
- ✅ Sistema de predicciones basado en historial
- ✅ Asesor de estrategia Martingale
- ✅ Integración con Firebase para autenticación
- ✅ Integración con Stripe para pagos
- ✅ Notificaciones push con Firebase Cloud Messaging
- ✅ Almacenamiento local con SharedPreferences
- ✅ Gráficos de estadísticas

## Desarrollo

### Ejecutar tests
```bash
flutter test
```

### Análisis de código
```bash
flutter analyze
```

### Formateo de código
```bash
dart format .
```

## CI/CD

El proyecto incluye GitHub Actions para:
- Verificación de formato de código
- Análisis estático
- Ejecución de tests
- Construcción automática de APK

## Notas Importantes

⚠️ **CONFIGURACIÓN REQUERIDA**: Este proyecto incluye archivos de configuración de ejemplo con valores placeholder. Debes reemplazarlos con tus propias credenciales:

1. `lib/firebase_options.dart` - Genera con `flutterfire configure`
2. `android/app/google-services.json` - Descarga desde Firebase Console
3. `lib/main.dart` - Actualiza la clave de Stripe

## Licencia

**Disclaimer**: Solo simulación educativa. No promueve gambling real.

