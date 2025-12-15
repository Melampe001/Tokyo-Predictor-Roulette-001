import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Prueba de navegación y botón de giro', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Verify initial state before spinning
    expect(find.text('Girar Ruleta'), findsOneWidget);
    expect(find.text('Resultado: Presiona Girar'), findsOneWidget);
    
    // Tap the spin button
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pumpAndSettle();
    
    // Verify that the result changed after spinning
    expect(find.text('Resultado: Presiona Girar'), findsNothing);
    
    // Verify that a number result is displayed (0-36 for roulette)
    final resultText = tester.widget<Text>(
      find.byWidgetPredicate((widget) => 
        widget is Text && 
        widget.data != null && 
        widget.data!.startsWith('Resultado: ') &&
        widget.data != 'Resultado: Presiona Girar'
      )
    );
    expect(resultText, isNotNull);
    
    // Verify that the history contains at least one number
    expect(find.byWidgetPredicate((widget) => 
      widget is Text && 
      widget.data != null && 
      widget.data!.startsWith('Historia: ') &&
      widget.data != 'Historia: '
    ), findsOneWidget);
  });
}