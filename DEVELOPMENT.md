# Tokyo Roulette Predicciones - Guía de Desarrollo

## Estado del Proyecto

✅ Estructura básica de Flutter creada
✅ Pantallas principales implementadas (Login, Main, Settings, Manual, Upgrade)
✅ Lógica de ruleta con RNG
✅ Sistema de planes (Básica, Avanzada, Premium)
✅ Tests básicos incluidos
✅ Configuración Android lista

## Estructura del Proyecto

```
tokyo_roulette_predicciones/
├── lib/
│   └── main.dart           # Aplicación principal con todas las pantallas
├── test/
│   └── widget_test.dart    # Tests unitarios
├── android/                # Configuración Android
├── assets/
│   └── images/            # Recursos gráficos
├── pubspec.yaml           # Dependencias del proyecto
└── .gitignore            # Archivos ignorados por Git
```

## Requisitos

- Flutter SDK 3.0.0 o superior
- Dart SDK incluido con Flutter
- Android Studio o VS Code
- Java JDK 11 o superior para builds Android

## Instalación

1. Instalar Flutter SDK (si no lo tienes):
   ```bash
   # Ver instrucciones en: https://flutter.dev/docs/get-started/install
   ```

2. Verificar instalación:
   ```bash
   flutter doctor
   ```

3. Obtener dependencias:
   ```bash
   flutter pub get
   ```

## Comandos Disponibles

### Desarrollo
```bash
# Ejecutar en modo desarrollo
flutter run

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
flutter format .
```

### Builds

```bash
# Build APK para Android
flutter build apk --release

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release

# El APK estará en: build/app/outputs/flutter-apk/app-release.apk
```

## Características Implementadas

### ✅ Funcionalidades Básicas
- Login con email (guardado local)
- Simulador de ruleta con números 0-36
- Colores correctos (rojo/negro/verde)
- Historial de últimos 10 giros
- Interfaz responsive

### ✅ Sistema Freemium
- **Plan Básica** (Gratis): Simulación básica sin predicciones
- **Plan Avanzada** ($199 MXN): Predicciones simples + historial extendido
- **Plan Premium** ($299 MXN): Predicciones IA + estadísticas completas

### ✅ Pantallas
1. **LoginScreen**: Solicita email del usuario
2. **MainScreen**: Pantalla principal con ruleta y predicciones
3. **UpgradeScreen**: Muestra planes premium disponibles
4. **SettingsScreen**: Configuración de idioma y plataforma
5. **ManualScreen**: Instrucciones de uso

### 📋 Por Implementar (Opcional)

Para una versión de producción completa, considera:

1. **Integración Firebase**:
   ```bash
   # Instalar FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configurar Firebase
   flutterfire configure
   ```

2. **Integración Stripe**:
   - Crear cuenta en stripe.com
   - Obtener API keys
   - Configurar en el código

3. **Mejoras de UI**:
   - Agregar iconos personalizados
   - Animaciones para el giro de ruleta
   - Gráficos de estadísticas

4. **Funcionalidades Avanzadas**:
   - Remote Config para updates OTA
   - Push notifications
   - Analytics

## Configuración de Firebase (Opcional)

Si deseas agregar Firebase:

1. Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Agregar app Android con package: `com.melampe.tokyo_roulette_predicciones`
3. Descargar `google-services.json` a `android/app/`
4. Ejecutar: `flutterfire configure`
5. Descomentar código Firebase en `lib/main.dart`

## Configuración de Stripe (Opcional)

1. Crear cuenta en [Stripe](https://stripe.com/)
2. Obtener publishable key del dashboard
3. Reemplazar en `main.dart`: `Stripe.publishableKey = 'tu_clave_aqui'`
4. Implementar backend para crear payment intents

## Testing

```bash
# Ejecutar todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Test específico
flutter test test/widget_test.dart
```

## Deployment Android

### Google Play Store

1. Crear cuenta de desarrollador ($25 USD único)
2. Crear keystore para firma:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```
3. Configurar firma en `android/app/build.gradle`
4. Build del bundle:
   ```bash
   flutter build appbundle --release
   ```
5. Subir a Play Console

### Distribución Directa (APK)

```bash
# Generar APK
flutter build apk --release

# El archivo estará en:
# build/app/outputs/flutter-apk/app-release.apk
```

## Notas Importantes

⚠️ **Disclaimer Legal**: Esta aplicación es un simulador educativo. No promueve apuestas reales ni garantiza resultados. Cumple con las leyes locales de tu jurisdicción antes de monetizar.

⚠️ **Seguridad**: 
- Nunca commitees API keys reales
- Usa variables de entorno para secretos
- Implementa autenticación adecuada para producción

## Soporte

Para problemas o preguntas:
- Revisa la documentación de Flutter: https://flutter.dev/docs
- Comunidad Flutter: https://flutter.dev/community

## Licencia

Este proyecto es de código abierto para fines educativos.
