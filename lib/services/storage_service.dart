import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Servicio de almacenamiento local usando SharedPreferences
/// Maneja la persistencia de datos del usuario, historial y logros
class StorageService {
  static const String _userKey = 'user_data';
  static const String _historyKey = 'roulette_history';
  static const String _achievementsKey = 'achievements';
  static const String _settingsKey = 'app_settings';
  
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  /// Factory para inicializar el servicio
  static Future<StorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }
  
  /// Guarda los datos del usuario
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode({
      'id': user.id,
      'email': user.email,
      'balance': user.balance,
      'currentBet': user.currentBet,
      'totalSpins': user.totalSpins,
      'totalWins': user.totalWins,
      'totalLosses': user.totalLosses,
      'unlockedAchievements': user.unlockedAchievements,
    });
    await _prefs.setString(_userKey, json);
  }
  
  /// Carga los datos del usuario
  UserModel? loadUser() {
    final json = _prefs.getString(_userKey);
    if (json == null) return null;
    
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
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
      // Si hay error al parsear, retorna null
      return null;
    }
  }
  
  /// Guarda el historial de giros
  Future<void> saveHistory(List<int> history) async {
    await _prefs.setString(_historyKey, jsonEncode(history));
  }
  
  /// Carga el historial de giros
  List<int> loadHistory() {
    final json = _prefs.getString(_historyKey);
    if (json == null) return [];
    
    try {
      return List<int>.from(jsonDecode(json) as List);
    } catch (e) {
      return [];
    }
  }
  
  /// Guarda configuraciones de la app
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString('${_settingsKey}_$key', value);
    } else if (value is int) {
      await _prefs.setInt('${_settingsKey}_$key', value);
    } else if (value is double) {
      await _prefs.setDouble('${_settingsKey}_$key', value);
    } else if (value is bool) {
      await _prefs.setBool('${_settingsKey}_$key', value);
    }
  }
  
  /// Carga configuración de la app
  T? loadSetting<T>(String key) {
    return _prefs.get('${_settingsKey}_$key') as T?;
  }
  
  /// Limpia todos los datos
  Future<void> clearAll() async {
    await _prefs.clear();
  }
  
  /// Limpia solo los datos del usuario
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
  
  /// Limpia solo el historial
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }
}
