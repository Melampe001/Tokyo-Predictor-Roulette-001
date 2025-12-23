/// Estadísticas de usuario para Tokyo Roulette Predictor
/// 
/// Contiene estadísticas agregadas y métricas de rendimiento
class UserStats {
  final int totalPredictions;
  final int totalWins;
  final int totalLosses;
  final double totalBetAmount;
  final double totalWinnings;
  final double netProfit;
  final int totalSessions;
  final int activeDays;
  final DateTime? lastPlayed;
  final DateTime? firstPlayed;
  final Map<String, dynamic> achievements;
  final Map<String, int> numberFrequency;
  final Map<String, int> colorFrequency;

  UserStats({
    this.totalPredictions = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalBetAmount = 0.0,
    this.totalWinnings = 0.0,
    this.netProfit = 0.0,
    this.totalSessions = 0,
    this.activeDays = 0,
    this.lastPlayed,
    this.firstPlayed,
    Map<String, dynamic>? achievements,
    Map<String, int>? numberFrequency,
    Map<String, int>? colorFrequency,
  })  : achievements = achievements ?? {},
        numberFrequency = numberFrequency ?? {},
        colorFrequency = colorFrequency ?? {};

  /// Crear instancia desde Map
  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalPredictions: map['totalPredictions'] as int? ?? 0,
      totalWins: map['totalWins'] as int? ?? 0,
      totalLosses: map['totalLosses'] as int? ?? 0,
      totalBetAmount: (map['totalBetAmount'] as num?)?.toDouble() ?? 0.0,
      totalWinnings: (map['totalWinnings'] as num?)?.toDouble() ?? 0.0,
      netProfit: (map['netProfit'] as num?)?.toDouble() ?? 0.0,
      totalSessions: map['totalSessions'] as int? ?? 0,
      activeDays: map['activeDays'] as int? ?? 0,
      lastPlayed: map['lastPlayed'] is String
          ? DateTime.parse(map['lastPlayed'] as String)
          : map['lastPlayed'] as DateTime?,
      firstPlayed: map['firstPlayed'] is String
          ? DateTime.parse(map['firstPlayed'] as String)
          : map['firstPlayed'] as DateTime?,
      achievements: map['achievements'] as Map<String, dynamic>? ?? {},
      numberFrequency: _parseIntMap(map['numberFrequency']),
      colorFrequency: _parseIntMap(map['colorFrequency']),
    );
  }

  /// Helper para parsear Map<String, dynamic> a Map<String, int>
  static Map<String, int> _parseIntMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, int>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    }
    return {};
  }

  /// Convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'totalPredictions': totalPredictions,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'totalBetAmount': totalBetAmount,
      'totalWinnings': totalWinnings,
      'netProfit': netProfit,
      'totalSessions': totalSessions,
      'activeDays': activeDays,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'firstPlayed': firstPlayed?.toIso8601String(),
      'achievements': achievements,
      'numberFrequency': numberFrequency,
      'colorFrequency': colorFrequency,
    };
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() => toMap();

  /// Crear copia con cambios
  UserStats copyWith({
    int? totalPredictions,
    int? totalWins,
    int? totalLosses,
    double? totalBetAmount,
    double? totalWinnings,
    double? netProfit,
    int? totalSessions,
    int? activeDays,
    DateTime? lastPlayed,
    DateTime? firstPlayed,
    Map<String, dynamic>? achievements,
    Map<String, int>? numberFrequency,
    Map<String, int>? colorFrequency,
  }) {
    return UserStats(
      totalPredictions: totalPredictions ?? this.totalPredictions,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      totalBetAmount: totalBetAmount ?? this.totalBetAmount,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      netProfit: netProfit ?? this.netProfit,
      totalSessions: totalSessions ?? this.totalSessions,
      activeDays: activeDays ?? this.activeDays,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      firstPlayed: firstPlayed ?? this.firstPlayed,
      achievements: achievements ?? this.achievements,
      numberFrequency: numberFrequency ?? this.numberFrequency,
      colorFrequency: colorFrequency ?? this.colorFrequency,
    );
  }

  // ==================== MÉTRICAS CALCULADAS ====================

  /// Calcular tasa de victorias (win rate) en porcentaje
  double get winRate {
    if (totalPredictions == 0) return 0.0;
    return (totalWins / totalPredictions) * 100;
  }

  /// Calcular tasa de pérdidas (loss rate) en porcentaje
  double get lossRate {
    if (totalPredictions == 0) return 0.0;
    return (totalLosses / totalPredictions) * 100;
  }

  /// Calcular ROI (Return on Investment) en porcentaje
  double get roi {
    if (totalBetAmount == 0) return 0.0;
    return (netProfit / totalBetAmount) * 100;
  }

  /// Promedio de apuesta por predicción
  double get averageBetAmount {
    if (totalPredictions == 0) return 0.0;
    return totalBetAmount / totalPredictions;
  }

  /// Promedio de ganancia por victoria
  double get averageWinAmount {
    if (totalWins == 0) return 0.0;
    return totalWinnings / totalWins;
  }

  /// Promedio de predicciones por sesión
  double get averagePredictionsPerSession {
    if (totalSessions == 0) return 0.0;
    return totalPredictions / totalSessions;
  }

  /// Verificar si el usuario tiene ganancias netas positivas
  bool get isProfitable {
    return netProfit > 0;
  }

  /// Obtener nivel de experiencia (basado en predicciones totales)
  int get experienceLevel {
    if (totalPredictions < 10) return 1; // Principiante
    if (totalPredictions < 50) return 2; // Novato
    if (totalPredictions < 100) return 3; // Intermedio
    if (totalPredictions < 500) return 4; // Avanzado
    if (totalPredictions < 1000) return 5; // Experto
    return 6; // Maestro
  }

  /// Obtener nombre del nivel de experiencia
  String get experienceLevelName {
    switch (experienceLevel) {
      case 1:
        return 'Principiante';
      case 2:
        return 'Novato';
      case 3:
        return 'Intermedio';
      case 4:
        return 'Avanzado';
      case 5:
        return 'Experto';
      case 6:
        return 'Maestro';
      default:
        return 'Desconocido';
    }
  }

  /// Obtener número más apostado
  String? get mostBetNumber {
    if (numberFrequency.isEmpty) return null;
    
    final sortedEntries = numberFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.first.key;
  }

  /// Obtener color más apostado
  String? get mostBetColor {
    if (colorFrequency.isEmpty) return null;
    
    final sortedEntries = colorFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.first.key;
  }

  /// Calcular racha actual de victorias
  int get currentWinStreak {
    // Esta métrica requeriría acceso al historial ordenado
    // Por ahora retornamos 0
    return achievements['currentWinStreak'] as int? ?? 0;
  }

  /// Calcular mejor racha de victorias
  int get bestWinStreak {
    return achievements['bestWinStreak'] as int? ?? 0;
  }

  /// Días desde el primer juego
  int? get daysSinceFirstPlay {
    if (firstPlayed == null) return null;
    return DateTime.now().difference(firstPlayed!).inDays;
  }

  /// Días desde el último juego
  int? get daysSinceLastPlay {
    if (lastPlayed == null) return null;
    return DateTime.now().difference(lastPlayed!).inDays;
  }

  /// Verificar si el usuario es activo (jugó en los últimos 7 días)
  bool get isActive {
    if (lastPlayed == null) return false;
    return daysSinceLastPlay! <= 7;
  }

  /// Frecuencia de juego (sesiones por día activo)
  double get playFrequency {
    if (activeDays == 0) return 0.0;
    return totalSessions / activeDays;
  }

  // ==================== LOGROS ====================

  /// Verificar si ha desbloqueado logro de primera victoria
  bool get hasFirstWin {
    return totalWins >= 1;
  }

  /// Verificar si ha desbloqueado logro de 10 victorias
  bool get has10Wins {
    return totalWins >= 10;
  }

  /// Verificar si ha desbloqueado logro de 100 predicciones
  bool get has100Predictions {
    return totalPredictions >= 100;
  }

  /// Verificar si ha desbloqueado logro de rentabilidad
  bool get isProfitablePlayer {
    return isProfitable && totalPredictions >= 50;
  }

  /// Obtener lista de logros desbloqueados
  List<String> get unlockedAchievements {
    final unlocked = <String>[];
    
    if (hasFirstWin) unlocked.add('Primera Victoria');
    if (has10Wins) unlocked.add('10 Victorias');
    if (has100Predictions) unlocked.add('100 Predicciones');
    if (isProfitablePlayer) unlocked.add('Jugador Rentable');
    
    // Agregar logros personalizados del mapa achievements
    achievements.forEach((key, value) {
      if (value == true) {
        unlocked.add(key);
      }
    });
    
    return unlocked;
  }

  // ==================== VALIDACIÓN ====================

  /// Validar que las estadísticas sean consistentes
  bool get isValid {
    // Verificar que wins + losses no exceda total predictions
    if (totalWins + totalLosses > totalPredictions) return false;
    
    // Verificar que las cantidades sean no negativas
    if (totalBetAmount < 0 || totalWinnings < 0) return false;
    if (totalPredictions < 0 || totalWins < 0 || totalLosses < 0) return false;
    if (totalSessions < 0 || activeDays < 0) return false;
    
    // Verificar que firstPlayed sea antes que lastPlayed
    if (firstPlayed != null && lastPlayed != null) {
      if (firstPlayed!.isAfter(lastPlayed!)) return false;
    }
    
    return true;
  }

  // ==================== UTILIDADES ====================

  /// Obtener resumen legible
  String get summary {
    return '$totalPredictions predicciones: $totalWins victorias, $totalLosses derrotas '
        '(${winRate.toStringAsFixed(1)}% win rate) - '
        '${isProfitable ? "Ganancia" : "Pérdida"}: \$${netProfit.abs().toStringAsFixed(2)}';
  }

  /// Crear estadísticas vacías/iniciales
  factory UserStats.initial() {
    return UserStats(
      firstPlayed: DateTime.now(),
      lastPlayed: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserStats(predictions: $totalPredictions, wins: $totalWins, '
        'losses: $totalLosses, winRate: ${winRate.toStringAsFixed(1)}%)';
  }
}
