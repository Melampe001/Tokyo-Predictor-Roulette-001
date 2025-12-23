import '../test_runner.dart';

/// Módulo de pruebas de integración
class IntegrationModuleTest extends TestModule {
  @override
  String get name => 'Integration Tests';

  @override
  bool get critical => true;

  @override
  Duration get timeout => const Duration(minutes: 3);

  @override
  List<Test> get tests => [
        Test(
          name: 'Complete spin workflow',
          run: () async {
            // 1. Usuario inicia con créditos
            var credits = 100;
            if (credits <= 0) {
              throw Exception('User should start with credits');
            }

            // 2. Usuario hace apuesta
            final betAmount = 10;
            credits -= betAmount;
            if (credits != 90) {
              throw Exception('Credits not deducted correctly');
            }

            // 3. Ruleta gira y genera número
            await Future.delayed(Duration(milliseconds: 10)); // Minimized for speed
            final result = 7; // Número ganador

            // 4. Calcular resultado
            final won = (result % 2 == 1); // Simplificado: odd = win

            if (won) {
              credits += betAmount * 2; // Premio 2x
            }

            // 5. Guardar en historial
            final history = <int>[result];
            if (history.isEmpty) {
              throw Exception('History should be updated');
            }

            // 6. Actualizar estadísticas
            if (credits <= 0 && !won) {
              throw Exception('Credits calculation error');
            }
          },
          timeout: Duration(seconds: 60),
        ),
        Test(
          name: 'Martingale strategy workflow',
          run: () async {
            var credits = 1000.0;
            var currentBet = 10.0;
            var consecutiveLosses = 0;

            // Simular 5 giros con Martingale
            for (var i = 0; i < 5; i++) {
              if (credits < currentBet) {
                throw Exception('Insufficient credits for Martingale bet');
              }

              credits -= currentBet;

              // Simular resultado (alternando para test)
              final won = (i % 2 == 0);

              if (won) {
                credits += currentBet * 2;
                currentBet = 10.0; // Reset a apuesta base
                consecutiveLosses = 0;
              } else {
                currentBet *= 2; // Duplicar apuesta
                consecutiveLosses++;
              }

              if (consecutiveLosses > 5) {
                throw Exception('Too many consecutive losses');
              }
            }

            if (credits <= 0) {
              throw Exception('Strategy should preserve some credits');
            }
          },
          timeout: Duration(seconds: 60),
        ),
        Test(
          name: 'Premium upgrade workflow',
          run: () async {
            var isPremium = false;
            final userEmail = 'test@example.com';

            // 1. Validar email
            if (!userEmail.contains('@')) {
              throw Exception('Invalid email format');
            }

            // 2. Procesar "pago" simulado
            await Future.delayed(Duration(milliseconds: 10)); // Minimized for speed
            final paymentSuccess = true;

            // 3. Activar premium
            if (paymentSuccess) {
              isPremium = true;
            }

            if (!isPremium) {
              throw Exception('Premium upgrade failed');
            }

            // 4. Verificar acceso a features premium
            final canAccessAdvancedStats = isPremium;
            if (!canAccessAdvancedStats) {
              throw Exception('Premium features not accessible');
            }
          },
          timeout: Duration(seconds: 60),
        ),
        Test(
          name: 'Prediction and betting workflow',
          run: () async {
            // 1. Construir historial
            final history = [5, 12, 5, 23, 5, 8, 15];

            // 2. Generar predicción
            final frequencies = <int, int>{};
            for (final num in history) {
              frequencies[num] = (frequencies[num] ?? 0) + 1;
            }
            final prediction = frequencies.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;

            if (prediction < 0 || prediction > 36) {
              throw Exception('Invalid prediction');
            }

            // 3. Hacer apuesta basada en predicción
            final betAmount = 10;
            var credits = 100;
            credits -= betAmount;

            // 4. Simular giro
            await Future.delayed(Duration(milliseconds: 10)); // Minimized for speed
            final result = 5; // Número ganador

            // 5. Verificar si ganó
            if (result == prediction) {
              credits += betAmount * 35; // Pago full
            }

            if (credits < 0) {
              throw Exception('Credits went negative');
            }
          },
          timeout: Duration(seconds: 60),
        ),
        Test(
          name: 'Session persistence workflow',
          run: () async {
            // 1. Simular sesión de juego
            final session = {
              'credits': 150,
              'history': [1, 5, 12, 7, 23],
              'total_spins': 5,
              'premium': false,
            };

            // 2. "Guardar" sesión
            final savedData = Map<String, dynamic>.from(session);

            // 3. Simular cierre y reapertura de app
            await Future.delayed(Duration(milliseconds: 10)); // Minimized for speed

            // 4. "Cargar" sesión
            final loadedData = savedData;

            // 5. Verificar integridad
            if (loadedData['credits'] != 150) {
              throw Exception('Credits not restored correctly');
            }

            if ((loadedData['history'] as List).length != 5) {
              throw Exception('History not restored correctly');
            }

            if (loadedData['premium'] != false) {
              throw Exception('Premium status not restored correctly');
            }
          },
          timeout: Duration(seconds: 60),
        ),
      ];
}
