# Documentación de API - Tokyo Roulette Predicciones

Esta documentación describe las clases, métodos y servicios principales del proyecto.

## Tabla de contenidos

- [RouletteLogic](#roulettelogic)
- [MartingaleAdvisor](#martingaleadvisor)
- [Screens](#screens)
- [Services (Futuros)](#services)

---

## RouletteLogic

Clase que maneja la lógica principal de la ruleta europea.

### Constructor

```dart
RouletteLogic()
```

Crea una instancia de la lógica de ruleta con un generador de números aleatorios seguro.

### Propiedades

#### `wheel`
```dart
final List<int> wheel
```
Lista de números de la ruleta europea (0-36). Total: 37 números.

#### `rng`
```dart
final Random rng
```
Generador de números aleatorios seguro (`Random.secure()`).

### Métodos

#### `generateSpin()`
```dart
int generateSpin()
```

Genera un número aleatorio de la ruleta usando RNG seguro.

**Retorna:** Un entero entre 0 y 36 (inclusive).

**Ejemplo:**
```dart
final roulette = RouletteLogic();
final result = roulette.generateSpin(); // ej: 23
```

#### `predictNext()`
```dart
int predictNext(List<int> history)
```

Predice el siguiente número basado en el historial de giros.

**Parámetros:**
- `history` - Lista de números previos

**Retorna:** Número predicho (0-36)

**Algoritmo:** Retorna el número más frecuente en el historial. Si el historial está vacío, retorna un número aleatorio.

**Nota educativa:** En ruletas reales, cada giro es independiente y no se puede predecir. Esta función es solo ilustrativa.

**Ejemplo:**
```dart
final history = [5, 10, 5, 20, 5];
final prediction = roulette.predictNext(history); // Retorna 5 (más frecuente)
```

---

## MartingaleAdvisor

Asesor de estrategia Martingale para apuestas.

⚠️ **ADVERTENCIA**: Esta es una simulación educativa. La estrategia Martingale tiene riesgos significativos en juegos reales.

### Constructor

```dart
MartingaleAdvisor()
```

Crea una instancia del asesor con valores predeterminados.

### Propiedades

#### `baseBet`
```dart
double baseBet
```
Apuesta base (inicial). Por defecto: 1.0

#### `currentBet`
```dart
double currentBet
```
Apuesta actual calculada. Por defecto: 1.0

#### `lastWin`
```dart
bool lastWin
```
Indica si la última jugada fue ganadora. Por defecto: true

### Métodos

#### `getNextBet()`
```dart
double getNextBet(bool win)
```

Calcula la siguiente apuesta basada en el resultado de la jugada anterior.

**Parámetros:**
- `win` - true si se ganó la última jugada, false si se perdió

**Retorna:** Monto de la siguiente apuesta

**Lógica:**
- Si se ganó: Vuelve a `baseBet`
- Si se perdió: Duplica `currentBet`

**Ejemplo:**
```dart
final advisor = MartingaleAdvisor();
advisor.baseBet = 10.0;

print(advisor.getNextBet(false)); // 20.0 (perdió, duplica)
print(advisor.getNextBet(false)); // 40.0 (perdió, duplica)
print(advisor.getNextBet(true));  // 10.0 (ganó, vuelve a base)
```

#### `reset()`
```dart
void reset()
```

Reinicia el asesor a valores iniciales.

**Ejemplo:**
```dart
advisor.reset();
// currentBet = baseBet
// lastWin = true
```

---

## Screens

### LoginScreen

Pantalla de inicio de sesión/registro.

**Ruta:** `lib/main.dart`

**Características:**
- Validación de email
- Formulario con feedback visual
- Navegación a MainScreen
- Estado de carga

**Widgets principales:**
- `TextFormField` para email
- `ElevatedButton` para enviar
- Validación con RegExp

### MainScreen

Pantalla principal del juego.

**Ruta:** `lib/main.dart`

**Características:**
- Visualización de balance y estadísticas
- Botón para girar ruleta
- Sistema de predicciones
- Integración con MartingaleAdvisor
- Historial de giros (últimos 20)
- Botón de reinicio

**Estado gestionado:**
```dart
{
  result: String,           // Resultado del último giro
  history: List<int>,       // Historial de giros
  currentBet: double,       // Apuesta actual
  predictedNumber: int?,    // Predicción para próximo giro
  lastWin: bool,           // ¿Última jugada ganada?
  balance: double,         // Balance del jugador
  totalSpins: int,         // Total de giros
  wins: int,               // Total de victorias
  losses: int,             // Total de pérdidas
}
```

**Métodos principales:**

#### `spinRoulette()`
```dart
void spinRoulette()
```
Ejecuta un giro de la ruleta, actualiza estadísticas y balance.

#### `resetGame()`
```dart
void resetGame()
```
Reinicia el juego a valores iniciales.

---

## Services

### PaymentService (Futuro)

Servicio para manejar pagos con Stripe.

**Ubicación propuesta:** `lib/services/payment_service.dart`

**Método principal:**
```dart
Future<bool> purchasePremium()
```

Procesa la compra de acceso premium.

**Flujo:**
1. Crear Payment Intent en backend (Firebase Function)
2. Inicializar Payment Sheet de Stripe
3. Presentar UI de pago
4. Confirmar pago
5. Actualizar estado premium del usuario

**Ejemplo de uso:**
```dart
final paymentService = PaymentService();
final success = await paymentService.purchasePremium();

if (success) {
  print('Compra exitosa');
}
```

### AuthService (Futuro)

Servicio para autenticación con Firebase.

**Ubicación propuesta:** `lib/services/auth_service.dart`

**Métodos propuestos:**
```dart
Future<UserCredential> signInWithEmail(String email, String password)
Future<UserCredential> signUpWithEmail(String email, String password)
Future<void> signOut()
Future<User?> getCurrentUser()
```

### FirestoreService (Futuro)

Servicio para interactuar con Firestore.

**Ubicación propuesta:** `lib/services/firestore_service.dart`

**Métodos propuestos:**
```dart
Future<void> saveUserData(String userId, Map<String, dynamic> data)
Future<Map<String, dynamic>?> getUserData(String userId)
Future<void> saveGameStats(String userId, Map<String, dynamic> stats)
Future<List<int>> getGameHistory(String userId)
```

---

## Modelos de datos

### User (Futuro)

```dart
class User {
  final String id;
  final String email;
  final bool isPremium;
  final DateTime createdAt;
  final int totalSpins;
  final double totalWinnings;
  
  User({
    required this.id,
    required this.email,
    this.isPremium = false,
    required this.createdAt,
    this.totalSpins = 0,
    this.totalWinnings = 0.0,
  });
  
  Map<String, dynamic> toJson() { /* ... */ }
  factory User.fromJson(Map<String, dynamic> json) { /* ... */ }
}
```

### GameSession (Futuro)

```dart
class GameSession {
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<int> history;
  final double initialBalance;
  final double finalBalance;
  final int totalSpins;
  final int wins;
  final int losses;
  
  GameSession({
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.history,
    required this.initialBalance,
    required this.finalBalance,
    required this.totalSpins,
    required this.wins,
    required this.losses,
  });
  
  Map<String, dynamic> toJson() { /* ... */ }
  factory GameSession.fromJson(Map<String, dynamic> json) { /* ... */ }
}
```

---

## Constantes

### Game Constants

```dart
// lib/config/constants.dart
class GameConstants {
  static const double initialBalance = 1000.0;
  static const double defaultBaseBet = 10.0;
  static const int maxHistoryLength = 20;
  static const int minSpinsForPrediction = 3;
  static const int rouletteWheelSize = 37; // 0-36
  static const int payoutMultiplier = 35; // 35:1 para número único
}
```

### Premium Features

```dart
class PremiumConfig {
  static const double premiumPrice = 4.99;
  static const String currency = 'USD';
  static const int freeSpinsPerDay = 10;
  static const bool unlimitedSpinsForPremium = true;
}
```

---

## Testing

### Cobertura de pruebas

El proyecto incluye pruebas para:

- ✅ `RouletteLogic.generateSpin()`
- ✅ `RouletteLogic.predictNext()`
- ✅ `MartingaleAdvisor.getNextBet()`
- ✅ `MartingaleAdvisor.reset()`
- ✅ Widgets de LoginScreen
- ✅ Widgets de MainScreen
- ✅ Flujo de navegación
- ✅ Validación de formularios

### Ejecutar pruebas

```bash
# Todas las pruebas
flutter test

# Pruebas con cobertura
flutter test --coverage

# Prueba específica
flutter test test/roulette_logic_test.dart
```

---

## Configuración

### Variables de entorno

```bash
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxx
FIREBASE_API_KEY=AIzaxxxxx
```

### Compilar con variables

```bash
flutter build apk --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxxxx
```

---

## Recursos adicionales

- [Firebase Setup Guide](./FIREBASE_SETUP.md)
- [Stripe Setup Guide](./STRIPE_SETUP.md)
- [README principal](../README.md)

---

## Contribuir

Para contribuir al proyecto, por favor sigue las guías en [PULL_REQUEST_TEMPLATE.md](../.github/PULL_REQUEST_TEMPLATE.md).

## Licencia

Este proyecto es un simulador educativo. No promueve el juego real.
