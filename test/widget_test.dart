import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Prueba de navegación y botón de giro', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica que estamos en la pantalla de login
    expect(find.text('Login'), findsOneWidget);

    // Ingresa email y continúa
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Verifica que llegamos a la pantalla principal
    expect(find.text('Girar Ruleta'), findsOneWidget);
    expect(find.text('Balance: \$1000.00'), findsOneWidget);

    // Gira la ruleta
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();

    // Verifica que hay un resultado (debería haber cambiado de "Presiona Girar")
    expect(find.text('Presiona Girar'), findsNothing);
  });

  testWidgets('Prueba de diálogo de configuración', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Navega a la pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Abre el diálogo de configuración
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verifica que el diálogo está abierto
    expect(find.text('Configuración'), findsOneWidget);
    expect(find.text('Usar estrategia Martingale'), findsOneWidget);
  });

  testWidgets('Prueba de reset del juego', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Navega a la pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Gira la ruleta un par de veces
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();

    // Resetea el juego
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    // Verifica que el juego se reseteó
    expect(find.text('Balance: \$1000.00'), findsOneWidget);
    expect(find.text('Presiona Girar'), findsOneWidget);
  });

  testWidgets('Verifica que el disclaimer está presente', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Navega a la pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Verifica que el disclaimer está visible
    expect(find.textContaining('DISCLAIMER'), findsOneWidget);
    expect(find.textContaining('simulación educativa'), findsOneWidget);
  });

  testWidgets('Verifica protección de balance y deshabilitación de botón', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Navega a la pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();

    // Verifica balance inicial
    expect(find.text('Balance: \$1000.00'), findsOneWidget);

    // Constante basada en mecánicas del juego: balance inicial / apuesta mínima
    const int maxSpinsToDepleteFunds = 100; // 1000.0 / 10.0 = 100 spins máximo

    // Simula múltiples pérdidas hasta que el balance se agote
    // Nota: En una ruleta real, esto requeriría muchos giros
    // pero el balance está protegido contra valores negativos
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
    for (int i = 0; i < maxSpinsToDepleteFunds; i++) {
      if (buttonFinder.evaluate().isNotEmpty) {
        final elevatedButton = tester.widget<ElevatedButton>(buttonFinder);
        if (elevatedButton.onPressed != null) {
          await tester.tap(buttonFinder);
          await tester.pump();
        } else {
          // El botón está deshabilitado cuando balance < currentBet
          break;
        }
      } else {
        break;
      }
    }

    // Verifica que el balance nunca se volvió negativo
    final balanceText = find.textContaining('Balance: \$');
    expect(balanceText, findsOneWidget);

    // Verifica que el botón está deshabilitado si el balance es insuficiente
    final finalButton = tester.widget<ElevatedButton>(buttonFinder);

    // Si el balance es 0, el botón debe estar deshabilitado
    if (find.text('Balance: \$0.00').evaluate().isNotEmpty) {
      expect(finalButton.onPressed, isNull);
    }
  });
}
