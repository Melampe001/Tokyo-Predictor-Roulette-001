import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('Prueba de botón de giro y navegación', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verificar que estamos en la pantalla de login
    expect(find.text('Login'), findsOneWidget);
    
    // Ingresar email y continuar
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Verificar que llegamos a la pantalla principal
    expect(find.text('Tokyo Roulette Predicciones'), findsOneWidget);
    expect(find.text('Girar Ruleta'), findsOneWidget);
    
    // Verificar elementos iniciales
    expect(find.textContaining('Balance:'), findsOneWidget);
    expect(find.text('Presiona Girar'), findsOneWidget);
  });

  testWidgets('Prueba de giro de ruleta', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Girar la ruleta
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
    
    // Verificar que ya no muestra "Presiona Girar"
    expect(find.text('Presiona Girar'), findsNothing);
    
    // Verificar que hay estadísticas
    expect(find.textContaining('Total de giros:'), findsOneWidget);
  });

  testWidgets('Prueba de estrategia Martingale', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Verificar que existe el switch de Martingale
    expect(find.text('📊 Estrategia Martingale'), findsOneWidget);
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    
    // Activar Martingale
    await tester.tap(switchFinder);
    await tester.pump();
    
    // Verificar que el texto de activación aparece
    expect(find.textContaining('Activa:'), findsOneWidget);
  });

  testWidgets('Prueba de reset de juego', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a pantalla principal
    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Girar la ruleta
    await tester.tap(find.text('Girar Ruleta'));
    await tester.pump();
    
    // Presionar el botón de reset
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    
    // Verificar que volvemos al estado inicial
    expect(find.text('Presiona Girar'), findsOneWidget);
  });
}