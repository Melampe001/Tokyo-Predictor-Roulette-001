import 'package:flutter/material.dart';
// Removed unused imports: firebase_core and flutter_stripe.
// Uncomment and initialize when configured:
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'roulette_logic.dart';
import 'theme/app_theme.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_card.dart';
import 'widgets/roulette/animated_roulette_wheel.dart';
import 'widgets/number_selector.dart';
import 'widgets/win_animation.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/responsive_helper.dart';
import 'constants/app_constants.dart';
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
    
    // TODO: Implementar lógica de registro/Auth aquí con Firebase Auth
    // Por ahora, esto es solo una simulación educativa sin backend
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: ResponsiveCenter(
        maxWidth: 400,
        child: Padding(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo/title
              Icon(
                Icons.casino,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Tokyo Roulette',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Simulador Educativo de Predicciones',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Email input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'ejemplo@correo.com',
                  errorText: _emailError,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                onChanged: (value) {
                  // Clear error when user types
                  if (_emailError != null) {
                    setState(() {
                      _emailError = null;
                    });
                  }
                },
                onSubmitted: (_) => _validateAndContinue(),
              ),
              const SizedBox(height: 24),
              
              // Login button
              CustomButton(
                text: 'Registrar y Continuar',
                onPressed: _validateAndContinue,
                icon: Icons.arrow_forward,
                fullWidth: true,
                type: ButtonType.primary,
                size: ButtonSize.large,
              ),
              const SizedBox(height: 32),
              
              // Disclaimer
              CustomCard(
                color: theme.colorScheme.errorContainer.withOpacity(0.3),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'App educativa - No promueve juegos de azar reales',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
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
  
  int? result;
  List<int> history = [];
  int? prediction;
  double balance = AppConstants.defaultBalance;
  double currentBet = AppConstants.defaultBet;
  bool useMartingale = false;
  String lastBetResult = '';
  bool isSpinning = false;
  bool showWinAnimation = false;
  int _currentIndex = 0;

  // Stats tracking
  double totalWins = 0;
  double totalLosses = 0;
  int totalGames = 0;
  double highScore = AppConstants.defaultBalance;

  void spinRoulette() {
    if (isSpinning || balance < currentBet) return;

    setState(() {
      isSpinning = true;
      // Generate prediction before spin
      if (history.isNotEmpty) {
        prediction = _rouletteLogic.predictNext(history);
      } else {
        prediction = null;
      }
    });

    // Simulate spin delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final res = _rouletteLogic.generateSpin();
      final bool isRed = _isRedNumber(res);
      final bool won = isRed; // Simplified: assume betting on red
      
      setState(() {
        result = res;
        history.add(res);
        totalGames++;
        
        // Update balance and track stats
        if (won) {
          balance += currentBet;
          totalWins += currentBet;
          lastBetResult = 'win';
          showWinAnimation = true;
          
          // Update high score
          if (balance > highScore) {
            highScore = balance;
          }
        } else {
          balance -= currentBet;
          totalLosses += currentBet;
          if (balance < 0) balance = 0;
          lastBetResult = 'loss';
        }
        
        // Update bet according to Martingale if active
        if (useMartingale) {
          currentBet = _martingaleAdvisor.getNextBet(won);
          if (currentBet > balance) {
            currentBet = balance;
          }
        }
        
        // Limit history length
        if (history.length > AppConstants.historyMaxLength) {
          history = history.sublist(history.length - AppConstants.historyMaxLength);
        }
      });

      // Hide win animation after delay
      if (won) {
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() {
              showWinAnimation = false;
            });
          }
        });
      }

      // Stop spinning animation
      Future.delayed(const Duration(milliseconds: 4000), () {
        if (mounted) {
          setState(() {
            isSpinning = false;
          });
        }
      });
    });
  }
  
  bool _isRedNumber(int number) {
    return AppConstants.redNumbers.contains(number);
  }
  
  void _resetGame() {
    setState(() {
      history.clear();
      result = null;
      balance = AppConstants.defaultBalance;
      currentBet = AppConstants.defaultBet;
      prediction = null;
      lastBetResult = '';
      _martingaleAdvisor.reset();
      _martingaleAdvisor.baseBet = currentBet;
      isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show different screens based on navigation
    if (_currentIndex == 1) {
      return StatisticsScreen(
        history: history,
        totalWins: totalWins,
        totalLosses: totalLosses,
        totalGames: totalGames,
      );
    } else if (_currentIndex == 2) {
      return ProfileScreen(
        email: 'usuario@ejemplo.com', // TODO: Get from auth
        totalWins: totalWins,
        totalLosses: totalLosses,
        totalGames: totalGames,
        highScore: highScore,
      );
    } else if (_currentIndex == 3) {
      return const SettingsScreen();
    }

    // Main game screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Roulette'),
        actions: [
          CustomIconButton(
            icon: Icons.refresh,
            onPressed: _resetGame,
            tooltip: 'Reiniciar juego',
          ),
        ],
      ),
      body: Stack(
        children: [
          ResponsiveCenter(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.responsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Balance card
                  BalanceCard(
                    label: 'Balance Actual',
                    amount: balance,
                    icon: Icons.account_balance_wallet,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Roulette wheel
                  Center(
                    child: AnimatedRouletteWheel(
                      resultNumber: result,
                      predictionNumber: prediction,
                      size: ResponsiveHelper.isMobile(context) ? 280 : 350,
                      isSpinning: isSpinning,
                      onSpinComplete: () {
                        // Animation complete callback
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Result display
                  if (result != null)
                    Center(
                      child: RouletteResultDisplay(
                        number: result,
                        size: 100,
                        animate: true,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Prediction card
                  if (prediction != null && isSpinning)
                    PredictionDisplay(
                      predictedNumber: prediction!,
                      description: '(basada en historial reciente)',
                    ),
                  const SizedBox(height: 16),

                  // Bet amount
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apuesta Actual',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: currentBet,
                                min: AppConstants.minBet,
                                max: balance.clamp(AppConstants.minBet, AppConstants.maxBet),
                                divisions: 20,
                                label: '\$${currentBet.toStringAsFixed(0)}',
                                onChanged: useMartingale ? null : (value) {
                                  setState(() {
                                    currentBet = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '\$${currentBet.toStringAsFixed(0)}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Estrategia Martingale'),
                          subtitle: const Text('Duplica apuesta tras perder'),
                          value: useMartingale,
                          onChanged: (value) {
                            setState(() {
                              useMartingale = value;
                              if (value) {
                                _martingaleAdvisor.baseBet = currentBet;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Spin button
                  Center(
                    child: SpinButton(
                      onPressed: spinRoulette,
                      isSpinning: isSpinning,
                      isDisabled: balance < currentBet,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // History
                  if (history.isNotEmpty)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Historial Reciente',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          NumberHistory(
                            numbers: history,
                            highlightNumber: result,
                            itemSize: 48,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Disclaimer
                  CustomCard(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppConstants.disclaimer,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Win animation overlay
          if (showWinAnimation)
            WinAnimation(
              amount: currentBet,
              onComplete: () {
                setState(() {
                  showWinAnimation = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Jugar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}