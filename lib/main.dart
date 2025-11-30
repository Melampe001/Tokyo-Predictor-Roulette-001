import 'package:flutter/material.dart';
// TODO: Uncomment when Firebase is properly configured
// import 'package:firebase_core/firebase_core.dart';
// TODO: Uncomment when Stripe is properly configured
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'roulette_logic.dart';
// TODO: Genera firebase_options.dart con: flutterfire configure
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Descomentar cuando firebase_options.dart esté configurado
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // SEGURIDAD: NO hardcodear claves. Usar variables de entorno o configuración segura
  // TODO: Configurar Stripe key desde variables de entorno
  // const stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
  // if (stripeKey.isNotEmpty) {
  //   Stripe.publishableKey = stripeKey;
  // }
  
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implementar lógica de registro/Auth aquí
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
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
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RouletteLogic _rouletteLogic = RouletteLogic();
  String result = 'Presiona Girar';
  List<int> history = [];
  double bet = 10.0;

  void spinRoulette() {
    // Usa RouletteLogic con RNG seguro
    final res = _rouletteLogic.generateSpin();
    setState(() {
      result = res.toString();
      history.add(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Resultado: $result'),
            Text('Historia: ${history.join(', ')}'),
            ElevatedButton(
              onPressed: spinRoulette,
              child: const Text('Girar Ruleta'),
            ),
            // TODO: Agregar más widgets para Martingale, predicciones, etc.
          ],
        ),
      ),
    );
  }
}