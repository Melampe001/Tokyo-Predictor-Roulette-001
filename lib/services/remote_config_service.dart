import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Service for handling Firebase Remote Config
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // ==================== Config Keys ====================
  static const String keyMinBetAmount = 'min_bet_amount';
  static const String keyMaxBetAmount = 'max_bet_amount';
  static const String keyFeatureFlags = 'feature_flags';
  static const String keyMaintenanceMode = 'maintenance_mode';
  static const String keyPromotionMessage = 'promotion_message';
  static const String keySupportedNumbers = 'supported_numbers';
  static const String keyPredictionCooldown = 'prediction_cooldown';
  static const String keyInitialBalance = 'initial_balance';
  static const String keyMaxHistorySize = 'max_history_size';
  static const String keyEnableMartingale = 'enable_martingale';
  static const String keyEnableGoogleSignIn = 'enable_google_sign_in';
  static const String keyEnableAnonymousAuth = 'enable_anonymous_auth';

  // ==================== Default Values ====================
  static const Map<String, dynamic> _defaultValues = {
    keyMinBetAmount: 1.0,
    keyMaxBetAmount: 1000.0,
    keyFeatureFlags: '{}',
    keyMaintenanceMode: false,
    keyPromotionMessage: '',
    keySupportedNumbers: '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36',
    keyPredictionCooldown: 0,
    keyInitialBalance: 1000.0,
    keyMaxHistorySize: 20,
    keyEnableMartingale: true,
    keyEnableGoogleSignIn: true,
    keyEnableAnonymousAuth: true,
  };

  bool _isInitialized = false;

  /// Initialize Remote Config with defaults
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set config settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 4), // 4 months / 30 = ~4 hours for testing
      ));

      // Set default values
      await _remoteConfig.setDefaults(_defaultValues);

      // Fetch and activate
      await fetchAndActivate();

      _isInitialized = true;

      if (kDebugMode) {
        print('Remote Config initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config initialization error: $e');
      }
      // Continue with defaults if initialization fails
      _isInitialized = true;
    }
  }

  /// Fetch and activate remote config
  Future<bool> fetchAndActivate() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();

      if (kDebugMode) {
        print('Remote Config fetched and activated: $activated');
      }

      return activated;
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config fetch error: $e');
      }
      return false;
    }
  }

  /// Force fetch config (ignores cache)
  Future<void> forceFetch() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration.zero,
      ));

      await _remoteConfig.fetchAndActivate();

      // Restore normal fetch interval
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 4),
      ));

      if (kDebugMode) {
        print('Remote Config force fetched');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config force fetch error: $e');
      }
    }
  }

  // ==================== Getters ====================

  /// Get minimum bet amount
  double get minBetAmount {
    return _remoteConfig.getDouble(keyMinBetAmount);
  }

  /// Get maximum bet amount
  double get maxBetAmount {
    return _remoteConfig.getDouble(keyMaxBetAmount);
  }

  /// Get feature flags as Map
  Map<String, dynamic> get featureFlags {
    try {
      final flagsString = _remoteConfig.getString(keyFeatureFlags);
      // In a real implementation, you'd parse JSON here
      // For simplicity, returning empty map
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Check if app is in maintenance mode
  bool get isMaintenanceMode {
    return _remoteConfig.getBool(keyMaintenanceMode);
  }

  /// Get promotion message
  String get promotionMessage {
    return _remoteConfig.getString(keyPromotionMessage);
  }

  /// Get supported numbers as list
  List<int> get supportedNumbers {
    try {
      final numbersString = _remoteConfig.getString(keySupportedNumbers);
      return numbersString
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .where((n) => n != null)
          .cast<int>()
          .toList();
    } catch (e) {
      return List.generate(37, (i) => i); // 0-36 default
    }
  }

  /// Get prediction cooldown in seconds
  int get predictionCooldown {
    return _remoteConfig.getInt(keyPredictionCooldown);
  }

  /// Get initial balance
  double get initialBalance {
    return _remoteConfig.getDouble(keyInitialBalance);
  }

  /// Get max history size
  int get maxHistorySize {
    return _remoteConfig.getInt(keyMaxHistorySize);
  }

  /// Check if Martingale strategy is enabled
  bool get isMartingaleEnabled {
    return _remoteConfig.getBool(keyEnableMartingale);
  }

  /// Check if Google Sign-In is enabled
  bool get isGoogleSignInEnabled {
    return _remoteConfig.getBool(keyEnableGoogleSignIn);
  }

  /// Check if anonymous auth is enabled
  bool get isAnonymousAuthEnabled {
    return _remoteConfig.getBool(keyEnableAnonymousAuth);
  }

  /// Get all config values as map
  Map<String, dynamic> getAllConfig() {
    return {
      keyMinBetAmount: minBetAmount,
      keyMaxBetAmount: maxBetAmount,
      keyFeatureFlags: featureFlags,
      keyMaintenanceMode: isMaintenanceMode,
      keyPromotionMessage: promotionMessage,
      keySupportedNumbers: supportedNumbers,
      keyPredictionCooldown: predictionCooldown,
      keyInitialBalance: initialBalance,
      keyMaxHistorySize: maxHistorySize,
      keyEnableMartingale: isMartingaleEnabled,
      keyEnableGoogleSignIn: isGoogleSignInEnabled,
      keyEnableAnonymousAuth: isAnonymousAuthEnabled,
    };
  }

  /// Get config value by key (generic)
  dynamic getValue(String key) {
    final value = _remoteConfig.getValue(key);
    
    switch (value.source) {
      case ValueSource.valueRemote:
        if (kDebugMode) {
          print('Config $key from remote: ${value.asString()}');
        }
        break;
      case ValueSource.valueDefault:
        if (kDebugMode) {
          print('Config $key from default: ${value.asString()}');
        }
        break;
      case ValueSource.valueStatic:
        if (kDebugMode) {
          print('Config $key is static: ${value.asString()}');
        }
        break;
    }

    return value;
  }

  /// Listen to config updates
  Stream<RemoteConfigUpdate> get onConfigUpdated {
    return _remoteConfig.onConfigUpdated;
  }

  /// Activate config updates manually
  Future<bool> activate() async {
    try {
      final activated = await _remoteConfig.activate();

      if (kDebugMode) {
        print('Remote Config activated: $activated');
      }

      return activated;
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config activation error: $e');
      }
      return false;
    }
  }

  /// Get last fetch time
  DateTime get lastFetchTime {
    return _remoteConfig.lastFetchTime;
  }

  /// Get last fetch status
  RemoteConfigFetchStatus get lastFetchStatus {
    return _remoteConfig.lastFetchStatus;
  }
}
