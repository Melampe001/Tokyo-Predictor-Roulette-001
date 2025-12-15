/// Funciones helper de utilidad
class Helpers {
  /// Determina si un número es rojo en la ruleta
  static bool isRedNumber(int number) {
    const redNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36};
    return redNumbers.contains(number);
  }
  
  /// Determina si un número es negro en la ruleta
  static bool isBlackNumber(int number) {
    return number != 0 && !isRedNumber(number);
  }
  
  /// Determina si un número es par
  static bool isEvenNumber(int number) {
    return number != 0 && number % 2 == 0;
  }
  
  /// Determina si un número es impar
  static bool isOddNumber(int number) {
    return number != 0 && number % 2 != 0;
  }
  
  /// Determina si un número está en el rango bajo (1-18)
  static bool isLowNumber(int number) {
    return number >= 1 && number <= 18;
  }
  
  /// Determina si un número está en el rango alto (19-36)
  static bool isHighNumber(int number) {
    return number >= 19 && number <= 36;
  }
  
  /// Formatea un número de balance a string con símbolo de moneda
  static String formatBalance(double balance) {
    return '\$${balance.toStringAsFixed(2)}';
  }
  
  /// Formatea un porcentaje
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
  
  /// Trunca un string si excede la longitud máxima
  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
  
  /// Calcula la ganancia o pérdida de una apuesta
  static double calculatePayout(bool won, double betAmount, double multiplier) {
    if (won) {
      return betAmount * multiplier;
    }
    return -betAmount;
  }
  
  /// Valida un email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  
  /// Valida que un número esté en el rango de la ruleta
  static bool isValidRouletteNumber(int number) {
    return number >= 0 && number <= 36;
  }
  
  /// Valida que una apuesta esté en el rango permitido
  static bool isValidBet(double bet, double balance) {
    return bet > 0 && bet <= balance;
  }
  
  /// Genera un ID único simple
  static String generateSimpleId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  /// Calcula la racha más larga de victorias/derrotas
  static int calculateLongestStreak(List<bool> results, bool targetValue) {
    if (results.isEmpty) return 0;
    
    int maxStreak = 0;
    int currentStreak = 0;
    
    for (final result in results) {
      if (result == targetValue) {
        currentStreak++;
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }
    
    return maxStreak;
  }
  
  /// Calcula la frecuencia de aparición de números
  static Map<int, int> calculateFrequency(List<int> numbers) {
    final frequency = <int, int>{};
    for (final number in numbers) {
      frequency[number] = (frequency[number] ?? 0) + 1;
    }
    return frequency;
  }
}
