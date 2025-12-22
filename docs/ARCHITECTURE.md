# Arquitectura Técnica - Tokyo Roulette Predicciones

## Resumen Ejecutivo

Tokyo Roulette Predicciones es una aplicación Flutter para Android/iOS que simula una ruleta europea con sistema de predicciones y estrategia Martingale. La arquitectura prioriza simplicidad, seguridad y experiencia educativa.

## Stack Tecnológico

### Core
- **Framework**: Flutter 3.0+
- **Lenguaje**: Dart (SDK >=3.0.0 <4.0.0)
- **Patrón de diseño**: StatefulWidget con gestión de estado local

### Dependencias Principales
```yaml
flutter: sdk
flutter_stripe: ^10.0.0         # Pagos (futuro)
in_app_purchase: ^3.2.0         # Compras in-app (futuro)
firebase_core: ^2.24.2          # Base Firebase (opcional)
firebase_remote_config: ^4.3.12 # Config remota (opcional)
cloud_firestore: ^4.15.3        # Base de datos (opcional)
firebase_auth: ^4.16.0          # Autenticación (opcional)
intl: ^0.18.1                   # Internacionalización
device_info_plus: ^9.1.2        # Info del dispositivo
url_launcher: ^6.2.4            # Abrir enlaces
shared_preferences: ^2.2.2      # Almacenamiento local
fl_chart: ^0.65.0               # Gráficos (futuro)
firebase_messaging: ^14.7.10    # Notificaciones (futuro)
```

### Herramientas de Desarrollo
- **Testing**: flutter_test, integration_test
- **CI/CD**: GitHub Actions
- **Análisis de código**: flutter analyze

## Arquitectura de Componentes

### Estructura de Directorios
```
lib/
├── main.dart              # Punto de entrada y UI principal
└── roulette_logic.dart    # Lógica de negocio

test/
├── widget_test.dart       # Tests de UI
└── roulette_logic_test.dart # Tests unitarios

docs/
├── USER_GUIDE.md          # Guía de usuario
├── FIREBASE_SETUP.md      # Setup de Firebase
└── ARCHITECTURE.md        # Este documento

.github/
└── workflows/
    └── build-apk.yml      # CI/CD pipeline
```

## Componentes Principales

### 1. Capa de Presentación (UI)

#### `MyApp` (Widget)
- Widget raíz de la aplicación
- Configura tema global (MaterialApp)
- Define rutas y navegación

#### `LoginScreen` (StatefulWidget)
- Pantalla de entrada simple
- Captura email del usuario
- Navegación a pantalla principal
- **Futuro**: Integración con Firebase Auth

**Responsabilidades**:
- Validación básica de email
- Navegación a MainScreen
- Preparación para autenticación futura

#### `MainScreen` (StatefulWidget)
- Pantalla principal de la ruleta
- Gestiona todo el estado del juego
- Renderiza UI completa

**Estado Gestionado**:
```dart
RouletteLogic _rouletteLogic      // Lógica de ruleta
MartingaleAdvisor _martingaleAdvisor // Asesor de estrategia
String result                      // Resultado actual
List<int> history                  // Historial de giros
int? prediction                    // Predicción sugerida
double balance                     // Balance virtual
double currentBet                  // Apuesta actual
bool useMartingale                 // Flag de estrategia
String lastBetResult               // Mensaje de resultado
```

**Métodos Principales**:
- `spinRoulette()`: Ejecuta un giro completo
- `_isRedNumber()`: Determina color del número
- `_resetGame()`: Reinicia el juego
- `_showSettingsDialog()`: Muestra configuración
- `_getNumberColor()`: Obtiene color para UI

### 2. Capa de Lógica de Negocio

#### `RouletteLogic` (Class)
Encapsula la lógica central de la ruleta.

**Atributos**:
```dart
List<int> wheel    // [0, 1, 2, ..., 36] - Ruleta europea
Random rng         // Random.secure() - RNG criptográfico
```

**Métodos**:
```dart
int generateSpin()
  // Genera número aleatorio del 0 al 36
  // Usa Random.secure() para seguridad criptográfica
  // Retorno: Número de la ruleta

int predictNext(List<int> history)
  // Analiza historial y sugiere número más frecuente
  // Parámetro: Lista de números anteriores
  // Retorno: Número predicho
  // Nota: Si history vacío, retorna aleatorio
```

**Consideraciones de Seguridad**:
- `Random.secure()` usa generador criptográfico del SO
- No predecible ni reproducible
- Adecuado para simulaciones justas

#### `MartingaleAdvisor` (Class)
Implementa la estrategia de apuestas Martingale.

**Atributos**:
```dart
double baseBet     // Apuesta base inicial
double currentBet  // Apuesta actual
bool lastWin       // Resultado del último giro
```

**Métodos**:
```dart
double getNextBet(bool win)
  // Calcula siguiente apuesta según resultado
  // Si win: vuelve a baseBet
  // Si !win: duplica currentBet
  // Parámetro: true si ganó, false si perdió
  // Retorno: Próxima apuesta recomendada

void reset()
  // Reinicia a valores iniciales
  // currentBet = baseBet
  // lastWin = true
```

**Algoritmo**:
```
win == true:
  currentBet = baseBet
  return baseBet

win == false:
  currentBet = currentBet * 2
  return currentBet
```

### 3. Capa de Datos (Futuro)

Actualmente la app mantiene estado en memoria. Para persistencia:

#### Almacenamiento Local (SharedPreferences)
```dart
// Guardar historial
prefs.setStringList('history', history.map((e) => e.toString()).toList());

// Guardar balance
prefs.setDouble('balance', balance);

// Cargar en inicio
history = prefs.getStringList('history')?.map(int.parse).toList() ?? [];
balance = prefs.getDouble('balance') ?? 1000.0;
```

#### Almacenamiento Remoto (Firebase Firestore)
```dart
// Estructura de datos
/users/{userId}/
  - email: string
  - createdAt: timestamp
  /spins/{spinId}/
    - number: int
    - timestamp: timestamp
    - balance: double
    - bet: double
    - won: bool
```

## Flujo de Datos

### Flujo de un Giro Completo

```
1. Usuario toca "Girar Ruleta"
   ↓
2. MainScreen.spinRoulette()
   ↓
3. RouletteLogic.predictNext(history)  [si history no vacío]
   → Analiza frecuencias
   → Retorna número más común
   ↓
4. RouletteLogic.generateSpin()
   → Random.secure().nextInt(37)
   → Retorna número aleatorio
   ↓
5. _isRedNumber(result)
   → Determina si es rojo
   → Simula ganancia/pérdida
   ↓
6. setState({
     result = número
     history.add(número)
     balance +/- currentBet
     lastBetResult = mensaje
   })
   ↓
7. Si useMartingale:
     MartingaleAdvisor.getNextBet(won)
     → Ajusta currentBet
   ↓
8. UI se re-renderiza
   → Muestra nuevo resultado
   → Actualiza historial visual
   → Muestra nueva predicción
```

### Diagrama de Flujo de Navegación

```
[SplashScreen]
      ↓
[LoginScreen]
  - Input: email
  - Acción: "Registrar y Continuar"
      ↓
[MainScreen]
  ├─→ [Settings Dialog]
  │     - Toggle Martingale
  │     - Volver
  │         ↓
  │    [MainScreen]
  │
  └─→ Botón Reset
      └─→ [MainScreen] (estado reseteado)
```

## Gestión de Estado

### Patrón Utilizado: StatefulWidget + setState

**Ventajas**:
- Simple y directo
- No requiere dependencias adicionales
- Adecuado para apps pequeñas/medianas
- Fácil de entender y mantener

**Limitaciones**:
- No escala bien con múltiples pantallas complejas
- Estado acoplado al widget
- Difícil de testear lógica sin UI

### Alternativas para Futuro

Si la app crece, considerar:

#### Provider
```dart
class GameState extends ChangeNotifier {
  double _balance = 1000.0;
  List<int> _history = [];
  
  void spinRoulette() {
    // lógica
    notifyListeners();
  }
}

// En UI
Consumer<GameState>(
  builder: (context, game, child) => Text('${game.balance}')
)
```

#### Bloc (Business Logic Component)
```dart
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(InitialState()) {
    on<SpinEvent>((event, emit) async {
      emit(SpinningState());
      final result = await rouletteLogic.generateSpin();
      emit(ResultState(result));
    });
  }
}
```

#### Riverpod
```dart
final balanceProvider = StateProvider((ref) => 1000.0);
final historyProvider = StateProvider((ref) => <int>[]);

// En UI
final balance = ref.watch(balanceProvider);
```

## Seguridad

### Random Number Generation (RNG)

**Implementación Actual**:
```dart
final Random rng = Random.secure();
int result = rng.nextInt(37);
```

**Por qué Random.secure()**:
- Usa fuentes de entropía del sistema operativo
- No reproducible (sin seed)
- Cumple estándares criptográficos
- Apropiado para simulaciones justas

**Alternativa NO Recomendada**:
```dart
// ❌ NO USAR - Predecible con seed
final Random rng = Random(seed: 12345);
```

### Validación de Datos

**Balance Mínimo**:
```dart
// Botón deshabilitado si balance insuficiente
onPressed: balance >= currentBet ? spinRoulette : null
```

**Límite de Apuesta Martingale**:
```dart
// Evita apuestas mayores al balance
if (currentBet > balance) {
  currentBet = balance;
}
```

**Límite de Historial**:
```dart
// Previene uso excesivo de memoria
if (history.length > 20) {
  history = history.sublist(history.length - 20);
}
```

### Consideraciones Firebase

**Nunca Hardcodear Claves**:
```dart
// ❌ MALO
const stripeKey = 'pk_live_xxxxx';

// ✅ BUENO
const stripeKey = String.fromEnvironment('STRIPE_KEY');
```

**Firestore Security Rules**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      // Solo el usuario puede leer/escribir sus datos
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
  }
}
```

## Testing

### Estrategia de Testing

#### Tests Unitarios (`roulette_logic_test.dart`)
Cubren la lógica de negocio sin UI:

**RouletteLogic**:
- ✅ `generateSpin()` retorna 0-36
- ✅ `predictNext()` retorna número válido
- ✅ `predictNext([])` funciona con historial vacío
- ✅ `predictNext()` retorna el más frecuente

**MartingaleAdvisor**:
- ✅ Inicia con valores correctos
- ✅ Duplica apuesta tras perder
- ✅ Vuelve a base tras ganar
- ✅ Duplica en pérdidas consecutivas
- ✅ `reset()` restaura valores
- ✅ Apuesta base personalizada funciona

#### Tests de Widgets (`widget_test.dart`)
Cubren la interfaz y navegación:

- ✅ Navegación Login → Main
- ✅ Botón "Girar Ruleta" funciona
- ✅ Diálogo de configuración abre
- ✅ Reset restaura el juego
- ✅ Disclaimer visible

#### Tests de Integración (Futuro)
Para flujos completos E2E:

```dart
void main() {
  testWidgets('Flujo completo de juego', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Login
    await tester.enterText(find.byType(TextField), 'test@test.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Activar Martingale
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    
    // Jugar múltiples giros
    for (int i = 0; i < 10; i++) {
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();
    }
    
    // Verificar que el balance cambió
    expect(find.textContaining('\$1000.00'), findsNothing);
  });
}
```

### Cobertura de Código

Objetivo: >80% en lógica de negocio

```bash
# Generar reporte de cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Rendimiento

### Optimizaciones Actuales

1. **Historial Limitado**: Máximo 20 elementos previene uso excesivo de memoria
2. **setState Quirúrgico**: Solo actualiza widgets necesarios
3. **Widgets const**: Reducen reconstrucciones innecesarias
4. **SingleChildScrollView**: Permite scroll suave en pantallas pequeñas

### Métricas Objetivo

- **Tiempo de renderizado**: <16ms (60 FPS)
- **Tiempo de giro**: <100ms
- **Uso de memoria**: <50MB
- **Tamaño APK**: <15MB

### Profiling

```bash
# Analizar rendimiento
flutter run --profile
# En DevTools: Performance → Refresh

# Analizar tamaño
flutter build apk --analyze-size
```

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/build-apk.yml
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - Checkout código
      - Setup Java 11
      - Setup Flutter (stable)
      - flutter pub get
      - flutter analyze (no-fatal-infos)
      - flutter test
      - flutter build apk --release
      - Upload artifact (30 días)
```

**Fases**:
1. **Lint**: `flutter analyze`
2. **Test**: `flutter test`
3. **Build**: `flutter build apk --release`
4. **Artifact**: Guarda APK por 30 días

## Despliegue

### Android

#### Debug Build
```bash
flutter run
# Instala en dispositivo conectado o emulador
```

#### Release Build
```bash
flutter build apk --release
# Genera: build/app/outputs/flutter-apk/app-release.apk
```

#### Firmado (Producción)
1. Crear keystore:
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA \
        -keysize 2048 -validity 10000 -alias key
```

2. Configurar `key.properties`:
```properties
storeFile=/path/to/key.jks
storePassword=xxxxx
keyAlias=key
keyPassword=xxxxx
```

3. Build firmado:
```bash
flutter build apk --release
```

### iOS (Futuro)

Requiere:
- Mac con Xcode
- Cuenta de Apple Developer
- Certificados y provisioning profiles

```bash
flutter build ios --release
# Luego abrir en Xcode para archivar y distribuir
```

## Escalabilidad

### Arquitectura para Crecer

Si la app crece, migrar a **Clean Architecture**:

```
lib/
├── core/
│   ├── utils/
│   ├── errors/
│   └── constants/
├── features/
│   ├── roulette/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── auth/
│       └── ...
```

**Ventajas**:
- Separación de responsabilidades clara
- Testeable (inyección de dependencias)
- Escalable a múltiples features
- Mantenible a largo plazo

## Dependencias Futuras

### Pagos (Stripe)
Para modelo freemium:

```dart
import 'package:flutter_stripe/flutter_stripe.dart';

await Stripe.instance.presentPaymentSheet();
```

### Compras In-App
Para contenido premium:

```dart
import 'package:in_app_purchase/in_app_purchase.dart';

final available = await InAppPurchase.instance.isAvailable();
```

### Gráficos Avanzados (fl_chart)
Para estadísticas visuales:

```dart
LineChart(
  LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: history.map((i) => FlSpot(i, balance)).toList(),
      ),
    ],
  ),
);
```

## Troubleshooting

### Problemas Comunes

**Error: "Target of URI doesn't exist"**
- Solución: `flutter pub get`

**Error: "No Firebase App"**
- Solución: Comentar imports de Firebase o ejecutar `flutterfire configure`

**APK no se genera**
- Verificar: Java 11+ instalado
- Verificar: `flutter doctor` sin errores Android

**Tests fallan**
- Ejecutar: `flutter test --update-goldens` si son tests visuales

## Recursos

### Documentación
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart API Reference](https://api.dart.dev/)
- [Material Design](https://material.io/design)

### Herramientas
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)
- [DartPad](https://dartpad.dev/) - Prueba código online
- [FlutterFire](https://firebase.flutter.dev/) - Firebase para Flutter

### Comunidad
- [r/FlutterDev](https://reddit.com/r/FlutterDev)
- [Flutter Community Slack](https://fluttercommunity.dev/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

**Documento**: Arquitectura Técnica v1.0  
**Autor**: Equipo de Desarrollo  
**Fecha**: Diciembre 2024  
**Última revisión**: Diciembre 2025
