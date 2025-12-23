import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Servicio de Crashlytics de Firebase
/// 
/// Captura y reporta crashes y errores no fatales
/// Ayuda a identificar y resolver problemas en producción
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Inicializar Crashlytics
  /// 
  /// Debe llamarse al inicio de la app
  /// Configura handlers de errores y ajustes
  Future<void> initialize() async {
    try {
      // Habilitar Crashlytics solo en modo release
      // En debug, los errores se muestran en la consola
      await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      
      // Configurar FlutterError para reportar errores de Flutter
      FlutterError.onError = (FlutterErrorDetails details) {
        // Reportar a Crashlytics
        _crashlytics.recordFlutterFatalError(details);
        
        // También imprimir en consola en desarrollo
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
      };
      
      // Capturar errores asíncronos no manejados
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
      
      debugPrint('Crashlytics inicializado');
    } catch (e) {
      debugPrint('Error al inicializar Crashlytics: $e');
    }
  }

  // ==================== REPORTAR ERRORES ====================

  /// Reportar error no fatal
  /// 
  /// [error] El error a reportar
  /// [stackTrace] Stack trace del error (opcional)
  /// [reason] Descripción del contexto del error (opcional)
  /// [fatal] Si el error debe considerarse fatal (default: false)
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
        printDetails: kDebugMode,
      );
      
      if (kDebugMode) {
        debugPrint('Error reportado a Crashlytics:');
        debugPrint('Error: $error');
        debugPrint('Stack: $stackTrace');
        if (reason != null) debugPrint('Razón: $reason');
      }
    } catch (e) {
      debugPrint('Error al reportar error a Crashlytics: $e');
    }
  }

  /// Reportar excepción de Flutter
  /// 
  /// [details] Detalles del error de Flutter
  /// [fatal] Si el error debe considerarse fatal (default: true)
  Future<void> recordFlutterError(
    FlutterErrorDetails details, {
    bool fatal = true,
  }) async {
    try {
      if (fatal) {
        await _crashlytics.recordFlutterFatalError(details);
      } else {
        await _crashlytics.recordFlutterError(details);
      }
    } catch (e) {
      debugPrint('Error al reportar Flutter error: $e');
    }
  }

  // ==================== LOGGING ====================

  /// Registrar mensaje de log
  /// 
  /// Logs se incluyen en reportes de crash para contexto
  /// Máximo 64KB de logs por sesión
  /// 
  /// [message] Mensaje a registrar
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      
      if (kDebugMode) {
        debugPrint('Crashlytics log: $message');
      }
    } catch (e) {
      debugPrint('Error al registrar log: $e');
    }
  }

  /// Registrar evento con timestamp
  /// 
  /// [event] Nombre del evento
  /// [data] Datos adicionales (opcional)
  Future<void> logEvent(String event, [Map<String, dynamic>? data]) async {
    final timestamp = DateTime.now().toIso8601String();
    final message = data != null
        ? '$timestamp - $event: ${data.toString()}'
        : '$timestamp - $event';
    
    await log(message);
  }

  // ==================== INFORMACIÓN DEL USUARIO ====================

  /// Establecer ID de usuario
  /// 
  /// [userId] ID único del usuario (típicamente Firebase Auth UID)
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      debugPrint('User ID establecido en Crashlytics: $userId');
    } catch (e) {
      debugPrint('Error al establecer user ID: $e');
    }
  }

  /// Limpiar ID de usuario (útil al cerrar sesión)
  Future<void> clearUserId() async {
    try {
      await _crashlytics.setUserIdentifier('');
      debugPrint('User ID limpiado de Crashlytics');
    } catch (e) {
      debugPrint('Error al limpiar user ID: $e');
    }
  }

  // ==================== CUSTOM KEYS ====================

  /// Establecer clave personalizada (String)
  /// 
  /// [key] Nombre de la clave
  /// [value] Valor
  Future<void> setCustomKey(String key, String value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error al establecer custom key: $e');
    }
  }

  /// Establecer clave personalizada (int)
  /// 
  /// [key] Nombre de la clave
  /// [value] Valor
  Future<void> setCustomKeyInt(String key, int value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error al establecer custom key int: $e');
    }
  }

  /// Establecer clave personalizada (double)
  /// 
  /// [key] Nombre de la clave
  /// [value] Valor
  Future<void> setCustomKeyDouble(String key, double value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error al establecer custom key double: $e');
    }
  }

  /// Establecer clave personalizada (bool)
  /// 
  /// [key] Nombre de la clave
  /// [value] Valor
  Future<void> setCustomKeyBool(String key, bool value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error al establecer custom key bool: $e');
    }
  }

  /// Establecer múltiples claves personalizadas
  /// 
  /// [keys] Mapa de claves y valores
  Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    try {
      for (final entry in keys.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    } catch (e) {
      debugPrint('Error al establecer custom keys: $e');
    }
  }

  // ==================== CONTEXTO DE SESIÓN ====================

  /// Establecer información de sesión de juego
  /// 
  /// [sessionId] ID de la sesión
  /// [balance] Balance actual
  /// [predictions] Número de predicciones
  Future<void> setGameSessionContext({
    required String sessionId,
    required double balance,
    required int predictions,
  }) async {
    await setCustomKeys({
      'game_session_id': sessionId,
      'current_balance': balance,
      'total_predictions': predictions,
    });
  }

  /// Establecer información de apuesta actual
  /// 
  /// [betAmount] Cantidad de la apuesta
  /// [predictedNumber] Número predicho
  /// [usingMartingale] Si usa estrategia Martingale
  Future<void> setBetContext({
    required double betAmount,
    required int predictedNumber,
    required bool usingMartingale,
  }) async {
    await setCustomKeys({
      'current_bet': betAmount,
      'predicted_number': predictedNumber,
      'using_martingale': usingMartingale,
    });
  }

  // ==================== TESTING ====================

  /// Forzar un crash (solo para testing)
  /// 
  /// ADVERTENCIA: Esto cerrará la app inmediatamente
  /// Solo usar en desarrollo para probar Crashlytics
  void forceCrash() {
    if (kDebugMode) {
      debugPrint('Forzando crash para testing...');
    }
    _crashlytics.crash();
  }

  /// Simular error no fatal (para testing)
  Future<void> simulateError() async {
    try {
      throw Exception('Este es un error de prueba para Crashlytics');
    } catch (error, stackTrace) {
      await recordError(
        error,
        stackTrace,
        reason: 'Test error simulado',
        fatal: false,
      );
    }
  }

  // ==================== CONFIGURACIÓN ====================

  /// Habilitar o deshabilitar recopilación de Crashlytics
  /// 
  /// [enabled] Si se debe recopilar o no
  /// Útil para cumplir con GDPR o preferencias del usuario
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      debugPrint('Recopilación de Crashlytics: $enabled');
    } catch (e) {
      debugPrint('Error al configurar recopilación: $e');
    }
  }

  /// Verificar si Crashlytics está habilitado
  /// 
  /// Returns: true si está habilitado
  Future<bool> isCrashlyticsCollectionEnabled() async {
    try {
      return await _crashlytics.isCrashlyticsCollectionEnabled();
    } catch (e) {
      debugPrint('Error al verificar estado de Crashlytics: $e');
      return false;
    }
  }

  /// Verificar si hay un reporte de crash no enviado
  /// 
  /// Returns: true si hay reportes pendientes
  Future<bool> checkForUnsentReports() async {
    try {
      return await _crashlytics.checkForUnsentReports();
    } catch (e) {
      debugPrint('Error al verificar reportes no enviados: $e');
      return false;
    }
  }

  /// Enviar reportes no enviados
  Future<void> sendUnsentReports() async {
    try {
      await _crashlytics.sendUnsentReports();
      debugPrint('Reportes no enviados enviados');
    } catch (e) {
      debugPrint('Error al enviar reportes: $e');
    }
  }

  /// Eliminar reportes no enviados
  Future<void> deleteUnsentReports() async {
    try {
      await _crashlytics.deleteUnsentReports();
      debugPrint('Reportes no enviados eliminados');
    } catch (e) {
      debugPrint('Error al eliminar reportes: $e');
    }
  }

  // ==================== UTILIDADES ====================

  /// Wrapper para ejecutar código con manejo de errores
  /// 
  /// [function] Función a ejecutar
  /// [errorContext] Contexto del error para logging
  /// Returns: Resultado de la función o null si hay error
  Future<T?> runProtected<T>(
    Future<T> Function() function, {
    String? errorContext,
  }) async {
    try {
      return await function();
    } catch (error, stackTrace) {
      await recordError(
        error,
        stackTrace,
        reason: errorContext ?? 'Error en operación protegida',
        fatal: false,
      );
      return null;
    }
  }

  /// Wrapper sincrónico para ejecutar código con manejo de errores
  /// 
  /// [function] Función a ejecutar
  /// [errorContext] Contexto del error para logging
  /// Returns: Resultado de la función o null si hay error
  T? runProtectedSync<T>(
    T Function() function, {
    String? errorContext,
  }) {
    try {
      return function();
    } catch (error, stackTrace) {
      recordError(
        error,
        stackTrace,
        reason: errorContext ?? 'Error en operación protegida síncrona',
        fatal: false,
      );
      return null;
    }
  }
}
