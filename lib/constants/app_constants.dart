/// App-wide constants and design tokens
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Tokyo Roulette Predicciones';
  static const String appVersion = '1.0.0';
  
  // Design Tokens - Spacing
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2Xl = 48.0;
  static const double space3Xl = 64.0;
  
  // Design Tokens - Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 9999.0;
  
  // Design Tokens - Elevation
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 2.0;
  static const double elevationLg = 4.0;
  static const double elevationXl = 8.0;
  
  // Animation Durations (milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  static const int animationRouletteSpinMin = 3000;
  static const int animationRouletteSpinMax = 5000;
  
  // Touch Target Sizes (WCAG AA compliance)
  static const double minTouchTarget = 48.0;
  static const double recommendedTouchTarget = 56.0;
  
  // Roulette Configuration
  static const int rouletteMaxNumber = 36;
  static const int rouletteMinNumber = 0;
  static const int historyMaxLength = 20;
  
  // Game Configuration
  static const double defaultBalance = 1000.0;
  static const double defaultBet = 10.0;
  static const double minBet = 1.0;
  static const double maxBet = 1000.0;
  
  // Roulette Colors (European)
  static const List<int> redNumbers = [
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  ];
  
  static const List<int> blackNumbers = [
    2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
  ];
  
  // Green numbers (zero)
  static const List<int> greenNumbers = [0];
  
  // URLs and Links
  static const String supportEmail = 'support@tokyoroulette.com';
  static const String privacyPolicyUrl = 'https://tokyoroulette.com/privacy';
  static const String termsOfServiceUrl = 'https://tokyoroulette.com/terms';
  
  // Storage Keys (SharedPreferences)
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySoundEffects = 'sound_effects';
  static const String keyNotifications = 'notifications';
  static const String keyLanguage = 'language';
  static const String keyHighScore = 'high_score';
  static const String keyTotalGames = 'total_games';
  
  // Accessibility
  static const double minTextScale = 0.8;
  static const double maxTextScale = 2.0;
  static const double defaultTextScale = 1.0;
  
  // Disclaimer Text
  static const String disclaimer = 
    '⚠️ DISCLAIMER: Esta es una simulación educativa. '
    'No promueve juegos de azar reales. Las predicciones son '
    'aleatorias y no garantizan resultados.';
  
  // Educational Messages
  static const String martingaleWarning = 
    'La estrategia Martingale tiene riesgos significativos en juegos reales. '
    'Esta es solo una simulación educativa.';
  
  static const String predictionInfo = 
    'En ruletas reales, cada giro es independiente y no se puede predecir. '
    'Este predictor es solo para fines educativos.';
}

/// Route names for navigation
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String game = '/game';
  static const String statistics = '/statistics';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';
}

/// Asset paths
class AppAssets {
  AppAssets._();

  // Images
  static const String imagesPath = 'assets/images/';
  
  // Icons
  static const String iconsPath = 'assets/icons/';
  
  // Animations (Lottie)
  static const String animationsPath = 'assets/animations/';
  static const String winAnimation = '${animationsPath}win.json';
  static const String loadingAnimation = '${animationsPath}loading.json';
  static const String celebrationAnimation = '${animationsPath}celebration.json';
}
