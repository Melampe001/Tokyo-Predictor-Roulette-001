import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

/// Tests de idempotencia para las funciones principales de la aplicación
/// 
/// Estos tests verifican que las operaciones pueden ejecutarse múltiples veces
/// con el mismo resultado, sin efectos secundarios no deseados.
void main() {
  group('Idempotencia de MartingaleAdvisor', () {
    test('reset() es idempotente', () {
      final advisor = MartingaleAdvisor();
      
      // Modificar estado: hacer que la apuesta suba
      advisor.getNextBet(false); // Duplicar apuesta (pérdida)
      advisor.getNextBet(false); // Duplicar de nuevo
      advisor.getNextBet(false); // Y otra vez
      
      // Verificar que el estado cambió
      expect(advisor.currentBet, greaterThan(advisor.baseBet));
      
      // Primera ejecución de reset
      advisor.reset();
      final bet1 = advisor.currentBet;
      final lastWin1 = advisor.lastWin;
      
      // Segunda ejecución de reset (debe ser idempotente)
      advisor.reset();
      final bet2 = advisor.currentBet;
      final lastWin2 = advisor.lastWin;
      
      // Tercera ejecución de reset (verificación adicional)
      advisor.reset();
      final bet3 = advisor.currentBet;
      final lastWin3 = advisor.lastWin;
      
      // Verificar que todas las ejecuciones producen el mismo resultado
      expect(bet1, equals(bet2), reason: 'reset() debe ser idempotente');
      expect(bet2, equals(bet3), reason: 'reset() debe ser idempotente');
      expect(bet1, equals(advisor.baseBet), reason: 'reset() debe retornar a baseBet');
      
      expect(lastWin1, equals(lastWin2), reason: 'lastWin debe ser consistente');
      expect(lastWin2, equals(lastWin3), reason: 'lastWin debe ser consistente');
      expect(lastWin1, isTrue, reason: 'reset() debe marcar lastWin como true');
    });
    
    test('getNextBet con misma secuencia produce mismo resultado', () {
      final advisor1 = MartingaleAdvisor();
      final advisor2 = MartingaleAdvisor();
      
      // Secuencia de resultados: pérdida, pérdida, ganancia, pérdida
      final sequence = [false, false, true, false];
      
      // Ejecutar secuencia en ambos advisors
      final bets1 = sequence.map((win) => advisor1.getNextBet(win)).toList();
      final bets2 = sequence.map((win) => advisor2.getNextBet(win)).toList();
      
      // Los resultados deben ser idénticos
      expect(bets1, equals(bets2), 
        reason: 'Misma secuencia debe producir mismas apuestas');
      
      // Verificar valores esperados de la estrategia Martingale
      // Apuesta base = 1.0
      // false: 1.0 -> pérdida, próxima apuesta = 2.0
      // false: 2.0 -> pérdida, próxima apuesta = 4.0
      // true: 4.0 -> ganancia, próxima apuesta = 1.0 (reset)
      // false: 1.0 -> pérdida, próxima apuesta = 2.0
      expect(bets1, equals([2.0, 4.0, 1.0, 2.0]));
    });
    
    test('configuración de baseBet es idempotente', () {
      final advisor = MartingaleAdvisor();
      final originalBaseBet = advisor.baseBet;
      
      // "Configurar" baseBet (en este caso, simplemente leer)
      // En un escenario real, esto podría ser una operación de configuración
      final baseBet1 = advisor.baseBet;
      final baseBet2 = advisor.baseBet;
      final baseBet3 = advisor.baseBet;
      
      // Todas las lecturas deben ser idénticas
      expect(baseBet1, equals(baseBet2));
      expect(baseBet2, equals(baseBet3));
      expect(baseBet1, equals(originalBaseBet));
    });
    
    test('aplicar secuencia completa dos veces produce mismo resultado final', () {
      // Crear dos advisors con la misma configuración
      final advisor1 = MartingaleAdvisor();
      final advisor2 = MartingaleAdvisor();
      
      final winSequence = [true, false, false, true, false, true, true];
      
      // Aplicar secuencia completa al primer advisor
      for (var win in winSequence) {
        advisor1.getNextBet(win);
      }
      final finalBet1 = advisor1.currentBet;
      final finalLastWin1 = advisor1.lastWin;
      
      // Aplicar la misma secuencia al segundo advisor
      for (var win in winSequence) {
        advisor2.getNextBet(win);
      }
      final finalBet2 = advisor2.currentBet;
      final finalLastWin2 = advisor2.lastWin;
      
      // Estados finales deben ser idénticos
      expect(finalBet1, equals(finalBet2));
      expect(finalLastWin1, equals(finalLastWin2));
    });
  });
  
  group('Idempotencia de RouletteLogic', () {
    test('predictNext con misma historia produce mismo resultado', () {
      final logic = RouletteLogic();
      
      // Historia de giros conocida
      final history = [12, 35, 3, 26, 12, 35, 12, 3];
      
      // Hacer predicción múltiples veces con misma historia
      final prediction1 = logic.predictNext(history);
      final prediction2 = logic.predictNext(history);
      final prediction3 = logic.predictNext(history);
      
      // Todas las predicciones deben ser idénticas
      expect(prediction1, equals(prediction2),
        reason: 'predictNext debe ser determinístico');
      expect(prediction2, equals(prediction3),
        reason: 'predictNext debe ser determinístico');
      
      // El resultado debe ser uno de los números en la historia
      // (ya que la predicción usa el más frecuente)
      expect(history.contains(prediction1), isTrue,
        reason: 'Predicción debe ser de la historia');
      
      // Verificar que es el número más frecuente (12 aparece 3 veces)
      expect(prediction1, equals(12),
        reason: 'Debe predecir el número más frecuente');
    });
    
    test('predictNext con historia vacía es consistente', () {
      final logic = RouletteLogic();
      final emptyHistory = <int>[];
      
      // Con RNG, el resultado no será determinístico, pero la función
      // debe poder llamarse múltiples veces sin error
      expect(() => logic.predictNext(emptyHistory), returnsNormally);
      expect(() => logic.predictNext(emptyHistory), returnsNormally);
      expect(() => logic.predictNext(emptyHistory), returnsNormally);
    });
    
    test('generateSpin ejecutado múltiples veces no causa errores', () {
      final logic = RouletteLogic();
      
      // Generar múltiples giros
      final spins = List.generate(100, (_) => logic.generateSpin());
      
      // Verificar que todos los giros son válidos (0-36 para ruleta europea)
      for (var spin in spins) {
        expect(spin, greaterThanOrEqualTo(0));
        expect(spin, lessThanOrEqualTo(36));
      }
      
      // Verificar que hay variedad (no todos iguales)
      final uniqueSpins = spins.toSet();
      expect(uniqueSpins.length, greaterThan(1),
        reason: 'RNG debe generar variedad de números');
    });
    
    test('wheel configuration es idempotente', () {
      final logic1 = RouletteLogic();
      final logic2 = RouletteLogic();
      
      // Verificar que ambas instancias tienen la misma configuración
      expect(logic1.wheel.length, equals(logic2.wheel.length));
      expect(logic1.wheel, equals(logic2.wheel));
      
      // Verificar que la configuración no cambia al usarla
      final wheelBefore = List<int>.from(logic1.wheel);
      logic1.generateSpin();
      logic1.generateSpin();
      logic1.generateSpin();
      final wheelAfter = logic1.wheel;
      
      expect(wheelBefore, equals(wheelAfter),
        reason: 'wheel no debe modificarse al usarse');
    });
  });
  
  group('Idempotencia de Operaciones Combinadas', () {
    test('secuencia completa de juego es reproducible', () {
      // Simular una sesión de juego completa
      final logic1 = RouletteLogic();
      final advisor1 = MartingaleAdvisor();
      
      final logic2 = RouletteLogic();
      final advisor2 = MartingaleAdvisor();
      
      // Usar una secuencia de giros predefinida (determinística)
      final predefinedSpins = [12, 35, 3, 26, 0, 32, 15, 19, 4, 21];
      final history1 = <int>[];
      final history2 = <int>[];
      
      final bets1 = <double>[];
      final bets2 = <double>[];
      
      // Simular juego con apuestas en rojo (números pares ganan)
      for (var spin in predefinedSpins) {
        history1.add(spin);
        history2.add(spin);
        
        final win = (spin % 2 == 0) && (spin != 0);
        
        final bet1 = advisor1.getNextBet(win);
        final bet2 = advisor2.getNextBet(win);
        
        bets1.add(bet1);
        bets2.add(bet2);
      }
      
      // Verificar que ambas simulaciones produjeron los mismos resultados
      expect(bets1, equals(bets2),
        reason: 'Misma secuencia debe producir mismas apuestas');
      expect(history1, equals(history2),
        reason: 'Historias deben ser idénticas');
      
      // Verificar predicciones
      final prediction1 = logic1.predictNext(history1);
      final prediction2 = logic2.predictNext(history2);
      
      expect(prediction1, equals(prediction2),
        reason: 'Misma historia debe producir misma predicción');
    });
    
    test('resetear advisor múltiples veces durante juego es idempotente', () {
      final advisor = MartingaleAdvisor();
      final initialBet = advisor.baseBet;
      
      // Jugar algunas rondas
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      
      // Reset múltiple
      advisor.reset();
      final betAfterReset1 = advisor.currentBet;
      
      advisor.reset();
      final betAfterReset2 = advisor.currentBet;
      
      advisor.reset();
      final betAfterReset3 = advisor.currentBet;
      
      // Todos los resets deben producir el mismo resultado
      expect(betAfterReset1, equals(initialBet));
      expect(betAfterReset2, equals(initialBet));
      expect(betAfterReset3, equals(initialBet));
      expect(betAfterReset1, equals(betAfterReset2));
      expect(betAfterReset2, equals(betAfterReset3));
    });
  });
  
  group('Tests de Regresión de Idempotencia', () {
    test('configuración no se corrompe después de muchas operaciones', () {
      final advisor = MartingaleAdvisor();
      final initialBaseBet = advisor.baseBet;
      
      // Ejecutar muchas operaciones
      for (var i = 0; i < 1000; i++) {
        final win = (i % 3 == 0); // Patrón alternado
        advisor.getNextBet(win);
      }
      
      // Reset
      advisor.reset();
      
      // Verificar que la configuración base no se corrompió
      expect(advisor.baseBet, equals(initialBaseBet),
        reason: 'baseBet no debe cambiar después de muchas operaciones');
      expect(advisor.currentBet, equals(initialBaseBet),
        reason: 'reset debe funcionar después de muchas operaciones');
    });
    
    test('predicción permanece estable para misma entrada', () {
      final logic = RouletteLogic();
      final testHistory = [5, 12, 5, 23, 5, 8, 5];
      
      // Hacer predicción y guardar resultado
      final firstPrediction = logic.predictNext(testHistory);
      
      // Hacer muchas otras operaciones
      for (var i = 0; i < 100; i++) {
        logic.generateSpin();
        logic.predictNext([1, 2, 3, 4, 5]);
      }
      
      // Volver a hacer la predicción original
      final laterPrediction = logic.predictNext(testHistory);
      
      // Debe ser la misma
      expect(laterPrediction, equals(firstPrediction),
        reason: 'Predicción debe ser estable para misma entrada');
    });
  });
}
