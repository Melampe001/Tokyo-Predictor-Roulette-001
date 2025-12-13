# Guía de Configuración de Stripe

Esta guía te ayudará a configurar Stripe para procesar pagos en el proyecto Tokyo Roulette Predicciones.

## Requisitos previos

- Cuenta de Stripe (crear en [stripe.com](https://stripe.com))
- Firebase configurado (ver [FIREBASE_SETUP.md](./FIREBASE_SETUP.md))
- Flutter SDK instalado

## Paso 1: Crear cuenta en Stripe

1. Ve a [stripe.com](https://stripe.com) y crea una cuenta
2. Completa el proceso de verificación de identidad
3. Activa tu cuenta para pagos en producción

## Paso 2: Obtener las claves API

1. En el dashboard de Stripe, ve a "Developers" → "API keys"
2. Encontrarás dos tipos de claves:
   - **Publishable key**: Clave pública (puede estar en el código del cliente)
   - **Secret key**: Clave secreta (NUNCA debe estar en el código del cliente)

### Claves de prueba vs producción

- **Test keys**: Comienzan con `pk_test_` y `sk_test_`
- **Live keys**: Comienzan con `pk_live_` y `sk_live_`

⚠️ **IMPORTANTE**: Usa claves de prueba durante el desarrollo

## Paso 3: Configurar variables de entorno

### Método 1: Variables de entorno de sistema (Recomendado para CI/CD)

```bash
# En tu sistema o en GitHub Actions
export STRIPE_PUBLISHABLE_KEY="pk_test_xxxxxxxxxxxxx"
export STRIPE_SECRET_KEY="sk_test_xxxxxxxxxxxxx"
```

### Método 2: Archivo .env (Para desarrollo local)

Crea un archivo `.env` en la raíz del proyecto (ya está en `.gitignore`):

```env
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxx
```

Usa el paquete `flutter_dotenv` para cargar las variables:

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0

flutter:
  assets:
    - .env
```

```dart
// lib/main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final stripeKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
  // ...
}
```

### Método 3: Argumentos de compilación (Recomendado para producción)

```bash
flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
flutter build apk --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxxxxxxxxxxxx
```

En el código:

```dart
// lib/config/stripe_config.dart
class StripeConfig {
  static const String publishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '', // Sin valor por defecto en producción
  );
  
  static void validateConfig() {
    if (publishableKey.isEmpty) {
      throw Exception('STRIPE_PUBLISHABLE_KEY no está configurada');
    }
  }
}
```

## Paso 4: Inicializar Stripe en la aplicación

Actualiza `lib/main.dart`:

```dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'config/stripe_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Validar y configurar Stripe
  StripeConfig.validateConfig();
  Stripe.publishableKey = StripeConfig.publishableKey;
  Stripe.merchantIdentifier = 'merchant.tokyo.roulette'; // Para Apple Pay
  
  // Opcional: Configurar tema de Stripe
  await Stripe.instance.applySettings();
  
  runApp(const MyApp());
}
```

## Paso 5: Crear backend para procesar pagos

⚠️ **CRÍTICO**: Nunca uses la clave secreta de Stripe en el cliente. Necesitas un backend.

### Opción A: Firebase Cloud Functions (Recomendado)

1. Instala Firebase CLI:
```bash
npm install -g firebase-tools
firebase login
```

2. Inicializa Cloud Functions:
```bash
firebase init functions
cd functions
npm install stripe
```

3. Crea función para crear Payment Intent:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const stripe = require('stripe')(functions.config().stripe.secret);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // Verificar que el usuario está autenticado
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'El usuario debe estar autenticado'
    );
  }
  
  const { amount, currency } = data;
  
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // En centavos (ej: 499 = $4.99)
      currency: currency || 'usd',
      metadata: {
        userId: context.auth.uid,
        product: 'premium_access'
      }
    });
    
    return {
      clientSecret: paymentIntent.client_secret,
    };
  } catch (error) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});
```

4. Configura la clave secreta:
```bash
firebase functions:config:set stripe.secret="sk_test_xxxxxxxxxxxxx"
```

5. Despliega:
```bash
firebase deploy --only functions
```

### Opción B: Servidor Node.js/Express

Si prefieres tu propio servidor, ver [documentación de Stripe](https://stripe.com/docs/payments/quickstart).

## Paso 6: Implementar flujo de pago en Flutter

```dart
// lib/services/payment_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  Future<bool> purchasePremium() async {
    try {
      // 1. Crear Payment Intent en el backend
      final result = await _functions
          .httpsCallable('createPaymentIntent')
          .call({
            'amount': 499, // $4.99 en centavos
            'currency': 'usd',
          });
      
      final clientSecret = result.data['clientSecret'] as String;
      
      // 2. Confirmar pago con Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tokyo Roulette Predicciones',
          style: ThemeMode.light,
        ),
      );
      
      // 3. Mostrar sheet de pago
      await Stripe.instance.presentPaymentSheet();
      
      // Pago exitoso
      return true;
    } on StripeException catch (e) {
      print('Error de Stripe: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
```

## Paso 7: Agregar UI para compra Premium

```dart
// lib/screens/premium_screen.dart
class PremiumScreen extends StatelessWidget {
  final PaymentService _paymentService = PaymentService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar a Premium')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Acceso Premium', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('• Predicciones ilimitadas'),
            Text('• Sin anuncios'),
            Text('• Estadísticas avanzadas'),
            SizedBox(height: 32),
            Text('\$4.99 USD', style: TextStyle(fontSize: 32)),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final success = await _paymentService.purchasePremium();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Compra exitosa!')),
                  );
                }
              },
              child: Text('Comprar Premium'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Paso 8: Configuración de Android para Stripe

Actualiza `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <!-- Agregar dentro de <application> -->
        <meta-data
            android:name="com.google.android.gms.wallet.api.enabled"
            android:value="true" />
    </application>
    
    <!-- Permisos -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

## Paso 9: Configuración de iOS para Stripe

Actualiza `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para escanear tarjetas</string>
```

Para Apple Pay (opcional):
1. En Xcode, ve a "Signing & Capabilities"
2. Agrega "Apple Pay" capability
3. Configura merchant ID en Stripe Dashboard

## Paso 10: Testing

### Tarjetas de prueba de Stripe

Use estas tarjetas para probar en modo test:

- **Pago exitoso**: `4242 4242 4242 4242`
- **Requiere autenticación**: `4000 0025 0000 3155`
- **Pago declinado**: `4000 0000 0000 9995`

Fecha de expiración: Cualquier fecha futura  
CVC: Cualquier 3 dígitos  
Código postal: Cualquiera

## Seguridad y mejores prácticas

1. ✅ **NUNCA** incluyas la clave secreta (`sk_`) en el código del cliente
2. ✅ Usa HTTPS para todas las comunicaciones
3. ✅ Valida pagos en el backend antes de otorgar acceso
4. ✅ Implementa webhooks para manejar eventos de Stripe
5. ✅ Guarda registros de transacciones en Firestore
6. ✅ Usa claves de prueba durante el desarrollo

## Webhooks (Opcional pero recomendado)

Los webhooks te permiten recibir eventos de Stripe (ej: pago completado):

```javascript
// functions/index.js
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const webhookSecret = functions.config().stripe.webhook_secret;
  
  try {
    const event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
    
    if (event.type === 'payment_intent.succeeded') {
      const paymentIntent = event.data.object;
      // Actualizar Firestore con el pago exitoso
      await admin.firestore()
        .collection('users')
        .doc(paymentIntent.metadata.userId)
        .update({ premium: true });
    }
    
    res.json({ received: true });
  } catch (err) {
    res.status(400).send(`Webhook Error: ${err.message}`);
  }
});
```

## Troubleshooting

### Error: "Stripe.publishableKey must be set"
- Verifica que la clave está configurada antes de usar Stripe
- Asegúrate de que la variable de entorno está definida

### Error de compilación en Android
- Verifica que tienes internet en el emulador/dispositivo
- Asegúrate de tener los permisos correctos en AndroidManifest.xml

### Pagos no funcionan en producción
- Verifica que estás usando claves live (`pk_live_` y `sk_live_`)
- Asegúrate de que tu cuenta de Stripe está activada
- Verifica que el backend tiene la clave secreta correcta

## Recursos adicionales

- [Documentación de Stripe](https://stripe.com/docs)
- [flutter_stripe en pub.dev](https://pub.dev/packages/flutter_stripe)
- [Stripe Testing Cards](https://stripe.com/docs/testing)
- [Firebase Functions + Stripe](https://firebase.google.com/docs/functions/use-cases#integrate_with_third-party_services_and_apis)

## Siguiente paso

Después de configurar Stripe, considera implementar:
- Sistema de suscripciones recurrentes
- Cupones y descuentos
- Restauración de compras
- Análisis de conversión
