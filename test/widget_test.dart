import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Prueba de botón de giro', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Girar Ruleta'), findsOneWidget);
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
  });
}