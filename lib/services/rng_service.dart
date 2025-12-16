import 'dart:math';

/// Servicio de generación de números aleatorios seguro
/// Encapsula Random.secure() para garantizar aleatoriedad criptográfica
class RNGService {
  final Random _rng = Random.secure();
  
  /// Genera un número aleatorio entre 0 y 36 (ruleta europea)
  int generateRouletteNumber() {
    return _rng.nextInt(37);
  }
  
  /// Genera un número aleatorio en un rango específico [min, max]
  int generateInRange(int min, int max) {
    if (min > max) {
      throw ArgumentError('min debe ser menor o igual que max');
    }
    return min + _rng.nextInt(max - min + 1);
  }
  
  /// Genera un número double aleatorio entre 0.0 y 1.0
  double generateDouble() {
    return _rng.nextDouble();
  }
  
  /// Genera un booleano aleatorio
  bool generateBool() {
    return _rng.nextBool();
  }
}
