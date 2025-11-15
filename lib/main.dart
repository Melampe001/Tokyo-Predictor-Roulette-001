import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';  // Genera con flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = 'tu_publishable_key_de_stripe';  // Reemplaza con tu clave
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo Roulette Predicciones',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')), 
            ElevatedButton(
              onPressed: () {
                // Lógica de registro/Auth aquí
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MainScreen()));
              },
              child: const Text('Registrar y Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String result = 'Presiona Girar';
  List<int> history = [];
  double bet = 10.0;
  final Random _rng = Random.secure();
  static const int _maxHistorySize = 100; // Limit history to prevent memory issues

  void spinRoulette() {
    // Use secure RNG instead of timestamp-based modulo
    int res = _rng.nextInt(37);
    setState(() {
      result = res.toString();
      history.add(res);
      // Prevent unbounded list growth by limiting history size
      if (history.length > _maxHistorySize) {
        history.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show last 20 items in UI to avoid performance issues with long strings
    final displayHistory = history.length > 20 
        ? history.sublist(history.length - 20) 
        : history;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Resultado: $result'),
            Text('Historia (últimos ${displayHistory.length}): ${displayHistory.join(', ')}'),
            ElevatedButton(onPressed: spinRoulette, child: const Text('Girar Ruleta')),
            // Agrega más widgets para Martingale, predicciones, etc.
          ],
        ),
      ),
    );
  }
}