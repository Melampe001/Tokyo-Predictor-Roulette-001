import 'package:equatable/equatable.dart';

/// Tipos de apuesta en la ruleta
enum BetType {
  number,
  red,
  black,
  even,
  odd,
  low,
  high,
}

/// Modelo de apuesta
class BetModel extends Equatable {
  final BetType type;
  final double amount;
  final int? number;
  final DateTime timestamp;
  
  const BetModel({
    required this.type,
    required this.amount,
    this.number,
    required this.timestamp,
  });
  
  @override
  List<Object?> get props => [type, amount, number, timestamp];
}
