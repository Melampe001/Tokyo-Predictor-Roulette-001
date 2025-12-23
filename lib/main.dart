import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'roulette_logic.dart';
import 'services/auth_service.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';
import 'services/remote_config_service.dart';
import 'services/notification_service.dart';
// TODO: Genera firebase_options.dart con: flutterfire configure
// import 'firebase_options.dart';

// Servicios de Firebase globales (singleton pattern)
final authService = AuthService();
final analyticsService = AnalyticsService();
final crashlyticsService = CrashlyticsService();
final remoteConfigService = RemoteConfigService();
final notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase (descomentar cuando firebase_options.dart esté configurado)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inicializar servicios de Firebase (descomentar cuando Firebase esté configurado)
  // await crashlyticsService.initialize();
  // await remoteConfigService.initialize();
  // await notificationService.initialize();
  // await analyticsService.logAppOpen();
  
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
  String? _emailError;

  bool _isValidEmail(String email) {
    // Basic email validation regex for educational app
    // Note: This is intentionally simple. Full auth will be implemented
    // when Firebase Auth is configured (see TODO below).
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _validateAndContinue() {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Por favor ingresa un email';
      });
      return;
    }
    
    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'Por favor ingresa un email válido';
      });
      return;
    }
    
    // Email válido, continuar
    setState(() {
      _emailError = null;
    });
    
    // Log analytics event (descomentar cuando Firebase esté configurado)
    // analyticsService.logLogin('email');
    
    // TODO: Implementar lógica de registro/Auth aquí con Firebase Auth
    // Por ahora, esto es solo una simulación educativa sin backend
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

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
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'ejemplo@correo.com',
                errorText: _emailError,
              ),
              onChanged: (value) {
                // Clear error when user types
                if (_emailError != null) {
                  setState(() {
                    _emailError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateAndContinue,
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
  int? prediction;
  double balance = 1000.0;
  double currentBet = 10.0;
  bool useMartingale = false;
  String lastBetResult = '';

  void spinRoulette() {
    // Genera predicción antes del giro
    if (history.isNotEmpty) {
      prediction = _rouletteLogic.predictNext(history);
    } else {
      prediction = null;
    }
    
    // Usa RouletteLogic con RNG seguro
    final res = _rouletteLogic.generateSpin();
    
    // Simula resultado de apuesta (ejemplo: apostar al color rojo)
    final bool isRed = _isRedNumber(res);
    final bool won = isRed; // Simplificado: asumimos que apostamos a rojo
    
    setState(() {
      result = res.toString();
      history.add(res);
      
      // Actualiza balance
      if (won) {
        balance += currentBet;
        lastBetResult = '¡Ganaste! +${currentBet.toStringAsFixed(2)}';
        // Log analytics (descomentar cuando Firebase esté configurado)
        // analyticsService.logGameResult(won: true, amount: currentBet, predictedNumber: prediction, resultNumber: res);
      } else {
        balance -= currentBet;
        // Asegura que el balance no sea negativo
        if (balance < 0) balance = 0;
        lastBetResult = 'Perdiste -${currentBet.toStringAsFixed(2)}';
        // Log analytics (descomentar cuando Firebase esté configurado)
        // analyticsService.logGameResult(won: false, amount: currentBet, predictedNumber: prediction, resultNumber: res);
      }
      
      // Log roulette spin (descomentar cuando Firebase esté configurado)
      // analyticsService.logRouletteSpin(result: res, predicted: prediction);
      
      // Actualiza apuesta según Martingale si está activado
      if (useMartingale) {
        currentBet = _martingaleAdvisor.getNextBet(won);
        // Asegura que la apuesta no exceda el balance
        if (currentBet > balance) {
          currentBet = balance;
        }
      }
      
      // Limita el historial a los últimos 20 números
      if (history.length > 20) {
        history = history.sublist(history.length - 20);
      }
    });
  }
  
  bool _isRedNumber(int number) {
    // Números rojos en la ruleta europea
    const redNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36};
    return redNumbers.contains(number);
  }
  
  void _resetGame() {
    setState(() {
      history.clear();
      result = 'Presiona Girar';
      balance = 1000.0;
      currentBet = 10.0;
      prediction = null;
      lastBetResult = '';
      _martingaleAdvisor.reset();
      _martingaleAdvisor.baseBet = currentBet;
    });
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Usar estrategia Martingale'),
              subtitle: const Text('Duplica la apuesta tras perder'),
              value: useMartingale,
              onChanged: (value) {
                setState(() {
                  useMartingale = value;
                  if (value) {
                    _martingaleAdvisor.baseBet = currentBet;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Roulette Predicciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance y apuesta actual
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Balance: \$${balance.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Apuesta actual: \$${currentBet.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    if (lastBetResult.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          lastBetResult,
                          style: TextStyle(
                            fontSize: 16,
                            color: lastBetResult.contains('Ganaste') ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Resultado actual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Resultado',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: result == 'Presiona Girar' 
                          ? Colors.grey.shade300
                          : _getNumberColor(int.tryParse(result) ?? -1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          result,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Predicción
            if (prediction != null)
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 32, color: Colors.amber),
                      const SizedBox(height: 8),
                      const Text(
                        'Predicción sugerida',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        prediction.toString(),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '(basada en historial reciente)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            
            // Botón girar
            ElevatedButton.icon(
              onPressed: balance >= currentBet ? spinRoulette : null,
              icon: const Icon(Icons.play_circle_outline, size: 32),
              label: const Text('Girar Ruleta', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Historial
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historial Reciente',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (history.isEmpty)
                      const Text('No hay giros todavía', style: TextStyle(color: Colors.grey))
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: history.reversed.map((num) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getNumberColor(num),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                num.toString(),
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Info sobre Martingale
            if (useMartingale)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.show_chart, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Estrategia Martingale Activa',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'La apuesta se duplicará automáticamente después de cada pérdida.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Disclaimer
            const SizedBox(height: 16),
            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '⚠️ DISCLAIMER: Esta es una simulación educativa. No promueve juegos de azar reales. Las predicciones son aleatorias y no garantizan resultados.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getNumberColor(int number) {
    if (number == 0) return Colors.green;
    if (_isRedNumber(number)) return Colors.red.shade700;
    return Colors.black;
  }
}