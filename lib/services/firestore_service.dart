import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Servicio de Firestore para gestionar datos de la aplicación
/// 
/// Gestiona las siguientes colecciones:
/// - users: Perfiles de usuario
/// - predictions: Historial de predicciones
/// - sessions: Sesiones de juego
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Nombres de colecciones
  static const String _usersCollection = 'users';
  static const String _predictionsCollection = 'predictions';
  static const String _sessionsCollection = 'sessions';

  /// Inicializar configuración de Firestore
  /// 
  /// Habilita persistencia offline y configura ajustes
  Future<void> initialize() async {
    try {
      // Habilitar persistencia offline (solo para móviles)
      if (!kIsWeb) {
        await _db.settings.copyWith(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      }
    } catch (e) {
      debugPrint('Error al inicializar Firestore: $e');
    }
  }

  // ==================== OPERACIONES DE USUARIOS ====================

  /// Crear o actualizar perfil de usuario
  /// 
  /// [userId] ID del usuario (típicamente Firebase Auth UID)
  /// [data] Datos del usuario (email, displayName, etc.)
  Future<void> createUser(String userId, Map<String, dynamic> data) async {
    try {
      // Agregar timestamp de creación si no existe
      data['createdAt'] = data['createdAt'] ?? FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _db.collection(_usersCollection).doc(userId).set(
        data,
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('Error al crear usuario: $e');
      rethrow;
    }
  }

  /// Obtener perfil de usuario
  /// 
  /// [userId] ID del usuario
  /// Returns: Datos del usuario o null si no existe
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final doc = await _db.collection(_usersCollection).doc(userId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return doc.data();
    } catch (e) {
      debugPrint('Error al obtener usuario: $e');
      rethrow;
    }
  }

  /// Actualizar datos de usuario
  /// 
  /// [userId] ID del usuario
  /// [data] Datos a actualizar
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _db.collection(_usersCollection).doc(userId).update(data);
    } catch (e) {
      debugPrint('Error al actualizar usuario: $e');
      rethrow;
    }
  }

  /// Stream del perfil de usuario
  /// 
  /// [userId] ID del usuario
  /// Returns: Stream de datos del usuario
  Stream<Map<String, dynamic>?> userStream(String userId) {
    return _db
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  /// Eliminar usuario
  /// 
  /// [userId] ID del usuario a eliminar
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      debugPrint('Error al eliminar usuario: $e');
      rethrow;
    }
  }

  // ==================== OPERACIONES DE PREDICCIONES ====================

  /// Guardar una nueva predicción
  /// 
  /// [data] Datos de la predicción (userId, number, timestamp, etc.)
  /// Returns: ID de la predicción creada
  Future<String> savePrediction(Map<String, dynamic> data) async {
    try {
      data['timestamp'] = data['timestamp'] ?? FieldValue.serverTimestamp();
      
      final docRef = await _db.collection(_predictionsCollection).add(data);
      return docRef.id;
    } catch (e) {
      debugPrint('Error al guardar predicción: $e');
      rethrow;
    }
  }

  /// Obtener predicción por ID
  /// 
  /// [predictionId] ID de la predicción
  /// Returns: Datos de la predicción o null si no existe
  Future<Map<String, dynamic>?> getPrediction(String predictionId) async {
    try {
      final doc = await _db.collection(_predictionsCollection).doc(predictionId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      final data = doc.data();
      if (data != null) {
        data['id'] = doc.id;
      }
      return data;
    } catch (e) {
      debugPrint('Error al obtener predicción: $e');
      rethrow;
    }
  }

  /// Stream de predicciones de un usuario
  /// 
  /// [userId] ID del usuario
  /// [limit] Número máximo de predicciones a obtener (opcional)
  /// Returns: Stream de lista de predicciones ordenadas por timestamp descendente
  Stream<List<Map<String, dynamic>>> getPredictionsStream(
    String userId, {
    int? limit,
  }) {
    Query query = _db
        .collection(_predictionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Obtener predicciones recientes
  /// 
  /// [userId] ID del usuario
  /// [limit] Número de predicciones a obtener
  /// Returns: Lista de predicciones más recientes
  Future<List<Map<String, dynamic>>> getRecentPredictions(
    String userId,
    int limit,
  ) async {
    try {
      final snapshot = await _db
          .collection(_predictionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error al obtener predicciones recientes: $e');
      rethrow;
    }
  }

  /// Actualizar resultado de una predicción
  /// 
  /// [predictionId] ID de la predicción
  /// [data] Datos a actualizar (típicamente result: 'win' o 'loss')
  Future<void> updatePrediction(
    String predictionId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection(_predictionsCollection).doc(predictionId).update(data);
    } catch (e) {
      debugPrint('Error al actualizar predicción: $e');
      rethrow;
    }
  }

  /// Eliminar predicción
  /// 
  /// [predictionId] ID de la predicción
  Future<void> deletePrediction(String predictionId) async {
    try {
      await _db.collection(_predictionsCollection).doc(predictionId).delete();
    } catch (e) {
      debugPrint('Error al eliminar predicción: $e');
      rethrow;
    }
  }

  // ==================== OPERACIONES DE SESIONES ====================

  /// Crear nueva sesión de juego
  /// 
  /// [data] Datos de la sesión (userId, startTime, etc.)
  /// Returns: ID de la sesión creada
  Future<String> createSession(Map<String, dynamic> data) async {
    try {
      data['startTime'] = data['startTime'] ?? FieldValue.serverTimestamp();
      data['active'] = true;
      
      final docRef = await _db.collection(_sessionsCollection).add(data);
      return docRef.id;
    } catch (e) {
      debugPrint('Error al crear sesión: $e');
      rethrow;
    }
  }

  /// Obtener sesión activa del usuario
  /// 
  /// [userId] ID del usuario
  /// Returns: Datos de la sesión activa o null si no existe
  Future<Map<String, dynamic>?> getActiveSession(String userId) async {
    try {
      final snapshot = await _db
          .collection(_sessionsCollection)
          .where('userId', isEqualTo: userId)
          .where('active', isEqualTo: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    } catch (e) {
      debugPrint('Error al obtener sesión activa: $e');
      rethrow;
    }
  }

  /// Obtener sesión por ID
  /// 
  /// [sessionId] ID de la sesión
  /// Returns: Datos de la sesión o null si no existe
  Future<Map<String, dynamic>?> getSession(String sessionId) async {
    try {
      final doc = await _db.collection(_sessionsCollection).doc(sessionId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      final data = doc.data();
      if (data != null) {
        data['id'] = doc.id;
      }
      return data;
    } catch (e) {
      debugPrint('Error al obtener sesión: $e');
      rethrow;
    }
  }

  /// Finalizar sesión de juego
  /// 
  /// [sessionId] ID de la sesión
  /// [stats] Estadísticas finales de la sesión
  Future<void> endSession(String sessionId, Map<String, dynamic> stats) async {
    try {
      stats['endTime'] = FieldValue.serverTimestamp();
      stats['active'] = false;
      
      await _db.collection(_sessionsCollection).doc(sessionId).update(stats);
    } catch (e) {
      debugPrint('Error al finalizar sesión: $e');
      rethrow;
    }
  }

  /// Actualizar datos de sesión
  /// 
  /// [sessionId] ID de la sesión
  /// [data] Datos a actualizar
  Future<void> updateSession(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection(_sessionsCollection).doc(sessionId).update(data);
    } catch (e) {
      debugPrint('Error al actualizar sesión: $e');
      rethrow;
    }
  }

  /// Obtener historial de sesiones del usuario
  /// 
  /// [userId] ID del usuario
  /// [limit] Número máximo de sesiones a obtener (opcional)
  /// Returns: Lista de sesiones ordenadas por fecha descendente
  Future<List<Map<String, dynamic>>> getSessionHistory(
    String userId, {
    int? limit,
  }) async {
    try {
      Query query = _db
          .collection(_sessionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true);
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error al obtener historial de sesiones: $e');
      rethrow;
    }
  }

  // ==================== ESTADÍSTICAS ====================

  /// Obtener estadísticas del usuario
  /// 
  /// [userId] ID del usuario
  /// Returns: Mapa con estadísticas calculadas
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // Obtener todas las predicciones del usuario
      final predictionsSnapshot = await _db
          .collection(_predictionsCollection)
          .where('userId', isEqualTo: userId)
          .get();
      
      int totalPredictions = predictionsSnapshot.docs.length;
      int wins = 0;
      int losses = 0;
      double totalAmount = 0;
      
      for (final doc in predictionsSnapshot.docs) {
        final data = doc.data();
        final result = data['result'] as String?;
        final amount = (data['amount'] as num?)?.toDouble() ?? 0;
        
        if (result == 'win') {
          wins++;
          totalAmount += amount;
        } else if (result == 'loss') {
          losses++;
          totalAmount -= amount;
        }
      }
      
      double winRate = totalPredictions > 0 ? (wins / totalPredictions) * 100 : 0;
      
      return {
        'totalPredictions': totalPredictions,
        'wins': wins,
        'losses': losses,
        'winRate': winRate,
        'totalAmount': totalAmount,
        'lastUpdated': FieldValue.serverTimestamp(),
      };
    } catch (e) {
      debugPrint('Error al obtener estadísticas: $e');
      rethrow;
    }
  }

  // ==================== OPERACIONES BATCH ====================

  /// Ejecutar operaciones en batch (transacción atómica)
  /// 
  /// [operations] Función que recibe WriteBatch y realiza operaciones
  Future<void> executeBatch(Function(WriteBatch batch) operations) async {
    try {
      final batch = _db.batch();
      operations(batch);
      await batch.commit();
    } catch (e) {
      debugPrint('Error al ejecutar batch: $e');
      rethrow;
    }
  }

  /// Ejecutar transacción
  /// 
  /// [transactionHandler] Función que maneja la transacción
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) async {
    try {
      return await _db.runTransaction(transactionHandler);
    } catch (e) {
      debugPrint('Error al ejecutar transacción: $e');
      rethrow;
    }
  }

  // ==================== UTILIDADES ====================

  /// Habilitar red (útil después de deshabilitarla)
  Future<void> enableNetwork() async {
    try {
      await _db.enableNetwork();
    } catch (e) {
      debugPrint('Error al habilitar red: $e');
    }
  }

  /// Deshabilitar red (modo offline)
  Future<void> disableNetwork() async {
    try {
      await _db.disableNetwork();
    } catch (e) {
      debugPrint('Error al deshabilitar red: $e');
    }
  }

  /// Limpiar caché de persistencia
  Future<void> clearPersistence() async {
    try {
      await _db.clearPersistence();
    } catch (e) {
      debugPrint('Error al limpiar caché: $e');
    }
  }
}
