import 'package:equatable/equatable.dart';

/// Modelo de datos del usuario con balance y estadísticas
class UserModel extends Equatable {
  final String id;
  final String email;
  final double balance;
  final double currentBet;
  final int totalSpins;
  final int totalWins;
  final int totalLosses;
  final List<String> unlockedAchievements;
  
  const UserModel({
    required this.id,
    required this.email,
    this.balance = 1000.0,
    this.currentBet = 10.0,
    this.totalSpins = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.unlockedAchievements = const [],
  });
  
  UserModel copyWith({
    String? id,
    String? email,
    double? balance,
    double? currentBet,
    int? totalSpins,
    int? totalWins,
    int? totalLosses,
    List<String>? unlockedAchievements,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      currentBet: currentBet ?? this.currentBet,
      totalSpins: totalSpins ?? this.totalSpins,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }
  
  /// Calcula el ratio de victorias
  double get winRate => totalSpins > 0 ? totalWins / totalSpins : 0.0;
  
  @override
  List<Object?> get props => [
    id,
    email,
    balance,
    currentBet,
    totalSpins,
    totalWins,
    totalLosses,
    unlockedAchievements,
  ];
}
