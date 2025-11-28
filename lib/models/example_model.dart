// =============================================================================
// Example Model - Modelo de Entidad Básica
// =============================================================================
//
// Este archivo proporciona un ejemplo de modelo de datos siguiendo
// las mejores prácticas de Flutter/Dart.
//
// MEJORES PRÁCTICAS:
// - Usa clases inmutables cuando sea posible (final fields)
// - Implementa factory constructors para deserialización (fromJson)
// - Implementa toJson para serialización
// - Considera usar json_serializable para proyectos grandes
// - Implementa copyWith para facilitar actualizaciones inmutables
// - Implementa equals y hashCode si usas el modelo en Sets o como keys de Maps
//
// SEGURIDAD:
// - Valida datos al deserializar (en fromJson)
// - Sanitiza strings antes de mostrarlos en UI (prevención de XSS)
// - NUNCA almacenes contraseñas o datos sensibles en modelos planos
// - Considera encriptar datos sensibles en reposo
//
// PATRONES DE SERIALIZACIÓN:
// 1. Manual (como este ejemplo): Bueno para modelos simples
// 2. json_serializable: Recomendado para proyectos medianos/grandes
// 3. freezed: Excelente para immutability y pattern matching
//
// EJEMPLO CON JSON_SERIALIZABLE:
// ```dart
// import 'package:json_annotation/json_annotation.dart';
// part 'user_model.g.dart';
//
// @JsonSerializable()
// class UserModel {
//   final String id;
//   final String email;
//
//   UserModel({required this.id, required this.email});
//
//   factory UserModel.fromJson(Map<String, dynamic> json) =>
//     _$UserModelFromJson(json);
//   Map<String, dynamic> toJson() => _$UserModelToJson(this);
// }
// ```
// Luego ejecuta: dart run build_runner build
// =============================================================================

/// Modelo de usuario de ejemplo.
///
/// Representa un usuario de la aplicación con sus datos básicos.
/// Implementa serialización JSON y patrón copyWith.
///
/// Ejemplo de uso:
/// ```dart
/// // Crear desde JSON (ej: respuesta de API)
/// final userData = {'id': '123', 'email': 'user@example.com', 'name': 'John'};
/// final user = UserModel.fromJson(userData);
///
/// // Actualizar inmutablemente
/// final updatedUser = user.copyWith(name: 'Jane');
///
/// // Convertir a JSON (ej: para guardar en Firestore)
/// final json = user.toJson();
/// ```
class UserModel {
  /// Identificador único del usuario
  final String id;
  
  /// Email del usuario (validado en construcción)
  final String email;
  
  /// Nombre para mostrar del usuario (opcional)
  final String? displayName;
  
  /// URL del avatar/foto de perfil (opcional)
  final String? photoUrl;
  
  /// Fecha de creación de la cuenta
  final DateTime createdAt;
  
  /// Fecha de última actualización
  final DateTime? updatedAt;
  
  /// Indica si el usuario tiene cuenta premium
  final bool isPremium;
  
  /// Indica si el email ha sido verificado
  final bool isEmailVerified;
  
  /// Constructor principal con validación
  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.isPremium = false,
    this.isEmailVerified = false,
  }) {
    // Validaciones en construcción
    if (id.isEmpty) {
      throw ArgumentError('El ID no puede estar vacío');
    }
    if (!_isValidEmail(email)) {
      throw ArgumentError('El email no tiene un formato válido');
    }
  }
  
  /// Factory constructor para crear un UserModel desde JSON.
  ///
  /// Maneja valores nulos y tipos incorrectos de forma segura.
  /// Incluye validación básica de datos.
  ///
  /// [json] - Map con los datos del usuario
  /// [strict] - Si es true, lanza excepciones en datos inválidos
  factory UserModel.fromJson(Map<String, dynamic> json, {bool strict = false}) {
    // Extraer y validar campos requeridos
    final id = json['id']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';
    
    if (strict && (id.isEmpty || email.isEmpty)) {
      throw FormatException('Campos requeridos faltantes en JSON: id=$id, email=$email');
    }
    
    // Parsear fechas de forma segura
    DateTime createdAt;
    try {
      final createdAtValue = json['createdAt'] ?? json['created_at'];
      if (createdAtValue is DateTime) {
        createdAt = createdAtValue;
      } else if (createdAtValue is String) {
        createdAt = DateTime.parse(createdAtValue);
      } else if (createdAtValue is int) {
        // Timestamp en milisegundos
        createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
      } else {
        createdAt = DateTime.now();
      }
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    DateTime? updatedAt;
    try {
      final updatedAtValue = json['updatedAt'] ?? json['updated_at'];
      if (updatedAtValue is DateTime) {
        updatedAt = updatedAtValue;
      } else if (updatedAtValue is String) {
        updatedAt = DateTime.parse(updatedAtValue);
      } else if (updatedAtValue is int) {
        updatedAt = DateTime.fromMillisecondsSinceEpoch(updatedAtValue);
      }
    } catch (e) {
      updatedAt = null;
    }
    
    return UserModel(
      id: id.isNotEmpty ? id : 'unknown_${DateTime.now().millisecondsSinceEpoch}',
      email: email.isNotEmpty ? email : 'unknown@example.com',
      displayName: json['displayName']?.toString() ?? json['display_name']?.toString(),
      photoUrl: json['photoUrl']?.toString() ?? json['photo_url']?.toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPremium: json['isPremium'] == true || json['is_premium'] == true,
      isEmailVerified: json['isEmailVerified'] == true || json['is_email_verified'] == true,
    );
  }
  
  /// Convierte el modelo a un Map JSON.
  ///
  /// Útil para guardar en Firestore, enviar a APIs, etc.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPremium': isPremium,
      'isEmailVerified': isEmailVerified,
    };
  }
  
  /// Crea una copia del modelo con campos actualizados.
  ///
  /// Patrón copyWith para mantener inmutabilidad.
  /// Los campos no especificados mantienen su valor actual.
  ///
  /// Ejemplo:
  /// ```dart
  /// final updated = user.copyWith(isPremium: true);
  /// ```
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPremium,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isPremium: isPremium ?? this.isPremium,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
  
  /// Valida formato básico de email
  static bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl &&
        other.isPremium == isPremium &&
        other.isEmailVerified == isEmailVerified;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      displayName,
      photoUrl,
      isPremium,
      isEmailVerified,
    );
  }
  
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, '
        'isPremium: $isPremium, isEmailVerified: $isEmailVerified)';
  }
}

// =============================================================================
// MODELOS ADICIONALES DE EJEMPLO
// =============================================================================

/// Modelo de configuración de predicciones de ruleta.
///
/// Ejemplo de modelo de configuración con valores por defecto.
class PredictionConfigModel {
  final int historySize;
  final double confidenceThreshold;
  final bool useAdvancedAlgorithm;
  
  const PredictionConfigModel({
    this.historySize = 100,
    this.confidenceThreshold = 0.7,
    this.useAdvancedAlgorithm = false,
  });
  
  factory PredictionConfigModel.fromJson(Map<String, dynamic> json) {
    return PredictionConfigModel(
      historySize: json['historySize'] as int? ?? 100,
      confidenceThreshold: (json['confidenceThreshold'] as num?)?.toDouble() ?? 0.7,
      useAdvancedAlgorithm: json['useAdvancedAlgorithm'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'historySize': historySize,
      'confidenceThreshold': confidenceThreshold,
      'useAdvancedAlgorithm': useAdvancedAlgorithm,
    };
  }
}
