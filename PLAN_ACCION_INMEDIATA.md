# Plan de Acción Inmediata - Tokyo Roulette Predicciones

## 🎯 Objetivo
Completar los elementos críticos para tener un MVP funcional de la aplicación.

---

## 🚀 FASE 1: CONFIGURACIÓN BASE (1-2 días)

### Paso 1: Configurar Firebase
```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase para el proyecto
flutterfire configure
```

**Checklist:**
- [ ] Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
- [ ] Ejecutar `flutterfire configure`
- [ ] Verificar que se generó `lib/firebase_options.dart`
- [ ] Descomentar inicialización en `lib/main.dart` líneas 13-14
- [ ] Configurar Firebase Authentication (Email/Password)
- [ ] Configurar Cloud Firestore
- [ ] Configurar Firebase Remote Config
- [ ] Configurar Firebase Messaging

---

### Paso 2: Configurar Stripe
```bash
# Las dependencias ya están en pubspec.yaml
flutter pub get
```

**Checklist:**
- [ ] Crear cuenta en [Stripe Dashboard](https://dashboard.stripe.com/)
- [ ] Obtener Publishable Key (modo test)
- [ ] Crear productos/precios en Stripe para suscripciones
- [ ] Configurar variable de entorno `STRIPE_PUBLISHABLE_KEY`
- [ ] Descomentar código en `lib/main.dart` líneas 18-21
- [ ] Probar inicialización

**Ejemplo de configuración:**
```dart
// En main.dart
const stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', 
    defaultValue: 'pk_test_...'); // Solo para desarrollo
Stripe.publishableKey = stripeKey;
```

---

## 🔐 FASE 2: AUTENTICACIÓN (2-3 días)

### Implementar Pantalla de Login/Registro

**Crear:** `lib/screens/auth/login_screen.dart`
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registro
  Future<User?> registerWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    
    // Guardar datos adicionales en Firestore
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'subscriptionStatus': 'free',
    });
    
    return credential.user;
  }

  // Login
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return credential.user;
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
```

**Checklist:**
- [ ] Crear archivo `lib/services/auth_service.dart`
- [ ] Implementar registro con Firebase Auth
- [ ] Implementar login
- [ ] Implementar logout
- [ ] Agregar validación de formularios
- [ ] Implementar manejo de errores
- [ ] Guardar estado de usuario con Provider/Riverpod
- [ ] Probar flujo completo

---

## 🎰 FASE 3: FUNCIONALIDADES CORE (3-5 días)

### A. Completar UI de Predicciones

**Modificar:** `lib/main.dart` (MainScreen)

**Agregar variables en _MainScreenState:**
```dart
class _MainScreenState extends State<MainScreen> {
  final RouletteLogic _rouletteLogic = RouletteLogic();
  final MartingaleAdvisor _martingaleAdvisor = MartingaleAdvisor(); // AGREGAR
  String result = 'Presiona Girar';
  List<int> history = [];
  double bet = 10.0;
  // ...
}
```

**Agregar widgets:**
```dart
// En MainScreen, agregar:
Column(
  children: [
    // Widget de predicción
    Card(
      child: Column(
        children: [
          Text('Predicción para el próximo giro:'),
          Text(
            _rouletteLogic.predictNext(history).toString(),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text('Basado en ${history.length} giros anteriores'),
        ],
      ),
    ),
    
    // Widget de estrategia Martingale
    Card(
      child: Column(
        children: [
          Text('Estrategia Martingale'),
          Text('Apuesta actual: \$${_martingaleAdvisor.currentBet}'),
          Text('Apuesta base: \$${_martingaleAdvisor.baseBet}'),
        ],
      ),
    ),
    
    // Historial visual
    Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: history.length,
        itemBuilder: (context, index) {
          return _buildNumberChip(history[index]);
        },
      ),
    ),
  ],
)
```

**Checklist:**
- [ ] Agregar widget de predicción en MainScreen
- [ ] Mostrar número predicho antes de cada giro
- [ ] Agregar widget de Martingale
- [ ] Implementar actualización de apuesta según resultado
- [ ] Mostrar historial visual de números
- [ ] Agregar colores (rojo/negro/verde) a números
- [ ] Implementar reset de estrategia
- [ ] Agregar estadísticas básicas (win rate)

---

### B. Sistema de Suscripciones

**Crear:** `lib/screens/subscription_screen.dart`

**Estructura:**
```dart
class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planes')),
      body: Column(
        children: [
          // Plan Gratuito
          PlanCard(
            title: 'Gratuito',
            price: '\$0',
            features: [
              '10 giros por día',
              'Predicciones básicas',
              'Anuncios',
            ],
            onSelect: () {}, // Ya es gratis
          ),
          
          // Plan Premium
          PlanCard(
            title: 'Premium',
            price: '\$4.99/mes',
            features: [
              'Giros ilimitados',
              'Predicciones avanzadas',
              'Sin anuncios',
              'Estrategias personalizadas',
            ],
            onSelect: () => _purchaseSubscription(context),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseSubscription(BuildContext context) async {
    // Implementar con flutter_stripe
    // Ver: https://pub.dev/packages/flutter_stripe
  }
}
```

**Checklist:**
- [ ] Crear pantalla de planes
- [ ] Diseñar cards de planes (Free vs Premium)
- [ ] Implementar flujo de pago con Stripe
- [ ] Guardar estado de suscripción en Firestore
- [ ] Implementar verificación de suscripción activa
- [ ] Agregar límites de giros para usuarios gratuitos
- [ ] Implementar restauración de compras
- [ ] Agregar manejo de errores de pago
- [ ] Probar con tarjetas de prueba de Stripe

---

### C. Gráficos y Visualizaciones

**Crear:** `lib/widgets/statistics_chart.dart`

**Usar:** `fl_chart` (ya está en dependencias)

**Ejemplo básico:**
```dart
import 'package:fl_chart/fl_chart.dart';

class StatisticsChart extends StatelessWidget {
  final List<int> history;

  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // Configurar datos del gráfico
        lineBarsData: [
          LineChartBarData(
            spots: _generateSpots(history),
            isCurved: true,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots(List<int> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
    }).toList();
  }
}
```

**Checklist:**
- [ ] Crear widget de gráfico de historial
- [ ] Agregar gráfico de distribución (rojos/negros)
- [ ] Agregar gráfico de frecuencia de números
- [ ] Agregar gráfico de rendimiento de Martingale
- [ ] Implementar filtros temporales
- [ ] Agregar leyendas y etiquetas
- [ ] Optimizar rendimiento para listas largas

---

## 📱 FASE 4: CONFIGURACIÓN DE RELEASE (1-2 días)

### Paso 1: Generar Keystore

```bash
keytool -genkey -v -keystore ~/tokyo-roulette-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias tokyo-roulette
```

**Guardar información:**
- Ubicación del keystore
- Password del keystore
- Key alias
- Key password

### Paso 2: Configurar key.properties

**Crear:** `android/key.properties` (NO commitear)
```properties
storeFile=/ruta/a/tokyo-roulette-keystore.jks
storePassword=TU_PASSWORD
keyAlias=tokyo-roulette
keyPassword=TU_KEY_PASSWORD
```

**Agregar a `.gitignore`:**
```
android/key.properties
*.jks
```

### Paso 3: Configurar AndroidManifest.xml

**Editar:** `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.tuempresa.tokyo_roulette">
    
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <application
        android:label="Tokyo Roulette"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

**Checklist:**
- [ ] Generar keystore
- [ ] Configurar key.properties
- [ ] Agregar key.properties a .gitignore
- [ ] Configurar permisos en AndroidManifest
- [ ] Agregar íconos de app
- [ ] Configurar applicationId único
- [ ] Probar build de release: `flutter build apk --release`

---

## ⚖️ FASE 5: LEGAL Y COMPLIANCE (1 día)

### Crear Documentos Legales

**Crear:** `lib/screens/legal/privacy_policy_screen.dart`
**Crear:** `lib/screens/legal/terms_screen.dart`

**Contenido mínimo requerido:**
1. **Términos y Condiciones:**
   - Naturaleza educativa/simulada
   - Prohibición de uso con dinero real
   - Edad mínima (18+)
   - Limitación de responsabilidad

2. **Política de Privacidad:**
   - Datos recopilados (email, historial de uso)
   - Uso de Firebase/Stripe
   - Derechos del usuario (GDPR si aplica)
   - Contacto

**Checklist:**
- [ ] Redactar Términos y Condiciones
- [ ] Redactar Política de Privacidad
- [ ] Crear pantallas para mostrar documentos
- [ ] Agregar checkbox de aceptación en registro
- [ ] Agregar disclaimers en pantalla principal
- [ ] Agregar enlaces en configuración

---

## 🧪 FASE 6: TESTING Y QA (2-3 días)

### Tests Unitarios

**Crear tests para:**
```dart
// test/roulette_logic_test.dart
void main() {
  group('RouletteLogic', () {
    test('generateSpin debe retornar número entre 0-36', () {
      final logic = RouletteLogic();
      final result = logic.generateSpin();
      expect(result, greaterThanOrEqualTo(0));
      expect(result, lessThanOrEqualTo(36));
    });

    test('predictNext no debe fallar con historial vacío', () {
      final logic = RouletteLogic();
      expect(() => logic.predictNext([]), returnsNormally);
    });
  });

  group('MartingaleAdvisor', () {
    test('debe duplicar apuesta después de pérdida', () {
      final advisor = MartingaleAdvisor();
      advisor.baseBet = 10.0;
      final nextBet = advisor.getNextBet(false);
      expect(nextBet, equals(20.0));
    });

    test('debe resetear a apuesta base después de ganar', () {
      final advisor = MartingaleAdvisor();
      advisor.baseBet = 10.0;
      advisor.getNextBet(false); // pierde, duplica a 20
      final nextBet = advisor.getNextBet(true); // gana, vuelve a 10
      expect(nextBet, equals(10.0));
    });
  });
}
```

**Checklist:**
- [ ] Escribir tests para RouletteLogic
- [ ] Escribir tests para MartingaleAdvisor
- [ ] Escribir tests para AuthService
- [ ] Escribir widget tests para pantallas principales
- [ ] Ejecutar tests: `flutter test`
- [ ] Verificar coverage: `flutter test --coverage`
- [ ] Agregar tests al CI/CD workflow

---

### Testing Manual

**Escenarios críticos a probar:**
- [ ] Registro de nuevo usuario
- [ ] Login con credenciales existentes
- [ ] Login con credenciales incorrectas
- [ ] Giro de ruleta funciona correctamente
- [ ] Predicciones se actualizan
- [ ] Estrategia Martingale funciona
- [ ] Límites de giros para usuarios gratuitos
- [ ] Flujo de compra de suscripción
- [ ] Notificaciones funcionan
- [ ] App funciona offline (modo básico)
- [ ] Logout y limpieza de datos

---

## 📋 CHECKLIST FINAL PRE-LANZAMIENTO

### Funcionalidad
- [ ] Firebase configurado y funcionando
- [ ] Autenticación funciona correctamente
- [ ] Sistema de suscripciones implementado
- [ ] Predicciones funcionan
- [ ] Estrategia Martingale funciona
- [ ] Gráficos se muestran correctamente
- [ ] Notificaciones configuradas

### Calidad
- [ ] Tests unitarios pasan
- [ ] Tests de widget pasan
- [ ] Sin errores de análisis: `flutter analyze`
- [ ] Código formateado: `flutter format .`
- [ ] Sin warnings en build de release
- [ ] App probada en dispositivos Android reales
- [ ] App probada en diferentes tamaños de pantalla

### Seguridad
- [ ] No hay claves API hardcodeadas
- [ ] Keystore configurado correctamente
- [ ] Variables de entorno configuradas
- [ ] Permisos mínimos necesarios en AndroidManifest

### Legal
- [ ] Términos y Condiciones implementados
- [ ] Política de Privacidad implementada
- [ ] Disclaimers visibles
- [ ] Edad mínima verificada (18+)

### Assets
- [ ] Íconos de app configurados
- [ ] Splash screen implementado
- [ ] Imágenes optimizadas
- [ ] Todos los assets necesarios incluidos

### Documentación
- [ ] README actualizado
- [ ] Instrucciones de instalación claras
- [ ] Proceso de release documentado
- [ ] Código comentado donde necesario

---

## 🚀 COMANDOS ÚTILES

```bash
# Verificar instalación de Flutter
flutter doctor -v

# Obtener dependencias
flutter pub get

# Analizar código
flutter analyze

# Formatear código
flutter format .

# Ejecutar tests
flutter test

# Ejecutar en dispositivo
flutter run

# Build de release
flutter build apk --release

# Ver logs
flutter logs

# Limpiar build cache
flutter clean
```

---

## 📞 SIGUIENTE PASO INMEDIATO

**Comenzar con:**
1. Configurar Firebase (Fase 1, Paso 1)
2. Probar que la app compila: `flutter run`
3. Implementar autenticación básica (Fase 2)

**Tiempo estimado para MVP:** 50-70 horas de desarrollo (aprox. 1.5-2 semanas a tiempo completo)

---

## 🔗 RECURSOS

- [Documentación oficial de Flutter](https://docs.flutter.dev/)
- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Stripe Flutter](https://pub.dev/packages/flutter_stripe)
- [fl_chart ejemplos](https://pub.dev/packages/fl_chart)

---

**Nota:** Este plan asume 1 desarrollador trabajando tiempo completo. Ajustar tiempos según disponibilidad.
