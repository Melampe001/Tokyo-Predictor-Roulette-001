import 'package:flutter/material.dart';
// Configuration Notes:
// 1. Firebase: Generate firebase_options.dart with: flutterfire configure
//    Then uncomment the imports and initialization below
// 2. Stripe: Set STRIPE_PUBLISHABLE_KEY environment variable
//    Then uncomment the Stripe configuration below
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'firebase_options.dart';
import 'roulette_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization (uncomment when firebase_options.dart is configured)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Stripe configuration (uncomment when environment variable is set)
  // SECURITY NOTE: Never hardcode API keys. Use environment variables.
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
                // Implementación de registro/Auth con validación básica
                final email = _emailController.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingresa un email válido'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // Simulación de registro exitoso
                // En producción, aquí iría: FirebaseAuth.instance.signInWithEmailAndPassword()
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bienvenido $email'),
                    backgroundColor: Colors.green,
                  ),
                );
                
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
  final MartingaleAdvisor _martingaleAdvisor = MartingaleAdvisor();
  String result = 'Presiona Girar';
  List<int> history = [];
  double bet = 10.0;
  double balance = 1000.0;
  int? prediction;
  String strategyMessage = 'Inicia girando la ruleta';

  void spinRoulette() {
    // Usa RouletteLogic con RNG seguro
    final res = _rouletteLogic.generateSpin();
    
    // Generar predicción antes del siguiente giro
    final nextPrediction = _rouletteLogic.predictNext(history);
    
    // Actualizar estrategia Martingale
    final won = res % 2 == 0; // Simulación simple: par gana
    final nextBet = _martingaleAdvisor.getNextBet(won);
    
    // Actualizar balance
    final double newBalance = won ? balance + bet : balance - bet;
    
    setState(() {
      result = res.toString();
      history.add(res);
      prediction = nextPrediction;
      balance = newBalance;
      bet = nextBet;
      strategyMessage = won 
          ? '¡Ganaste! Apuesta vuelve a base: \$${nextBet.toStringAsFixed(2)}'
          : 'Perdiste. Duplicando apuesta: \$${nextBet.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Balance card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: balance >= 1000 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Result card
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Resultado',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Prediction card
            if (prediction != null)
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Predicción para el próximo giro',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prediction.toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Basado en historial)',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            
            // Martingale strategy card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Estrategia Martingale',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Apuesta actual: \$${bet.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strategyMessage,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Spin button
            ElevatedButton(
              onPressed: balance >= bet ? spinRoulette : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Girar Ruleta'),
            ),
            if (balance < bet)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Balance insuficiente para apostar',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            
            // History card
            if (history.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Historial',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: history.reversed.take(10).map((num) {
                          return Chip(
                            label: Text(num.toString()),
                            backgroundColor: num == 0
                                ? Colors.green
                                : num % 2 == 0
                                    ? Colors.red[200]
                                    : Colors.black87,
                            labelStyle: TextStyle(
                              color: num == 0 || num % 2 == 0
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                      if (history.length > 10)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '... y ${history.length - 10} más',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            
            // Reset button
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  result = 'Presiona Girar';
                  history = [];
                  balance = 1000.0;
                  bet = 10.0;
                  prediction = null;
                  strategyMessage = 'Inicia girando la ruleta';
                  _martingaleAdvisor.reset();
                });
              },
              child: const Text('Reiniciar Juego'),
            ),
            
            const SizedBox(height: 16),
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '⚠️ ADVERTENCIA: Esta es una simulación educativa.\n'
                  'La estrategia Martingale tiene riesgos significativos.\n'
                  'No usar con dinero real.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}