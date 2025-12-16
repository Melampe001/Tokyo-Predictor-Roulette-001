/// Constantes de la aplicación
class AppConstants {
  // Configuración de la ruleta
  static const int minRouletteNumber = 0;
  static const int maxRouletteNumber = 36;
  static const int maxHistoryLength = 20;
  
  // Números rojos en la ruleta europea
  static const Set<int> redNumbers = {
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  };
  
  // Configuración de apuestas
  static const double defaultBalance = 1000.0;
  static const double defaultBet = 10.0;
  static const double minBet = 1.0;
  static const double maxBet = 1000.0;
  
  // Multiplicadores de pago
  static const double straightUpPayout = 35.0;  // Apuesta a número único
  static const double colorPayout = 1.0;        // Apuesta a rojo/negro
  static const double evenOddPayout = 1.0;      // Apuesta a par/impar
  
  // Configuración de Martingale
  static const int maxMartingaleDoubles = 10;
  
  // Configuración de almacenamiento
  static const String storageKeyPrefix = 'tokyo_roulette_';
  
  // Configuración de analytics
  static const bool enableAnalytics = true;
  
  // Límites de la app
  static const int maxAchievements = 50;
  static const int maxMissions = 10;
  static const int maxHistoryForStats = 1000;
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration animationTimeout = Duration(seconds: 5);
  
  // URLs
  static const String supportEmail = 'support@tokyoroulette.com';
  static const String privacyPolicyUrl = 'https://tokyoroulette.com/privacy';
  static const String termsOfServiceUrl = 'https://tokyoroulette.com/terms';
  
  // Versión de la app
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  
  // Disclaimers
  static const String educationalDisclaimer =
      '⚠️ DISCLAIMER: Esta es una simulación educativa. '
      'No promueve juegos de azar reales. Las predicciones son aleatorias '
      'y no garantizan resultados.';
  
  static const String martingaleWarning =
      'ADVERTENCIA: La estrategia Martingale tiene riesgos significativos. '
      'Puede llevar a pérdidas importantes. Esta es solo una simulación educativa.';
}
