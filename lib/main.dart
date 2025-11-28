import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'roulette_logic.dart';
// TODO: Genera firebase_options.dart con: flutterfire configure
// import 'firebase_options.dart';

/// TokyoApps® - Simulación inteligente para entretenimiento
/// App branding constants
const String kAppBrand = String.fromEnvironment('APP_BRAND', defaultValue: 'TokyoApps®');
const String kAppSlogan = String.fromEnvironment('APP_SLOGAN', defaultValue: 'Simulación inteligente para entretenimiento');
const String kAppName = 'Tokyo Roulette';
const String kAppVersion = '1.0.0';

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
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1E88E5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          secondary: const Color(0xFFFF5722),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen con branding TokyoApps®
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.casino,
                size: 64,
                color: Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              kAppName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Brand
            const Text(
              kAppBrand,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            // Slogan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                kAppSlogan,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.white60,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
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
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
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
      appBar: AppBar(
        title: const Text('Ruleta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resultado: $result',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Historia: ${history.join(', ')}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: spinRoulette,
              icon: const Icon(Icons.casino),
              label: const Text('Girar Ruleta'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            // TODO: Agregar más widgets para Martingale, predicciones, etc.
          ],
        ),
      ),
    );
  }
}

/// About Screen con branding y disclaimer
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.casino,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // App Name
            const Text(
              kAppName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Version
            Text(
              'Versión $kAppVersion',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            // Brand
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                kAppBrand,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E88E5),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Slogan
            Text(
              kAppSlogan,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 32),
            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Disclaimer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Esta aplicación es estrictamente para entretenimiento y '
                    'educación sobre probabilidades. Tokyo Roulette es una simulación '
                    'y los resultados son completamente aleatorios.\n\n'
                    'No promueve ni facilita apuestas reales. Los resultados no pueden '
                    'usarse para predecir resultados en casinos reales.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Features
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Características',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    FeatureItem(icon: Icons.shuffle, text: 'RNG Seguro certificado'),
                    FeatureItem(icon: Icons.analytics, text: 'Predicciones estadísticas'),
                    FeatureItem(icon: Icons.trending_up, text: 'Estrategia Martingale'),
                    FeatureItem(icon: Icons.history, text: 'Historial completo'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Copyright
            Text(
              '© ${DateTime.now().year} $kAppBrand',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            Text(
              'Todos los derechos reservados',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for feature items in About screen
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1E88E5)),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}