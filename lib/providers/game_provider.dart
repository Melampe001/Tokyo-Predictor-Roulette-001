import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/roulette_model.dart';
import '../models/prediction_model.dart';
import '../services/rng_service.dart';
import '../services/prediction_service.dart';
import '../services/martingale_service.dart';
import '../services/storage_service.dart';
import '../services/analytics_service.dart';
import '../utils/helpers.dart';

/// Provider principal del estado del juego
class GameProvider with ChangeNotifier {
  // Servicios
  final RNGService _rngService;
  final PredictionService _predictionService;
  final MartingaleService _martingaleService;
  final StorageService _storageService;
  final AnalyticsService _analyticsService;
  
  // Estado
  UserModel _user;
  RouletteModel _roulette;
  PredictionModel? _currentPrediction;
  bool _useMartingale = false;
  bool _isSpinning = false;
  
  GameProvider({
    required RNGService rngService,
    required PredictionService predictionService,
    required MartingaleService martingaleService,
    required StorageService storageService,
    required AnalyticsService analyticsService,
    UserModel? initialUser,
  })  : _rngService = rngService,
        _predictionService = predictionService,
        _martingaleService = martingaleService,
        _storageService = storageService,
        _analyticsService = analyticsService,
        _user = initialUser ?? const UserModel(id: 'default', email: ''),
        _roulette = const RouletteModel(currentNumber: -1, history: []);
  
  // Getters
  UserModel get user => _user;
  RouletteModel get roulette => _roulette;
  PredictionModel? get currentPrediction => _currentPrediction;
  bool get useMartingale => _useMartingale;
  bool get isSpinning => _isSpinning;
  bool get canSpin => _user.balance >= _user.currentBet && !_isSpinning;
  
  /// Inicializa el provider cargando datos guardados
  Future<void> initialize() async {
    final savedUser = _storageService.loadUser();
    if (savedUser != null) {
      _user = savedUser;
    }
    
    final savedHistory = _storageService.loadHistory();
    if (savedHistory.isNotEmpty) {
      _roulette = _roulette.copyWith(history: savedHistory);
    }
    
    notifyListeners();
  }
  
  /// Gira la ruleta
  Future<void> spin() async {
    if (!canSpin) return;
    
    _isSpinning = true;
    notifyListeners();
    
    // Genera predicción antes del giro si hay historial
    if (_roulette.history.isNotEmpty) {
      _currentPrediction = _predictionService.predictNext(_roulette.history);
    }
    
    // Espera un momento para la animación
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Genera el número
    final number = _rngService.generateRouletteNumber();
    
    // Simula resultado de apuesta (apostar a rojo como ejemplo)
    final bool won = Helpers.isRedNumber(number);
    
    // Calcula el cambio de balance
    final oldBalance = _user.balance;
    final double balanceChange = won ? _user.currentBet : -_user.currentBet;
    final newBalance = (oldBalance + balanceChange).clamp(0.0, double.infinity);
    
    // Actualiza el usuario
    _user = _user.copyWith(
      balance: newBalance,
      totalSpins: _user.totalSpins + 1,
      totalWins: won ? _user.totalWins + 1 : _user.totalWins,
      totalLosses: won ? _user.totalLosses : _user.totalLosses + 1,
    );
    
    // Actualiza la ruleta
    final newHistory = [..._roulette.history, number];
    if (newHistory.length > 20) {
      newHistory.removeAt(0);
    }
    _roulette = RouletteModel(
      currentNumber: number,
      history: newHistory,
      isSpinning: false,
    );
    
    // Actualiza apuesta según Martingale si está activado
    if (_useMartingale) {
      final nextBet = _martingaleService.getNextBet(
        won,
        maxBet: _user.balance,
      );
      _user = _user.copyWith(currentBet: nextBet);
    }
    
    // Log analytics
    _analyticsService.logSpin(number, won, _user.currentBet);
    _analyticsService.logBalanceChange(oldBalance, newBalance);
    
    // Guarda el estado
    await _saveState();
    
    _isSpinning = false;
    notifyListeners();
  }
  
  /// Cambia el estado de Martingale
  void toggleMartingale(bool value) {
    _useMartingale = value;
    if (value) {
      _martingaleService.baseBet = _user.currentBet;
    } else {
      _martingaleService.reset();
    }
    _analyticsService.logMartingaleToggle(value);
    notifyListeners();
  }
  
  /// Cambia la apuesta actual con validación completa
  void setCurrentBet(double bet) {
    // Validar edge cases primero
    if (bet.isNaN || bet.isInfinite) {
      if (kDebugMode) {
        debugPrint('⚠️ Invalid bet amount (NaN or Infinite)');
      }
      return;
    }
    
    // Validar rangos
    if (bet <= 0 || bet > _user.balance) return;
    
    // Validar contra el máximo permitido
    const maxBet = 1000.0;  // From AppConstants
    if (bet > maxBet) {
      if (kDebugMode) {
        debugPrint('⚠️ Bet exceeds maximum allowed');
      }
      return;
    }
    
    _user = _user.copyWith(currentBet: bet);
    if (_useMartingale) {
      _martingaleService.baseBet = bet;
    }
    notifyListeners();
  }
  
  /// Reinicia el juego
  Future<void> resetGame() async {
    _user = _user.copyWith(
      balance: 1000.0,
      currentBet: 10.0,
      totalSpins: 0,
      totalWins: 0,
      totalLosses: 0,
    );
    _roulette = const RouletteModel(currentNumber: -1, history: []);
    _currentPrediction = null;
    _martingaleService.reset();
    _martingaleService.baseBet = 10.0;
    
    await _saveState();
    notifyListeners();
  }
  
  /// Guarda el estado actual
  Future<void> _saveState() async {
    await _storageService.saveUser(_user);
    await _storageService.saveHistory(_roulette.history);
  }
  
  /// Limpia todos los datos
  Future<void> clearAllData() async {
    await _storageService.clearAll();
    await resetGame();
  }
}
