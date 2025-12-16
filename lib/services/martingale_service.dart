/// Servicio de estrategia Martingale
/// ADVERTENCIA: Esta es una simulación educativa.
/// La estrategia Martingale tiene riesgos significativos en juegos reales
/// y puede llevar a pérdidas importantes. No la use en juegos de azar reales.
class MartingaleService {
  double _baseBet;
  double _currentBet;
  bool _lastWin;
  
  MartingaleService({double baseBet = 10.0})
      : _baseBet = baseBet,
        _currentBet = baseBet,
        _lastWin = true;
  
  double get baseBet => _baseBet;
  double get currentBet => _currentBet;
  bool get lastWin => _lastWin;
  
  set baseBet(double value) {
    if (value <= 0) {
      throw ArgumentError('La apuesta base debe ser mayor que 0');
    }
    _baseBet = value;
    reset();
  }
  
  /// Calcula la siguiente apuesta basada en el resultado
  /// Si se gana: vuelve a la apuesta base
  /// Si se pierde: duplica la apuesta
  double getNextBet(bool won, {double? maxBet}) {
    if (won) {
      _currentBet = _baseBet;
      _lastWin = true;
    } else {
      _currentBet *= 2;
      _lastWin = false;
    }
    
    // Limita la apuesta al máximo si se especifica
    if (maxBet != null && _currentBet > maxBet) {
      _currentBet = maxBet;
    }
    
    return _currentBet;
  }
  
  /// Reinicia el servicio a valores iniciales
  void reset() {
    _currentBet = _baseBet;
    _lastWin = true;
  }
}
