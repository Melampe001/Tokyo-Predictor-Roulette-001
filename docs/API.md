# 🔌 API Documentation

Complete API reference for Tokyo Roulette Predicciones services and methods.

## 📋 Table of Contents

- [Overview](#overview)
- [RouletteLogic](#roulettelogic)
- [MartingaleAdvisor](#martingaleadvisor)
- [Future Services](#future-services)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)

## 🎯 Overview

Tokyo Roulette Predicciones currently uses a simple architecture with business logic separated into dedicated classes. All services are synchronous and run locally.

### Current Architecture

```
┌─────────────────┐
│   UI Layer      │  LoginScreen, MainScreen
│   (main.dart)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Business Logic  │  RouletteLogic, MartingaleAdvisor
│ (roulette_      │
│  logic.dart)    │
└─────────────────┘
```

### Future Architecture (Planned)

```
┌─────────────────┐
│   UI Layer      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Service Layer  │  AuthService, AnalyticsService,
│                 │  NotificationService
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Data Layer     │  FirestoreService, StorageService
└─────────────────┘
```

## 🎰 RouletteLogic

Core class for roulette simulation and prediction.

### Class Definition

```dart
class RouletteLogic {
  final Random rng;
  final List<int> wheel;
  final List<int> history;
  
  RouletteLogic();
}
```

### Constructor

#### `RouletteLogic()`

Creates a new roulette logic instance with cryptographically secure random number generation.

**Example:**
```dart
final roulette = RouletteLogic();
```

**Properties:**
- Uses `Random.secure()` for RNG
- Initializes European wheel (0-36)
- Empty history on creation

### Methods

#### `generateSpin()`

Generates a random roulette number.

**Signature:**
```dart
int generateSpin()
```

**Returns:**
- `int`: A number between 0 and 36 (inclusive)

**Example:**
```dart
final roulette = RouletteLogic();
final result = roulette.generateSpin();
print('Spun: $result');  // e.g., "Spun: 17"
```

**Implementation Details:**
- Uses cryptographically secure RNG
- Equal probability for all numbers (1/37)
- Independent from previous spins
- Thread-safe

**Performance:**
- O(1) time complexity
- No memory allocation
- ~1 microsecond execution time

---

#### `addToHistory(int number)`

Adds a spin result to the history.

**Signature:**
```dart
void addToHistory(int number)
```

**Parameters:**
- `number` (int): The spin result to add (0-36)

**Behavior:**
- Adds number to end of history list
- Maintains maximum of 20 items
- Removes oldest when exceeding limit
- No validation (assumes valid input)

**Example:**
```dart
final roulette = RouletteLogic();
final result = roulette.generateSpin();
roulette.addToHistory(result);

print(roulette.history);  // [17]
```

**History Management:**
```dart
// After 20 spins
for (int i = 0; i < 25; i++) {
  roulette.addToHistory(i);
}
print(roulette.history.length);  // 20 (not 25)
```

---

#### `predictNext()`

Predicts the next number based on frequency analysis.

**Signature:**
```dart
int? predictNext()
```

**Returns:**
- `int`: Most frequent number in history
- `null`: If history is empty

**Algorithm:**
1. Count frequency of each number
2. Find maximum frequency
3. Return first number with max frequency
4. Return null if no history

**Example:**
```dart
final roulette = RouletteLogic();

// Empty history
print(roulette.predictNext());  // null

// Add spins
roulette.addToHistory(7);
roulette.addToHistory(7);
roulette.addToHistory(7);
roulette.addToHistory(15);

print(roulette.predictNext());  // 7 (most frequent)
```

**Edge Cases:**
```dart
// Tie in frequencies
roulette.addToHistory(7);
roulette.addToHistory(15);
final prediction = roulette.predictNext();
// Returns either 7 or 15 (whichever appears first in history)
```

**Complexity:**
- Time: O(n) where n = history length (max 20)
- Space: O(n) for frequency map

**⚠️ Important Note:**
This is an educational simulation. The prediction is based on past frequency, which has NO bearing on actual roulette outcomes. Each spin is independent and random.

---

#### `getColor(int number)`

Returns the color of a roulette number.

**Signature:**
```dart
String getColor(int number)
```

**Parameters:**
- `number` (int): Roulette number (0-36)

**Returns:**
- `'green'`: For 0
- `'red'`: For red numbers
- `'black'`: For black numbers

**Red Numbers:** 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36

**Black Numbers:** 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35

**Example:**
```dart
final roulette = RouletteLogic();

print(roulette.getColor(0));   // 'green'
print(roulette.getColor(7));   // 'red'
print(roulette.getColor(8));   // 'black'
print(roulette.getColor(17));  // 'black'
print(roulette.getColor(18));  // 'red'
```

**Use Case:**
```dart
final number = roulette.generateSpin();
final color = roulette.getColor(number);

// Display with appropriate color
Text(
  '$number',
  style: TextStyle(
    color: color == 'red' ? Colors.red :
           color == 'black' ? Colors.black :
           Colors.green,
  ),
);
```

---

### Properties

#### `history`

**Type:** `List<int>`

**Access:** Read-only (getter)

**Description:** List of recent spin results (max 20 items)

**Example:**
```dart
final roulette = RouletteLogic();
roulette.addToHistory(7);
roulette.addToHistory(15);

print(roulette.history);  // [7, 15]
print(roulette.history.length);  // 2
```

#### `wheel`

**Type:** `List<int>`

**Access:** Read-only (getter)

**Description:** European roulette wheel numbers [0, 1, 2, ..., 36]

**Example:**
```dart
final roulette = RouletteLogic();
print(roulette.wheel.length);  // 37
print(roulette.wheel.first);   // 0
print(roulette.wheel.last);    // 36
```

---

## 📊 MartingaleAdvisor

Manages the Martingale betting strategy.

### Class Definition

```dart
class MartingaleAdvisor {
  double baseBet;
  double currentBet;
  
  MartingaleAdvisor({this.baseBet = 10.0});
}
```

### Constructor

#### `MartingaleAdvisor({double baseBet = 10.0})`

Creates a new Martingale advisor with optional base bet.

**Parameters:**
- `baseBet` (double, optional): Starting bet amount (default: 10.0)

**Example:**
```dart
// Default base bet ($10)
final advisor = MartingaleAdvisor();

// Custom base bet ($25)
final advisor = MartingaleAdvisor(baseBet: 25.0);
```

### Methods

#### `afterLoss()`

Updates bet after a loss (doubles current bet).

**Signature:**
```dart
void afterLoss()
```

**Behavior:**
- Doubles `currentBet`
- Typical Martingale progression: 10 → 20 → 40 → 80 → 160...

**Example:**
```dart
final advisor = MartingaleAdvisor(baseBet: 10.0);
print(advisor.currentBet);  // 10.0

advisor.afterLoss();
print(advisor.currentBet);  // 20.0

advisor.afterLoss();
print(advisor.currentBet);  // 40.0
```

**Progressive Doubling:**
```dart
final advisor = MartingaleAdvisor();
final bets = <double>[];

for (int i = 0; i < 5; i++) {
  bets.add(advisor.currentBet);
  advisor.afterLoss();
}

print(bets);  // [10.0, 20.0, 40.0, 80.0, 160.0]
```

---

#### `afterWin()`

Resets bet to base amount after a win.

**Signature:**
```dart
void afterWin()
```

**Behavior:**
- Resets `currentBet` to `baseBet`
- Returns to starting bet

**Example:**
```dart
final advisor = MartingaleAdvisor(baseBet: 10.0);

advisor.afterLoss();
advisor.afterLoss();
print(advisor.currentBet);  // 40.0

advisor.afterWin();
print(advisor.currentBet);  // 10.0 (back to base)
```

**Complete Cycle:**
```dart
final advisor = MartingaleAdvisor();

// Lose 3 times
advisor.afterLoss();  // 20
advisor.afterLoss();  // 40
advisor.afterLoss();  // 80

// Win
advisor.afterWin();   // Back to 10
```

---

#### `reset()`

Resets current bet to base bet.

**Signature:**
```dart
void reset()
```

**Example:**
```dart
final advisor = MartingaleAdvisor(baseBet: 10.0);
advisor.afterLoss();
advisor.afterLoss();
print(advisor.currentBet);  // 40.0

advisor.reset();
print(advisor.currentBet);  // 10.0
```

**Use Case:**
```dart
// Reset when starting new session
void startNewGameSession() {
  martingaleAdvisor.reset();
  balance = 1000.0;
  history.clear();
}
```

---

### Properties

#### `currentBet`

**Type:** `double`

**Access:** Read/Write

**Description:** Current bet amount (changes with wins/losses)

**Example:**
```dart
final advisor = MartingaleAdvisor();
print(advisor.currentBet);  // 10.0

advisor.currentBet = 25.0;
print(advisor.currentBet);  // 25.0
```

#### `baseBet`

**Type:** `double`

**Access:** Read/Write

**Description:** Base (starting) bet amount

**Example:**
```dart
final advisor = MartingaleAdvisor(baseBet: 10.0);
print(advisor.baseBet);  // 10.0

advisor.baseBet = 20.0;
advisor.reset();
print(advisor.currentBet);  // 20.0 (uses new base)
```

---

### Martingale Strategy Guide

**How It Works:**
1. Start with base bet
2. If you lose: double the bet
3. If you win: reset to base bet
4. Goal: Recover all losses plus one unit profit

**Example Sequence:**
```
Bet  | Result | P/L  | Total P/L | Next Bet
-----|--------|------|-----------|----------
$10  | Loss   | -$10 | -$10      | $20
$20  | Loss   | -$20 | -$30      | $40
$40  | Loss   | -$40 | -$70      | $80
$80  | Win    | +$80 | +$10      | $10 (reset)
```

**Implementation:**
```dart
void processSpin(bool won) {
  if (won) {
    balance += advisor.currentBet;
    advisor.afterWin();
  } else {
    balance -= advisor.currentBet;
    advisor.afterLoss();
  }
}
```

**⚠️ Important Warnings:**

1. **Requires large bankroll**
   - Can escalate quickly: 10 → 20 → 40 → 80 → 160 → 320...
   - 7 losses = $1,270 wagered from $10 start

2. **Table limits**
   - Casinos have maximum bet limits
   - Strategy fails when limit reached

3. **Risk of ruin**
   - Losing streaks can bankrupt player
   - Not guaranteed to win

4. **Educational only**
   - This app is a simulation
   - Don't use in real gambling

---

## 🔮 Future Services

These services are planned but not yet implemented.

### AuthService

```dart
abstract class AuthService {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Stream<User?> authStateChanges();
  User? getCurrentUser();
}
```

**Methods:**
- `signInWithEmail`: Authenticate user
- `signUpWithEmail`: Create new account
- `signOut`: Log out current user
- `authStateChanges`: Listen to auth changes
- `getCurrentUser`: Get current user

**Firebase Implementation:**
```dart
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }
  
  // ... other methods
}
```

---

### FirestoreService

```dart
abstract class FirestoreService {
  Future<void> saveUserData(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<void> saveGameHistory(String userId, List<int> history);
  Future<List<int>> getGameHistory(String userId);
}
```

**Methods:**
- `saveUserData`: Store user profile
- `getUserData`: Retrieve user profile
- `saveGameHistory`: Save spin history
- `getGameHistory`: Load spin history

---

### AnalyticsService

```dart
abstract class AnalyticsService {
  Future<void> logEvent(String name, Map<String, dynamic> parameters);
  Future<void> setUserProperty(String name, String value);
  Future<void> logScreenView(String screenName);
}
```

**Methods:**
- `logEvent`: Track events (spin, win, loss)
- `setUserProperty`: Set user attributes
- `logScreenView`: Track screen views

**Example Usage:**
```dart
// Log spin event
analytics.logEvent('roulette_spin', {
  'result': 17,
  'color': 'black',
  'bet_amount': 10.0,
  'martingale_active': true,
});

// Log win
analytics.logEvent('roulette_win', {
  'amount': 20.0,
  'number': 17,
});
```

---

### NotificationService

```dart
abstract class NotificationService {
  Future<void> initialize();
  Future<String?> getToken();
  Future<void> sendNotification(String userId, String title, String body);
  Stream<RemoteMessage> onMessageReceived();
}
```

**Methods:**
- `initialize`: Set up push notifications
- `getToken`: Get device FCM token
- `sendNotification`: Send push notification
- `onMessageReceived`: Listen for notifications

---

### StorageService

```dart
abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
```

**SharedPreferences Implementation:**
```dart
class SharedPrefsStorage implements StorageService {
  final SharedPreferences _prefs;
  
  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  // ... other methods
}
```

---

## ⚠️ Error Handling

### Current Error Handling

Currently, errors are minimal as operations are local and synchronous.

**Input Validation Example:**
```dart
void validateBet(double bet, double balance) {
  if (bet <= 0) {
    throw ArgumentError('Bet must be positive');
  }
  if (bet > balance) {
    throw ArgumentError('Insufficient balance');
  }
}
```

### Future Error Handling

**Custom Exceptions:**
```dart
class InsufficientBalanceException implements Exception {
  final double required;
  final double available;
  
  InsufficientBalanceException(this.required, this.available);
  
  @override
  String toString() =>
      'Insufficient balance: need \$$required, have \$$available';
}

class InvalidBetException implements Exception {
  final String message;
  InvalidBetException(this.message);
  
  @override
  String toString() => 'Invalid bet: $message';
}
```

**Service Errors:**
```dart
abstract class ServiceException implements Exception {
  final String message;
  final String? code;
  
  ServiceException(this.message, {this.code});
}

class NetworkException extends ServiceException {
  NetworkException(String message) : super(message, code: 'network_error');
}

class AuthException extends ServiceException {
  AuthException(String message) : super(message, code: 'auth_error');
}

class DataException extends ServiceException {
  DataException(String message) : super(message, code: 'data_error');
}
```

**Error Handling Pattern:**
```dart
Future<void> performAction() async {
  try {
    await riskyOperation();
  } on NetworkException catch (e) {
    showError('Network error: ${e.message}');
  } on AuthException catch (e) {
    showError('Authentication error: ${e.message}');
    navigateToLogin();
  } catch (e) {
    debugPrint('Unexpected error: $e');
    showError('An unexpected error occurred');
  }
}
```

---

## 📚 Best Practices

### 1. Always Validate Inputs

```dart
// ✅ Good
void placeBet(double amount) {
  if (amount <= 0) {
    throw ArgumentError('Bet must be positive');
  }
  if (amount > balance) {
    throw InsufficientBalanceException(amount, balance);
  }
  // Process bet
}

// ❌ Bad
void placeBet(double amount) {
  balance -= amount;  // No validation!
}
```

### 2. Handle Async Errors

```dart
// ✅ Good
Future<void> saveData() async {
  try {
    await service.save(data);
  } catch (e) {
    debugPrint('Save failed: $e');
    throw DataException('Failed to save data');
  }
}

// ❌ Bad
Future<void> saveData() async {
  await service.save(data);  // Unhandled errors!
}
```

### 3. Use Type-Safe APIs

```dart
// ✅ Good
int generateSpin();  // Returns int, never null

// ❌ Bad
dynamic generateSpin();  // What does it return?
```

### 4. Document Complex Logic

```dart
/// Predicts next number based on frequency analysis.
///
/// Returns the most frequent number from recent history.
/// Returns null if history is empty.
///
/// **Note**: This is purely educational. Past spins do not
/// influence future outcomes in real roulette.
int? predictNext() {
  // Implementation
}
```

### 5. Keep Services Focused

```dart
// ✅ Good: Single responsibility
class RouletteLogic {
  int generateSpin();
  int? predictNext();
}

class MartingaleAdvisor {
  void afterLoss();
  void afterWin();
}

// ❌ Bad: Too many responsibilities
class GameManager {
  int spin();
  int? predict();
  void manageBets();
  void saveToDatabase();
  void sendAnalytics();
  void showNotification();
}
```

---

## 📖 Related Documentation

- [Architecture](ARCHITECTURE.md) - System design and patterns
- [Development](DEVELOPMENT.md) - Day-to-day development
- [Testing](TESTING.md) - How to test services
- [Examples](EXAMPLES.md) - Code examples

---

**Last Updated:** December 2024
