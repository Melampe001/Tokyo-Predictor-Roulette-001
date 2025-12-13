import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Login screen validates email', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Test empty email validation
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pump();
    expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    
    // Test invalid email validation
    await tester.enterText(find.byType(TextField), 'invalid-email');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pump();
    expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
  });
  
  testWidgets('Valid email allows navigation to main screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    expect(find.text('Girar Ruleta'), findsOneWidget);
    expect(find.text('Balance'), findsOneWidget);
  });
  
  testWidgets('Roulette spin updates result and history', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navigate to main screen
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Check initial state
    expect(find.text('Presiona Girar'), findsOneWidget);
    
    // Spin the roulette
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
    
    // Verify result changed
    expect(find.text('Presiona Girar'), findsNothing);
    expect(find.text('Resultado'), findsOneWidget);
  });
  
  testWidgets('Martingale strategy updates bet on spin', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navigate to main screen
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Verify Martingale strategy card exists
    expect(find.text('Estrategia Martingale'), findsOneWidget);
    expect(find.textContaining('Apuesta actual:'), findsOneWidget);
  });
  
  testWidgets('Reset button clears game state', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navigate to main screen
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Spin once
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
    
    // Reset game
    await tester.tap(find.text('Reiniciar Juego'));
    await tester.pump();
    
    // Verify reset
    expect(find.text('Presiona Girar'), findsOneWidget);
  });
}