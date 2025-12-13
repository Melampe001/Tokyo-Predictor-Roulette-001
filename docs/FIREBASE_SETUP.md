# Guía de Configuración de Firebase

Esta guía te ayudará a configurar Firebase para el proyecto Tokyo Roulette Predicciones.

## Requisitos previos

- Cuenta de Google/Firebase
- Flutter SDK instalado
- FlutterFire CLI instalado

## Paso 1: Crear proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto"
3. Ingresa el nombre del proyecto: "Tokyo Roulette Predicciones"
4. Sigue los pasos del asistente
5. Habilita Google Analytics (opcional pero recomendado)

## Paso 2: Instalar FlutterFire CLI

```bash
# Instalar FlutterFire CLI globalmente
dart pub global activate flutterfire_cli

# Verificar instalación
flutterfire --version
```

## Paso 3: Configurar FlutterFire en el proyecto

```bash
# Navega al directorio del proyecto
cd /ruta/al/proyecto/tokyo_roulette_predicciones

# Ejecuta el comando de configuración
flutterfire configure
```

Este comando:
- Te pedirá que selecciones el proyecto Firebase
- Generará automáticamente `lib/firebase_options.dart`
- Configurará las plataformas (Android, iOS, Web, etc.)

## Paso 4: Habilitar servicios de Firebase

### Authentication (Firebase Auth)

1. En Firebase Console, ve a "Authentication"
2. Haz clic en "Comenzar"
3. Habilita los métodos de inicio de sesión que necesites:
   - Email/Password (recomendado para este proyecto)
   - Google Sign-In
   - Otros proveedores según necesidad

### Firestore Database

1. En Firebase Console, ve a "Firestore Database"
2. Haz clic en "Crear base de datos"
3. Selecciona modo de inicio:
   - **Modo de producción**: Más seguro, requiere reglas
   - **Modo de prueba**: Útil para desarrollo (expira en 30 días)
4. Selecciona la ubicación (recomendado: us-central1 o más cercana a tus usuarios)

#### Reglas de seguridad de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura/escritura solo a usuarios autenticados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Colección de emails (para el registro)
    match /emails/{emailId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
    }
    
    // Estadísticas globales (solo lectura)
    match /stats/{stat} {
      allow read: if true;
      allow write: if false; // Solo admin puede escribir
    }
  }
}
```

### Remote Config

1. En Firebase Console, ve a "Remote Config"
2. Haz clic en "Crear configuración"
3. Agrega parámetros:
   - `free_spins_per_day`: 10
   - `premium_price`: 4.99
   - `features_enabled`: {"predictions": true, "martingale": true}
   - `maintenance_mode`: false

### Cloud Messaging (Notificaciones)

1. En Firebase Console, ve a "Cloud Messaging"
2. Sigue las instrucciones para configurar notificaciones push
3. Descarga los archivos de configuración:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

## Paso 5: Actualizar el código

Una vez generado `firebase_options.dart`, descomentar en `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## Paso 6: Configuración específica de Android

### Actualizar `android/app/build.gradle`

Asegúrate de tener:

```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        multiDexEnabled true
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

### Actualizar `android/build.gradle`

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### Aplicar plugin en `android/app/build.gradle`

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Paso 7: Verificar instalación

```bash
# Ejecutar la app
flutter run

# Si hay errores, limpiar y reconstruir
flutter clean
flutter pub get
flutter run
```

## Variables de entorno (Opcional pero recomendado)

Para mayor seguridad, considera usar variables de entorno para claves API:

```dart
// lib/config/firebase_config.dart
class FirebaseConfig {
  static const String apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'default-key-for-dev',
  );
}
```

Ejecutar con:
```bash
flutter run --dart-define=FIREBASE_API_KEY=tu-api-key-real
```

## Troubleshooting

### Error: "No Firebase App '[DEFAULT]' has been created"
- Asegúrate de llamar a `Firebase.initializeApp()` antes de usar cualquier servicio
- Verifica que `firebase_options.dart` existe y tiene la configuración correcta

### Error de compilación en Android
- Verifica que `google-services.json` esté en `android/app/`
- Asegúrate de que el nombre del paquete coincida en el archivo y en Firebase Console
- Limpia el proyecto: `flutter clean && flutter pub get`

### Error de permisos en iOS
- Actualiza `ios/Runner/Info.plist` con los permisos necesarios
- Ejecuta `cd ios && pod install`

## Recursos adicionales

- [Documentación oficial de FlutterFire](https://firebase.flutter.dev/docs/overview)
- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire en GitHub](https://github.com/firebase/flutterfire)

## Siguiente paso

Después de configurar Firebase, continúa con la [Guía de Configuración de Stripe](./STRIPE_SETUP.md) para habilitar los pagos.
