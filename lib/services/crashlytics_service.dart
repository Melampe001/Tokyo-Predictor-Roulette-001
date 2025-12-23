import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterError, kDebugMode;

/// Service for handling Firebase Crashlytics
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  bool _isInitialized = false;

  /// Initialize Crashlytics
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Enable crashlytics collection
      await _crashlytics.setCrashlyticsCollectionEnabled(true);

      // Pass Flutter errors to Crashlytics
      FlutterError.onError = (FlutterErrorDetails details) {
        _crashlytics.recordFlutterFatalError(details);
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
      };

      // Catch async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      _isInitialized = true;

      if (kDebugMode) {
        print('Crashlytics initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Crashlytics initialization error: $e');
      }
    }
  }

  /// Log a custom error
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      if (kDebugMode) {
        print('Error logged to Crashlytics: $exception');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log error to Crashlytics: $e');
      }
    }
  }

  /// Log a Flutter error
  Future<void> logFlutterError(FlutterErrorDetails details) async {
    try {
      await _crashlytics.recordFlutterError(details);

      if (kDebugMode) {
        print('Flutter error logged to Crashlytics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log Flutter error to Crashlytics: $e');
      }
    }
  }

  /// Log a custom message
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);

      if (kDebugMode) {
        print('Log sent to Crashlytics: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send log to Crashlytics: $e');
      }
    }
  }

  /// Set user identifier
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);

      if (kDebugMode) {
        print('User ID set in Crashlytics: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user ID in Crashlytics: $e');
      }
    }
  }

  /// Set custom key
  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      if (value is String) {
        await _crashlytics.setCustomKey(key, value);
      } else if (value is int) {
        await _crashlytics.setCustomKey(key, value);
      } else if (value is double) {
        await _crashlytics.setCustomKey(key, value);
      } else if (value is bool) {
        await _crashlytics.setCustomKey(key, value);
      } else {
        await _crashlytics.setCustomKey(key, value.toString());
      }

      if (kDebugMode) {
        print('Custom key set in Crashlytics: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set custom key in Crashlytics: $e');
      }
    }
  }

  /// Set multiple custom keys
  Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Check if crashlytics is enabled
  Future<bool> isCrashlyticsCollectionEnabled() async {
    return await _crashlytics.isCrashlyticsCollectionEnabled();
  }

  /// Send unhandled crash report (for testing)
  Future<void> testCrash() async {
    if (kDebugMode) {
      print('⚠️ WARNING: This will crash the app for testing purposes');
    }
    _crashlytics.crash();
  }

  /// Check if fatal crash occurred on previous session
  Future<bool> didCrashOnPreviousExecution() async {
    return await _crashlytics.didCrashOnPreviousExecution();
  }

  /// Send unsent crash reports
  Future<void> sendUnsentReports() async {
    try {
      await _crashlytics.sendUnsentReports();

      if (kDebugMode) {
        print('Unsent crash reports sent');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send unsent reports: $e');
      }
    }
  }

  /// Delete unsent crash reports
  Future<void> deleteUnsentReports() async {
    try {
      await _crashlytics.deleteUnsentReports();

      if (kDebugMode) {
        print('Unsent crash reports deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete unsent reports: $e');
      }
    }
  }

  /// Record specific game session error
  Future<void> logGameError(
    String errorType,
    String message, {
    int? predictedNumber,
    int? actualNumber,
    double? betAmount,
  }) async {
    try {
      await log('Game Error: $errorType - $message');
      
      if (predictedNumber != null) {
        await setCustomKey('predicted_number', predictedNumber);
      }
      if (actualNumber != null) {
        await setCustomKey('actual_number', actualNumber);
      }
      if (betAmount != null) {
        await setCustomKey('bet_amount', betAmount);
      }

      await logError(
        Exception('Game Error: $errorType'),
        StackTrace.current,
        reason: message,
        fatal: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log game error: $e');
      }
    }
  }

  /// Record authentication error
  Future<void> logAuthError(String message, dynamic exception) async {
    try {
      await log('Auth Error: $message');
      await setCustomKey('auth_error_type', message);
      await logError(
        exception,
        StackTrace.current,
        reason: 'Authentication Error: $message',
        fatal: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log auth error: $e');
      }
    }
  }

  /// Record Firestore error
  Future<void> logFirestoreError(String operation, dynamic exception) async {
    try {
      await log('Firestore Error: $operation');
      await setCustomKey('firestore_operation', operation);
      await logError(
        exception,
        StackTrace.current,
        reason: 'Firestore Error: $operation',
        fatal: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log Firestore error: $e');
      }
    }
  }
}

// Add this import at the top of the file
import 'dart:ui' show PlatformDispatcher;
