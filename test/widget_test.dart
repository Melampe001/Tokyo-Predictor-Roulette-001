import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Prueba de navegación y botón de giro', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Girar Ruleta'), findsOneWidget);
    
    // Verify initial state
    expect(find.text('Resultado: Presiona Girar'), findsOneWidget);
    expect(find.text('Historia: '), findsOneWidget);
    
    // Tap the spin button
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pumpAndSettle();
    
    // Verify that the result changed from 'Presiona Girar'
    expect(find.text('Resultado: Presiona Girar'), findsNothing);
    
    // Verify that a number (0-36) appears in the result
    final resultText = tester.widget<Text>(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.startsWith('Resultado: '),
      ),
    ).data!;
    final resultNumber = int.parse(resultText.replaceFirst('Resultado: ', ''));
    expect(resultNumber, inInclusiveRange(0, 36));
    
    // Verify that the history now contains one number
    final historyText = tester.widget<Text>(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.startsWith('Historia: '),
      ),
    ).data!;
    expect(historyText, isNot('Historia: '));
    expect(historyText, contains(resultNumber.toString()));
  });
}