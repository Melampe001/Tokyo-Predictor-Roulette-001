import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a user in the application
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserStatistics statistics;
  final bool notificationsEnabled;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    this.lastLoginAt,
    required this.statistics,
    this.notificationsEnabled = true,
    this.fcmToken,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : null,
      statistics: UserStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>? ?? {}),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      fcmToken: json['fcmToken'] as String?,
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'statistics': statistics.toJson(),
      'notificationsEnabled': notificationsEnabled,
      'fcmToken': fcmToken,
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserStatistics? statistics,
    bool? notificationsEnabled,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      statistics: statistics ?? this.statistics,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

/// User statistics model
class UserStatistics {
  final int totalPredictions;
  final int totalWins;
  final int totalLosses;
  final double winRate;
  final int totalGameSessions;
  final double totalBetAmount;
  final double totalWinAmount;

  UserStatistics({
    this.totalPredictions = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.winRate = 0.0,
    this.totalGameSessions = 0,
    this.totalBetAmount = 0.0,
    this.totalWinAmount = 0.0,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalPredictions: json['totalPredictions'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      totalLosses: json['totalLosses'] as int? ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      totalGameSessions: json['totalGameSessions'] as int? ?? 0,
      totalBetAmount: (json['totalBetAmount'] as num?)?.toDouble() ?? 0.0,
      totalWinAmount: (json['totalWinAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPredictions': totalPredictions,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'winRate': winRate,
      'totalGameSessions': totalGameSessions,
      'totalBetAmount': totalBetAmount,
      'totalWinAmount': totalWinAmount,
    };
  }

  UserStatistics copyWith({
    int? totalPredictions,
    int? totalWins,
    int? totalLosses,
    double? winRate,
    int? totalGameSessions,
    double? totalBetAmount,
    double? totalWinAmount,
  }) {
    return UserStatistics(
      totalPredictions: totalPredictions ?? this.totalPredictions,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      winRate: winRate ?? this.winRate,
      totalGameSessions: totalGameSessions ?? this.totalGameSessions,
      totalBetAmount: totalBetAmount ?? this.totalBetAmount,
      totalWinAmount: totalWinAmount ?? this.totalWinAmount,
    );
  }
}

/// Prediction model
class PredictionModel {
  final String? id;
  final String userId;
  final int predictedNumber;
  final int? actualNumber;
  final double betAmount;
  final bool? isWin;
  final DateTime timestamp;
  final double? accuracy;

  PredictionModel({
    this.id,
    required this.userId,
    required this.predictedNumber,
    this.actualNumber,
    required this.betAmount,
    this.isWin,
    required this.timestamp,
    this.accuracy,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json, String id) {
    return PredictionModel(
      id: id,
      userId: json['userId'] as String,
      predictedNumber: json['predictedNumber'] as int,
      actualNumber: json['actualNumber'] as int?,
      betAmount: (json['betAmount'] as num).toDouble(),
      isWin: json['isWin'] as bool?,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'predictedNumber': predictedNumber,
      'actualNumber': actualNumber,
      'betAmount': betAmount,
      'isWin': isWin,
      'timestamp': Timestamp.fromDate(timestamp),
      'accuracy': accuracy,
    };
  }
}

/// Game session model
class GameSessionModel {
  final String? id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalBets;
  final int totalWins;
  final int totalLosses;
  final double winRate;
  final double totalBetAmount;
  final double totalWinAmount;
  final List<int> predictions;
  final double startingBalance;
  final double? endingBalance;

  GameSessionModel({
    this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.totalBets = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.winRate = 0.0,
    this.totalBetAmount = 0.0,
    this.totalWinAmount = 0.0,
    this.predictions = const [],
    required this.startingBalance,
    this.endingBalance,
  });

  factory GameSessionModel.fromJson(Map<String, dynamic> json, String id) {
    return GameSessionModel(
      id: id,
      userId: json['userId'] as String,
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: json['endTime'] != null
          ? (json['endTime'] as Timestamp).toDate()
          : null,
      totalBets: json['totalBets'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      totalLosses: json['totalLosses'] as int? ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      totalBetAmount: (json['totalBetAmount'] as num?)?.toDouble() ?? 0.0,
      totalWinAmount: (json['totalWinAmount'] as num?)?.toDouble() ?? 0.0,
      predictions: (json['predictions'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      startingBalance: (json['startingBalance'] as num).toDouble(),
      endingBalance: (json['endingBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'totalBets': totalBets,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'winRate': winRate,
      'totalBetAmount': totalBetAmount,
      'totalWinAmount': totalWinAmount,
      'predictions': predictions,
      'startingBalance': startingBalance,
      'endingBalance': endingBalance,
    };
  }
}
