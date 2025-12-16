import '../models/prediction_model.dart';
import 'rng_service.dart';

/// Servicio de predicciones para la ruleta
/// NOTA: Esta es una simulación educativa. Las predicciones son aleatorias
/// y no garantizan resultados reales. En ruletas reales, cada giro es independiente.
class PredictionService {
  final RNGService _rngService;
  
  PredictionService(this._rngService);
  
  /// Predice el siguiente número basado en el historial
  PredictionModel predictNext(List<int> history) {
    if (history.isEmpty) {
      return PredictionModel(
        predictedNumber: _rngService.generateRouletteNumber(),
        confidence: 0.1,
        method: 'random',
        timestamp: DateTime.now(),
      );
    }
    
    // Método 1: Número más frecuente
    final mostFrequent = _getMostFrequentNumber(history);
    
    // Método 2: Patrón de números calientes (hot numbers)
    final hotNumbers = _getHotNumbers(history);
    
    // Combinar métodos con aleatoriedad
    final predicted = hotNumbers.isNotEmpty && _rngService.generateDouble() > 0.5
        ? hotNumbers[_rngService.generateInRange(0, hotNumbers.length - 1)]
        : mostFrequent;
    
    return PredictionModel(
      predictedNumber: predicted,
      confidence: _calculateConfidence(history, predicted),
      method: 'frequency_analysis',
      timestamp: DateTime.now(),
    );
  }
  
  /// Obtiene el número más frecuente en el historial
  int _getMostFrequentNumber(List<int> history) {
    final freq = <int, int>{};
    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
  
  /// Obtiene los números calientes (que aparecen múltiples veces recientemente)
  List<int> _getHotNumbers(List<int> history) {
    final recentHistory = history.length > 10 
        ? history.sublist(history.length - 10) 
        : history;
    
    final freq = <int, int>{};
    for (final num in recentHistory) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    
    return freq.entries
        .where((e) => e.value >= 2)
        .map((e) => e.key)
        .toList();
  }
  
  /// Calcula el nivel de confianza de la predicción (0.0 - 1.0)
  double _calculateConfidence(List<int> history, int predicted) {
    if (history.length < 5) return 0.2;
    
    final count = history.where((n) => n == predicted).length;
    final confidence = count / history.length;
    
    return confidence.clamp(0.1, 0.9);
  }
}
