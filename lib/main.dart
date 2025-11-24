import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';

/// Aplicación educativa de simulación de sistemas RNG y análisis estadístico.
/// PROPÓSITO EXCLUSIVAMENTE EDUCATIVO - No para uso en gambling real.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = 'tu_publishable_key_de_stripe';  // Para acceso a funciones premium educativas (no apuestas)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo Roulette - Simulador Educativo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')), 
            ElevatedButton(
              onPressed: () {
                // Lógica de registro/Auth aquí
                Navigator.push(context, MaterialPageRoute(builder: (_) => MainScreen()));
              },
              child: Text('Registrar y Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String result = 'Presiona Girar';
  List<int> history = [];
  double simulationCredits = 10.0;  // Créditos virtuales sin valor monetario

  void spinRoulette() {
    // Generador de números pseudo-aleatorios para fines educativos
    // En producción, usar RouletteLogic con Random.secure()
    int res = (0 + (37 * (DateTime.now().millisecondsSinceEpoch % 37))).toInt();
    setState(() {
      result = res.toString();
      history.add(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulador de Ruleta')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Resultado: $result'),
            Text('Historia: ${history.join(', ')}'),
            ElevatedButton(onPressed: spinRoulette, child: Text('Girar Ruleta')),
            // Agrega más widgets para análisis estadístico, predicciones, etc.
          ],
        ),
      ),
    );
  }
}