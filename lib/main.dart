import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme
import 'theme/app_theme.dart';

// Providers
import 'providers/game_provider.dart';

// Services
import 'services/rng_service.dart';
import 'services/prediction_service.dart';
import 'services/martingale_service.dart';
import 'services/storage_service.dart';
import 'services/analytics_service.dart';

// Screens
import 'screens/login_screen.dart';

// TODO: Descomentar cuando firebase_options.dart esté configurado
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Inicializar Firebase cuando esté configurado
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Inicializar servicios
  final rngService = RNGService();
  final predictionService = PredictionService(rngService);
  final martingaleService = MartingaleService();
  final storageService = StorageService(prefs);
  final analyticsService = AnalyticsService();
  
  // Crear provider
  final gameProvider = GameProvider(
    rngService: rngService,
    predictionService: predictionService,
    martingaleService: martingaleService,
    storageService: storageService,
    analyticsService: analyticsService,
  );
  
  // Inicializar provider
  await gameProvider.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>.value(value: gameProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo Roulette Predicciones',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
