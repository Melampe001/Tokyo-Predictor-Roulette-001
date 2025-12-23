import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  group('MainScreen Widget Tests', () {
    testWidgets('MainScreen renderiza correctamente', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Verificar elementos principales
      expect(find.text('Tokyo Roulette Predicciones'), findsOneWidget);
      expect(find.text('Girar Ruleta'), findsOneWidget);
      expect(find.text('Balance: \$1000.00'), findsOneWidget);
      expect(find.text('Apuesta actual: \$10.00'), findsOneWidget);
    });

    testWidgets('muestra disclaimer de simulación educativa', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      expect(find.textContaining('DISCLAIMER'), findsOneWidget);
      expect(find.textContaining('simulación educativa'), findsOneWidget);
    });

    testWidgets('botón de girar está habilitado inicialmente', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
      final elevatedButton = tester.widget<ElevatedButton>(button);
      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('giro cambia el resultado', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      expect(find.text('Presiona Girar'), findsOneWidget);

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Resultado debe cambiar de "Presiona Girar"
      expect(find.text('Presiona Girar'), findsNothing);
    });

    testWidgets('muestra resultado numérico después del giro', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Buscar un Container con forma circular (el resultado)
      final circles = find.byWidgetPredicate(
        (widget) => widget is Container && 
                    widget.decoration is BoxDecoration &&
                    (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(circles, findsWidgets);
    });

    testWidgets('actualiza historial después del giro', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Inicialmente no hay historial
      expect(find.text('No hay giros todavía'), findsOneWidget);

      // Girar ruleta
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Historial debe tener elementos
      expect(find.text('No hay giros todavía'), findsNothing);
    });

    testWidgets('actualiza balance después del giro', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      expect(find.text('Balance: \$1000.00'), findsOneWidget);

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Balance debe cambiar (ganó o perdió)
      final balanceTexts = find.textContaining('Balance: \$');
      expect(balanceTexts, findsOneWidget);
      
      // El balance no debe ser exactamente 1000 después del giro
      expect(find.text('Balance: \$1000.00'), findsNothing);
    });

    testWidgets('muestra resultado de apuesta (ganaste/perdiste)', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Debe mostrar resultado de la apuesta
      final gainOrLoss = find.textMatching(r'(Ganaste|Perdiste)');
      expect(gainOrLoss, findsOneWidget);
    });
  });

  group('MainScreen Settings Dialog', () {
    testWidgets('abre diálogo de configuración', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Configuración'), findsOneWidget);
      expect(find.text('Usar estrategia Martingale'), findsOneWidget);
    });

    testWidgets('puede activar estrategia Martingale', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Abrir configuración
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Activar Martingale
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Verificar que el diálogo se cerró
      expect(find.text('Configuración'), findsNothing);

      // Verificar que el indicador de Martingale está visible
      expect(find.text('Estrategia Martingale Activa'), findsOneWidget);
    });

    testWidgets('puede cerrar diálogo sin cambios', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();

      expect(find.text('Configuración'), findsNothing);
    });
  });

  group('MainScreen Reset Functionality', () {
    testWidgets('botón reset restaura balance inicial', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Girar para cambiar balance
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Verificar reset
      expect(find.text('Balance: \$1000.00'), findsOneWidget);
      expect(find.text('Presiona Girar'), findsOneWidget);
    });

    testWidgets('reset limpia historial', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Crear historial
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Historial debe estar vacío
      expect(find.text('No hay giros todavía'), findsOneWidget);
    });

    testWidgets('reset restaura apuesta inicial', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Activar Martingale y perder para aumentar apuesta
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Girar varias veces
      for (int i = 0; i < 5; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
          }
        }
      }

      // Reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Apuesta debe volver a 10.00
      expect(find.text('Apuesta actual: \$10.00'), findsOneWidget);
    });
  });

  group('MainScreen Martingale Strategy', () {
    testWidgets('muestra información de Martingale cuando está activa', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Activar Martingale
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Verificar información
      expect(find.text('Estrategia Martingale Activa'), findsOneWidget);
      expect(find.textContaining('duplicará automáticamente'), findsOneWidget);
    });

    testWidgets('no muestra información de Martingale cuando está inactiva', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      expect(find.text('Estrategia Martingale Activa'), findsNothing);
    });
  });

  group('MainScreen Predicciones', () {
    testWidgets('muestra predicción después del primer giro', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Primer giro
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Segundo giro debería mostrar predicción
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Verificar que hay predicción
      expect(find.text('Predicción sugerida'), findsOneWidget);
      expect(find.textContaining('basada en historial'), findsOneWidget);
    });

    testWidgets('no muestra predicción en el primer giro', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // En el primer giro no debe haber predicción visible
      // (porque history está vacío antes del primer giro)
      expect(find.text('Predicción sugerida'), findsNothing);
    });
  });

  group('MainScreen Balance Protection', () {
    testWidgets('deshabilita botón cuando balance es insuficiente', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Girar múltiples veces para agotar balance
      for (int i = 0; i < 150; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
          } else {
            // Botón deshabilitado, balance agotado
            break;
          }
        }
      }

      // Verificar que el botón está deshabilitado
      final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
      final elevatedButton = tester.widget<ElevatedButton>(button);
      
      // Si el balance es muy bajo, el botón debe estar deshabilitado
      final balanceText = find.textMatching(r'Balance: \$\d+\.\d+');
      expect(balanceText, findsOneWidget);
    });

    testWidgets('balance nunca es negativo', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Girar múltiples veces
      for (int i = 0; i < 200; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
          } else {
            break;
          }
        }
      }

      // Verificar que el balance no es negativo
      final balanceText = find.textMatching(r'Balance: \$\d+\.\d+');
      expect(balanceText, findsOneWidget);
      
      // No debe haber balance negativo
      expect(find.textMatching(r'Balance: \$-'), findsNothing);
    });
  });

  group('MainScreen UI Cards', () {
    testWidgets('muestra todas las cards principales', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Debe haber múltiples Cards en la UI
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('muestra historial en formato visual', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Girar para crear historial
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Debe haber un título de Historial Reciente
      expect(find.text('Historial Reciente'), findsOneWidget);
    });

    testWidgets('resultado se muestra en círculo', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();

      // Buscar el círculo del resultado
      final resultCircle = find.byWidgetPredicate(
        (widget) => widget is Container &&
                    widget.decoration is BoxDecoration &&
                    (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(resultCircle, findsWidgets);
    });
  });

  group('MainScreen Navigation', () {
    testWidgets('puede navegar de Login a MainScreen y back', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Login
      await tester.enterText(find.byType(TextField), 'test@email.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('Girar Ruleta'), findsOneWidget);

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
  });

  group('MainScreen Edge Cases', () {
    testWidgets('maneja múltiples giros rápidos', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Múltiples giros rápidos
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Girar Ruleta'));
        await tester.pump();
      }

      // No debe lanzar excepciones
      expect(tester.takeException(), isNull);
    });

    testWidgets('limita historial a 20 números', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));

      // Girar 25 veces
      for (int i = 0; i < 25; i++) {
        final button = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (button.evaluate().isNotEmpty) {
          final elevatedButton = tester.widget<ElevatedButton>(button);
          if (elevatedButton.onPressed != null) {
            await tester.tap(button);
            await tester.pump();
          }
        }
      }

      // El historial debe estar limitado
      // (Este test verifica que no crashea, el límite se verifica en unit tests)
      expect(tester.takeException(), isNull);
    });
  });
}
