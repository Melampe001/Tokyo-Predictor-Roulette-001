import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Servicio de Remote Config de Firebase
/// 
/// Permite actualizar configuración de la app sin requerir una actualización
/// Incluye feature flags, límites, y configuración dinámica
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  // Valores por defecto
  static const Map<String, dynamic> _defaults = {
    // Feature Flags
    'enable_google_signin': true,
    'enable_anonymous_signin': true,
    'enable_martingale': true,
    'enable_predictions': true,
    'enable_analytics': true,
    'show_ads': false,
    
    // Configuración de la app
    'min_app_version': '1.0.0',
    'force_update': false,
    'maintenance_mode': false,
    'maintenance_message': 'Estamos realizando mantenimiento. Por favor, vuelve pronto.',
    
    // Límites y configuración del juego
    'max_bet_amount': 1000.0,
    'min_bet_amount': 1.0,
    'default_balance': 1000.0,
    'max_prediction_history': 20,
    'max_sessions_per_day': 100,
    
    // UI Configuration
    'primary_color': '#2196F3',
    'accent_color': '#FF9800',
    'show_tutorial': true,
    'tutorial_version': 1,
    
    // A/B Testing
    'experiment_group': 'control',
    'new_ui_enabled': false,
    
    // Rate Limiting
    'max_predictions_per_minute': 10,
    'rate_limit_enabled': true,
    
    // Notificaciones
    'enable_push_notifications': true,
    'reminder_interval_hours': 24,
    
    // Premium Features
    'premium_price_usd': 4.99,
    'trial_days': 7,
    'enable_trial': true,
  };

  /// Inicializar Remote Config
  /// 
  /// Configura valores por defecto y ajustes de fetch
  Future<void> initialize() async {
    try {
      // Establecer valores por defecto
      await _remoteConfig.setDefaults(_defaults);
      
      // Configurar ajustes de fetch
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: kDebugMode
              ? const Duration(minutes: 5) // En desarrollo: 5 minutos
              : const Duration(hours: 4), // En producción: 4 horas (como especificado)
        ),
      );
      
      // Fetch y activar valores
      await fetchAndActivate();
      
      debugPrint('Remote Config inicializado');
    } catch (e) {
      debugPrint('Error al inicializar Remote Config: $e');
      // No lanzar error, usar valores por defecto
    }
  }

  /// Fetch y activar nuevos valores
  /// 
  /// Returns: true si se activaron nuevos valores
  Future<bool> fetchAndActivate() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      
      if (activated) {
        debugPrint('Nuevos valores de Remote Config activados');
      } else {
        debugPrint('No hay nuevos valores de Remote Config');
      }
      
      return activated;
    } catch (e) {
      debugPrint('Error al hacer fetch de Remote Config: $e');
      return false;
    }
  }

  // ==================== GETTERS PARA VALORES ====================

  /// Obtener valor booleano
  /// 
  /// [key] Clave del valor
  /// Returns: Valor booleano
  bool getBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      debugPrint('Error al obtener bool $key: $e');
      return _defaults[key] as bool? ?? false;
    }
  }

  /// Obtener valor entero
  /// 
  /// [key] Clave del valor
  /// Returns: Valor entero
  int getInt(String key) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      debugPrint('Error al obtener int $key: $e');
      return _defaults[key] as int? ?? 0;
    }
  }

  /// Obtener valor double
  /// 
  /// [key] Clave del valor
  /// Returns: Valor double
  double getDouble(String key) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      debugPrint('Error al obtener double $key: $e');
      return _defaults[key] as double? ?? 0.0;
    }
  }

  /// Obtener valor string
  /// 
  /// [key] Clave del valor
  /// Returns: Valor string
  String getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      debugPrint('Error al obtener string $key: $e');
      return _defaults[key] as String? ?? '';
    }
  }

  // ==================== FEATURE FLAGS ====================

  /// Verificar si Google Sign-In está habilitado
  bool get isGoogleSignInEnabled => getBool('enable_google_signin');

  /// Verificar si autenticación anónima está habilitada
  bool get isAnonymousSignInEnabled => getBool('enable_anonymous_signin');

  /// Verificar si estrategia Martingale está habilitada
  bool get isMartingaleEnabled => getBool('enable_martingale');

  /// Verificar si predicciones están habilitadas
  bool get arePredictionsEnabled => getBool('enable_predictions');

  /// Verificar si Analytics está habilitado
  bool get isAnalyticsEnabled => getBool('enable_analytics');

  /// Verificar si se deben mostrar anuncios
  bool get shouldShowAds => getBool('show_ads');

  /// Verificar si notificaciones push están habilitadas
  bool get arePushNotificationsEnabled => getBool('enable_push_notifications');

  /// Verificar si el nuevo UI está habilitado
  bool get isNewUIEnabled => getBool('new_ui_enabled');

  /// Verificar si el tutorial debe mostrarse
  bool get shouldShowTutorial => getBool('show_tutorial');

  /// Verificar si rate limiting está habilitado
  bool get isRateLimitingEnabled => getBool('rate_limit_enabled');

  /// Verificar si el trial está habilitado
  bool get isTrialEnabled => getBool('enable_trial');

  // ==================== CONFIGURACIÓN DE LA APP ====================

  /// Obtener versión mínima requerida de la app
  String get minAppVersion => getString('min_app_version');

  /// Verificar si se debe forzar actualización
  bool get forceUpdate => getBool('force_update');

  /// Verificar si la app está en modo mantenimiento
  bool get isMaintenanceMode => getBool('maintenance_mode');

  /// Obtener mensaje de mantenimiento
  String get maintenanceMessage => getString('maintenance_message');

  /// Obtener grupo de experimento (A/B testing)
  String get experimentGroup => getString('experiment_group');

  // ==================== CONFIGURACIÓN DEL JUEGO ====================

  /// Obtener apuesta máxima permitida
  double get maxBetAmount => getDouble('max_bet_amount');

  /// Obtener apuesta mínima permitida
  double get minBetAmount => getDouble('min_bet_amount');

  /// Obtener balance inicial por defecto
  double get defaultBalance => getDouble('default_balance');

  /// Obtener máximo de predicciones en historial
  int get maxPredictionHistory => getInt('max_prediction_history');

  /// Obtener máximo de sesiones por día
  int get maxSessionsPerDay => getInt('max_sessions_per_day');

  /// Obtener máximo de predicciones por minuto
  int get maxPredictionsPerMinute => getInt('max_predictions_per_minute');

  // ==================== UI CONFIGURATION ====================

  /// Obtener color primario
  String get primaryColor => getString('primary_color');

  /// Obtener color de acento
  String get accentColor => getString('accent_color');

  /// Obtener versión del tutorial
  int get tutorialVersion => getInt('tutorial_version');

  // ==================== NOTIFICACIONES ====================

  /// Obtener intervalo de recordatorios en horas
  int get reminderIntervalHours => getInt('reminder_interval_hours');

  // ==================== PREMIUM FEATURES ====================

  /// Obtener precio premium en USD
  double get premiumPriceUSD => getDouble('premium_price_usd');

  /// Obtener días de prueba gratuita
  int get trialDays => getInt('trial_days');

  // ==================== UTILIDADES ====================

  /// Obtener todos los valores actuales
  /// 
  /// Returns: Mapa con todos los valores y sus claves
  Map<String, dynamic> getAllValues() {
    try {
      final keys = _remoteConfig.getAll();
      final values = <String, dynamic>{};
      
      for (final entry in keys.entries) {
        values[entry.key] = entry.value.asString();
      }
      
      return values;
    } catch (e) {
      debugPrint('Error al obtener todos los valores: $e');
      return {};
    }
  }

  /// Obtener información del último fetch
  /// 
  /// Returns: Información del fetch (tiempo, estado, etc.)
  RemoteConfigFetchStatus get lastFetchStatus => _remoteConfig.lastFetchStatus;

  /// Obtener tiempo del último fetch exitoso
  /// 
  /// Returns: DateTime del último fetch o null
  DateTime? get lastFetchTime => _remoteConfig.lastFetchTime;

  /// Verificar si un valor específico existe
  /// 
  /// [key] Clave a verificar
  /// Returns: true si existe
  bool hasKey(String key) {
    return _remoteConfig.getAll().containsKey(key);
  }

  /// Obtener valor crudo (RemoteConfigValue)
  /// 
  /// [key] Clave del valor
  /// Returns: RemoteConfigValue o null
  RemoteConfigValue? getValue(String key) {
    try {
      return _remoteConfig.getAll()[key];
    } catch (e) {
      debugPrint('Error al obtener valor $key: $e');
      return null;
    }
  }

  /// Enseguida fetch (útil para testing)
  /// 
  /// Ignora el intervalo mínimo de fetch
  Future<void> ensureInitialized() async {
    try {
      await _remoteConfig.ensureInitialized();
    } catch (e) {
      debugPrint('Error en ensureInitialized: $e');
    }
  }
}
