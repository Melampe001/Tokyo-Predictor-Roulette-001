import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Servicio de Analytics de Firebase
/// 
/// Rastrea eventos y comportamiento del usuario para análisis
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  /// Obtener observador de navegación para tracking automático de pantallas
  FirebaseAnalyticsObserver get navigationObserver {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // ==================== CONFIGURACIÓN DE USUARIO ====================

  /// Establecer ID de usuario para análisis
  /// 
  /// [userId] ID único del usuario (típicamente Firebase Auth UID)
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint('Error al establecer userId: $e');
    }
  }

  /// Establecer propiedad de usuario
  /// 
  /// [name] Nombre de la propiedad
  /// [value] Valor de la propiedad
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Error al establecer propiedad de usuario: $e');
    }
  }

  // ==================== EVENTOS DE PANTALLA ====================

  /// Registrar vista de pantalla
  /// 
  /// [screenName] Nombre de la pantalla
  /// [screenClass] Clase de la pantalla (opcional)
  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      debugPrint('Error al registrar vista de pantalla: $e');
    }
  }

  // ==================== EVENTOS DE AUTENTICACIÓN ====================

  /// Registrar evento de registro de usuario
  /// 
  /// [method] Método de registro (email, google, anonymous)
  Future<void> logSignUp(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (e) {
      debugPrint('Error al registrar sign up: $e');
    }
  }

  /// Registrar evento de inicio de sesión
  /// 
  /// [method] Método de inicio de sesión (email, google, anonymous)
  Future<void> logLogin(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      debugPrint('Error al registrar login: $e');
    }
  }

  // ==================== EVENTOS DEL JUEGO ====================

  /// Registrar inicio de sesión de juego
  Future<void> logGameSessionStart() async {
    try {
      await logEvent('game_session_start', parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error al registrar inicio de sesión: $e');
    }
  }

  /// Registrar fin de sesión de juego
  /// 
  /// [duration] Duración de la sesión en segundos
  /// [predictions] Número de predicciones realizadas
  /// [wins] Número de victorias
  /// [losses] Número de derrotas
  Future<void> logGameSessionEnd({
    required int duration,
    required int predictions,
    required int wins,
    required int losses,
  }) async {
    try {
      await logEvent('game_session_end', parameters: {
        'duration_seconds': duration,
        'total_predictions': predictions,
        'wins': wins,
        'losses': losses,
        'win_rate': predictions > 0 ? (wins / predictions * 100).toStringAsFixed(2) : '0',
      });
    } catch (e) {
      debugPrint('Error al registrar fin de sesión: $e');
    }
  }

  /// Registrar predicción realizada
  /// 
  /// [number] Número predicho
  /// [amount] Cantidad apostada
  /// [predictionMethod] Método usado para la predicción
  Future<void> logPrediction({
    required int number,
    required double amount,
    String predictionMethod = 'manual',
  }) async {
    try {
      await logEvent('prediction_made', parameters: {
        'predicted_number': number,
        'bet_amount': amount,
        'prediction_method': predictionMethod,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error al registrar predicción: $e');
    }
  }

  /// Registrar giro de ruleta
  /// 
  /// [result] Número que salió
  /// [predicted] Número que se había predicho (opcional)
  Future<void> logRouletteSpin({
    required int result,
    int? predicted,
  }) async {
    try {
      await logEvent('roulette_spin', parameters: {
        'result_number': result,
        if (predicted != null) 'predicted_number': predicted,
        if (predicted != null) 'was_correct': result == predicted,
      });
    } catch (e) {
      debugPrint('Error al registrar giro: $e');
    }
  }

  /// Registrar resultado del juego
  /// 
  /// [won] Si ganó o perdió
  /// [amount] Cantidad ganada o perdida
  /// [predictedNumber] Número predicho
  /// [resultNumber] Número que salió
  Future<void> logGameResult({
    required bool won,
    required double amount,
    int? predictedNumber,
    int? resultNumber,
  }) async {
    try {
      await logEvent('game_result', parameters: {
        'result': won ? 'win' : 'loss',
        'amount': amount,
        if (predictedNumber != null) 'predicted_number': predictedNumber,
        if (resultNumber != null) 'result_number': resultNumber,
      });
      
      // También registrar eventos específicos de victoria/derrota
      if (won) {
        await logEvent('player_win', parameters: {
          'win_amount': amount,
        });
      } else {
        await logEvent('player_loss', parameters: {
          'loss_amount': amount,
        });
      }
    } catch (e) {
      debugPrint('Error al registrar resultado: $e');
    }
  }

  // ==================== EVENTOS DE ESTRATEGIA ====================

  /// Registrar activación de estrategia Martingale
  /// 
  /// [enabled] Si se activó o desactivó
  /// [baseBet] Apuesta base
  Future<void> logMartingaleToggle({
    required bool enabled,
    required double baseBet,
  }) async {
    try {
      await logEvent('martingale_toggle', parameters: {
        'enabled': enabled,
        'base_bet': baseBet,
      });
    } catch (e) {
      debugPrint('Error al registrar toggle de Martingale: $e');
    }
  }

  /// Registrar apuesta de Martingale
  /// 
  /// [betAmount] Cantidad de la apuesta
  /// [consecutiveLosses] Número de pérdidas consecutivas
  Future<void> logMartingaleBet({
    required double betAmount,
    required int consecutiveLosses,
  }) async {
    try {
      await logEvent('martingale_bet', parameters: {
        'bet_amount': betAmount,
        'consecutive_losses': consecutiveLosses,
      });
    } catch (e) {
      debugPrint('Error al registrar apuesta Martingale: $e');
    }
  }

  // ==================== EVENTOS DE CONFIGURACIÓN ====================

  /// Registrar cambio de configuración
  /// 
  /// [setting] Nombre de la configuración
  /// [value] Nuevo valor
  Future<void> logSettingChanged(String setting, dynamic value) async {
    try {
      await logEvent('setting_changed', parameters: {
        'setting_name': setting,
        'new_value': value.toString(),
      });
    } catch (e) {
      debugPrint('Error al registrar cambio de configuración: $e');
    }
  }

  // ==================== EVENTOS DE MONETIZACIÓN ====================

  /// Registrar compra in-app
  /// 
  /// [itemId] ID del producto
  /// [itemName] Nombre del producto
  /// [price] Precio
  /// [currency] Moneda
  Future<void> logPurchase({
    required String itemId,
    required String itemName,
    required double price,
    String currency = 'USD',
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            price: price,
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error al registrar compra: $e');
    }
  }

  /// Registrar inicio de proceso de compra
  /// 
  /// [itemId] ID del producto
  /// [itemName] Nombre del producto
  Future<void> logBeginCheckout({
    required String itemId,
    required String itemName,
  }) async {
    try {
      await _analytics.logBeginCheckout(
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error al registrar inicio de checkout: $e');
    }
  }

  // ==================== EVENTOS DE ENGAGEMENT ====================

  /// Registrar apertura de la app
  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (e) {
      debugPrint('Error al registrar apertura de app: $e');
    }
  }

  /// Registrar tutorial comenzado
  Future<void> logTutorialBegin() async {
    try {
      await _analytics.logTutorialBegin();
    } catch (e) {
      debugPrint('Error al registrar inicio de tutorial: $e');
    }
  }

  /// Registrar tutorial completado
  Future<void> logTutorialComplete() async {
    try {
      await _analytics.logTutorialComplete();
    } catch (e) {
      debugPrint('Error al registrar fin de tutorial: $e');
    }
  }

  /// Registrar compartir contenido
  /// 
  /// [contentType] Tipo de contenido
  /// [itemId] ID del item
  /// [method] Método usado para compartir
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method,
      );
    } catch (e) {
      debugPrint('Error al registrar compartir: $e');
    }
  }

  // ==================== EVENTOS PERSONALIZADOS ====================

  /// Registrar evento personalizado
  /// 
  /// [name] Nombre del evento (máximo 40 caracteres)
  /// [parameters] Parámetros del evento (opcional, máximo 25 parámetros)
  Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Error al registrar evento: $e');
    }
  }

  // ==================== EVENTOS DE ERRORES Y DEBUGGING ====================

  /// Registrar error en la app
  /// 
  /// [errorMessage] Mensaje de error
  /// [errorCode] Código de error (opcional)
  /// [fatal] Si el error es fatal
  Future<void> logError({
    required String errorMessage,
    String? errorCode,
    bool fatal = false,
  }) async {
    try {
      await logEvent('app_error', parameters: {
        'error_message': errorMessage,
        if (errorCode != null) 'error_code': errorCode,
        'fatal': fatal,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error al registrar error: $e');
    }
  }

  // ==================== UTILIDADES ====================

  /// Resetear datos de Analytics
  /// Útil para testing o cuando el usuario cierra sesión
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
    } catch (e) {
      debugPrint('Error al resetear datos de Analytics: $e');
    }
  }

  /// Establecer si se debe recopilar Analytics (GDPR compliance)
  /// 
  /// [enabled] Si se debe recopilar o no
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      debugPrint('Error al establecer recopilación de Analytics: $e');
    }
  }
}
