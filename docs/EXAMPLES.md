# 💡 Code Examples and Tutorials

Practical code examples and step-by-step tutorials for common tasks in Tokyo Roulette Predicciones.

## 📋 Table of Contents

- [Common Code Patterns](#common-code-patterns)
- [How to Add a New Screen](#how-to-add-a-new-screen)
- [How to Create a Custom Widget](#how-to-create-a-custom-widget)
- [How to Add Firebase Integration](#how-to-add-firebase-integration)
- [How to Implement a New Feature](#how-to-implement-a-new-feature)
- [State Management Examples](#state-management-examples)
- [Navigation Examples](#navigation-examples)
- [API Integration Examples](#api-integration-examples)

## 🎨 Common Code Patterns

### 1. StatefulWidget Pattern

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // State variables
  int _counter = 0;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load data here
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading data: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### 2. Form Validation Pattern

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process data
      final email = _emailController.text;
      final password = _passwordController.text;
      
      // TODO: Submit to backend
      debugPrint('Email: $email, Password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'example@email.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

### 3. List with Pull-to-Refresh

```dart
class RefreshableList extends StatefulWidget {
  const RefreshableList({super.key});

  @override
  State<RefreshableList> createState() => _RefreshableListState();
}

class _RefreshableListState extends State<RefreshableList> {
  List<int> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _items = List.generate(20, (i) => i);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadItems,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${_items[index]}')),
            title: Text('Item ${_items[index]}'),
            onTap: () {
              debugPrint('Tapped item ${_items[index]}');
            },
          );
        },
      ),
    );
  }
}
```

## 📱 How to Add a New Screen

### Step 1: Create Screen File

Create `lib/screens/statistics_screen.dart`:

```dart
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh statistics
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(
              title: 'Total Spins',
              value: '150',
              icon: Icons.casino,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              title: 'Win Rate',
              value: '48.5%',
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              title: 'Total Wagered',
              value: '\$1,500',
              icon: Icons.attach_money,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 2: Add Navigation

In your main screen or menu:

```dart
// Navigate to statistics
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const StatisticsScreen(),
  ),
);

// Or with named routes (recommended)
// 1. Define route in MaterialApp
MaterialApp(
  routes: {
    '/': (context) => const MainScreen(),
    '/statistics': (context) => const StatisticsScreen(),
  },
);

// 2. Navigate using route name
Navigator.pushNamed(context, '/statistics');
```

### Step 3: Pass Data to Screen

```dart
// Screen with parameters
class DetailScreen extends StatelessWidget {
  final int itemId;
  final String itemName;

  const DetailScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(itemName)),
      body: Center(child: Text('Item ID: $itemId')),
    );
  }
}

// Navigate with data
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      itemId: 123,
      itemName: 'My Item',
    ),
  ),
);
```

### Step 4: Return Data from Screen

```dart
// Screen that returns data
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Option 1'),
            onTap: () => Navigator.pop(context, 'option1'),
          ),
          ListTile(
            title: const Text('Option 2'),
            onTap: () => Navigator.pop(context, 'option2'),
          ),
        ],
      ),
    );
  }
}

// Navigate and wait for result
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SelectionScreen()),
);

if (result != null) {
  debugPrint('Selected: $result');
}
```

### Step 5: Add Tests

Create `test/screens/statistics_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/screens/statistics_screen.dart';

void main() {
  testWidgets('StatisticsScreen displays stats', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: StatisticsScreen()),
    );

    expect(find.text('Estadísticas'), findsOneWidget);
    expect(find.text('Total Spins'), findsOneWidget);
    expect(find.text('Win Rate'), findsOneWidget);
  });

  testWidgets('StatisticsScreen has refresh button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: StatisticsScreen()),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
```

## 🎨 How to Create a Custom Widget

### Reusable Button Widget

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
    );
  }
}

// Usage
CustomButton(
  text: 'Girar',
  icon: Icons.casino,
  onPressed: () => _spinRoulette(),
  isLoading: _isSpinning,
)
```

### Animated Card Widget

```dart
class AnimatedResultCard extends StatefulWidget {
  final int number;
  final String color;

  const AnimatedResultCard({
    super.key,
    required this.number,
    required this.color,
  });

  @override
  State<AnimatedResultCard> createState() => _AnimatedResultCardState();
}

class _AnimatedResultCardState extends State<AnimatedResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.color) {
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 8,
        shape: const CircleBorder(),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getColor(),
          ),
          child: Center(
            child: Text(
              '${widget.number}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Usage
AnimatedResultCard(
  number: 17,
  color: 'black',
)
```

### Custom Painter Example

```dart
class RouletteWheelPainter extends CustomPainter {
  final int highlightNumber;

  RouletteWheelPainter({required this.highlightNumber});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw wheel background
    final wheelPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, wheelPaint);

    // Draw segments
    final numbers = List.generate(37, (i) => i);
    final segmentAngle = (2 * 3.14159) / 37;

    for (int i = 0; i < numbers.length; i++) {
      final isHighlighted = numbers[i] == highlightNumber;
      final segmentPaint = Paint()
        ..color = isHighlighted ? Colors.yellow : _getNumberColor(numbers[i])
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segmentAngle,
        segmentAngle,
        true,
        segmentPaint,
      );
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, centerPaint);
  }

  Color _getNumberColor(int number) {
    if (number == 0) return Colors.green;
    final redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
    return redNumbers.contains(number) ? Colors.red : Colors.black;
  }

  @override
  bool shouldRepaint(RouletteWheelPainter oldDelegate) {
    return highlightNumber != oldDelegate.highlightNumber;
  }
}

// Usage
CustomPaint(
  size: const Size(300, 300),
  painter: RouletteWheelPainter(highlightNumber: 17),
)
```

## 🔥 How to Add Firebase Integration

### Step 1: Install Dependencies

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.15.3
```

### Step 2: Configure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

### Step 3: Initialize Firebase

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### Step 4: Create Auth Service

```dart
// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
```

### Step 5: Create Firestore Service

```dart
// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user data
  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  // Save game history
  Future<void> saveGameHistory(String userId, List<int> history) async {
    await _db.collection('users').doc(userId).update({
      'game_history': history,
      'last_played': FieldValue.serverTimestamp(),
    });
  }

  // Get game history
  Future<List<int>> getGameHistory(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    final data = doc.data();
    
    if (data != null && data['game_history'] != null) {
      return List<int>.from(data['game_history']);
    }
    
    return [];
  }

  // Listen to user data changes
  Stream<Map<String, dynamic>?> userDataStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      return snapshot.exists ? snapshot.data() : null;
    });
  }
}
```

### Step 6: Use in UI

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return _buildMainContent(snapshot.data!);
        }

        return const LoginScreen();
      },
    );
  }

  Widget _buildMainContent(User user) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _firestoreService.userDataStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userData = snapshot.data ?? {};
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome, ${user.email}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _authService.signOut(),
              ),
            ],
          ),
          body: Center(
            child: Text('Balance: \$${userData['balance'] ?? 0}'),
          ),
        );
      },
    );
  }
}
```

For more Firebase examples, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

## 🔄 State Management Examples

### Using Provider (Recommended)

```dart
// 1. Add dependency
// pubspec.yaml
dependencies:
  provider: ^6.1.0

// 2. Create state class
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  double _balance = 1000.0;
  List<int> _history = [];
  int? _currentNumber;

  double get balance => _balance;
  List<int> get history => List.unmodifiable(_history);
  int? get currentNumber => _currentNumber;

  void spin(int number) {
    _currentNumber = number;
    _history.add(number);
    if (_history.length > 20) {
      _history.removeAt(0);
    }
    notifyListeners();
  }

  void updateBalance(double amount) {
    _balance += amount;
    notifyListeners();
  }

  void reset() {
    _balance = 1000.0;
    _history.clear();
    _currentNumber = null;
    notifyListeners();
  }
}

// 3. Provide at app level
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: const MyApp(),
    ),
  );
}

// 4. Consume in widgets
class BalanceDisplay extends StatelessWidget {
  const BalanceDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<GameState>().balance;
    
    return Text(
      'Balance: \$${balance.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 24),
    );
  }
}

// 5. Update state
class SpinButton extends StatelessWidget {
  const SpinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final gameState = context.read<GameState>();
        final roulette = RouletteLogic();
        final number = roulette.generateSpin();
        
        gameState.spin(number);
        gameState.updateBalance(-10); // Bet amount
      },
      child: const Text('Girar'),
    );
  }
}
```

## 🧭 Navigation Examples

### Named Routes

```dart
// Define routes
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const LoginScreen(),
    '/main': (context) => const MainScreen(),
    '/statistics': (context) => const StatisticsScreen(),
    '/settings': (context) => const SettingsScreen(),
  },
);

// Navigate
Navigator.pushNamed(context, '/statistics');

// Navigate and replace
Navigator.pushReplacementNamed(context, '/main');

// Navigate and clear stack
Navigator.pushNamedAndRemoveUntil(
  context,
  '/main',
  (route) => false,
);

// Pop to specific route
Navigator.popUntil(context, ModalRoute.withName('/main'));
```

### Bottom Navigation

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const StatsTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
```

### Drawer Navigation

```dart
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tokyo Roulette')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.casino, size: 30),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tokyo Roulette',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to home
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/statistics');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Main Content')),
    );
  }
}
```

## 📚 Related Documentation

- [Architecture](ARCHITECTURE.md) - System design
- [Development](DEVELOPMENT.md) - Development guide
- [Testing](TESTING.md) - Testing examples
- [API](API.md) - API reference

---

**Last Updated:** December 2024
