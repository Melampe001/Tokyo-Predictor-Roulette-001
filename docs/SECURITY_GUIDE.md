# Guía de Seguridad - Tokyo Roulette Predictor

## 📋 Índice
1. [Visión General](#visión-general)
2. [Implementaciones de Seguridad](#implementaciones-de-seguridad)
3. [Configuración de Firebase](#configuración-de-firebase)
4. [Validación de Entrada](#validación-de-entrada)
5. [Cumplimiento Ético](#cumplimiento-ético)
6. [Checklist de Deploy](#checklist-de-deploy)

---

## Visión General

Esta aplicación es un **simulador educativo** de ruleta que NO involucra dinero real. La seguridad se enfoca en:
- Protección de datos de usuario
- Prevención de inyecciones y XSS
- Cumplimiento ético (solo mayores de 18 años)
- RNG seguro y verificable

---

## Implementaciones de Seguridad

### ✅ 1. Random Number Generator (RNG) Seguro

**Ubicación**: `lib/roulette_logic.dart:6`

```dart
final Random rng = Random.secure();
```

- Usa `Random.secure()` para generación criptográficamente segura
- Previene predictibilidad de resultados
- Garantiza aleatoriedad para fines educativos

### ✅ 2. Validación de Email

**Ubicación**: `lib/main.dart` - Método `_validateEmail()`

Implementa:
- Sanitización (trim, lowercase)
- Validación de formato con regex
- Límite de longitud (254 caracteres)
- Prevención de inyecciones

```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor ingresa un email';
  }
  
  final sanitized = value.trim().toLowerCase();
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  if (!emailRegex.hasMatch(sanitized)) {
    return 'Ingresa un email válido';
  }
  
  if (sanitized.length > 254) {
    return 'Email demasiado largo';
  }
  
  return null;
}
```

### ✅ 3. Gestión de Memoria

**Ubicación**: `lib/main.dart` - `_LoginScreenState`

```dart
@override
void dispose() {
  _emailController.dispose();
  super.dispose();
}
```

- Previene memory leaks
- Libera recursos correctamente

### ✅ 4. Verificación de Edad

**Ubicación**: `lib/main.dart` - Método `_showAgeVerificationDialog()`

- Diálogo modal obligatorio (barrierDismissible: false)
- Confirmación explícita de ser mayor de 18 años
- Previene acceso de menores

### ✅ 5. Protección de Balance

**Ubicación**: `lib/main.dart:121-124`

```dart
if (balance < 0) balance = 0;
```

- El balance nunca puede ser negativo
- Botón de giro deshabilitado cuando balance < apuesta actual

### ✅ 6. Seguridad de Red (Android)

**Ubicación**: `android/app/src/main/AndroidManifest.xml`

```xml
android:usesCleartextTraffic="false"
android:networkSecurityConfig="@xml/network_security_config"
```

**Archivo**: `android/app/src/main/res/xml/network_security_config.xml`

- Solo permite HTTPS (cleartextTrafficPermitted="false")
- Confía en certificados del sistema
- Previene ataques man-in-the-middle

---

## Configuración de Firebase

### 📁 Archivos de Seguridad

1. **firestore.rules** - Reglas de seguridad de Firestore
2. **storage.rules** - Reglas de seguridad de Storage

### Despliegue de Reglas

```bash
# Instala Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Despliega reglas de Firestore
firebase deploy --only firestore:rules

# Despliega reglas de Storage
firebase deploy --only storage:rules
```

### Rate Limiting en Firebase Auth

**Recomendaciones**:

1. **Habilitar en Firebase Console**:
   - Authentication > Settings > User account management
   - Activar "Email enumeration protection"
   - Configurar límites de intentos de login

2. **Implementar en Backend** (Cloud Functions):

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.checkRateLimit = functions.https.onCall(async (data, context) => {
  const uid = context.auth.uid;
  const loginAttemptsRef = admin.firestore()
    .collection('loginAttempts')
    .doc(uid);
  
  const doc = await loginAttemptsRef.get();
  const attempts = doc.exists ? doc.data().count : 0;
  
  if (attempts > 5) {
    const lastAttempt = doc.data().lastAttempt.toDate();
    const now = new Date();
    const diffMinutes = (now - lastAttempt) / 1000 / 60;
    
    if (diffMinutes < 15) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Demasiados intentos. Intenta en 15 minutos.'
      );
    }
  }
  
  return { allowed: true };
});
```

### Variables de Entorno

**NUNCA hardcodear**:
- API Keys de Firebase
- Stripe Keys
- Secretos de JWT

**Usar**:

```dart
// En main.dart
const stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
```

**Configurar en CI/CD**:
```bash
flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
```

---

## Validación de Entrada

### Principios OWASP

1. **Whitelist sobre Blacklist**: Define qué es permitido
2. **Sanitización**: Limpia input antes de uso
3. **Validación de Tipo**: Verifica tipos de datos
4. **Límites**: Establece límites de tamaño

### Ejemplo: Validación de Apuesta

```dart
// Ejemplo para futuras implementaciones
double? validateBetAmount(String? input) {
  if (input == null || input.isEmpty) return null;
  
  // Solo números y punto decimal
  final sanitized = input.replaceAll(RegExp(r'[^0-9.]'), '');
  final amount = double.tryParse(sanitized);
  
  if (amount == null) return null;
  if (amount < 1.0 || amount > 10000.0) return null;
  
  return amount;
}
```

### Protección contra XSS

En contextos web, siempre:

```dart
import 'package:html_escape/html_escape.dart';

final sanitized = HtmlEscape().convert(userInput);
```

---

## Cumplimiento Ético

### ✅ Implementado

1. **Verificación de Edad 18+**
   - Diálogo modal en login
   - Confirmación explícita

2. **Disclaimers Visibles**
   - En pantalla de login
   - En pantalla principal
   - Incluyendo líneas de ayuda para ludopatía

3. **Sin Dinero Real**
   - Sistema de balance es simulado
   - Sin integración de pagos para apuestas

### 📞 Líneas de Ayuda

Incluidas en la aplicación:
- **Internacional**: 1-800-GAMBLER
- **España**: 900 200 225 (Juego Responsable)

### Texto del Disclaimer

```
⚠️ AVISO IMPORTANTE

Esta aplicación es SOLO para fines educativos y de entretenimiento.

• NO involucra dinero real
• NO promueve apuestas
• NO es un juego de azar regulado
• Las predicciones son simulaciones aleatorias

🆘 El juego puede ser adictivo
Si necesitas ayuda: 1-800-GAMBLER
España: 900 200 225 (Juego Responsable)
```

---

## Checklist de Deploy

### Pre-Deploy

- [ ] Todas las API keys en variables de entorno
- [ ] Firestore rules desplegadas y testeadas
- [ ] Storage rules desplegadas
- [ ] Rate limiting configurado en Firebase Auth
- [ ] Disclaimers visibles
- [ ] Verificación de edad implementada
- [ ] Tests de seguridad pasados
- [ ] CodeQL scan sin alertas críticas

### Android

- [ ] `usesCleartextTraffic="false"` en AndroidManifest
- [ ] `network_security_config.xml` configurado
- [ ] Solo permisos necesarios (INTERNET, ACCESS_NETWORK_STATE)
- [ ] ProGuard/R8 habilitado para ofuscación
- [ ] Firma de APK configurada

```gradle
// android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        signingConfig signingConfigs.release
    }
}
```

### iOS

- [ ] Info.plist con descripciones de permisos
- [ ] App Transport Security configurado
- [ ] Sin permisos innecesarios

### Testing

```bash
# Lint
flutter analyze

# Tests unitarios
flutter test

# Test de integración
flutter test integration_test/

# Build de release
flutter build apk --release
flutter build ios --release
```

### Post-Deploy

- [ ] Monitoreo de Firebase crashlytics
- [ ] Revisión de logs de seguridad
- [ ] Actualización de dependencias mensual
- [ ] Escaneo de vulnerabilidades trimestral

---

## Contacto de Seguridad

Para reportar vulnerabilidades:
1. **NO** abrir issue público
2. Crear GitHub Security Advisory privado
3. Contactar a maintainers directamente

---

## Referencias

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [Dart Security](https://dart.dev/guides/libraries/secure-random)

---

**Última actualización**: 2025-12-15
**Versión**: 1.0.0
