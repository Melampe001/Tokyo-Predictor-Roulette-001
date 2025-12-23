import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de sesión de juego para Tokyo Roulette Predictor
/// 
/// Representa una sesión de juego completa con todas sus estadísticas
class SessionModel {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final bool active;
  final double initialBalance;
  final double? finalBalance;
  final int totalPredictions;
  final int wins;
  final int losses;
  final double totalBetAmount;
  final double totalWinnings;
  final bool usedMartingale;
  final Map<String, dynamic>? metadata;

  SessionModel({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.active = true,
    required this.initialBalance,
    this.finalBalance,
    this.totalPredictions = 0,
    this.wins = 0,
    this.losses = 0,
    this.totalBetAmount = 0.0,
    this.totalWinnings = 0.0,
    this.usedMartingale = false,
    this.metadata,
  });

  /// Crear instancia desde documento de Firestore
  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SessionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      active: data['active'] as bool? ?? true,
      initialBalance: (data['initialBalance'] as num?)?.toDouble() ?? 0.0,
      finalBalance: (data['finalBalance'] as num?)?.toDouble(),
      totalPredictions: data['totalPredictions'] as int? ?? 0,
      wins: data['wins'] as int? ?? 0,
      losses: data['losses'] as int? ?? 0,
      totalBetAmount: (data['totalBetAmount'] as num?)?.toDouble() ?? 0.0,
      totalWinnings: (data['totalWinnings'] as num?)?.toDouble() ?? 0.0,
      usedMartingale: data['usedMartingale'] as bool? ?? false,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Crear instancia desde Map
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      startTime: map['startTime'] is Timestamp
          ? (map['startTime'] as Timestamp).toDate()
          : map['startTime'] is DateTime
              ? map['startTime'] as DateTime
              : DateTime.now(),
      endTime: map['endTime'] is Timestamp
          ? (map['endTime'] as Timestamp?)?.toDate()
          : map['endTime'] as DateTime?,
      active: map['active'] as bool? ?? true,
      initialBalance: (map['initialBalance'] as num?)?.toDouble() ?? 0.0,
      finalBalance: (map['finalBalance'] as num?)?.toDouble(),
      totalPredictions: map['totalPredictions'] as int? ?? 0,
      wins: map['wins'] as int? ?? 0,
      losses: map['losses'] as int? ?? 0,
      totalBetAmount: (map['totalBetAmount'] as num?)?.toDouble() ?? 0.0,
      totalWinnings: (map['totalWinnings'] as num?)?.toDouble() ?? 0.0,
      usedMartingale: map['usedMartingale'] as bool? ?? false,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'active': active,
      'initialBalance': initialBalance,
      'finalBalance': finalBalance,
      'totalPredictions': totalPredictions,
      'wins': wins,
      'losses': losses,
      'totalBetAmount': totalBetAmount,
      'totalWinnings': totalWinnings,
      'usedMartingale': usedMartingale,
      'metadata': metadata,
    };
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'active': active,
      'initialBalance': initialBalance,
      'finalBalance': finalBalance,
      'totalPredictions': totalPredictions,
      'wins': wins,
      'losses': losses,
      'totalBetAmount': totalBetAmount,
      'totalWinnings': totalWinnings,
      'usedMartingale': usedMartingale,
      'metadata': metadata,
    };
  }

  /// Crear copia con cambios
  SessionModel copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    bool? active,
    double? initialBalance,
    double? finalBalance,
    int? totalPredictions,
    int? wins,
    int? losses,
    double? totalBetAmount,
    double? totalWinnings,
    bool? usedMartingale,
    Map<String, dynamic>? metadata,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      active: active ?? this.active,
      initialBalance: initialBalance ?? this.initialBalance,
      finalBalance: finalBalance ?? this.finalBalance,
      totalPredictions: totalPredictions ?? this.totalPredictions,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      totalBetAmount: totalBetAmount ?? this.totalBetAmount,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      usedMartingale: usedMartingale ?? this.usedMartingale,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Calcular duración de la sesión
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Obtener duración en minutos
  int get durationInMinutes {
    return duration.inMinutes;
  }

  /// Obtener duración en horas
  double get durationInHours {
    return duration.inMinutes / 60.0;
  }

  /// Calcular tasa de victorias (win rate)
  double get winRate {
    if (totalPredictions == 0) return 0.0;
    return (wins / totalPredictions) * 100;
  }

  /// Calcular ganancia/pérdida neta
  double get netProfit {
    if (finalBalance == null) return 0.0;
    return finalBalance! - initialBalance;
  }

  /// Calcular ROI (Return on Investment)
  double get roi {
    if (initialBalance == 0) return 0.0;
    return (netProfit / initialBalance) * 100;
  }

  /// Promedio de apuesta por predicción
  double get averageBet {
    if (totalPredictions == 0) return 0.0;
    return totalBetAmount / totalPredictions;
  }

  /// Promedio de ganancia por victoria
  double get averageWinAmount {
    if (wins == 0) return 0.0;
    return totalWinnings / wins;
  }

  /// Verificar si la sesión fue exitosa (ganancia neta positiva)
  bool get isSuccessful {
    return netProfit > 0;
  }

  /// Verificar si la sesión está completada
  bool get isCompleted {
    return !active && endTime != null;
  }

  /// Obtener estadísticas como Map
  Map<String, dynamic> get stats {
    return {
      'duration_minutes': durationInMinutes,
      'win_rate': winRate,
      'net_profit': netProfit,
      'roi': roi,
      'average_bet': averageBet,
      'average_win': averageWinAmount,
      'successful': isSuccessful,
    };
  }

  /// Obtener resumen legible de la sesión
  String get summary {
    final duration = durationInMinutes;
    final profitStr = netProfit >= 0 
        ? '+\$${netProfit.toStringAsFixed(2)}' 
        : '-\$${(-netProfit).toStringAsFixed(2)}';
    
    return '$totalPredictions predicciones en ${duration}min: '
        '$wins victorias, $losses derrotas ($profitStr)';
  }

  /// Validar que las estadísticas sean consistentes
  bool get isValid {
    // Verificar que wins + losses no exceda total predictions
    if (wins + losses > totalPredictions) return false;
    
    // Verificar que el balance final sea razonable
    if (finalBalance != null && finalBalance! < 0) return false;
    
    // Verificar que las cantidades sean no negativas
    if (totalBetAmount < 0 || totalWinnings < 0) return false;
    
    return true;
  }

  /// Crear nueva sesión
  factory SessionModel.create({
    required String userId,
    required double initialBalance,
    bool usedMartingale = false,
    Map<String, dynamic>? metadata,
  }) {
    return SessionModel(
      id: '', // Se asignará al guardar en Firestore
      userId: userId,
      startTime: DateTime.now(),
      active: true,
      initialBalance: initialBalance,
      usedMartingale: usedMartingale,
      metadata: metadata,
    );
  }

  /// Finalizar sesión
  SessionModel end(double finalBalance) {
    return copyWith(
      endTime: DateTime.now(),
      active: false,
      finalBalance: finalBalance,
    );
  }

  /// Agregar resultado de predicción
  SessionModel addPrediction({
    required bool won,
    required double betAmount,
    required double winAmount,
  }) {
    return copyWith(
      totalPredictions: totalPredictions + 1,
      wins: won ? wins + 1 : wins,
      losses: won ? losses : losses + 1,
      totalBetAmount: totalBetAmount + betAmount,
      totalWinnings: won ? totalWinnings + winAmount : totalWinnings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SessionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SessionModel(id: $id, user: $userId, predictions: $totalPredictions, '
        'wins: $wins, losses: $losses, active: $active)';
  }
}
