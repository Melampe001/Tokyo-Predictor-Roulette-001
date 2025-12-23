import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../models/user_model.dart';

/// Service for handling Cloud Firestore operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String usersCollection = 'users';
  static const String predictionsCollection = 'predictions';
  static const String gameSessionsCollection = 'gameSessions';

  FirestoreService() {
    // Enable offline persistence
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // ==================== User Operations ====================

  /// Create a new user document
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(usersCollection).doc(user.uid).set(
            user.toJson(),
            SetOptions(merge: false),
          );

      if (kDebugMode) {
        print('User created in Firestore: ${user.uid}');
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc =
          await _firestore.collection(usersCollection).doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update(data);

      if (kDebugMode) {
        print('User updated: $userId');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).delete();

      if (kDebugMode) {
        print('User deleted: $userId');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Listen to user changes (real-time)
  Stream<UserModel?> listenToUser(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  /// Update user statistics
  Future<void> updateUserStatistics(
      String userId, UserStatistics statistics) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'statistics': statistics.toJson(),
      });

      if (kDebugMode) {
        print('User statistics updated: $userId');
      }
    } catch (e) {
      throw Exception('Failed to update user statistics: $e');
    }
  }

  /// Update FCM token
  Future<void> updateFCMToken(String userId, String fcmToken) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'fcmToken': fcmToken,
      });

      if (kDebugMode) {
        print('FCM token updated for user: $userId');
      }
    } catch (e) {
      throw Exception('Failed to update FCM token: $e');
    }
  }

  // ==================== Prediction Operations ====================

  /// Create a new prediction
  Future<String> createPrediction(PredictionModel prediction) async {
    try {
      final docRef = await _firestore
          .collection(predictionsCollection)
          .add(prediction.toJson());

      if (kDebugMode) {
        print('Prediction created: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create prediction: $e');
    }
  }

  /// Get prediction by ID
  Future<PredictionModel?> getPrediction(String predictionId) async {
    try {
      final doc = await _firestore
          .collection(predictionsCollection)
          .doc(predictionId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return PredictionModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get prediction: $e');
    }
  }

  /// Get user predictions with pagination
  Future<List<PredictionModel>> getUserPredictions(
    String userId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(predictionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => PredictionModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user predictions: $e');
    }
  }

  /// Update prediction result
  Future<void> updatePredictionResult(
    String predictionId, {
    required int actualNumber,
    required bool isWin,
    double? accuracy,
  }) async {
    try {
      await _firestore.collection(predictionsCollection).doc(predictionId).update({
        'actualNumber': actualNumber,
        'isWin': isWin,
        'accuracy': accuracy,
      });

      if (kDebugMode) {
        print('Prediction result updated: $predictionId');
      }
    } catch (e) {
      throw Exception('Failed to update prediction result: $e');
    }
  }

  /// Delete prediction
  Future<void> deletePrediction(String predictionId) async {
    try {
      await _firestore
          .collection(predictionsCollection)
          .doc(predictionId)
          .delete();

      if (kDebugMode) {
        print('Prediction deleted: $predictionId');
      }
    } catch (e) {
      throw Exception('Failed to delete prediction: $e');
    }
  }

  /// Listen to user predictions (real-time)
  Stream<List<PredictionModel>> listenToUserPredictions(
    String userId, {
    int limit = 20,
  }) {
    return _firestore
        .collection(predictionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PredictionModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // ==================== Game Session Operations ====================

  /// Create a new game session
  Future<String> createGameSession(GameSessionModel session) async {
    try {
      final docRef = await _firestore
          .collection(gameSessionsCollection)
          .add(session.toJson());

      if (kDebugMode) {
        print('Game session created: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create game session: $e');
    }
  }

  /// Get game session by ID
  Future<GameSessionModel?> getGameSession(String sessionId) async {
    try {
      final doc = await _firestore
          .collection(gameSessionsCollection)
          .doc(sessionId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return GameSessionModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get game session: $e');
    }
  }

  /// Update game session
  Future<void> updateGameSession(
      String sessionId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(gameSessionsCollection)
          .doc(sessionId)
          .update(data);

      if (kDebugMode) {
        print('Game session updated: $sessionId');
      }
    } catch (e) {
      throw Exception('Failed to update game session: $e');
    }
  }

  /// End game session
  Future<void> endGameSession(
    String sessionId, {
    required double endingBalance,
    required int totalBets,
    required int totalWins,
    required int totalLosses,
    required double winRate,
    required double totalBetAmount,
    required double totalWinAmount,
  }) async {
    try {
      await _firestore
          .collection(gameSessionsCollection)
          .doc(sessionId)
          .update({
        'endTime': FieldValue.serverTimestamp(),
        'endingBalance': endingBalance,
        'totalBets': totalBets,
        'totalWins': totalWins,
        'totalLosses': totalLosses,
        'winRate': winRate,
        'totalBetAmount': totalBetAmount,
        'totalWinAmount': totalWinAmount,
      });

      if (kDebugMode) {
        print('Game session ended: $sessionId');
      }
    } catch (e) {
      throw Exception('Failed to end game session: $e');
    }
  }

  /// Get user game sessions with pagination
  Future<List<GameSessionModel>> getUserGameSessions(
    String userId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(gameSessionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => GameSessionModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user game sessions: $e');
    }
  }

  /// Delete game session
  Future<void> deleteGameSession(String sessionId) async {
    try {
      await _firestore
          .collection(gameSessionsCollection)
          .doc(sessionId)
          .delete();

      if (kDebugMode) {
        print('Game session deleted: $sessionId');
      }
    } catch (e) {
      throw Exception('Failed to delete game session: $e');
    }
  }

  // ==================== Batch Operations ====================

  /// Batch write operations
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final type = operation['type'] as String;
        final collection = operation['collection'] as String;
        final docId = operation['docId'] as String?;
        final data = operation['data'] as Map<String, dynamic>?;

        if (type == 'set' && data != null) {
          final docRef = docId != null
              ? _firestore.collection(collection).doc(docId)
              : _firestore.collection(collection).doc();
          batch.set(docRef, data);
        } else if (type == 'update' && data != null && docId != null) {
          final docRef = _firestore.collection(collection).doc(docId);
          batch.update(docRef, data);
        } else if (type == 'delete' && docId != null) {
          final docRef = _firestore.collection(collection).doc(docId);
          batch.delete(docRef);
        }
      }

      await batch.commit();

      if (kDebugMode) {
        print('Batch write completed: ${operations.length} operations');
      }
    } catch (e) {
      throw Exception('Failed to execute batch write: $e');
    }
  }

  // ==================== Transaction Operations ====================

  /// Execute a transaction
  Future<T> runTransaction<T>(
      Future<T> Function(Transaction transaction) updateFunction) async {
    try {
      return await _firestore.runTransaction(updateFunction);
    } catch (e) {
      throw Exception('Failed to execute transaction: $e');
    }
  }

  // ==================== Query Operations ====================

  /// Generic query with filters
  Future<List<Map<String, dynamic>>> query(
    String collection, {
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      // Apply filters
      if (filters != null) {
        for (final filter in filters) {
          query = query.where(filter.field,
              isEqualTo: filter.isEqualTo,
              isNotEqualTo: filter.isNotEqualTo,
              isLessThan: filter.isLessThan,
              isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
              isGreaterThan: filter.isGreaterThan,
              isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
              arrayContains: filter.arrayContains,
              arrayContainsAny: filter.arrayContainsAny,
              whereIn: filter.whereIn,
              whereNotIn: filter.whereNotIn,
              isNull: filter.isNull);
        }
      }

      // Apply ordering
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      // Apply pagination
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to execute query: $e');
    }
  }
}

/// Class representing a query filter
class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final List<dynamic>? whereNotIn;
  final bool? isNull;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}
