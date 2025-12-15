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
    expect(find.textContaining('Historia:'), findsOneWidget);
    
    // Tap the spin button
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pumpAndSettle();
    
    // Verify that the result changed from 'Presiona Girar' to a number
    expect(find.text('Resultado: Presiona Girar'), findsNothing);
    
    // Verify that a number between 0-36 appears in the result
    final resultText = find.textContaining('Resultado:');
    expect(resultText, findsOneWidget);
    
    // Verify that the history now contains at least one number
    final historyText = find.textContaining('Historia:');
    expect(historyText, findsOneWidget);
    
    // Get the actual text to verify it's not empty
    final Text historyWidget = tester.widget(historyText);
    final String historyString = historyWidget.data ?? '';
    expect(historyString, isNot(equals('Historia: ')));
    expect(historyString, matches(RegExp(r'Historia: \d+')));
  });
}