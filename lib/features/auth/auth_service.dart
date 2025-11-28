// =============================================================================
// Auth Service - Servicio de Autenticación con Firebase Auth
// =============================================================================
//
// Este archivo proporciona un servicio para gestionar la autenticación
// de usuarios usando Firebase Authentication.
//
// MEJORES PRÁCTICAS:
// - Usa un singleton o inyección de dependencias para el servicio de auth.
// - Siempre verifica el estado de autenticación antes de operaciones sensibles.
// - Implementa logout automático después de periodos de inactividad.
// - Valida emails antes de enviarlos a Firebase.
// - Usa contraseñas fuertes (mínimo 8 caracteres, mayúsculas, números, símbolos).
//
// SEGURIDAD:
// - NUNCA almacenes contraseñas en texto plano.
// - Implementa rate limiting en el backend para prevenir ataques de fuerza bruta.
// - Usa HTTPS siempre para comunicaciones de autenticación.
// - Considera implementar 2FA (Two-Factor Authentication) para mayor seguridad.
// - Verifica emails de usuarios antes de permitir acceso completo.
// - Implementa detección de sesiones sospechosas (múltiples IPs, dispositivos).
// - Los tokens de Firebase tienen una duración limitada - maneja la renovación.
//
// 2FA (TWO-FACTOR AUTHENTICATION):
// Firebase soporta varios métodos de 2FA:
// - SMS: firebase_auth soporta verificación por SMS
// - Email: Puedes enviar códigos de verificación por email
// - Authenticator Apps: Usa paquetes como otp para TOTP
// - Phone Authentication: Integrado en firebase_auth
//
// PASOS PARA IMPLEMENTAR 2FA:
// 1. Habilita Phone Authentication en Firebase Console
// 2. Configura el proveedor de SMS (Twilio, etc.)
// 3. Implementa el flujo de verificación después del login inicial
// 4. Almacena el estado de 2FA del usuario en Firestore
// =============================================================================

import 'package:firebase_auth/firebase_auth.dart';

/// Resultado de operaciones de autenticación
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;
  
  AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
  });
  
  factory AuthResult.success(User user) {
    return AuthResult(success: true, user: user);
  }
  
  factory AuthResult.failure(String message) {
    return AuthResult(success: false, errorMessage: message);
  }
}

/// Servicio de autenticación usando Firebase Auth.
///
/// Proporciona métodos para registro, inicio de sesión, cierre de sesión
/// y gestión del estado de autenticación.
///
/// Ejemplo de uso:
/// ```dart
/// final authService = AuthService.instance;
/// 
/// // Registro
/// final result = await authService.registerWithEmailAndPassword(
///   email: 'usuario@ejemplo.com',
///   password: 'ContraseñaSegura123!',
/// );
/// 
/// if (result.success) {
///   print('Usuario registrado: ${result.user?.email}');
/// }
/// ```
class AuthService {
  // Instancia singleton
  static final AuthService _instance = AuthService._internal();
  
  /// Obtiene la instancia singleton del servicio de autenticación
  static AuthService get instance => _instance;
  
  // Instancia de Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Constructor privado para patrón singleton
  AuthService._internal();
  
  /// Obtiene el usuario actualmente autenticado, o null si no hay sesión
  User? get currentUser => _auth.currentUser;
  
  /// Stream de cambios en el estado de autenticación
  /// 
  /// Útil para widgets que necesitan reaccionar a cambios de login/logout
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Verifica si hay un usuario autenticado actualmente
  bool get isAuthenticated => currentUser != null;
  
  // ===========================================================================
  // REGISTRO DE USUARIOS
  // ===========================================================================
  
  /// Registra un nuevo usuario con email y contraseña.
  /// 
  /// SEGURIDAD:
  /// - La contraseña debe tener mínimo 8 caracteres
  /// - Incluir mayúsculas, números y símbolos para mayor seguridad
  /// - El email se verificará automáticamente según configuración de Firebase
  /// 
  /// [email] - Email del usuario (debe ser válido)
  /// [password] - Contraseña (mínimo 6 caracteres requerido por Firebase)
  /// [sendEmailVerification] - Enviar email de verificación (default: true)
  Future<AuthResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    bool sendEmailVerification = true,
  }) async {
    try {
      // Validación básica de email
      if (!_isValidEmail(email)) {
        return AuthResult.failure('El formato del email no es válido');
      }
      
      // Validación de contraseña
      final passwordValidation = _validatePassword(password);
      if (passwordValidation != null) {
        return AuthResult.failure(passwordValidation);
      }
      
      // Crear usuario en Firebase
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Enviar email de verificación si está habilitado
      if (sendEmailVerification && credential.user != null) {
        await credential.user!.sendEmailVerification();
      }
      
      return AuthResult.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleFirebaseAuthError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado durante el registro: $e');
    }
  }
  
  // ===========================================================================
  // INICIO DE SESIÓN
  // ===========================================================================
  
  /// Inicia sesión con email y contraseña.
  /// 
  /// SEGURIDAD:
  /// - Implementa rate limiting en el backend para prevenir ataques
  /// - Considera bloquear cuenta después de múltiples intentos fallidos
  /// - Notifica al usuario de nuevos inicios de sesión
  /// 
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validación básica
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.failure('Email y contraseña son requeridos');
      }
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // NOTA: Aquí podrías implementar verificación de 2FA
      // if (_requires2FA(credential.user)) {
      //   return AuthResult.failure('2FA_REQUIRED');
      // }
      
      return AuthResult.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleFirebaseAuthError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado durante el inicio de sesión: $e');
    }
  }
  
  // ===========================================================================
  // CIERRE DE SESIÓN
  // ===========================================================================
  
  /// Cierra la sesión del usuario actual.
  /// 
  /// SEGURIDAD:
  /// - Limpia cualquier dato sensible almacenado localmente
  /// - Revoca tokens si es necesario
  /// - Notifica al backend del cierre de sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      
      // TODO: Limpiar datos locales sensibles
      // await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      
      // TODO: Notificar al backend del cierre de sesión
      // await _notifyBackendSignOut();
      
    } catch (e) {
      // En caso de error, intentar forzar el signout de todas formas
      // ignore: avoid_print
      print('[AuthService] Error durante signOut: $e');
      rethrow;
    }
  }
  
  // ===========================================================================
  // RECUPERACIÓN DE CONTRASEÑA
  // ===========================================================================
  
  /// Envía un email para restablecer la contraseña.
  /// 
  /// [email] - Email del usuario registrado
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthResult.failure('El formato del email no es válido');
      }
      
      await _auth.sendPasswordResetEmail(email: email.trim());
      
      // No revelamos si el email existe o no por seguridad
      return AuthResult(
        success: true,
        errorMessage: null,
        user: null,
      );
    } on FirebaseAuthException catch (e) {
      // Por seguridad, no revelamos si el email existe
      // ignore: avoid_print
      print('[AuthService] Error en reset password: ${e.code}');
      return AuthResult(success: true, errorMessage: null, user: null);
    } catch (e) {
      return AuthResult.failure('Error al enviar email de recuperación');
    }
  }
  
  // ===========================================================================
  // VERIFICACIÓN DE EMAIL
  // ===========================================================================
  
  /// Reenvía el email de verificación al usuario actual.
  Future<bool> resendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) return false;
      
      await user.sendEmailVerification();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('[AuthService] Error al reenviar verificación: $e');
      return false;
    }
  }
  
  /// Verifica si el email del usuario actual está verificado.
  Future<bool> isEmailVerified() async {
    final user = currentUser;
    if (user == null) return false;
    
    // Recargar datos del usuario para obtener estado actualizado
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
  
  // ===========================================================================
  // MÉTODOS AUXILIARES PRIVADOS
  // ===========================================================================
  
  /// Valida el formato básico de un email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }
  
  /// Valida la fortaleza de la contraseña
  /// Retorna null si es válida, o un mensaje de error
  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    // Recomendación: descomentar para mayor seguridad
    // if (!password.contains(RegExp(r'[A-Z]'))) {
    //   return 'La contraseña debe contener al menos una mayúscula';
    // }
    // if (!password.contains(RegExp(r'[0-9]'))) {
    //   return 'La contraseña debe contener al menos un número';
    // }
    // if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'La contraseña debe contener al menos un símbolo especial';
    // }
    
    return null; // Contraseña válida
  }
  
  /// Convierte errores de FirebaseAuth a mensajes amigables
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'invalid-email':
        return 'El formato del email no es válido';
      case 'operation-not-allowed':
        return 'Operación no permitida. Contacta al soporte';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'user-not-found':
        // Por seguridad, usamos mensaje genérico
        return 'Credenciales inválidas';
      case 'wrong-password':
        // Por seguridad, usamos mensaje genérico
        return 'Credenciales inválidas';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
