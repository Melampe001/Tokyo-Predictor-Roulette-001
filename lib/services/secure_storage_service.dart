import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

/// Servicio de almacenamiento seguro usando FlutterSecureStorage
/// Reemplaza SharedPreferences para datos sensibles con encriptación nativa
class SecureStorageService {
  static const String _userKey = 'user_data_secure';
  static const String _historyKey = 'roulette_history_secure';
  static const String _achievementsKey = 'achievements_secure';
  static const String _settingsKeyPrefix = 'settings_';
  
  // Configuración de seguridad para almacenamiento
  static const _secureStorageOptions = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,  // Resetea si hay error de encriptación
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  final FlutterSecureStorage _secureStorage;
  
  SecureStorageService([FlutterSecureStorage? storage]) 
      : _secureStorage = storage ?? _secureStorageOptions;
  
  /// Factory para inicializar el servicio
  static Future<SecureStorageService> initialize() async {
    return SecureStorageService();
  }
  
  /// Guarda los datos del usuario de forma segura
  Future<void> saveUser(UserModel user) async {
    try {
      final json = jsonEncode({
        'id': user.id,
        'email': user.email,
        'balance': user.balance,
        'currentBet': user.currentBet,
        'totalSpins': user.totalSpins,
        'totalWins': user.totalWins,
        'totalLosses': user.totalLosses,
        'unlockedAchievements': user.unlockedAchievements,
        'version': 1,  // Para futuras migraciones
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      await _secureStorage.write(key: _userKey, value: json);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error saving user data: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Carga los datos del usuario de forma segura
  Future<UserModel?> loadUser() async {
    try {
      final json = await _secureStorage.read(key: _userKey);
      if (json == null) return null;
      
      final data = jsonDecode(json) as Map<String, dynamic>;
      
      // Validar estructura de datos
      if (!_isValidUserData(data)) {
        if (kDebugMode) {
          debugPrint('⚠️ Invalid user data structure detected');
        }
        return null;
      }
      
      return UserModel(
        id: data['id'] as String,
        email: data['email'] as String,
        balance: (data['balance'] as num).toDouble(),
        currentBet: (data['currentBet'] as num).toDouble(),
        totalSpins: data['totalSpins'] as int,
        totalWins: data['totalWins'] as int,
        totalLosses: data['totalLosses'] as int,
        unlockedAchievements: List<String>.from(data['unlockedAchievements'] as List),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error loading user data: ${e.runtimeType}');
      }
      return null;
    }
  }
  
  /// Valida la estructura de datos del usuario
  bool _isValidUserData(Map<String, dynamic> data) {
    final requiredKeys = ['id', 'email', 'balance', 'currentBet', 
                         'totalSpins', 'totalWins', 'totalLosses', 
                         'unlockedAchievements'];
    
    for (final key in requiredKeys) {
      if (!data.containsKey(key)) return false;
    }
    
    // Validar tipos y rangos
    if (data['balance'] is! num || (data['balance'] as num) < 0) return false;
    if (data['currentBet'] is! num || (data['currentBet'] as num) < 0) return false;
    if (data['totalSpins'] is! int || (data['totalSpins'] as int) < 0) return false;
    
    return true;
  }
  
  /// Guarda el historial de giros
  Future<void> saveHistory(List<int> history) async {
    try {
      // Validar historial antes de guardar
      if (history.any((n) => n < 0 || n > 36)) {
        throw ArgumentError('Invalid roulette number in history');
      }
      
      await _secureStorage.write(
        key: _historyKey, 
        value: jsonEncode(history),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error saving history: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Carga el historial de giros
  Future<List<int>> loadHistory() async {
    try {
      final json = await _secureStorage.read(key: _historyKey);
      if (json == null) return [];
      
      final list = List<int>.from(jsonDecode(json) as List);
      
      // Validar datos cargados
      if (list.any((n) => n < 0 || n > 36)) {
        if (kDebugMode) {
          debugPrint('⚠️ Corrupted history data detected');
        }
        return [];
      }
      
      return list;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error loading history: ${e.runtimeType}');
      }
      return [];
    }
  }
  
  /// Guarda configuración de la app con validación
  Future<void> saveSetting(String key, dynamic value) async {
    // Validar clave
    if (!_isValidSettingKey(key)) {
      throw ArgumentError('Invalid setting key: $key');
    }
    
    // Validar valor
    if (value is String && value.length > 10000) {
      throw ArgumentError('Setting value too large');
    }
    
    try {
      final prefixedKey = '$_settingsKeyPrefix$key';
      await _secureStorage.write(key: prefixedKey, value: value.toString());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error saving setting: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Valida clave de configuración
  bool _isValidSettingKey(String key) {
    if (key.isEmpty || key.length > 50) return false;
    // Solo permite caracteres alfanuméricos y guiones bajos
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(key);
  }
  
  /// Carga configuración de la app
  Future<String?> loadSetting(String key) async {
    if (!_isValidSettingKey(key)) {
      throw ArgumentError('Invalid setting key: $key');
    }
    
    try {
      final prefixedKey = '$_settingsKeyPrefix$key';
      return await _secureStorage.read(key: prefixedKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error loading setting: ${e.runtimeType}');
      }
      return null;
    }
  }
  
  /// Limpia todos los datos de forma segura
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      
      if (kDebugMode) {
        debugPrint('✅ All secure data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error clearing data: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Limpia solo los datos del usuario
  Future<void> clearUser() async {
    try {
      await _secureStorage.delete(key: _userKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error clearing user: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Limpia solo el historial
  Future<void> clearHistory() async {
    try {
      await _secureStorage.delete(key: _historyKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error clearing history: ${e.runtimeType}');
      }
      rethrow;
    }
  }
  
  /// Verifica si hay datos del usuario guardados
  Future<bool> hasUserData() async {
    try {
      final json = await _secureStorage.read(key: _userKey);
      return json != null;
    } catch (e) {
      return false;
    }
  }
}
