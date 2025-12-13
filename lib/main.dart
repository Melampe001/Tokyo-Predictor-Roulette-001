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
  final MartingaleAdvisor _martingaleAdvisor = MartingaleAdvisor();
  
  SpinResult? lastSpin;
  List<int> history = [];
  double balance = 1000.0;
  double currentBet = 10.0;
  int? prediction;
  bool useMartingale = false;
  bool lastWin = false;

  @override
  void initState() {
    super.initState();
    _martingaleAdvisor.baseBet = currentBet;
    _martingaleAdvisor.currentBet = currentBet;
  }

  void spinRoulette() {
    // Generar el giro
    final spin = _rouletteLogic.generateSpin();
    
    // Simular apuesta en rojo (ejemplo)
    final betOnRed = spin.color == RouletteColor.red;
    final won = betOnRed;
    
    setState(() {
      lastSpin = spin;
      history.add(spin.number);
      
      // Actualizar balance
      if (won) {
        balance += currentBet;
        lastWin = true;
      } else {
        balance -= currentBet;
        lastWin = false;
      }
      
      // Actualizar predicción basada en el nuevo historial
      if (history.length >= 3) {
        prediction = _rouletteLogic.predictNext(history);
      }
      
      // Actualizar apuesta si Martingale está activado
      if (useMartingale) {
        currentBet = _martingaleAdvisor.getNextBet(won);
      }
    });
  }

  void toggleMartingale() {
    setState(() {
      useMartingale = !useMartingale;
      if (useMartingale) {
        _martingaleAdvisor.baseBet = 10.0;
        _martingaleAdvisor.reset();
        currentBet = _martingaleAdvisor.currentBet;
      } else {
        currentBet = 10.0;
      }
    });
  }

  void resetGame() {
    setState(() {
      lastSpin = null;
      history.clear();
      balance = 1000.0;
      currentBet = 10.0;
      prediction = null;
      lastWin = false;
      _martingaleAdvisor.reset();
    });
  }

  Color _getColorForNumber(int number) {
    final color = _rouletteLogic.getColor(number);
    switch (color) {
      case RouletteColor.red:
        return Colors.red;
      case RouletteColor.black:
        return Colors.black;
      case RouletteColor.green:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _rouletteLogic.getStatistics(history);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Roulette Predicciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
            tooltip: 'Reiniciar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Balance: \$${balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Apuesta actual: \$${currentBet.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
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
                    Text(
                      'Último Resultado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    lastSpin != null
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _getColorForNumber(lastSpin!.number),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                lastSpin!.number.toString(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const Text(
                            'Presiona Girar',
                            style: TextStyle(fontSize: 24),
                          ),
                    if (lastSpin != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        lastWin ? '¡Ganaste! 🎉' : 'Perdiste',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: lastWin ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón de girar
            ElevatedButton.icon(
              onPressed: balance >= currentBet ? spinRoulette : null,
              icon: const Icon(Icons.casino, size: 28),
              label: const Text(
                'Girar Ruleta',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Predicción
            if (prediction != null)
              Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🔮 Predicción',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Número más probable: $prediction',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Basado en frecuencia histórica)',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Estrategia Martingale
            Card(
              color: useMartingale ? Colors.orange.shade50 : Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📊 Estrategia Martingale',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: useMartingale,
                          onChanged: (value) => toggleMartingale(),
                        ),
                      ],
                    ),
                    if (useMartingale) ...[
                      const SizedBox(height: 8),
                      Text(
                        useMartingale
                            ? 'Activa: La apuesta se duplica tras cada pérdida'
                            : 'Inactiva: Apuesta fija',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Estadísticas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📈 Estadísticas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow('Total de giros:', '${stats['total']}'),
                    _buildStatRow('Rojos:', '${stats['reds']}', Colors.red),
                    _buildStatRow('Negros:', '${stats['blacks']}', Colors.black),
                    _buildStatRow('Verdes:', '${stats['greens']}', Colors.green),
                    if (stats['most_frequent'] != null)
                      _buildStatRow('Más frecuente:', '${stats['most_frequent']}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Historial
            if (history.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🕐 Historial (Últimos ${history.length > 10 ? 10 : history.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: history.reversed.take(10).map((num) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getColorForNumber(num),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 1),
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
            
            // Disclaimer
            const Card(
              color: Colors.yellow,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '⚠️ Disclaimer: Esta es una simulación educativa. '
                  'En ruletas reales, cada giro es independiente y no se puede predecir. '
                  'No promueve gambling real.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}