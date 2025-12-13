import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Note: Firebase and Stripe initialization would go here with proper config
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Stripe.publishableKey = 'your_publishable_key';
  runApp(const TokyoRouletteApp());
}

class TokyoRouletteApp extends StatelessWidget {
  const TokyoRouletteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo Roulette Predicciones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese un email válido')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tokyo Roulette Predicciones')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.casino, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simulador de predicciones para ruleta',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrar y Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Constants for business logic
  static const int _historyLimit = 10;
  static const int _predictionWindow = 5;
  
  final Random _random = Random();
  int? _lastNumber;
  List<int> _history = [];
  bool _isSpinning = false;
  String _userTier = 'Básica';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userTier = prefs.getString('user_tier') ?? 'Básica';
    });
  }

  Future<void> _spinRoulette() async {
    setState(() => _isSpinning = true);

    await Future.delayed(const Duration(seconds: 2));

    final number = _random.nextInt(37); // 0-36
    setState(() {
      _lastNumber = number;
      _history.insert(0, number);
      if (_history.length > _historyLimit) {
        _history = _history.sublist(0, _historyLimit);
      }
      _isSpinning = false;
    });
  }

  int? _getPrediction() {
    if (_userTier == 'Básica') {
      return null; // Free tier doesn't get predictions
    }
    
    if (_history.isEmpty) {
      return _random.nextInt(37);
    }

    // Simple prediction based on history (for demo purposes)
    if (_userTier == 'Avanzada' || _userTier == 'Premium') {
      // Martingale-inspired prediction
      final recentHistory = _history.take(_predictionWindow).toList();
      if (recentHistory.isEmpty) return _random.nextInt(37);
      final sum = recentHistory.reduce((a, b) => a + b);
      return (sum ~/ recentHistory.length) % 37;
    }
    
    return null;
  }

  Color _getNumberColor(int number) {
    if (number == 0) return Colors.green;
    const redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
    return redNumbers.contains(number) ? Colors.red : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final prediction = _getPrediction();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Roulette'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManualScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User tier card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan: $_userTier',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_userTier == 'Básica')
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UpgradeScreen(),
                                  ),
                                );
                              },
                              child: const Text('Actualizar Plan'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Roulette result
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: _isSpinning
                    ? const CircularProgressIndicator()
                    : _lastNumber != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getNumberColor(_lastNumber!),
                                ),
                                child: Center(
                                  child: Text(
                                    '$_lastNumber',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Presiona\nGirar',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
              ),
            ),
            const SizedBox(height: 24),

            // Prediction section
            if (prediction != null)
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.lightbulb, size: 40, color: Colors.amber),
                      const SizedBox(height: 8),
                      const Text(
                        'Predicción',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Número sugerido: $prediction',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            if (_userTier == 'Básica')
              Card(
                color: Colors.orange.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '🔒 Las predicciones están disponibles en los planes Avanzada y Premium',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Spin button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isSpinning ? null : _spinRoulette,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Girar Ruleta',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // History
            if (_history.isNotEmpty) ...[
              const Text(
                'Historial',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _history.map((num) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getNumberColor(num),
                    ),
                    child: Center(
                      child: Text(
                        '$num',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPlanCard(
            context,
            'Avanzada',
            '\$199 MXN',
            [
              'Predicciones básicas',
              'Historial de 50 giros',
              'Estadísticas simples',
            ],
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            'Premium',
            '\$299 MXN',
            [
              'Predicciones avanzadas',
              'Historial ilimitado',
              'Estadísticas completas',
              'Análisis con IA',
              'Soporte prioritario',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    String name,
    String price,
    List<String> features,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const Divider(height: 24),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Simulated purchase
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user_tier', name);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Plan $name activado!')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: const Text('Español'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Plataforma'),
            subtitle: const Text('Android'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Enviar comentarios'),
            onTap: () {
              // In production, this would use url_launcher
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función disponible próximamente')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ManualScreen extends StatelessWidget {
  const ManualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual de Usuario')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Bienvenido a Tokyo Roulette Predicciones',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Cómo funciona:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '1. Presiona "Girar Ruleta" para simular un giro\n'
            '2. Los números aparecerán en el círculo central\n'
            '3. El historial muestra tus últimos 10 giros\n'
            '4. Con planes premium, recibes predicciones\n',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Planes disponibles:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '• Básica (Gratis): Simulación de ruleta básica\n'
            '• Avanzada (\$199): Predicciones y estadísticas\n'
            '• Premium (\$299): Predicciones IA y soporte\n',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Nota importante:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Esta es una aplicación de simulación educativa. '
            'No promueve apuestas reales ni garantiza resultados. '
            'Use responsablemente.',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
