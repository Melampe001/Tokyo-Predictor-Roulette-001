import 'package:equatable/equatable.dart';

/// Modelo de predicción del siguiente número
class PredictionModel extends Equatable {
  final int predictedNumber;
  final double confidence;
  final String method;
  final DateTime timestamp;
  
  const PredictionModel({
    required this.predictedNumber,
    required this.confidence,
    required this.method,
    required this.timestamp,
  });
  
  @override
  List<Object?> get props => [predictedNumber, confidence, method, timestamp];
}
