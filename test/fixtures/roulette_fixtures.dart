/// Fixtures de prueba para datos de juego de ruleta
/// Proporciona datos de prueba consistentes para tests
class RouletteFixtures {
  /// Historia de giros corta
  static List<int> shortHistory() => [5, 12, 18, 7, 23];

  /// Historia de giros larga (20 números)
  static List<int> fullHistory() => [
        5, 12, 18, 7, 23, 36, 1, 14, 9, 27,
        33, 16, 4, 21, 2, 25, 17, 34, 6, 27,
      ];

  /// Historia con números repetidos (para test de predicción)
  static List<int> historyWithRepeats() => [10, 10, 10, 5, 10, 8];

  /// Historia solo con ceros
  static List<int> historyAllZeros() => [0, 0, 0, 0];

  /// Historia con números al límite superior
  static List<int> historyWithMaxNumbers() => [36, 36, 35, 36, 34];

  /// Historia con todos los números posibles (0-36)
  static List<int> historyAllNumbers() => List.generate(37, (i) => i);

  /// Historia vacía
  static List<int> emptyHistory() => [];

  /// Historia con un solo número
  static List<int> singleNumberHistory(int number) => [number];

  /// Números rojos de la ruleta europea
  static Set<int> redNumbers() => {
        1, 3, 5, 7, 9, 12, 14, 16, 18, 19,
        21, 23, 25, 27, 30, 32, 34, 36,
      };

  /// Números negros de la ruleta europea
  static Set<int> blackNumbers() => {
        2, 4, 6, 8, 10, 11, 13, 15, 17, 20,
        22, 24, 26, 28, 29, 31, 33, 35,
      };

  /// Sesión de juego básica
  static Map<String, dynamic> gameSession() => {
        'id': 'session123',
        'user_id': 'user123',
        'start_balance': 1000.0,
        'current_balance': 850.0,
        'spins': 10,
        'history': shortHistory(),
        'strategy': 'none',
        'started_at': '2024-01-01T10:00:00Z',
      };

  /// Sesión con estrategia Martingale
  static Map<String, dynamic> martingaleSession() => {
        'id': 'session456',
        'user_id': 'user123',
        'start_balance': 1000.0,
        'current_balance': 500.0,
        'spins': 20,
        'history': fullHistory(),
        'strategy': 'martingale',
        'base_bet': 10.0,
        'current_bet': 40.0,
        'started_at': '2024-01-01T10:00:00Z',
      };

  /// Sesión con balance agotado
  static Map<String, dynamic> brokenSession() => {
        'id': 'session789',
        'user_id': 'user456',
        'start_balance': 100.0,
        'current_balance': 0.0,
        'spins': 50,
        'history': fullHistory(),
        'strategy': 'martingale',
        'ended_at': '2024-01-01T11:00:00Z',
      };

  /// Sesión ganadora
  static Map<String, dynamic> winningSession() => {
        'id': 'session_win',
        'user_id': 'user789',
        'start_balance': 1000.0,
        'current_balance': 2500.0,
        'spins': 15,
        'history': [5, 12, 18, 7, 23, 12, 5, 18],
        'strategy': 'none',
        'started_at': '2024-01-01T10:00:00Z',
      };

  /// Resultados de apuesta
  static Map<String, dynamic> betResult({
    required int number,
    required bool won,
    required double amount,
  }) =>
      {
        'number': number,
        'won': won,
        'bet_amount': amount,
        'color': redNumbers().contains(number)
            ? 'red'
            : (number == 0 ? 'green' : 'black'),
        'timestamp': DateTime.now().toIso8601String(),
      };

  /// Lista de resultados de apuestas
  static List<Map<String, dynamic>> betHistory() => [
        betResult(number: 12, won: true, amount: 10.0),
        betResult(number: 7, won: false, amount: 10.0),
        betResult(number: 23, won: true, amount: 10.0),
        betResult(number: 15, won: false, amount: 10.0),
        betResult(number: 36, won: true, amount: 10.0),
      ];

  /// Predicción de ejemplo
  static Map<String, dynamic> prediction() => {
        'number': 12,
        'confidence': 0.75,
        'based_on_history': shortHistory(),
        'method': 'frequency',
        'timestamp': DateTime.now().toIso8601String(),
      };

  /// Estadísticas de juego
  static Map<String, dynamic> gameStatistics() => {
        'total_spins': 100,
        'wins': 45,
        'losses': 55,
        'win_rate': 0.45,
        'total_bet': 1000.0,
        'total_won': 900.0,
        'net_profit': -100.0,
        'average_bet': 10.0,
        'max_bet': 80.0,
        'longest_win_streak': 5,
        'longest_loss_streak': 8,
      };

  /// Configuración de apuestas
  static Map<String, dynamic> betConfig() => {
        'min_bet': 1.0,
        'max_bet': 100.0,
        'default_bet': 10.0,
        'martingale_enabled': false,
        'base_bet': 10.0,
      };

  /// Configuración de apuestas con Martingale
  static Map<String, dynamic> martingaleBetConfig() => {
        'min_bet': 1.0,
        'max_bet': 1000.0,
        'default_bet': 10.0,
        'martingale_enabled': true,
        'base_bet': 10.0,
        'max_martingale_rounds': 10,
      };
}
