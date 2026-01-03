// =============================================================================
// Stripe Service - Servicio de Pagos con Stripe
// =============================================================================
//
// Este archivo proporciona un servicio para integrar pagos con Stripe
// en la aplicación Flutter.
//
// ARQUITECTURA RECOMENDADA:
// ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
// │   Flutter   │────>│   Backend   │────>│   Stripe    │
// │    App      │<────│   (Seguro)  │<────│    API      │
// └─────────────┘     └─────────────┘     └─────────────┘
//
// El flujo seguro de pagos es:
// 1. La app solicita al backend crear un PaymentIntent
// 2. El backend usa la SECRET KEY para crear el PaymentIntent
// 3. El backend devuelve el client_secret a la app
// 4. La app usa el client_secret para completar el pago
//
// MEJORES PRÁCTICAS:
// - NUNCA uses la Secret Key en el cliente (app móvil/web)
// - Solo usa la Publishable Key en el cliente
// - Toda la lógica de creación de pagos debe estar en el backend
// - Implementa webhooks para confirmar pagos
// - Usa HTTPS para todas las comunicaciones
// - Implementa idempotency keys para evitar cargos duplicados
//
// SEGURIDAD CRÍTICA:
// ⚠️  NUNCA hardcodees claves de Stripe en el código fuente
// ⚠️  NUNCA expongas la Secret Key (sk_...) en el cliente
// ⚠️  SIEMPRE valida montos y datos en el backend
// ⚠️  SIEMPRE usa variables de entorno para las claves
// ⚠️  SIEMPRE verifica la firma de webhooks
//
// GESTIÓN DE CLAVES:
// - Publishable Key (pk_...): Segura para usar en el cliente
// - Secret Key (sk_...): SOLO en backend, NUNCA en cliente
// - Webhook Signing Secret: SOLO en backend para verificar webhooks
//
// CONFIGURACIÓN DE VARIABLES DE ENTORNO:
// En desarrollo local, crea un archivo .env (nunca lo subas al repo):
//   STRIPE_PUBLISHABLE_KEY=pk_test_...
//
// En CI/CD (GitHub Actions, etc.):
//   - Usa secrets del repositorio
//   - Inyecta variables en tiempo de build
//
// Para Flutter, usa --dart-define:
//   flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...
// =============================================================================

import 'package:flutter_stripe/flutter_stripe.dart';

/// Servicio para gestionar pagos con Stripe.
///
/// IMPORTANTE: Este servicio maneja solo la parte del cliente.
/// La creación de PaymentIntents debe hacerse en tu backend.
///
/// Ejemplo de uso:
/// ```dart
/// // Inicialización (hacer una sola vez, en main.dart)
/// await StripeService.instance.initialize();
///
/// // Procesar un pago
/// final result = await StripeService.instance.processPayment(
///   clientSecret: 'pi_xxx_secret_xxx', // Obtenido de tu backend
///   billingDetails: BillingDetails(email: 'user@example.com'),
/// );
/// ```
class StripeService {
  // Instancia singleton
  static final StripeService _instance = StripeService._internal();
  
  /// Obtiene la instancia singleton del servicio Stripe
  static StripeService get instance => _instance;
  
  // Constructor privado para patrón singleton
  StripeService._internal();
  
  // Estado de inicialización
  bool _initialized = false;
  
  /// Indica si Stripe ha sido inicializado
  bool get isInitialized => _initialized;
  
  // ===========================================================================
  // INICIALIZACIÓN
  // ===========================================================================
  
  /// Inicializa Stripe con la publishable key.
  ///
  /// SEGURIDAD:
  /// - Obtiene la key de variables de entorno
  /// - NUNCA hardcodees la key directamente
  /// - Usa --dart-define para pasar la key en tiempo de build
  ///
  /// Ejemplo de build seguro:
  /// ```bash
  /// flutter build apk --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx
  /// ```
  Future<bool> initialize() async {
    if (_initialized) {
      return true;
    }
    
    try {
      // SEGURIDAD: Obtener key de variable de entorno
      // La key se pasa con: --dart-define=STRIPE_PUBLISHABLE_KEY=pk_xxx
      const publishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
      
      if (publishableKey.isEmpty) {
        // En desarrollo, podrías tener un fallback a test key
        // ADVERTENCIA: Nunca usar keys de producción aquí
        // NOTE: En producción, usa un framework de logging apropiado
        assert(() {
          // ignore: avoid_print
          print(
            '[StripeService] ADVERTENCIA: STRIPE_PUBLISHABLE_KEY no configurada. '
            'Usa --dart-define=STRIPE_PUBLISHABLE_KEY=pk_xxx',
          );
          return true;
        }());
        return false;
      }
      
      // Validar que sea una publishable key (pk_) y no una secret key (sk_)
      if (publishableKey.startsWith('sk_')) {
        throw SecurityException(
          '¡ALERTA DE SEGURIDAD! Se detectó una Secret Key. '
          'NUNCA uses la Secret Key en el cliente. '
          'Usa solo la Publishable Key (pk_xxx).',
        );
      }
      
      // Validar que la key tenga el formato correcto de publishable key
      if (!publishableKey.startsWith('pk_')) {
        throw SecurityException(
          'Formato de clave inválido. '
          'La clave debe ser una Publishable Key (pk_test_xxx o pk_live_xxx).',
        );
      }
      
      // Configurar Stripe
      Stripe.publishableKey = publishableKey;
      
      // Configuraciones opcionales
      // Stripe.merchantIdentifier = 'merchant.com.tuapp'; // Para Apple Pay
      // Stripe.urlScheme = 'tuapp'; // Para deep linking
      
      _initialized = true;
      
      // NOTE: En producción, usa un framework de logging apropiado
      assert(() {
        // ignore: avoid_print
        print('[StripeService] Stripe inicializado correctamente');
        return true;
      }());
      
      return true;
    } catch (e) {
      // NOTE: En producción, usa un framework de logging apropiado
      assert(() {
        // ignore: avoid_print
        print('[StripeService] Error al inicializar Stripe: $e');
        return true;
      }());
      return false;
    }
  }
  
  // ===========================================================================
  // PROCESAMIENTO DE PAGOS
  // ===========================================================================
  
  /// Procesa un pago usando un PaymentIntent creado en el backend.
  ///
  /// FLUJO SEGURO:
  /// 1. Tu backend crea un PaymentIntent usando la Secret Key
  /// 2. El backend te devuelve el client_secret
  /// 3. Usas este método para completar el pago
  ///
  /// [clientSecret] - El client_secret del PaymentIntent (de tu backend)
  /// [billingDetails] - Detalles de facturación del cliente
  ///
  /// EJEMPLO DE BACKEND (Node.js):
  /// ```javascript
  /// // En tu servidor (NUNCA en el cliente)
  /// const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
  ///
  /// app.post('/create-payment-intent', async (req, res) => {
  ///   const { amount, currency } = req.body;
  ///
  ///   // Validar monto en el servidor
  ///   if (amount < 50) {
  ///     return res.status(400).json({ error: 'Monto mínimo es 50 centavos' });
  ///   }
  ///
  ///   const paymentIntent = await stripe.paymentIntents.create({
  ///     amount: amount, // En centavos
  ///     currency: currency,
  ///     automatic_payment_methods: { enabled: true },
  ///   });
  ///
  ///   res.json({ clientSecret: paymentIntent.client_secret });
  /// });
  /// ```
  Future<PaymentResult> processPayment({
    required String clientSecret,
    BillingDetails? billingDetails,
  }) async {
    _ensureInitialized();
    
    try {
      // Validar que tenemos un client_secret
      if (clientSecret.isEmpty) {
        return PaymentResult.failure('Client secret es requerido');
      }
      
      // Confirmar el pago con Stripe
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      
      // Verificar el resultado
      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        return PaymentResult.success(paymentIntent.id);
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
        // El pago requiere acción adicional (3D Secure, etc.)
        return PaymentResult.requiresAction(paymentIntent.id);
      } else {
        return PaymentResult.failure(
          'Estado de pago inesperado: ${paymentIntent.status}',
        );
      }
    } on StripeException catch (e) {
      return PaymentResult.failure(
        e.error.localizedMessage ?? 'Error de pago desconocido',
      );
    } catch (e) {
      return PaymentResult.failure('Error inesperado: $e');
    }
  }
  
  // ===========================================================================
  // PRESENTACIÓN DE PAYMENT SHEET
  // ===========================================================================
  
  /// Presenta el Payment Sheet de Stripe.
  ///
  /// El Payment Sheet es una UI pre-construida por Stripe que maneja
  /// la entrada de tarjeta de forma segura y cumple con PCI.
  ///
  /// [clientSecret] - Client secret del PaymentIntent
  /// [merchantDisplayName] - Nombre de tu negocio mostrado al usuario
  Future<PaymentResult> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    _ensureInitialized();
    
    try {
      // Inicializar el payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          // Configuraciones adicionales opcionales:
          // customerEphemeralKeySecret: 'ek_xxx', // Para guardar métodos de pago
          // customerId: 'cus_xxx', // ID del cliente en Stripe
          // style: ThemeMode.system, // Tema claro/oscuro
        ),
      );
      
      // Presentar el payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      return PaymentResult.success('payment_completed');
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.cancelled();
      }
      return PaymentResult.failure(
        e.error.localizedMessage ?? 'Error de pago',
      );
    } catch (e) {
      return PaymentResult.failure('Error inesperado: $e');
    }
  }
  
  // ===========================================================================
  // MÉTODOS AUXILIARES
  // ===========================================================================
  
  /// Verifica que Stripe esté inicializado
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'Stripe no ha sido inicializado. '
        'Llama a StripeService.instance.initialize() primero.',
      );
    }
  }
}

// =============================================================================
// CLASES AUXILIARES
// =============================================================================

/// Resultado de una operación de pago
class PaymentResult {
  final PaymentStatus status;
  final String? paymentIntentId;
  final String? errorMessage;
  
  PaymentResult._({
    required this.status,
    this.paymentIntentId,
    this.errorMessage,
  });
  
  factory PaymentResult.success(String paymentIntentId) {
    return PaymentResult._(
      status: PaymentStatus.success,
      paymentIntentId: paymentIntentId,
    );
  }
  
  factory PaymentResult.failure(String message) {
    return PaymentResult._(
      status: PaymentStatus.failed,
      errorMessage: message,
    );
  }
  
  factory PaymentResult.cancelled() {
    return PaymentResult._(status: PaymentStatus.cancelled);
  }
  
  factory PaymentResult.requiresAction(String paymentIntentId) {
    return PaymentResult._(
      status: PaymentStatus.requiresAction,
      paymentIntentId: paymentIntentId,
    );
  }
  
  bool get isSuccess => status == PaymentStatus.success;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isCancelled => status == PaymentStatus.cancelled;
}

/// Estados posibles de un pago
enum PaymentStatus {
  success,
  failed,
  cancelled,
  requiresAction,
}

/// Excepción de seguridad personalizada
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}
