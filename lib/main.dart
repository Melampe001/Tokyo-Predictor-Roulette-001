import 'package:flutter/material.dart';
// Removed unused imports: firebase_core and flutter_stripe.
// Uncomment and initialize when configured:
// import 'package:firebase_core/firebase_core.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _ageVerified = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Valida el formato del email
  /// Previene inyecciones y asegura formato válido
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un email';
    }
    
    // Sanitiza el input: trim y lowercase
    final sanitized = value.trim().toLowerCase();
    
    // Validación de formato de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(sanitized)) {
      return 'Ingresa un email válido';
    }
    
    // Verifica longitud máxima para prevenir ataques de buffer
    if (sanitized.length > 254) {
      return 'Email demasiado largo';
    }
    
    return null;
  }

  void _showAgeVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Verificación de Edad'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta aplicación es SOLO para mayores de 18 años.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '¿Confirmas que tienes 18 años o más?',
            ),
            SizedBox(height: 16),
            Text(
              'AVISO: Esta es una simulación educativa que NO involucra dinero real.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // No permite continuar si no verifica edad
            },
            child: const Text('No, soy menor de 18'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ageVerified = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Sí, soy mayor de 18'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_ageVerified) {
      _showAgeVerificationDialog();
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Sanitiza el email antes de usarlo
      final sanitizedEmail = _emailController.text.trim().toLowerCase();
      
      // TODO: Implementar lógica de registro/Auth aquí
      // Ejemplo seguro de uso con Firebase:
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: sanitizedEmail,
      //   password: password,
      // );
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                '🎰 Tokyo Roulette Predicciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Simulador Educativo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'tu@email.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: _validateEmail,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.login),
                label: const Text('Registrar y Continuar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.orange.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Importante',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Solo para mayores de 18 años\n'
                        '• Simulación educativa únicamente\n'
                        '• No involucra dinero real\n'
                        '• No promueve apuestas',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      } else {
        balance -= currentBet;
        // Asegura que el balance no sea negativo
        if (balance < 0) balance = 0;
        lastBetResult = 'Perdiste -${currentBet.toStringAsFixed(2)}';
      }
      
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
            
            // Disclaimer mejorado con información de ayuda
            const SizedBox(height: 16),
            Card(
              color: Colors.red.shade700,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '⚠️ AVISO IMPORTANTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Esta aplicación es SOLO para fines educativos y de entretenimiento.\n\n'
                      '• NO involucra dinero real\n'
                      '• NO promueve apuestas\n'
                      '• NO es un juego de azar regulado\n'
                      '• Las predicciones son simulaciones aleatorias',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.white70),
                    SizedBox(height: 8),
                    Text(
                      '🆘 El juego puede ser adictivo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Si necesitas ayuda: 1-800-GAMBLER\n'
                      'España: 900 200 225 (Juego Responsable)',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
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