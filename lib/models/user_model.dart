import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de usuario para Tokyo Roulette Predictor
/// 
/// Representa un usuario de la aplicación con toda su información
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> stats;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
    this.isPremium = false,
    required this.createdAt,
    required this.updatedAt,
    Map<String, dynamic>? stats,
    Map<String, dynamic>? preferences,
  })  : stats = stats ?? {},
        preferences = preferences ?? {};

  /// Crear instancia desde documento de Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      isPremium: data['isPremium'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stats: data['stats'] as Map<String, dynamic>? ?? {},
      preferences: data['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Crear instancia desde Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      isPremium: map['isPremium'] as bool? ?? false,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] is DateTime
              ? map['createdAt'] as DateTime
              : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'] is DateTime
              ? map['updatedAt'] as DateTime
              : DateTime.now(),
      stats: map['stats'] as Map<String, dynamic>? ?? {},
      preferences: map['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'stats': stats,
      'preferences': preferences,
    };
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'stats': stats,
      'preferences': preferences,
    };
  }

  /// Crear copia con cambios
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isAnonymous,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? stats,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Validar email
  bool get hasValidEmail {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Verificar si el usuario tiene nombre
  bool get hasDisplayName {
    return displayName != null && displayName!.isNotEmpty;
  }

  /// Verificar si el usuario tiene foto
  bool get hasPhoto {
    return photoUrl != null && photoUrl!.isNotEmpty;
  }

  /// Obtener iniciales del nombre para avatar
  String get initials {
    if (hasDisplayName) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, '
        'isAnonymous: $isAnonymous, isPremium: $isPremium)';
  }
}
