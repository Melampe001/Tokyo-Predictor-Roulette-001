import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de predicción para Tokyo Roulette Predictor
/// 
/// Representa una predicción realizada por el usuario
class PredictionModel {
  final String id;
  final String userId;
  final int predictedNumber;
  final int? resultNumber;
  final double betAmount;
  final String result; // 'pending', 'win', 'loss'
  final DateTime timestamp;
  final String? predictionMethod; // 'manual', 'ai', 'frequency', etc.
  final Map<String, dynamic>? metadata;

  PredictionModel({
    required this.id,
    required this.userId,
    required this.predictedNumber,
    this.resultNumber,
    required this.betAmount,
    this.result = 'pending',
    required this.timestamp,
    this.predictionMethod,
    this.metadata,
  });

  /// Crear instancia desde documento de Firestore
  factory PredictionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return PredictionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      predictedNumber: data['predictedNumber'] as int? ?? 0,
      resultNumber: data['resultNumber'] as int?,
      betAmount: (data['betAmount'] as num?)?.toDouble() ?? 0.0,
      result: data['result'] as String? ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      predictionMethod: data['predictionMethod'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Crear instancia desde Map
  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    return PredictionModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      predictedNumber: map['predictedNumber'] as int? ?? 0,
      resultNumber: map['resultNumber'] as int?,
      betAmount: (map['betAmount'] as num?)?.toDouble() ?? 0.0,
      result: map['result'] as String? ?? 'pending',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : map['timestamp'] is DateTime
              ? map['timestamp'] as DateTime
              : DateTime.now(),
      predictionMethod: map['predictionMethod'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'predictedNumber': predictedNumber,
      'resultNumber': resultNumber,
      'betAmount': betAmount,
      'result': result,
      'timestamp': Timestamp.fromDate(timestamp),
      'predictionMethod': predictionMethod,
      'metadata': metadata,
    };
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'predictedNumber': predictedNumber,
      'resultNumber': resultNumber,
      'betAmount': betAmount,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'predictionMethod': predictionMethod,
      'metadata': metadata,
    };
  }

  /// Crear copia con cambios
  PredictionModel copyWith({
    String? id,
    String? userId,
    int? predictedNumber,
    int? resultNumber,
    double? betAmount,
    String? result,
    DateTime? timestamp,
    String? predictionMethod,
    Map<String, dynamic>? metadata,
  }) {
    return PredictionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      predictedNumber: predictedNumber ?? this.predictedNumber,
      resultNumber: resultNumber ?? this.resultNumber,
      betAmount: betAmount ?? this.betAmount,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
      predictionMethod: predictionMethod ?? this.predictionMethod,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Verificar si la predicción fue ganadora
  bool get isWin => result == 'win';

  /// Verificar si la predicción fue perdedora
  bool get isLoss => result == 'loss';

  /// Verificar si la predicción está pendiente
  bool get isPending => result == 'pending';

  /// Verificar si la predicción fue correcta (número exacto)
  bool get isExactMatch {
    return resultNumber != null && predictedNumber == resultNumber;
  }

  /// Calcular ganancia/pérdida
  double get profitLoss {
    if (isPending) return 0.0;
    if (isWin) {
      // En ruleta, ganar número exacto paga 35:1
      // Ajustar según las reglas específicas del juego
      return betAmount * 35;
    }
    return -betAmount;
  }

  /// Obtener color del número predicho
  String get predictedColor {
    return _getNumberColor(predictedNumber);
  }

  /// Obtener color del número resultado
  String? get resultColor {
    if (resultNumber == null) return null;
    return _getNumberColor(resultNumber!);
  }

  /// Determinar color de un número de ruleta
  String _getNumberColor(int number) {
    if (number == 0) return 'green';
    
    // Números rojos en ruleta europea
    const redNumbers = {
      1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
    };
    
    return redNumbers.contains(number) ? 'red' : 'black';
  }

  /// Validar número de ruleta europea (0-36)
  bool get isValidPrediction {
    return predictedNumber >= 0 && predictedNumber <= 36;
  }

  /// Validar número de resultado
  bool get isValidResult {
    return resultNumber == null ||
        (resultNumber! >= 0 && resultNumber! <= 36);
  }

  /// Verificar si es una predicción de color (metadata)
  bool get isColorBet {
    return metadata?['betType'] == 'color';
  }

  /// Verificar si es una predicción de par/impar (metadata)
  bool get isEvenOddBet {
    return metadata?['betType'] == 'evenOdd';
  }

  /// Verificar si es una predicción de número específico
  bool get isNumberBet {
    return metadata?['betType'] == 'number' || metadata?['betType'] == null;
  }

  /// Obtener descripción legible de la predicción
  String get description {
    final method = predictionMethod != null ? ' ($predictionMethod)' : '';
    return 'Número $predictedNumber con \$$betAmount$method';
  }

  /// Obtener descripción del resultado
  String get resultDescription {
    if (isPending) return 'Pendiente';
    if (resultNumber == null) return 'Sin resultado';
    
    final profit = profitLoss;
    final sign = profit >= 0 ? '+' : '';
    return 'Resultado: $resultNumber ($sign\$${profit.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is PredictionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PredictionModel(id: $id, predicted: $predictedNumber, '
        'result: $resultNumber, bet: \$$betAmount, status: $result)';
  }
}
