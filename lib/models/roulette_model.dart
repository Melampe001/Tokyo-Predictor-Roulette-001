import 'package:equatable/equatable.dart';

/// Modelo de datos de la ruleta
class RouletteModel extends Equatable {
  final int currentNumber;
  final List<int> history;
  final bool isSpinning;
  
  const RouletteModel({
    required this.currentNumber,
    required this.history,
    this.isSpinning = false,
  });
  
  RouletteModel copyWith({
    int? currentNumber,
    List<int>? history,
    bool? isSpinning,
  }) {
    return RouletteModel(
      currentNumber: currentNumber ?? this.currentNumber,
      history: history ?? List.from(this.history),
      isSpinning: isSpinning ?? this.isSpinning,
    );
  }
  
  @override
  List<Object?> get props => [currentNumber, history, isSpinning];
}
