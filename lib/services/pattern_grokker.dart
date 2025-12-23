import 'dart:math';

/// PatternGrokker - Deep pattern analysis service for roulette predictions
/// "Grok" means to understand deeply and intuitively - this service analyzes
/// roulette spin history to identify patterns, trends, and statistical insights.
class PatternGrokker {
  final Random _rng = Random.secure();

  /// Analiza profundamente el historial de giros para encontrar patrones
  /// Returns a comprehensive analysis of the spin history
  PatternAnalysis grokHistory(List<int> history) {
    if (history.isEmpty) {
      return PatternAnalysis.empty();
    }

    return PatternAnalysis(
      hotNumbers: _findHotNumbers(history),
      coldNumbers: _findColdNumbers(history),
      streaks: _findStreaks(history),
      sectorAnalysis: _analyzeSectors(history),
      colorAnalysis: _analyzeColors(history),
      evenOddAnalysis: _analyzeEvenOdd(history),
      recommendations: _generateRecommendations(history),
    );
  }

  /// Encuentra los números "calientes" (más frecuentes)
  List<HotNumber> _findHotNumbers(List<int> history) {
    final frequency = <int, int>{};
    for (final num in history) {
      frequency[num] = (frequency[num] ?? 0) + 1;
    }

    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map((e) => HotNumber(
              number: e.key,
              frequency: e.value,
              percentage: (e.value / history.length * 100),
            ))
        .toList();
  }

  /// Encuentra los números "fríos" (menos frecuentes)
  List<ColdNumber> _findColdNumbers(List<int> history) {
    final frequency = <int, int>{};
    // Initialize all numbers 0-36
    for (int i = 0; i <= 36; i++) {
      frequency[i] = 0;
    }
    // Count occurrences
    for (final num in history) {
      frequency[num] = (frequency[num] ?? 0) + 1;
    }

    final sorted = frequency.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted
        .take(5)
        .map((e) => ColdNumber(
              number: e.key,
              frequency: e.value,
              missedSpins: history.length - e.value,
            ))
        .toList();
  }

  /// Encuentra rachas de colores, pares/impares, etc.
  StreakAnalysis _findStreaks(List<int> history) {
    int currentRedStreak = 0;
    int currentBlackStreak = 0;
    int currentEvenStreak = 0;
    int currentOddStreak = 0;
    int maxRedStreak = 0;
    int maxBlackStreak = 0;

    for (final num in history.reversed) {
      final isRed = _isRedNumber(num);
      final isBlack = !isRed && num != 0;
      final isEven = num != 0 && num % 2 == 0;
      final isOdd = num != 0 && num % 2 != 0;

      // Red/Black streaks
      if (isRed) {
        currentRedStreak++;
        currentBlackStreak = 0;
        maxRedStreak = max(maxRedStreak, currentRedStreak);
      } else if (isBlack) {
        currentBlackStreak++;
        currentRedStreak = 0;
        maxBlackStreak = max(maxBlackStreak, currentBlackStreak);
      }

      // Even/Odd streaks
      if (isEven) {
        currentEvenStreak++;
        currentOddStreak = 0;
      } else if (isOdd) {
        currentOddStreak++;
        currentEvenStreak = 0;
      }
    }

    return StreakAnalysis(
      currentRedStreak: currentRedStreak,
      currentBlackStreak: currentBlackStreak,
      maxRedStreak: maxRedStreak,
      maxBlackStreak: maxBlackStreak,
      currentEvenStreak: currentEvenStreak,
      currentOddStreak: currentOddStreak,
    );
  }

  /// Analiza por sectores (docenas y columnas)
  SectorAnalysis _analyzeSectors(List<int> history) {
    final dozens = <int, int>{1: 0, 2: 0, 3: 0};
    final columns = <int, int>{1: 0, 2: 0, 3: 0};

    for (final num in history) {
      if (num == 0) continue;

      // Docenas: 1-12, 13-24, 25-36
      if (num >= 1 && num <= 12) dozens[1] = (dozens[1] ?? 0) + 1;
      if (num >= 13 && num <= 24) dozens[2] = (dozens[2] ?? 0) + 1;
      if (num >= 25 && num <= 36) dozens[3] = (dozens[3] ?? 0) + 1;

      // Columnas: 1,4,7..., 2,5,8..., 3,6,9...
      final column = (num % 3 == 0) ? 3 : (num % 3);
      columns[column] = (columns[column] ?? 0) + 1;
    }

    return SectorAnalysis(
      firstDozenCount: dozens[1]!,
      secondDozenCount: dozens[2]!,
      thirdDozenCount: dozens[3]!,
      firstColumnCount: columns[1]!,
      secondColumnCount: columns[2]!,
      thirdColumnCount: columns[3]!,
    );
  }

  /// Analiza distribución de colores
  ColorAnalysis _analyzeColors(List<int> history) {
    int redCount = 0;
    int blackCount = 0;
    int greenCount = 0;

    for (final num in history) {
      if (num == 0) {
        greenCount++;
      } else if (_isRedNumber(num)) {
        redCount++;
      } else {
        blackCount++;
      }
    }

    return ColorAnalysis(
      redCount: redCount,
      blackCount: blackCount,
      greenCount: greenCount,
      redPercentage: (redCount / history.length * 100),
      blackPercentage: (blackCount / history.length * 100),
      greenPercentage: (greenCount / history.length * 100),
    );
  }

  /// Analiza pares vs impares
  EvenOddAnalysis _analyzeEvenOdd(List<int> history) {
    int evenCount = 0;
    int oddCount = 0;
    int zeroCount = 0;

    for (final num in history) {
      if (num == 0) {
        zeroCount++;
      } else if (num % 2 == 0) {
        evenCount++;
      } else {
        oddCount++;
      }
    }

    return EvenOddAnalysis(
      evenCount: evenCount,
      oddCount: oddCount,
      evenPercentage: (evenCount / (history.length - zeroCount) * 100),
      oddPercentage: (oddCount / (history.length - zeroCount) * 100),
    );
  }

  /// Genera recomendaciones basadas en el análisis profundo
  List<Recommendation> _generateRecommendations(List<int> history) {
    final recommendations = <Recommendation>[];
    final analysis = grokHistory(history);

    // Recomendación basada en números calientes
    if (analysis.hotNumbers.isNotEmpty) {
      final hottest = analysis.hotNumbers.first;
      recommendations.add(Recommendation(
        type: RecommendationType.hotNumber,
        suggestedNumber: hottest.number,
        confidence: _calculateConfidence(hottest.frequency, history.length),
        reasoning: 'El número ${hottest.number} ha salido ${hottest.frequency} veces '
            '(${hottest.percentage.toStringAsFixed(1)}% del historial)',
      ));
    }

    // Recomendación basada en rachas
    if (analysis.streaks.currentRedStreak >= 3) {
      recommendations.add(Recommendation(
        type: RecommendationType.streak,
        suggestedNumber: _getRandomBlackNumber(),
        confidence: 0.6,
        reasoning:
            'Racha de ${analysis.streaks.currentRedStreak} rojos consecutivos. '
            'Considera apostar a negro (falacia del jugador, solo educativo).',
      ));
    } else if (analysis.streaks.currentBlackStreak >= 3) {
      recommendations.add(Recommendation(
        type: RecommendationType.streak,
        suggestedNumber: _getRandomRedNumber(),
        confidence: 0.6,
        reasoning:
            'Racha de ${analysis.streaks.currentBlackStreak} negros consecutivos. '
            'Considera apostar a rojo (falacia del jugador, solo educativo).',
      ));
    }

    // Recomendación basada en números fríos
    if (analysis.coldNumbers.isNotEmpty) {
      final coldest = analysis.coldNumbers.first;
      if (coldest.missedSpins > history.length * 0.7) {
        recommendations.add(Recommendation(
          type: RecommendationType.coldNumber,
          suggestedNumber: coldest.number,
          confidence: 0.5,
          reasoning: 'El número ${coldest.number} no ha salido en '
              '${coldest.missedSpins} giros. Teoría de "números debidos".',
        ));
      }
    }

    return recommendations;
  }

  double _calculateConfidence(int frequency, int totalSpins) {
    final percentage = frequency / totalSpins;
    // Confidence based on frequency: higher frequency = higher confidence
    // Capped at 0.8 (80%) since roulette is random
    return min(0.5 + (percentage * 2), 0.8);
  }

  int _getRandomBlackNumber() {
    const blackNumbers = [
      2,
      4,
      6,
      8,
      10,
      11,
      13,
      15,
      17,
      20,
      22,
      24,
      26,
      28,
      29,
      31,
      33,
      35
    ];
    return blackNumbers[_rng.nextInt(blackNumbers.length)];
  }

  int _getRandomRedNumber() {
    const redNumbers = [
      1,
      3,
      5,
      7,
      9,
      12,
      14,
      16,
      18,
      19,
      21,
      23,
      25,
      27,
      30,
      32,
      34,
      36
    ];
    return redNumbers[_rng.nextInt(redNumbers.length)];
  }

  bool _isRedNumber(int number) {
    const redNumbers = {
      1,
      3,
      5,
      7,
      9,
      12,
      14,
      16,
      18,
      19,
      21,
      23,
      25,
      27,
      30,
      32,
      34,
      36
    };
    return redNumbers.contains(number);
  }
}

/// Análisis completo de patrones
class PatternAnalysis {
  final List<HotNumber> hotNumbers;
  final List<ColdNumber> coldNumbers;
  final StreakAnalysis streaks;
  final SectorAnalysis sectorAnalysis;
  final ColorAnalysis colorAnalysis;
  final EvenOddAnalysis evenOddAnalysis;
  final List<Recommendation> recommendations;

  PatternAnalysis({
    required this.hotNumbers,
    required this.coldNumbers,
    required this.streaks,
    required this.sectorAnalysis,
    required this.colorAnalysis,
    required this.evenOddAnalysis,
    required this.recommendations,
  });

  factory PatternAnalysis.empty() {
    return PatternAnalysis(
      hotNumbers: [],
      coldNumbers: [],
      streaks: StreakAnalysis.empty(),
      sectorAnalysis: SectorAnalysis.empty(),
      colorAnalysis: ColorAnalysis.empty(),
      evenOddAnalysis: EvenOddAnalysis.empty(),
      recommendations: [],
    );
  }
}

class HotNumber {
  final int number;
  final int frequency;
  final double percentage;

  HotNumber({
    required this.number,
    required this.frequency,
    required this.percentage,
  });
}

class ColdNumber {
  final int number;
  final int frequency;
  final int missedSpins;

  ColdNumber({
    required this.number,
    required this.frequency,
    required this.missedSpins,
  });
}

class StreakAnalysis {
  final int currentRedStreak;
  final int currentBlackStreak;
  final int maxRedStreak;
  final int maxBlackStreak;
  final int currentEvenStreak;
  final int currentOddStreak;

  StreakAnalysis({
    required this.currentRedStreak,
    required this.currentBlackStreak,
    required this.maxRedStreak,
    required this.maxBlackStreak,
    required this.currentEvenStreak,
    required this.currentOddStreak,
  });

  factory StreakAnalysis.empty() {
    return StreakAnalysis(
      currentRedStreak: 0,
      currentBlackStreak: 0,
      maxRedStreak: 0,
      maxBlackStreak: 0,
      currentEvenStreak: 0,
      currentOddStreak: 0,
    );
  }
}

class SectorAnalysis {
  final int firstDozenCount;
  final int secondDozenCount;
  final int thirdDozenCount;
  final int firstColumnCount;
  final int secondColumnCount;
  final int thirdColumnCount;

  SectorAnalysis({
    required this.firstDozenCount,
    required this.secondDozenCount,
    required this.thirdDozenCount,
    required this.firstColumnCount,
    required this.secondColumnCount,
    required this.thirdColumnCount,
  });

  factory SectorAnalysis.empty() {
    return SectorAnalysis(
      firstDozenCount: 0,
      secondDozenCount: 0,
      thirdDozenCount: 0,
      firstColumnCount: 0,
      secondColumnCount: 0,
      thirdColumnCount: 0,
    );
  }
}

class ColorAnalysis {
  final int redCount;
  final int blackCount;
  final int greenCount;
  final double redPercentage;
  final double blackPercentage;
  final double greenPercentage;

  ColorAnalysis({
    required this.redCount,
    required this.blackCount,
    required this.greenCount,
    required this.redPercentage,
    required this.blackPercentage,
    required this.greenPercentage,
  });

  factory ColorAnalysis.empty() {
    return ColorAnalysis(
      redCount: 0,
      blackCount: 0,
      greenCount: 0,
      redPercentage: 0,
      blackPercentage: 0,
      greenPercentage: 0,
    );
  }
}

class EvenOddAnalysis {
  final int evenCount;
  final int oddCount;
  final double evenPercentage;
  final double oddPercentage;

  EvenOddAnalysis({
    required this.evenCount,
    required this.oddCount,
    required this.evenPercentage,
    required this.oddPercentage,
  });

  factory EvenOddAnalysis.empty() {
    return EvenOddAnalysis(
      evenCount: 0,
      oddCount: 0,
      evenPercentage: 0,
      oddPercentage: 0,
    );
  }
}

enum RecommendationType {
  hotNumber,
  coldNumber,
  streak,
  sector,
}

class Recommendation {
  final RecommendationType type;
  final int suggestedNumber;
  final double confidence; // 0.0 to 1.0
  final String reasoning;

  Recommendation({
    required this.type,
    required this.suggestedNumber,
    required this.confidence,
    required this.reasoning,
  });
}
