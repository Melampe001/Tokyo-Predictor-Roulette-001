# Guía de Configuración de Firebase (Opcional)

Esta guía describe cómo configurar Firebase para habilitar las funcionalidades opcionales de autenticación y configuración remota.

## ⚠️ Nota Importante

Las funcionalidades de Firebase son **opcionales**. La aplicación funciona completamente sin Firebase, pero estas características añaden:
- Autenticación de usuarios con email
- Configuración remota para actualizar parámetros sin nueva versión
- Almacenamiento de datos de usuario en Firestore

## Prerequisitos

1. Instalar Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Instalar FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

## Paso 1: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o usa uno existente
3. Habilita los siguientes servicios:
   - **Authentication** (Email/Password provider)
   - **Firestore Database**
   - **Remote Config**

## Paso 2: Configurar Firebase en Flutter

```bash
# Inicia sesión en Firebase
firebase login

# Configura el proyecto Flutter con Firebase
flutterfire configure
```

Este comando:
- Crea automáticamente `firebase_options.dart`
- Configura las credenciales para Android e iOS
- Registra la app en tu proyecto Firebase

## Paso 3: Habilitar Firebase en el Código

Una vez generado `firebase_options.dart`, descomentar las siguientes líneas en `lib/main.dart`:

```dart
// En los imports (línea 4-5)
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// En main() (línea 14)
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

## Paso 4: Implementar Autenticación (Opcional)

En `lib/main.dart`, en la clase `_LoginScreenState`, reemplazar el TODO con:

```dart
import 'package:firebase_auth/firebase_auth.dart';

// En el método onPressed del botón (línea 63)
onPressed: () async {
  try {
    // Crear cuenta o iniciar sesión
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: 'temporal123', // En producción, pedir contraseña al usuario
    );
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  } catch (e) {
    // Si el usuario ya existe, intentar login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: 'temporal123',
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e2) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e2.toString()}')),
        );
      }
    }
  }
},
```

## Paso 5: Guardar Datos en Firestore (Opcional)

Para guardar el historial de giros en la nube:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Después de cada giro exitoso
void spinRoulette() async {
  final res = _rouletteLogic.generateSpin();
  
  // ... código existente ...
  
  // Guardar en Firestore
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('spins')
        .add({
      'number': res,
      'timestamp': FieldValue.serverTimestamp(),
      'balance': balance,
      'bet': currentBet,
    });
  }
}
```

## Paso 6: Configurar Remote Config (Opcional)

Remote Config permite cambiar configuraciones sin publicar nueva versión:

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

// En main(), después de inicializar Firebase
final remoteConfig = FirebaseRemoteConfig.instance;
await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(minutes: 1),
  minimumFetchInterval: const Duration(hours: 4),
));

await remoteConfig.setDefaults({
  'initial_balance': 1000.0,
  'min_bet': 10.0,
  'max_bet': 500.0,
  'enable_predictions': true,
});

await remoteConfig.fetchAndActivate();

// Usar los valores
final initialBalance = remoteConfig.getDouble('initial_balance');
```

## Consideraciones de Seguridad

1. **Nunca** incluir claves API o secrets en el código
2. Usar **Firestore Security Rules** para proteger datos:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. En Authentication, habilitar límites de tasa para prevenir abuso

## Despliegue en CI/CD

Para compilar con Firebase en GitHub Actions, agregar los secrets:
- `FIREBASE_CONFIG_BASE64`: Base64 del archivo `firebase_options.dart`

```yaml
- name: Decodificar Firebase Config
  run: echo "${{ secrets.FIREBASE_CONFIG_BASE64 }}" | base64 -d > lib/firebase_options.dart
```

## Testing sin Firebase

Los tests pueden ejecutarse sin Firebase usando mocks:

```dart
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setupFirebaseCoreMocks(); // Mock Firebase

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // ... tests ...
}
```

## Recursos Adiciales

- [Firebase Flutter Documentation](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Firebase Auth Flutter](https://firebase.flutter.dev/docs/auth/overview)
- [Firestore Flutter](https://firebase.flutter.dev/docs/firestore/overview)

---

**Última actualización**: Diciembre 2025
