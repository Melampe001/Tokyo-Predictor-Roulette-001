# 🧪 Test Module Example

Este ejemplo muestra cómo crear un módulo de tests personalizado para el Vercel Emulator.

## Caso de Uso: Módulo de Tests para API Calls

Vamos a crear un módulo que prueba las llamadas a API (Firebase, Stripe, etc.).

### 1. Crear el Módulo

```dart
// testing/vercel_emulator/modules/api_module_test.dart

import '../test_runner.dart';

/// Módulo de pruebas para APIs externas
class APIModuleTest extends TestModule {
  @override
  String get name => 'API & External Services';

  @override
  bool get critical => false;  // No crítico para permitir desarrollo offline

  @override
  Duration get timeout => const Duration(minutes: 2);

  @override
  List<Test> get tests => [
        // Firebase Tests
        Test(
          name: 'Firebase connection mock',
          run: () async {
            // Simular inicialización de Firebase
            final initialized = await _mockFirebaseInit();
            
            if (!initialized) {
              throw Exception('Firebase initialization failed');
            }
          },
          timeout: Duration(seconds: 30),
        ),

        // Firestore Tests
        Test(
          name: 'Firestore write/read operations',
          run: () async {
            // Simular escritura y lectura en Firestore
            final testData = {'email': 'test@example.com', 'timestamp': DateTime.now()};
            
            // Mock write
            await _mockFirestoreWrite('test_collection', testData);
            
            // Mock read
            final readData = await _mockFirestoreRead('test_collection');
            
            if (readData == null) {
              throw Exception('Failed to read from Firestore');
            }
          },
        ),

        // Stripe Tests
        Test(
          name: 'Stripe payment intent creation',
          run: () async {
            // Simular creación de payment intent
            final intent = await _mockStripePaymentIntent(amount: 1000);
            
            if (intent['status'] != 'created') {
              throw Exception('Payment intent creation failed');
            }
            
            if (intent['amount'] != 1000) {
              throw Exception('Amount mismatch in payment intent');
            }
          },
        ),

        Test(
          name: 'Stripe webhook validation',
          run: () async {
            // Simular validación de webhook
            final mockPayload = {
              'type': 'payment_intent.succeeded',
              'data': {'amount': 1000, 'currency': 'usd'}
            };
            
            final isValid = await _validateWebhookPayload(mockPayload);
            
            if (!isValid) {
              throw Exception('Webhook validation failed');
            }
          },
        ),

        // Remote Config Tests
        Test(
          name: 'Firebase Remote Config fetch',
          run: () async {
            // Simular fetch de remote config
            final config = await _mockRemoteConfigFetch();
            
            if (config.isEmpty) {
              throw Exception('Remote config is empty');
            }
            
            // Verificar valores esperados
            if (!config.containsKey('feature_flags')) {
              throw Exception('Missing feature_flags in remote config');
            }
          },
        ),

        // Network Error Handling
        Test(
          name: 'Network error handling',
          run: () async {
            // Simular error de red
            try {
              await _mockAPICallWithError();
              throw Exception('Should have thrown network error');
            } catch (e) {
              // Verificar que el error se maneje correctamente
              if (!e.toString().contains('Network')) {
                rethrow;
              }
            }
          },
        ),

        // Rate Limiting
        Test(
          name: 'Rate limiting compliance',
          run: () async {
            // Simular múltiples llamadas
            final calls = <Future>[];
            
            for (var i = 0; i < 5; i++) {
              calls.add(_mockAPICall());
            }
            
            // Esperar todas las llamadas
            final results = await Future.wait(calls);
            
            // Verificar que todas tuvieron éxito
            if (results.any((r) => !r)) {
              throw Exception('Some API calls failed');
            }
          },
        ),

        // Timeout Handling
        Test(
          name: 'API timeout handling',
          run: () async {
            try {
              await _mockSlowAPICall().timeout(
                Duration(milliseconds: 500),
              );
              throw Exception('Should have timed out');
            } on TimeoutException {
              // Correcto - el timeout funcionó
            }
          },
        ),
      ];

  // Mock implementations
  Future<bool> _mockFirebaseInit() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  Future<void> _mockFirestoreWrite(String collection, Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 50));
    // Simular escritura exitosa
  }

  Future<Map<String, dynamic>?> _mockFirestoreRead(String collection) async {
    await Future.delayed(Duration(milliseconds: 50));
    return {'email': 'test@example.com'};
  }

  Future<Map<String, dynamic>> _mockStripePaymentIntent({required int amount}) async {
    await Future.delayed(Duration(milliseconds: 100));
    return {
      'id': 'pi_mock_123',
      'status': 'created',
      'amount': amount,
      'currency': 'usd',
    };
  }

  Future<bool> _validateWebhookPayload(Map<String, dynamic> payload) async {
    await Future.delayed(Duration(milliseconds: 50));
    return payload.containsKey('type') && payload.containsKey('data');
  }

  Future<Map<String, dynamic>> _mockRemoteConfigFetch() async {
    await Future.delayed(Duration(milliseconds: 100));
    return {
      'feature_flags': {
        'premium_enabled': true,
        'new_ui': false,
      },
      'version': '1.0.0',
    };
  }

  Future<void> _mockAPICallWithError() async {
    await Future.delayed(Duration(milliseconds: 50));
    throw Exception('Network error: Connection timeout');
  }

  Future<bool> _mockAPICall() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  Future<void> _mockSlowAPICall() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Future<void> setup() async {
    // Setup inicial del módulo
    print('📡 Setting up API test environment...');
    await Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Future<void> teardown() async {
    // Cleanup después de los tests
    print('🧹 Cleaning up API test environment...');
    await Future.delayed(Duration(milliseconds: 50));
  }
}
```

### 2. Registrar el Módulo

En `testing/vercel_emulator/run_tests.dart`:

```dart
import 'modules/api_module_test.dart';

// En main()
final modules = <TestModule>[
  UIModuleTest(),
  MLModuleTest(),
  DataModuleTest(),
  IntegrationModuleTest(),
  APIModuleTest(),  // Agregar aquí
];
```

### 3. Configurar en YAML

En `testing/vercel_emulator/config/test_config.yaml`:

```yaml
test_config:
  modules:
    # ... otros módulos
    api:
      enabled: true
      critical: false  # No crítico para desarrollo offline
      timeout: 120
      description: "Pruebas de APIs y servicios externos"
```

### 4. Ejecutar los Tests

```bash
# Ejecutar todos los módulos (incluido API)
dart testing/vercel_emulator/run_tests.dart

# Ver resultados detallados
dart testing/vercel_emulator/run_tests.dart --verbose
```

### 5. Resultado Esperado

```
🔧 Starting module: API & External Services
────────────────────────────────────────────────────────────
⏳ Running API & External Services › Firebase connection mock...
✅ API & External Services › Firebase connection mock (105ms)
⏳ Running API & External Services › Firestore write/read operations...
✅ API & External Services › Firestore write/read operations (102ms)
⏳ Running API & External Services › Stripe payment intent creation...
✅ API & External Services › Stripe payment intent creation (103ms)
⏳ Running API & External Services › Stripe webhook validation...
✅ API & External Services › Stripe webhook validation (52ms)
⏳ Running API & External Services › Firebase Remote Config fetch...
✅ API & External Services › Firebase Remote Config fetch (101ms)
⏳ Running API & External Services › Network error handling...
✅ API & External Services › Network error handling (51ms)
⏳ Running API & External Services › Rate limiting compliance...
✅ API & External Services › Rate limiting compliance (102ms)
⏳ Running API & External Services › API timeout handling...
✅ API & External Services › API timeout handling (501ms)
────────────────────────────────────────────────────────────
✅ Module API & External Services completed:
   Passed: 8/8
   Duration: 1117ms
```

## Características Avanzadas

### Tests con Diferentes Configuraciones

```dart
Test(
  name: 'API call with retry logic',
  run: () async {
    var attempts = 0;
    const maxAttempts = 3;
    
    while (attempts < maxAttempts) {
      try {
        await _mockAPICall();
        break;  // Éxito
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
    
    if (attempts >= maxAttempts) {
      throw Exception('Max retry attempts reached');
    }
  },
),
```

### Tests Parametrizados

```dart
for (final amount in [100, 1000, 10000]) {
  tests.add(
    Test(
      name: 'Stripe payment intent for \$${amount / 100}',
      run: () async {
        final intent = await _mockStripePaymentIntent(amount: amount);
        if (intent['amount'] != amount) {
          throw Exception('Amount mismatch');
        }
      },
    ),
  );
}
```

### Tests con Setup Específico

```dart
@override
Future<void> setup() async {
  print('📡 Setting up API test environment...');
  
  // Inicializar mocks
  await _initializeMocks();
  
  // Configurar test data
  await _setupTestData();
  
  // Verificar conectividad (opcional)
  await _checkConnectivity();
}

@override
Future<void> teardown() async {
  print('🧹 Cleaning up API test environment...');
  
  // Limpiar datos de test
  await _cleanupTestData();
  
  // Cerrar conexiones
  await _closeConnections();
}
```

## Testing con Datos Reales (Opcional)

Para tests de integración real:

```dart
Test(
  name: 'Real Firebase read (integration)',
  run: () async {
    // Skip si no hay conexión
    if (!await _hasInternetConnection()) {
      print('⏭️  Skipping (no internet)');
      return;
    }
    
    // Test real aquí
    final data = await FirebaseFirestore.instance
        .collection('test')
        .doc('test_doc')
        .get();
    
    if (!data.exists) {
      throw Exception('Test document not found');
    }
  },
),
```

## Best Practices

1. **Mock por Defecto**: Usa mocks para tests rápidos
2. **Tests de Integración Opcionales**: Marca como no críticos
3. **Timeouts Apropiados**: API calls necesitan más tiempo
4. **Manejo de Errores**: Prueba casos de error
5. **Cleanup**: Limpia datos de test en `teardown()`
6. **Offline-First**: Tests deben funcionar sin internet

## Debugging

```bash
# Ver output detallado
dart testing/vercel_emulator/run_tests.dart --verbose

# Ejecutar solo el módulo API (edita run_tests.dart temporalmente)
# Comenta otros módulos y deja solo APIModuleTest()
```

---

¡Crea tests robustos para tus APIs! 🧪
