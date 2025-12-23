import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Service for handling Firebase Analytics
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ==================== Event Names ====================
  static const String eventAppOpen = 'app_open';
  static const String eventUserSignup = 'user_signup';
  static const String eventUserLogin = 'user_login';
  static const String eventPredictionMade = 'prediction_made';
  static const String eventPredictionResult = 'prediction_result';
  static const String eventGameSessionStart = 'game_session_start';
  static const String eventGameSessionEnd = 'game_session_end';
  static const String eventScreenView = 'screen_view';
  static const String eventShareApp = 'share_app';
  static const String eventSettingsChanged = 'settings_changed';

  // ==================== User Properties ====================
  static const String propertyTotalPredictions = 'total_predictions';
  static const String propertyWinRate = 'win_rate';
  static const String propertyAccountAge = 'account_age_days';
  static const String propertyPreferredTheme = 'preferred_theme';
  static const String propertyNotificationsEnabled = 'notifications_enabled';

  // ==================== Event Tracking ====================

  /// Log app open event
  Future<void> logAppOpen() async {
    try {
      await _analytics.logEvent(name: eventAppOpen);

      if (kDebugMode) {
        print('Analytics: App opened');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log user signup event
  Future<void> logUserSignup({
    required String method,
    String? userId,
  }) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);

      if (userId != null) {
        await setUserId(userId);
      }

      if (kDebugMode) {
        print('Analytics: User signed up via $method');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log user login event
  Future<void> logUserLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);

      if (kDebugMode) {
        print('Analytics: User logged in via $method');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log prediction made event
  Future<void> logPredictionMade({
    required int predictedNumber,
    required double betAmount,
    String? sessionId,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventPredictionMade,
        parameters: {
          'predicted_number': predictedNumber,
          'bet_amount': betAmount,
          if (sessionId != null) 'session_id': sessionId,
        },
      );

      if (kDebugMode) {
        print(
            'Analytics: Prediction made - Number: $predictedNumber, Bet: $betAmount');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log prediction result event
  Future<void> logPredictionResult({
    required int predictedNumber,
    required int actualNumber,
    required bool isWin,
    required double betAmount,
    double? winAmount,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventPredictionResult,
        parameters: {
          'predicted_number': predictedNumber,
          'actual_number': actualNumber,
          'is_win': isWin,
          'bet_amount': betAmount,
          if (winAmount != null) 'win_amount': winAmount,
        },
      );

      if (kDebugMode) {
        print(
            'Analytics: Prediction result - Win: $isWin, Amount: $betAmount');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log game session start event
  Future<void> logGameSessionStart({
    required String sessionId,
    required double startingBalance,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventGameSessionStart,
        parameters: {
          'session_id': sessionId,
          'starting_balance': startingBalance,
        },
      );

      if (kDebugMode) {
        print(
            'Analytics: Game session started - ID: $sessionId, Balance: $startingBalance');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log game session end event
  Future<void> logGameSessionEnd({
    required String sessionId,
    required double startingBalance,
    required double endingBalance,
    required int totalBets,
    required int totalWins,
    required int totalLosses,
    required double winRate,
    required int durationSeconds,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventGameSessionEnd,
        parameters: {
          'session_id': sessionId,
          'starting_balance': startingBalance,
          'ending_balance': endingBalance,
          'total_bets': totalBets,
          'total_wins': totalWins,
          'total_losses': totalLosses,
          'win_rate': winRate,
          'duration_seconds': durationSeconds,
          'profit_loss': endingBalance - startingBalance,
        },
      );

      if (kDebugMode) {
        print(
            'Analytics: Game session ended - Win rate: $winRate, Duration: $durationSeconds s');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log screen view event
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      if (kDebugMode) {
        print('Analytics: Screen viewed - $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log share app event
  Future<void> logShareApp({
    required String method,
    String? contentType,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType ?? 'app',
        itemId: 'tokyo_roulette_app',
        method: method,
      );

      if (kDebugMode) {
        print('Analytics: App shared via $method');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Log settings changed event
  Future<void> logSettingsChanged({
    required String settingName,
    required dynamic newValue,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventSettingsChanged,
        parameters: {
          'setting_name': settingName,
          'new_value': newValue.toString(),
        },
      );

      if (kDebugMode) {
        print('Analytics: Settings changed - $settingName: $newValue');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  // ==================== User Properties ====================

  /// Set user ID
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);

      if (kDebugMode) {
        print('Analytics: User ID set - $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set user property for total predictions
  Future<void> setTotalPredictions(int count) async {
    try {
      await _analytics.setUserProperty(
        name: propertyTotalPredictions,
        value: count.toString(),
      );

      if (kDebugMode) {
        print('Analytics: Total predictions set - $count');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set user property for win rate
  Future<void> setWinRate(double rate) async {
    try {
      await _analytics.setUserProperty(
        name: propertyWinRate,
        value: rate.toStringAsFixed(2),
      );

      if (kDebugMode) {
        print('Analytics: Win rate set - $rate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set user property for account age
  Future<void> setAccountAge(int days) async {
    try {
      await _analytics.setUserProperty(
        name: propertyAccountAge,
        value: days.toString(),
      );

      if (kDebugMode) {
        print('Analytics: Account age set - $days days');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set user property for preferred theme
  Future<void> setPreferredTheme(String theme) async {
    try {
      await _analytics.setUserProperty(
        name: propertyPreferredTheme,
        value: theme,
      );

      if (kDebugMode) {
        print('Analytics: Preferred theme set - $theme');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set user property for notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      await _analytics.setUserProperty(
        name: propertyNotificationsEnabled,
        value: enabled.toString(),
      );

      if (kDebugMode) {
        print('Analytics: Notifications enabled set - $enabled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Set multiple user properties at once
  Future<void> setUserProperties(Map<String, String> properties) async {
    try {
      for (final entry in properties.entries) {
        await _analytics.setUserProperty(
          name: entry.key,
          value: entry.value,
        );
      }

      if (kDebugMode) {
        print('Analytics: ${properties.length} user properties set');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Reset analytics data (useful for sign out)
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.setUserId(id: null);
      await _analytics.resetAnalyticsData();

      if (kDebugMode) {
        print('Analytics: Data reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Get analytics observer for navigation tracking
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
