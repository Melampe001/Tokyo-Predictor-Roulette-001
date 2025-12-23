/// Constantes de Firebase para Tokyo Roulette Predictor
/// 
/// Centraliza nombres de colecciones, campos, y configuraciones

class FirebaseConstants {
  // ==================== COLECCIONES ====================
  
  /// Colección de usuarios
  static const String usersCollection = 'users';
  
  /// Colección de predicciones
  static const String predictionsCollection = 'predictions';
  
  /// Colección de sesiones
  static const String sessionsCollection = 'sessions';
  
  /// Colección de logros
  static const String achievementsCollection = 'achievements';
  
  /// Colección de configuración
  static const String configCollection = 'config';

  // ==================== CAMPOS DE USUARIO ====================
  
  static const String userEmail = 'email';
  static const String userDisplayName = 'displayName';
  static const String userPhotoUrl = 'photoUrl';
  static const String userIsAnonymous = 'isAnonymous';
  static const String userIsPremium = 'isPremium';
  static const String userCreatedAt = 'createdAt';
  static const String userUpdatedAt = 'updatedAt';
  static const String userStats = 'stats';
  static const String userPreferences = 'preferences';

  // ==================== CAMPOS DE PREDICCIÓN ====================
  
  static const String predictionUserId = 'userId';
  static const String predictionNumber = 'predictedNumber';
  static const String predictionResult = 'resultNumber';
  static const String predictionBetAmount = 'betAmount';
  static const String predictionStatus = 'result'; // 'pending', 'win', 'loss'
  static const String predictionTimestamp = 'timestamp';
  static const String predictionMethod = 'predictionMethod';
  static const String predictionMetadata = 'metadata';

  // ==================== CAMPOS DE SESIÓN ====================
  
  static const String sessionUserId = 'userId';
  static const String sessionStartTime = 'startTime';
  static const String sessionEndTime = 'endTime';
  static const String sessionActive = 'active';
  static const String sessionInitialBalance = 'initialBalance';
  static const String sessionFinalBalance = 'finalBalance';
  static const String sessionTotalPredictions = 'totalPredictions';
  static const String sessionWins = 'wins';
  static const String sessionLosses = 'losses';
  static const String sessionTotalBetAmount = 'totalBetAmount';
  static const String sessionTotalWinnings = 'totalWinnings';
  static const String sessionUsedMartingale = 'usedMartingale';
  static const String sessionMetadata = 'metadata';

  // ==================== VALORES DE ESTADO ====================
  
  /// Estados de predicción
  static const String predictionStatusPending = 'pending';
  static const String predictionStatusWin = 'win';
  static const String predictionStatusLoss = 'loss';

  /// Métodos de predicción
  static const String predictionMethodManual = 'manual';
  static const String predictionMethodAI = 'ai';
  static const String predictionMethodFrequency = 'frequency';
  static const String predictionMethodMartingale = 'martingale';

  /// Tipos de apuesta
  static const String betTypeNumber = 'number';
  static const String betTypeColor = 'color';
  static const String betTypeEvenOdd = 'evenOdd';
  static const String betTypeHighLow = 'highLow';

  // ==================== STORAGE PATHS ====================
  
  /// Ruta base para usuarios en Storage
  static const String storageUsersPath = 'users';
  
  /// Ruta para avatares
  static const String storageAvatarsPath = 'avatars';
  
  /// Ruta para archivos temporales
  static const String storageTempPath = 'temp';
  
  /// Ruta para assets del juego
  static const String storageAssetsPath = 'assets';

  // ==================== ANALYTICS EVENTS ====================
  
  /// Eventos de Analytics
  static const String analyticsAppOpen = 'app_open';
  static const String analyticsSignUp = 'sign_up';
  static const String analyticsLogin = 'login';
  static const String analyticsGameSessionStart = 'game_session_start';
  static const String analyticsGameSessionEnd = 'game_session_end';
  static const String analyticsPredictionMade = 'prediction_made';
  static const String analyticsRouletteSpin = 'roulette_spin';
  static const String analyticsGameResult = 'game_result';
  static const String analyticsPlayerWin = 'player_win';
  static const String analyticsPlayerLoss = 'player_loss';
  static const String analyticsMartingaleToggle = 'martingale_toggle';
  static const String analyticsMartingaleBet = 'martingale_bet';
  static const String analyticsSettingChanged = 'setting_changed';
  static const String analyticsPurchase = 'purchase';
  static const String analyticsBeginCheckout = 'begin_checkout';
  static const String analyticsShare = 'share';
  static const String analyticsTutorialBegin = 'tutorial_begin';
  static const String analyticsTutorialComplete = 'tutorial_complete';
  static const String analyticsAppError = 'app_error';

  // ==================== REMOTE CONFIG KEYS ====================
  
  /// Feature Flags
  static const String rcEnableGoogleSignIn = 'enable_google_signin';
  static const String rcEnableAnonymousSignIn = 'enable_anonymous_signin';
  static const String rcEnableMartingale = 'enable_martingale';
  static const String rcEnablePredictions = 'enable_predictions';
  static const String rcEnableAnalytics = 'enable_analytics';
  static const String rcShowAds = 'show_ads';
  static const String rcEnablePushNotifications = 'enable_push_notifications';
  static const String rcNewUIEnabled = 'new_ui_enabled';
  static const String rcShowTutorial = 'show_tutorial';
  static const String rcRateLimitEnabled = 'rate_limit_enabled';
  static const String rcEnableTrial = 'enable_trial';

  /// Configuración de la app
  static const String rcMinAppVersion = 'min_app_version';
  static const String rcForceUpdate = 'force_update';
  static const String rcMaintenanceMode = 'maintenance_mode';
  static const String rcMaintenanceMessage = 'maintenance_message';
  static const String rcExperimentGroup = 'experiment_group';

  /// Límites y configuración del juego
  static const String rcMaxBetAmount = 'max_bet_amount';
  static const String rcMinBetAmount = 'min_bet_amount';
  static const String rcDefaultBalance = 'default_balance';
  static const String rcMaxPredictionHistory = 'max_prediction_history';
  static const String rcMaxSessionsPerDay = 'max_sessions_per_day';
  static const String rcMaxPredictionsPerMinute = 'max_predictions_per_minute';

  /// UI Configuration
  static const String rcPrimaryColor = 'primary_color';
  static const String rcAccentColor = 'accent_color';
  static const String rcTutorialVersion = 'tutorial_version';

  /// Notificaciones
  static const String rcReminderIntervalHours = 'reminder_interval_hours';

  /// Premium
  static const String rcPremiumPriceUSD = 'premium_price_usd';
  static const String rcTrialDays = 'trial_days';

  // ==================== TÓPICOS DE NOTIFICACIONES ====================
  
  /// Tópicos para notificaciones push
  static const String notificationTopicAllUsers = 'all_users';
  static const String notificationTopicPremiumUsers = 'premium_users';
  static const String notificationTopicFreeUsers = 'free_users';
  static const String notificationTopicDailyReminders = 'daily_reminders';
  static const String notificationTopicAnnouncements = 'announcements';

  // ==================== TIPOS DE NOTIFICACIÓN ====================
  
  /// Tipos de notificaciones
  static const String notificationTypeInvitation = 'invitation';
  static const String notificationTypeAchievement = 'achievement';
  static const String notificationTypeReminder = 'reminder';
  static const String notificationTypeAnnouncement = 'announcement';
  static const String notificationTypeWinStreak = 'win_streak';
  static const String notificationTypeDailyStats = 'daily_stats';

  // ==================== LÍMITES Y CONFIGURACIÓN ====================
  
  /// Límites de la aplicación
  static const int maxFileUploadSizeMB = 10;
  static const int maxPredictionsPerSession = 1000;
  static const int maxSessionDurationHours = 24;
  static const int minPasswordLength = 6;
  static const int maxDisplayNameLength = 50;
  static const int maxBioLength = 500;

  /// Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 5);

  /// Intervalos de actualización
  static const Duration remoteConfigFetchInterval = Duration(hours: 4);
  static const Duration remoteConfigFetchIntervalDebug = Duration(minutes: 5);

  /// Cache
  static const int defaultCacheSizeBytes = 104857600; // 100 MB
  static const Duration cacheExpiration = Duration(days: 7);

  // ==================== COLORES DE RULETA ====================
  
  /// Colores de números de ruleta
  static const String rouletteColorGreen = 'green';
  static const String rouletteColorRed = 'red';
  static const String rouletteColorBlack = 'black';

  /// Números rojos de ruleta europea
  static const List<int> redNumbers = [
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  ];

  // ==================== LOGROS ====================
  
  /// IDs de logros
  static const String achievementFirstWin = 'first_win';
  static const String achievement10Wins = 'ten_wins';
  static const String achievement100Predictions = 'hundred_predictions';
  static const String achievementProfitablePlayer = 'profitable_player';
  static const String achievementWinStreak5 = 'win_streak_5';
  static const String achievementWinStreak10 = 'win_streak_10';
  static const String achievementBigWin = 'big_win';
  static const String achievement1000Predictions = 'thousand_predictions';

  // ==================== PREFERENCIAS DE USUARIO ====================
  
  /// Claves de preferencias
  static const String prefThemeMode = 'theme_mode';
  static const String prefLanguage = 'language';
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefSoundEnabled = 'sound_enabled';
  static const String prefMartingaleEnabled = 'martingale_enabled';
  static const String prefDefaultBet = 'default_bet';
  static const String prefShowTutorial = 'show_tutorial';
  static const String prefAnalyticsEnabled = 'analytics_enabled';

  // ==================== VALIDACIÓN ====================
  
  /// Expresión regular para validar email
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Verificar si un número es rojo
  static bool isRedNumber(int number) {
    return redNumbers.contains(number);
  }

  /// Obtener color de un número
  static String getNumberColor(int number) {
    if (number == 0) return rouletteColorGreen;
    if (isRedNumber(number)) return rouletteColorRed;
    return rouletteColorBlack;
  }

  /// Verificar si un número es válido en ruleta europea (0-36)
  static bool isValidRouletteNumber(int number) {
    return number >= 0 && number <= 36;
  }

  // ==================== PATHS DE NAVEGACIÓN ====================
  
  /// Rutas de navegación
  static const String routeHome = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeStats = '/stats';
  static const String routeHistory = '/history';
  static const String routeAbout = '/about';

  // ==================== METADATA ====================
  
  /// Metadata de la aplicación
  static const String appName = 'Tokyo Roulette Predictor';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.tokyoapps.roulette';
}
