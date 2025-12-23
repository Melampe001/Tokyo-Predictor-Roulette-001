import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Servicio de autenticación de Firebase
/// 
/// Proporciona métodos para autenticación de usuarios incluyendo:
/// - Email/Password
/// - Google Sign-In
/// - Autenticación anónima
/// - Gestión de sesión
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream del estado de autenticación
  /// Emite el usuario actual cuando cambia el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actualmente autenticado
  User? get currentUser => _auth.currentUser;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => currentUser != null;

  /// Registrar nuevo usuario con email y contraseña
  /// 
  /// [email] Email del usuario
  /// [password] Contraseña (mínimo 6 caracteres)
  /// 
  /// Returns: Usuario creado o null si hay error
  /// Throws: FirebaseAuthException en caso de error
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Enviar email de verificación automáticamente
      await credential.user?.sendEmailVerification();
      
      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al registrar usuario: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado al registrar usuario: $e');
      rethrow;
    }
  }

  /// Iniciar sesión con email y contraseña
  /// 
  /// [email] Email del usuario
  /// [password] Contraseña
  /// 
  /// Returns: Usuario autenticado o null si hay error
  /// Throws: FirebaseAuthException en caso de error
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al iniciar sesión: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado al iniciar sesión: $e');
      rethrow;
    }
  }

  /// Iniciar sesión con Google
  /// 
  /// Returns: Usuario autenticado o null si se cancela
  /// Throws: Exception en caso de error
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Si el usuario cancela, retornar null
      if (googleUser == null) {
        return null;
      }

      // Obtener detalles de autenticación de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial de Firebase con el token de Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con las credenciales de Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential.user;
    } catch (e) {
      debugPrint('Error al iniciar sesión con Google: $e');
      rethrow;
    }
  }

  /// Iniciar sesión anónima
  /// 
  /// Útil para permitir a los usuarios probar la app sin registro
  /// 
  /// Returns: Usuario anónimo autenticado
  /// Throws: FirebaseAuthException en caso de error
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential credential = await _auth.signInAnonymously();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al iniciar sesión anónima: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado al iniciar sesión anónima: $e');
      rethrow;
    }
  }

  /// Cerrar sesión
  /// 
  /// Cierra sesión tanto de Firebase como de Google Sign-In
  /// 
  /// Throws: Exception en caso de error
  Future<void> signOut() async {
    try {
      // Cerrar sesión de Google si está autenticado con Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Cerrar sesión de Firebase
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  /// Enviar email de restablecimiento de contraseña
  /// 
  /// [email] Email del usuario que solicita restablecer contraseña
  /// 
  /// Throws: FirebaseAuthException en caso de error
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al enviar email de restablecimiento: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado al restablecer contraseña: $e');
      rethrow;
    }
  }

  /// Enviar email de verificación al usuario actual
  /// 
  /// Throws: Exception si no hay usuario autenticado o error
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      debugPrint('Error al enviar email de verificación: $e');
      rethrow;
    }
  }

  /// Recargar datos del usuario actual
  /// 
  /// Útil para actualizar el estado de verificación de email
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      debugPrint('Error al recargar usuario: $e');
      rethrow;
    }
  }

  /// Actualizar perfil del usuario
  /// 
  /// [displayName] Nombre para mostrar (opcional)
  /// [photoURL] URL de la foto de perfil (opcional)
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload();
    } catch (e) {
      debugPrint('Error al actualizar perfil: $e');
      rethrow;
    }
  }

  /// Actualizar email del usuario
  /// 
  /// [newEmail] Nuevo email
  /// Requiere re-autenticación reciente
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await user.updateEmail(newEmail);
      await user.sendEmailVerification();
    } catch (e) {
      debugPrint('Error al actualizar email: $e');
      rethrow;
    }
  }

  /// Actualizar contraseña del usuario
  /// 
  /// [newPassword] Nueva contraseña
  /// Requiere re-autenticación reciente
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await user.updatePassword(newPassword);
    } catch (e) {
      debugPrint('Error al actualizar contraseña: $e');
      rethrow;
    }
  }

  /// Re-autenticar usuario con email y contraseña
  /// 
  /// Necesario antes de operaciones sensibles como cambiar email o contraseña
  /// 
  /// [email] Email actual
  /// [password] Contraseña actual
  Future<void> reauthenticateWithEmail(String email, String password) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      debugPrint('Error al re-autenticar: $e');
      rethrow;
    }
  }

  /// Eliminar cuenta del usuario actual
  /// 
  /// Requiere re-autenticación reciente
  /// Esta acción es irreversible
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await user.delete();
    } catch (e) {
      debugPrint('Error al eliminar cuenta: $e');
      rethrow;
    }
  }

  /// Vincular cuenta anónima con credenciales de email
  /// 
  /// Permite convertir una cuenta anónima en una cuenta permanente
  /// 
  /// [email] Email para la cuenta
  /// [password] Contraseña para la cuenta
  Future<User?> linkAnonymousWithEmail(String email, String password) async {
    try {
      final user = currentUser;
      if (user == null || !user.isAnonymous) {
        throw Exception('No hay usuario anónimo para vincular');
      }
      
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      final userCredential = await user.linkWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Error al vincular cuenta anónima: $e');
      rethrow;
    }
  }
}
