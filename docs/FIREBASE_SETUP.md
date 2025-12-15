# Guía de Configuración Segura de Firebase

Esta guía describe cómo configurar Firebase de manera segura para habilitar las funcionalidades opcionales de autenticación y configuración remota.

## ⚠️ Nota Importante

Las funcionalidades de Firebase son **opcionales**. La aplicación funciona completamente sin Firebase, pero estas características añaden:
- Autenticación de usuarios con email
- Configuración remota para actualizar parámetros sin nueva versión
- Almacenamiento de datos de usuario en Firestore

## 🔒 Principios de Seguridad

1. **NUNCA** hardcodear claves API o secrets en el código
2. Usar variables de entorno para información sensible
3. Implementar y desplegar Security Rules antes de usar Firebase
4. Validar y sanitizar TODOS los inputs de usuario
5. Implementar rate limiting para prevenir abuso

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

## Paso 2: Desplegar Security Rules PRIMERO

**CRÍTICO**: Desplegar las reglas de seguridad ANTES de habilitar Firebase en la app.

```bash
# Clonar las reglas de seguridad del repositorio
cd /ruta/a/tokyo-roulette

# Inicializar Firebase en el proyecto
firebase init

# Desplegar reglas de Firestore
firebase deploy --only firestore:rules

# Desplegar reglas de Storage
firebase deploy --only storage:rules
```

Las reglas ya están incluidas en:
- `firestore.rules` - Reglas de Firestore Database
- `storage.rules` - Reglas de Firebase Storage

## Paso 3: Configurar Firebase en Flutter

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

## Paso 4: Habilitar Firebase en el Código

Una vez generado `firebase_options.dart` y desplegadas las security rules, descomentar las siguientes líneas en `lib/main.dart`:

```dart
// En los imports (línea 4-5)
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// En main() (línea 14)
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

## Paso 5: Implementar Autenticación Segura

**IMPORTANTE**: La aplicación ya incluye validación de email y verificación de edad.

En `lib/main.dart`, el método `_handleSubmit()` ya sanitiza el email:

```dart
final sanitizedEmail = _emailController.text.trim().toLowerCase();
```

Para integrar Firebase Auth, reemplazar el TODO con:

```dart
import 'package:firebase_auth/firebase_auth.dart';

void _handleSubmit() async {
  if (!_ageVerified) {
    _showAgeVerificationDialog();
    return;
  }

  if (_formKey.currentState!.validate()) {
    // Email ya sanitizado por _validateEmail()
    final sanitizedEmail = _emailController.text.trim().toLowerCase();
    
    try {
      // Crear cuenta o iniciar sesión
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: sanitizedEmail,
        password: 'temporal123', // PRODUCCIÓN: pedir contraseña al usuario
      );
      
      // Guardar datos adicionales en Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': sanitizedEmail,
          'ageVerified': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Error de autenticación';
        switch (e.code) {
          case 'email-already-in-use':
            // Intentar login
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: sanitizedEmail,
                password: 'temporal123',
              );
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              }
              return;
            } catch (e2) {
              message = 'Error al iniciar sesión';
            }
            break;
          case 'invalid-email':
            message = 'Email inválido';
            break;
          case 'weak-password':
            message = 'Contraseña débil';
            break;
          case 'too-many-requests':
            message = 'Demasiados intentos. Intenta más tarde.';
            break;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }
}
```

## Paso 6: Configurar Rate Limiting

En Firebase Console:
1. Ve a Authentication > Settings
2. Habilita "Email enumeration protection"
3. Configura "Suspicious activity detection"

Para rate limiting avanzado, usa Cloud Functions:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.checkLoginAttempts = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Usuario no autenticado');
  }
  
  const uid = context.auth.uid;
  const attemptsRef = admin.firestore().collection('loginAttempts').doc(uid);
  const doc = await attemptsRef.get();
  
  if (doc.exists) {
    const data = doc.data();
    const attempts = data.count || 0;
    const lastAttempt = data.lastAttempt.toDate();
    const now = new Date();
    const minutesSinceLastAttempt = (now - lastAttempt) / 1000 / 60;
    
    // Si hay más de 5 intentos en los últimos 15 minutos, bloquear
    if (attempts >= 5 && minutesSinceLastAttempt < 15) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        'Demasiados intentos. Intenta en 15 minutos.'
      );
    }
    
    // Reset si han pasado más de 15 minutos
    if (minutesSinceLastAttempt >= 15) {
      await attemptsRef.set({ count: 1, lastAttempt: admin.firestore.FieldValue.serverTimestamp() });
    } else {
      await attemptsRef.update({ count: attempts + 1, lastAttempt: admin.firestore.FieldValue.serverTimestamp() });
    }
  } else {
    await attemptsRef.set({ count: 1, lastAttempt: admin.firestore.FieldValue.serverTimestamp() });
  }
  
  return { allowed: true };
});
```

## Paso 7: Guardar Datos en Firestore de Forma Segura

Para guardar el historial de giros en la nube de forma segura:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Después de cada giro exitoso
void spinRoulette() async {
  final res = _rouletteLogic.generateSpin();
  
  // ... código existente ...
  
  // Guardar en Firestore SOLO si el usuario está autenticado
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Validar datos antes de guardar
      if (balance >= 0 && currentBet >= 0 && res >= 0 && res <= 36) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('gameHistory')
            .add({
          'number': res,
          'timestamp': FieldValue.serverTimestamp(),
          'balance': balance,
          'bet': currentBet,
          'won': won,
        });
      }
    } catch (e) {
      // Manejar errores silenciosamente para no interrumpir el juego
      print('Error guardando historial: $e');
    }
  }
}
```

**Nota**: Las Security Rules ya validan que:
- Solo el usuario propietario puede escribir en su historial
- Los datos tienen el formato correcto
- Los valores numéricos están en rangos válidos

## Paso 8: Configurar Remote Config Seguro

Remote Config permite cambiar configuraciones sin publicar nueva versión:

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

// En main(), después de inicializar Firebase
Future<void> initRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 4), // Actualiza cada 4 meses según requerimientos
  ));

  await remoteConfig.setDefaults({
    'initial_balance': 1000.0,
    'min_bet': 1.0,
    'max_bet': 1000.0,
    'enable_predictions': true,
    'enable_martingale': true,
    'max_history_items': 20,
    'maintenance_mode': false,
  });

  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    print('Error al obtener Remote Config: $e');
    // Continuar con valores por defecto
  }
}

// Usar los valores de forma segura
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  double get initialBalance {
    final value = _remoteConfig.getDouble('initial_balance');
    // Validar que el valor está en un rango razonable
    return value.clamp(100.0, 10000.0);
  }
  
  double get minBet {
    final value = _remoteConfig.getDouble('min_bet');
    return value.clamp(1.0, 100.0);
  }
  
  double get maxBet {
    final value = _remoteConfig.getDouble('max_bet');
    return value.clamp(10.0, 10000.0);
  }
  
  bool get enablePredictions => _remoteConfig.getBool('enable_predictions');
  bool get enableMartingale => _remoteConfig.getBool('enable_martingale');
  bool get maintenanceMode => _remoteConfig.getBool('maintenance_mode');
  
  int get maxHistoryItems {
    final value = _remoteConfig.getInt('max_history_items');
    return value.clamp(10, 100);
  }
}
```

## 🔒 Consideraciones Críticas de Seguridad

1. **NUNCA** incluir claves API o secrets en el código
   - Usar variables de entorno: `String.fromEnvironment('FIREBASE_API_KEY')`
   - Agregar `firebase_options.dart` a `.gitignore`

2. **Security Rules ya incluidas** en `firestore.rules` y `storage.rules`:
   - Validación de tipos de datos
   - Restricciones de acceso por usuario
   - Validación de formato de email
   - Límites de tamaño de archivos
   - Prevención de inyecciones

3. **Firestore Security Rules**:
```javascript
// Ya desplegadas desde firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo el usuario puede acceder a sus datos
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.data.ageVerified == true
        && isValidEmail(request.resource.data.email);
      // Ver firestore.rules para reglas completas
    }
  }
}
```

4. **En Authentication, configurar**:
   - Email enumeration protection ✅
   - Rate limiting para prevenir abuso ✅
   - Suspicious activity detection ✅

5. **Validación de Inputs**:
   - La app ya incluye validación de email
   - Todos los datos son sanitizados antes de guardar
   - Límites de tamaño aplicados

6. **Logging Seguro**:
   - NUNCA loggear emails, passwords o tokens
   - Usar niveles de log apropiados (INFO, WARNING, ERROR)
   - Sanitizar datos antes de loggear

## 🧪 Testing Seguro sin Firebase

Los tests pueden ejecutarse sin Firebase usando mocks:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks([CustomMockPlatform()]);
}

void main() {
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Security Tests', () {
    test('Validación de email rechaza inputs maliciosos', () {
      // Tests incluidos en test/security_test.dart
      expect(validateEmail('<script>alert(1)</script>@test.com'), isNull);
      expect(validateEmail('test@example.com'), isNotNull);
    });

    test('Balance no puede ser negativo', () {
      double balance = 50.0;
      balance -= 100.0;
      if (balance < 0) balance = 0.0;
      expect(balance, greaterThanOrEqualTo(0));
    });
  });
}
```

## 📊 Monitoreo de Seguridad

### Firebase Crashlytics

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Capturar errores de Flutter
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  
  // Capturar errores async
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  
  runApp(MyApp());
}
```

### Auditoría de Seguridad

```bash
# Verificar configuración de Firebase
firebase projects:list

# Ver reglas actuales
firebase firestore:rules:get

# Test de reglas localmente
npm install -g @firebase/rules-unit-testing
npm test
```

## 🚀 Despliegue Seguro en CI/CD

Para compilar con Firebase en GitHub Actions de forma segura:

### 1. Configurar Secrets en GitHub

```bash
# Generar base64 de firebase_options.dart
base64 -i lib/firebase_options.dart -o firebase_config.txt

# En GitHub: Settings > Secrets > Actions
# Agregar: FIREBASE_CONFIG_BASE64 con el contenido de firebase_config.txt
```

### 2. Workflow Seguro

```.yaml
name: Build with Firebase

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # Decodificar Firebase Config de forma segura
      - name: Setup Firebase Config
        run: |
          echo "${{ secrets.FIREBASE_CONFIG_BASE64 }}" | base64 -d > lib/firebase_options.dart
          # Verificar que el archivo se creó (sin mostrar contenido)
          ls -la lib/firebase_options.dart
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
        env:
          STRIPE_PUBLISHABLE_KEY: ${{ secrets.STRIPE_PUBLISHABLE_KEY }}
      
      # Limpiar archivos sensibles
      - name: Cleanup
        if: always()
        run: |
          rm -f lib/firebase_options.dart
          rm -f firebase_config.txt
```

### 3. Variables de Entorno

```bash
# Build local con variables
flutter build apk --release \
  --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_KEY \
  --dart-define=FIREBASE_API_KEY=$FIREBASE_KEY

# Build iOS
flutter build ios --release \
  --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_KEY \
  --dart-define=FIREBASE_API_KEY=$FIREBASE_KEY
```

## ✅ Checklist de Seguridad Pre-Deploy

Antes de desplegar a producción:

- [ ] Firebase Security Rules desplegadas (`firestore.rules`, `storage.rules`)
- [ ] Rules testeadas con emulador local
- [ ] Rate limiting configurado en Authentication
- [ ] Email enumeration protection habilitado
- [ ] Variables de entorno configuradas (NO hardcoded)
- [ ] `firebase_options.dart` en `.gitignore`
- [ ] Crashlytics configurado para monitoreo
- [ ] Tests de seguridad pasados
- [ ] Validación de inputs implementada
- [ ] Verificación de edad funcional
- [ ] Disclaimers visibles
- [ ] CodeQL scan sin alertas críticas

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
