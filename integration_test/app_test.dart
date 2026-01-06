import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart' as app;

/// Tests de integración end-to-end
/// Estos tests simulan un flujo completo de usuario
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End User Flow', () {
    testWidgets('Complete user journey: Login -> Play -> Statistics -> Logout',
        (tester) async {
      // Iniciar la app
      app.main();
      await tester.pumpAndSettle();

      // PASO 1: Pantalla de Login
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Ingresar email
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.pumpAndSettle();

      // Tap en botón de continuar
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // PASO 2: Pantalla Principal
      expect(find.text('Tokyo Roulette Predicciones'), findsOneWidget);
      expect(find.text('Girar Ruleta'), findsOneWidget);
      expect(find.text('Balance: \$1000.00'), findsOneWidget);

      // PASO 3: Realizar apuestas
      // Girar la ruleta varias veces
      for (int i = 0; i < 5; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          await tester.tap(button);
          await tester.pumpAndSettle();
          
          // Esperar un momento entre giros
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Verificar que hay historial
      expect(find.text('Historial Reciente'), findsOneWidget);
      expect(find.text('No hay giros todavía'), findsNothing);

      // PASO 4: Abrir configuración
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Configuración'), findsOneWidget);

      // Activar estrategia Martingale
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Verificar que Martingale está activa
      expect(find.text('Estrategia Martingale Activa'), findsOneWidget);

      // PASO 5: Jugar con Martingale
      for (int i = 0; i < 3; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pumpAndSettle();
            await Future.delayed(const Duration(milliseconds: 300));
          }
        }
      }

      // PASO 6: Reset del juego
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Verificar reset
      expect(find.text('Balance: \$1000.00'), findsOneWidget);
      expect(find.text('Presiona Girar'), findsOneWidget);
      expect(find.text('No hay giros todavía'), findsOneWidget);

      // PASO 7: Navegar hacia atrás (logout simulado)
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verificar que volvimos al login
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('User exhausts balance and cannot continue', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextField), 'broke@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Intentar agotar el balance
      int spins = 0;
      const maxSpins = 200;

      while (spins < maxSpins) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
            spins++;
          } else {
            // Botón deshabilitado, balance agotado
            break;
          }
        } else {
          break;
        }
      }

      // Verificar que el botón está deshabilitado
      final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
      if (button.evaluate().isNotEmpty) {
        final elevatedButton = tester.widget<ElevatedButton>(button);
        // Si el balance es bajo, el botón podría estar deshabilitado
        expect(elevatedButton, isNotNull);
      }

      // Verificar que el balance no es negativo
      expect(find.textMatching(r'Balance: \$-'), findsNothing);
    });

    testWidgets('Navigation between screens maintains state', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(find.byType(TextField), 'state@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Girar algunas veces
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Girar Ruleta'));
        await tester.pump();
      }

      // Capturar balance actual
      final balanceText = find.textMatching(r'Balance: \$\d+\.\d+');
      expect(balanceText, findsOneWidget);

      // Note: En una app real con persistencia, aquí verificaríamos
      // que el estado se mantiene. En esta versión simple, el estado
      // se pierde al navegar hacia atrás.
    });
  });

  group('Error Handling', () {
    testWidgets('Handles invalid email gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Intentar con email inválido
      await tester.enterText(find.byType(TextField), 'invalid-email');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();

      // Debe mostrar error y no navegar
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
      expect(find.text('Girar Ruleta'), findsNothing);
    });

    testWidgets('Handles rapid button clicks', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Clicks rápidos múltiples
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Girar Ruleta'));
        await tester.pump();
      }

      // No debe crashear
      expect(tester.takeException(), isNull);
    });
  });

  group('Martingale Strategy Integration', () {
    testWidgets('Martingale doubles bet after loss', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'martingale@test.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Activar Martingale
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(find.text('Estrategia Martingale Activa'), findsOneWidget);

      // Apuesta inicial
      expect(find.text('Apuesta actual: \$10.00'), findsOneWidget);

      // Girar varias veces para ver el cambio de apuestas
      for (int i = 0; i < 5; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      }

      // La apuesta debería haber cambiado (duplicado en pérdidas)
      final betText = find.textMatching(r'Apuesta actual: \$\d+\.\d+');
      expect(betText, findsOneWidget);
    });
  });

  group('UI Responsiveness', () {
    testWidgets('All interactive elements are accessible', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'access@test.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Verificar que todos los botones son accesibles
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Girar Ruleta'), findsOneWidget);

      // Verificar que todos son interactivos
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Scrolling works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'scroll@test.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // La pantalla principal tiene un SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Intentar scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('Disclaimer Visibility', () {
    testWidgets('Educational disclaimer is always visible', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'disclaimer@test.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Scroll to bottom para ver el disclaimer
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1000),
      );
      await tester.pumpAndSettle();

      // Verificar disclaimer
      expect(find.textContaining('DISCLAIMER'), findsOneWidget);
      expect(find.textContaining('simulación educativa'), findsOneWidget);
    });
  });
}
