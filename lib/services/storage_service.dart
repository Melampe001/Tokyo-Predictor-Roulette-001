import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Servicio de Cloud Storage de Firebase
/// 
/// Gestiona el almacenamiento de archivos en la nube:
/// - Avatares de usuario
/// - Assets del juego (opcional)
/// - Archivos temporales
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Rutas de almacenamiento
  static const String _usersPath = 'users';
  static const String _avatarsPath = 'avatars';
  static const String _assetsPath = 'assets';
  static const String _tempPath = 'temp';

  /// Inicializar Storage
  /// 
  /// Configura ajustes opcionales
  Future<void> initialize() async {
    try {
      // Configurar tiempo de timeout (opcional)
      // _storage.setMaxOperationRetryTime(const Duration(seconds: 30));
      
      debugPrint('Cloud Storage inicializado');
    } catch (e) {
      debugPrint('Error al inicializar Cloud Storage: $e');
    }
  }

  // ==================== SUBIR ARCHIVOS ====================

  /// Subir archivo desde File
  /// 
  /// [file] Archivo a subir
  /// [path] Ruta en Storage (incluye nombre de archivo)
  /// [metadata] Metadatos opcionales del archivo
  /// Returns: URL de descarga del archivo subido
  Future<String> uploadFile(
    File file,
    String path, {
    SettableMetadata? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      
      // Subir archivo
      final uploadTask = ref.putFile(file, metadata);
      
      // Esperar a que se complete
      final snapshot = await uploadTask;
      
      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        debugPrint('Archivo subido exitosamente: $path');
        debugPrint('URL: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error al subir archivo: $e');
      rethrow;
    }
  }

  /// Subir datos (Uint8List) directamente
  /// 
  /// [data] Datos a subir
  /// [path] Ruta en Storage
  /// [metadata] Metadatos opcionales
  /// Returns: URL de descarga
  Future<String> uploadData(
    Uint8List data,
    String path, {
    SettableMetadata? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      
      // Subir datos
      final uploadTask = ref.putData(data, metadata);
      
      // Esperar a que se complete
      final snapshot = await uploadTask;
      
      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        debugPrint('Datos subidos exitosamente: $path');
        debugPrint('URL: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error al subir datos: $e');
      rethrow;
    }
  }

  /// Subir con progreso
  /// 
  /// [file] Archivo a subir
  /// [path] Ruta en Storage
  /// [onProgress] Callback para progreso (0.0 - 1.0)
  /// Returns: URL de descarga
  Future<String> uploadFileWithProgress(
    File file,
    String path, {
    Function(double progress)? onProgress,
    SettableMetadata? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file, metadata);
      
      // Escuchar progreso
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
        
        if (kDebugMode) {
          debugPrint('Progreso: ${(progress * 100).toStringAsFixed(2)}%');
        }
      });
      
      // Esperar a que se complete
      final snapshot = await uploadTask;
      
      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error al subir archivo con progreso: $e');
      rethrow;
    }
  }

  // ==================== DESCARGAR ARCHIVOS ====================

  /// Obtener URL de descarga de un archivo
  /// 
  /// [path] Ruta del archivo en Storage
  /// Returns: URL de descarga
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Error al obtener URL de descarga: $e');
      rethrow;
    }
  }

  /// Descargar archivo a memoria
  /// 
  /// [path] Ruta del archivo en Storage
  /// [maxSize] Tamaño máximo en bytes (default: 10MB)
  /// Returns: Datos del archivo
  Future<Uint8List?> downloadData(String path, {int maxSize = 10485760}) async {
    try {
      final ref = _storage.ref().child(path);
      final data = await ref.getData(maxSize);
      return data;
    } catch (e) {
      debugPrint('Error al descargar datos: $e');
      return null;
    }
  }

  /// Descargar archivo a disco
  /// 
  /// [path] Ruta del archivo en Storage
  /// [localFile] Archivo local donde guardar
  /// Returns: File descargado
  Future<File?> downloadFile(String path, File localFile) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.writeToFile(localFile);
      return localFile;
    } catch (e) {
      debugPrint('Error al descargar archivo: $e');
      return null;
    }
  }

  // ==================== ELIMINAR ARCHIVOS ====================

  /// Eliminar archivo
  /// 
  /// [path] Ruta del archivo a eliminar
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
      
      if (kDebugMode) {
        debugPrint('Archivo eliminado: $path');
      }
    } catch (e) {
      debugPrint('Error al eliminar archivo: $e');
      rethrow;
    }
  }

  // ==================== AVATARES DE USUARIO ====================

  /// Subir avatar de usuario
  /// 
  /// [userId] ID del usuario
  /// [imageFile] Archivo de imagen
  /// Returns: URL del avatar
  Future<String> uploadUserAvatar(String userId, File imageFile) async {
    final path = '$_usersPath/$userId/$_avatarsPath/avatar.jpg';
    
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'userId': userId,
        'type': 'avatar',
      },
    );
    
    return await uploadFile(imageFile, path, metadata: metadata);
  }

  /// Subir avatar desde datos
  /// 
  /// [userId] ID del usuario
  /// [imageData] Datos de la imagen
  /// Returns: URL del avatar
  Future<String> uploadUserAvatarData(String userId, Uint8List imageData) async {
    final path = '$_usersPath/$userId/$_avatarsPath/avatar.jpg';
    
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'userId': userId,
        'type': 'avatar',
      },
    );
    
    return await uploadData(imageData, path, metadata: metadata);
  }

  /// Obtener URL del avatar de usuario
  /// 
  /// [userId] ID del usuario
  /// Returns: URL del avatar o null si no existe
  Future<String?> getUserAvatarUrl(String userId) async {
    try {
      final path = '$_usersPath/$userId/$_avatarsPath/avatar.jpg';
      return await getDownloadUrl(path);
    } catch (e) {
      debugPrint('Avatar no encontrado para usuario $userId');
      return null;
    }
  }

  /// Eliminar avatar de usuario
  /// 
  /// [userId] ID del usuario
  Future<void> deleteUserAvatar(String userId) async {
    final path = '$_usersPath/$userId/$_avatarsPath/avatar.jpg';
    await deleteFile(path);
  }

  // ==================== METADATOS ====================

  /// Obtener metadatos de un archivo
  /// 
  /// [path] Ruta del archivo
  /// Returns: Metadatos del archivo
  Future<FullMetadata?> getMetadata(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = await ref.getMetadata();
      return metadata;
    } catch (e) {
      debugPrint('Error al obtener metadatos: $e');
      return null;
    }
  }

  /// Actualizar metadatos de un archivo
  /// 
  /// [path] Ruta del archivo
  /// [metadata] Nuevos metadatos
  Future<void> updateMetadata(String path, SettableMetadata metadata) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.updateMetadata(metadata);
      
      if (kDebugMode) {
        debugPrint('Metadatos actualizados: $path');
      }
    } catch (e) {
      debugPrint('Error al actualizar metadatos: $e');
      rethrow;
    }
  }

  // ==================== LISTAR ARCHIVOS ====================

  /// Listar archivos en una ruta
  /// 
  /// [path] Ruta a listar
  /// [maxResults] Número máximo de resultados
  /// Returns: Lista de referencias a archivos
  Future<ListResult> listFiles(String path, {int? maxResults}) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.list(ListOptions(maxResults: maxResults));
      return result;
    } catch (e) {
      debugPrint('Error al listar archivos: $e');
      rethrow;
    }
  }

  /// Listar todos los archivos recursivamente
  /// 
  /// [path] Ruta a listar
  /// Returns: Lista de referencias a archivos
  Future<ListResult> listAllFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();
      return result;
    } catch (e) {
      debugPrint('Error al listar todos los archivos: $e');
      rethrow;
    }
  }

  // ==================== UTILIDADES ====================

  /// Obtener referencia a un archivo
  /// 
  /// [path] Ruta del archivo
  /// Returns: Reference del archivo
  Reference getReference(String path) {
    return _storage.ref().child(path);
  }

  /// Verificar si un archivo existe
  /// 
  /// [path] Ruta del archivo
  /// Returns: true si existe
  Future<bool> fileExists(String path) async {
    try {
      await getDownloadUrl(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener tamaño de un archivo
  /// 
  /// [path] Ruta del archivo
  /// Returns: Tamaño en bytes o null si no existe
  Future<int?> getFileSize(String path) async {
    try {
      final metadata = await getMetadata(path);
      return metadata?.size;
    } catch (e) {
      return null;
    }
  }

  /// Limpiar archivos temporales de un usuario
  /// 
  /// [userId] ID del usuario
  Future<void> cleanupTempFiles(String userId) async {
    try {
      final path = '$_usersPath/$userId/$_tempPath';
      final result = await listAllFiles(path);
      
      for (final item in result.items) {
        await item.delete();
      }
      
      if (kDebugMode) {
        debugPrint('Archivos temporales limpiados para usuario $userId');
      }
    } catch (e) {
      debugPrint('Error al limpiar archivos temporales: $e');
    }
  }

  /// Obtener bucket de Storage
  /// 
  /// Returns: Nombre del bucket
  String get bucket => _storage.bucket;

  /// Establecer tiempo máximo de operación
  /// 
  /// [duration] Duración máxima
  Future<void> setMaxOperationRetryTime(Duration duration) async {
    try {
      _storage.setMaxOperationRetryTime(duration);
    } catch (e) {
      debugPrint('Error al establecer tiempo de retry: $e');
    }
  }

  /// Establecer tiempo máximo de subida
  /// 
  /// [duration] Duración máxima
  Future<void> setMaxUploadRetryTime(Duration duration) async {
    try {
      _storage.setMaxUploadRetryTime(duration);
    } catch (e) {
      debugPrint('Error al establecer tiempo de subida: $e');
    }
  }

  /// Establecer tiempo máximo de descarga
  /// 
  /// [duration] Duración máxima
  Future<void> setMaxDownloadRetryTime(Duration duration) async {
    try {
      _storage.setMaxDownloadRetryTime(duration);
    } catch (e) {
      debugPrint('Error al establecer tiempo de descarga: $e');
    }
  }
}
