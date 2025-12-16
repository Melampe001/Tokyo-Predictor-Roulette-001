/// Servicio de análisis y tracking de eventos
/// Centraliza el logging de eventos para analytics
class AnalyticsService {
  final List<Map<String, dynamic>> _events = [];
  
  /// Registra un evento genérico
  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final event = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters ?? {},
    };
    
    _events.add(event);
    
    // TODO: Integrar con Firebase Analytics cuando esté configurado
    // FirebaseAnalytics.instance.logEvent(
    //   name: eventName,
    //   parameters: parameters,
    // );
    
    // Log para debugging (remover en producción)
    // print('📊 Analytics: $eventName ${parameters != null ? '- $parameters' : ''}');
  }
  
  /// Registra un giro de ruleta
  void logSpin(int result, bool won, double betAmount) {
    logEvent('roulette_spin', parameters: {
      'result': result,
      'won': won,
      'bet_amount': betAmount,
    });
  }
  
  /// Registra un logro desbloqueado
  void logAchievementUnlocked(String achievementId) {
    logEvent('achievement_unlocked', parameters: {
      'achievement_id': achievementId,
    });
  }
  
  /// Registra un cambio de balance
  void logBalanceChange(double oldBalance, double newBalance) {
    logEvent('balance_changed', parameters: {
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'difference': newBalance - oldBalance,
    });
  }
  
  /// Registra el uso de estrategia Martingale
  void logMartingaleToggle(bool enabled) {
    logEvent('martingale_toggle', parameters: {
      'enabled': enabled,
    });
  }
  
  /// Registra apertura de pantalla
  void logScreenView(String screenName) {
    logEvent('screen_view', parameters: {
      'screen_name': screenName,
    });
  }
  
  /// Obtiene todos los eventos registrados (para debugging)
  List<Map<String, dynamic>> getEvents() => List.unmodifiable(_events);
  
  /// Limpia el historial de eventos
  void clearEvents() {
    _events.clear();
  }
  
  /// Obtiene estadísticas de eventos
  Map<String, int> getEventCounts() {
    final counts = <String, int>{};
    for (final event in _events) {
      final name = event['event'] as String;
      counts[name] = (counts[name] ?? 0) + 1;
    }
    return counts;
  }
}
