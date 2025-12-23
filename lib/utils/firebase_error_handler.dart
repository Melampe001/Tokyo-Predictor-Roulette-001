import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Manejador de errores de Firebase
/// 
/// Convierte excepciones de Firebase en mensajes amigables para el usuario
class FirebaseErrorHandler {
  /// Obtener mensaje de error amigable para FirebaseAuthException
  static String getAuthErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      // Errores de autenticación con email/password
      case 'user-not-found':
        return 'No existe una cuenta con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'invalid-email':
        return 'El email no es válido.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Usa al menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Operación no permitida. Contacta al soporte.';
      
      // Errores de cuenta
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con este email pero con un método de inicio de sesión diferente.';
      case 'invalid-credential':
        return 'Las credenciales proporcionadas son inválidas o han expirado.';
      case 'credential-already-in-use':
        return 'Esta credencial ya está asociada con otra cuenta.';
      
      // Errores de verificación
      case 'invalid-verification-code':
        return 'El código de verificación es inválido.';
      case 'invalid-verification-id':
        return 'El ID de verificación es inválido.';
      
      // Errores de sesión
      case 'requires-recent-login':
        return 'Esta operación es sensible y requiere que inicies sesión nuevamente.';
      case 'too-many-requests':
        return 'Demasiados intentos. Por favor, espera un momento e intenta de nuevo.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet e intenta de nuevo.';
      
      // Errores de provider
      case 'popup-closed-by-user':
        return 'Inicio de sesión cancelado.';
      case 'popup-blocked':
        return 'Ventana emergente bloqueada. Permite ventanas emergentes en tu navegador.';
      case 'cancelled-popup-request':
        return 'Inicio de sesión cancelado.';
      
      // Errores de token
      case 'invalid-action-code':
        return 'El código de acción es inválido. Puede haber expirado o ya fue usado.';
      case 'expired-action-code':
        return 'El código de acción ha expirado.';
      case 'invalid-continue-uri':
        return 'URL de continuación inválida.';
      
      default:
        return 'Error de autenticación: ${error.message ?? error.code}';
    }
  }

  /// Obtener mensaje de error amigable para FirebaseException
  static String getFirestoreErrorMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'No tienes permisos para realizar esta operación.';
      case 'not-found':
        return 'El documento solicitado no existe.';
      case 'already-exists':
        return 'El documento ya existe.';
      case 'cancelled':
        return 'Operación cancelada.';
      case 'unavailable':
        return 'Servicio temporalmente no disponible. Intenta de nuevo.';
      case 'deadline-exceeded':
        return 'Operación tomó demasiado tiempo. Intenta de nuevo.';
      case 'resource-exhausted':
        return 'Cuota de recursos excedida.';
      case 'failed-precondition':
        return 'Operación rechazada. Verifica las condiciones.';
      case 'aborted':
        return 'Operación abortada debido a conflicto. Intenta de nuevo.';
      case 'out-of-range':
        return 'Operación fuera de rango válido.';
      case 'unimplemented':
        return 'Operación no implementada o no soportada.';
      case 'internal':
        return 'Error interno del servidor.';
      case 'data-loss':
        return 'Pérdida irrecuperable de datos.';
      case 'unauthenticated':
        return 'No estás autenticado. Inicia sesión e intenta de nuevo.';
      default:
        return 'Error de base de datos: ${error.message ?? error.code}';
    }
  }

  /// Obtener mensaje de error amigable para Storage
  static String getStorageErrorMessage(FirebaseException error) {
    switch (error.code) {
      case 'storage/unknown':
        return 'Error desconocido al acceder al almacenamiento.';
      case 'storage/object-not-found':
        return 'Archivo no encontrado.';
      case 'storage/bucket-not-found':
        return 'Bucket de almacenamiento no encontrado.';
      case 'storage/project-not-found':
        return 'Proyecto no encontrado.';
      case 'storage/quota-exceeded':
        return 'Cuota de almacenamiento excedida.';
      case 'storage/unauthenticated':
        return 'No estás autenticado. Inicia sesión e intenta de nuevo.';
      case 'storage/unauthorized':
        return 'No tienes permisos para acceder a este archivo.';
      case 'storage/retry-limit-exceeded':
        return 'Límite de reintentos excedido.';
      case 'storage/invalid-checksum':
        return 'Checksum del archivo inválido.';
      case 'storage/canceled':
        return 'Operación cancelada.';
      case 'storage/invalid-event-name':
        return 'Nombre de evento inválido.';
      case 'storage/invalid-url':
        return 'URL inválida.';
      case 'storage/invalid-argument':
        return 'Argumento inválido.';
      case 'storage/no-default-bucket':
        return 'No hay bucket por defecto configurado.';
      case 'storage/cannot-slice-blob':
        return 'Error al procesar archivo.';
      case 'storage/server-file-wrong-size':
        return 'Tamaño de archivo incorrecto.';
      default:
        return 'Error de almacenamiento: ${error.message ?? error.code}';
    }
  }

  /// Obtener mensaje genérico de error de Firebase
  static String getFirebaseErrorMessage(FirebaseException error) {
    if (error is FirebaseAuthException) {
      return getAuthErrorMessage(error);
    }
    
    // Intentar determinar el tipo por el plugin
    if (error.plugin == 'firebase_auth') {
      return getAuthErrorMessage(error as FirebaseAuthException);
    } else if (error.plugin == 'cloud_firestore') {
      return getFirestoreErrorMessage(error);
    } else if (error.plugin == 'firebase_storage') {
      return getStorageErrorMessage(error);
    }
    
    // Error genérico
    return error.message ?? 'Error de Firebase: ${error.code}';
  }

  /// Manejar cualquier error y retornar mensaje amigable
  static String handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      return getAuthErrorMessage(error);
    } else if (error is FirebaseException) {
      return getFirebaseErrorMessage(error);
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return 'Error inesperado: $error';
    }
  }

  /// Determinar si un error es recuperable (puede reintentar)
  static bool isRetryableError(dynamic error) {
    if (error is FirebaseException) {
      return [
        'unavailable',
        'deadline-exceeded',
        'network-request-failed',
        'too-many-requests',
        'aborted',
        'storage/retry-limit-exceeded',
      ].contains(error.code);
    }
    return false;
  }

  /// Determinar si un error requiere re-autenticación
  static bool requiresReauth(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'requires-recent-login';
    }
    if (error is FirebaseException) {
      return error.code == 'unauthenticated';
    }
    return false;
  }

  /// Determinar si un error es de permisos
  static bool isPermissionError(dynamic error) {
    if (error is FirebaseException) {
      return [
        'permission-denied',
        'storage/unauthorized',
        'unauthenticated',
        'storage/unauthenticated',
      ].contains(error.code);
    }
    return false;
  }

  /// Determinar si un error es de red
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseException) {
      return [
        'network-request-failed',
        'unavailable',
        'deadline-exceeded',
      ].contains(error.code);
    }
    return false;
  }

  /// Obtener sugerencia de acción para el usuario
  static String? getActionSuggestion(dynamic error) {
    if (isNetworkError(error)) {
      return 'Verifica tu conexión a internet e intenta de nuevo.';
    } else if (requiresReauth(error)) {
      return 'Por favor, cierra sesión e inicia sesión nuevamente.';
    } else if (isPermissionError(error)) {
      return 'Contacta al administrador si crees que deberías tener acceso.';
    } else if (isRetryableError(error)) {
      return 'Espera un momento e intenta de nuevo.';
    }
    return null;
  }

  /// Crear mensaje completo de error con sugerencia
  static String getFullErrorMessage(dynamic error) {
    final message = handleError(error);
    final suggestion = getActionSuggestion(error);
    
    if (suggestion != null) {
      return '$message\n\n$suggestion';
    }
    
    return message;
  }
}

/// Extensión para manejar errores de forma fluida
extension FirebaseErrorExtension on dynamic {
  /// Convertir error a mensaje amigable
  String toUserMessage() {
    return FirebaseErrorHandler.handleError(this);
  }

  /// Obtener mensaje completo con sugerencia
  String toFullMessage() {
    return FirebaseErrorHandler.getFullErrorMessage(this);
  }

  /// Verificar si es error recuperable
  bool get isRetryable {
    return FirebaseErrorHandler.isRetryableError(this);
  }

  /// Verificar si requiere re-autenticación
  bool get requiresReauth {
    return FirebaseErrorHandler.requiresReauth(this);
  }

  /// Verificar si es error de permisos
  bool get isPermissionError {
    return FirebaseErrorHandler.isPermissionError(this);
  }

  /// Verificar si es error de red
  bool get isNetworkError {
    return FirebaseErrorHandler.isNetworkError(this);
  }
}
