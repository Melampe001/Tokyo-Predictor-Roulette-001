import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  testWidgets('LoginScreen muestra campo de email y botón', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verificar que existe el campo de email
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    
    // Verificar que existe el botón de registro
    expect(find.text('Registrar y Continuar'), findsOneWidget);
  });

  testWidgets('LoginScreen valida email inválido', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Intentar con email inválido
    await tester.enterText(find.byType(TextFormField), 'email-invalido');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pump();
    
    // Debería mostrar mensaje de error
    expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
  });

  testWidgets('LoginScreen acepta email válido y navega a MainScreen', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Ingresar email válido
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pump();
    
    // Esperar la animación de navegación
    await tester.pumpAndSettle();
    
    // Verificar que navegamos a MainScreen
    expect(find.text('🎰 Girar Ruleta'), findsOneWidget);
  });

  testWidgets('MainScreen muestra componentes principales', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Verificar componentes principales
    expect(find.text('Balance: \$1000.00'), findsOneWidget);
    expect(find.text('🎰 Girar Ruleta'), findsOneWidget);
    expect(find.text('💡 Asesor Martingale'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Botón de girar ruleta funciona correctamente', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Estado inicial
    expect(find.text('Resultado'), findsOneWidget);
    expect(find.text('Presiona Girar'), findsOneWidget);
    expect(find.text('Giros'), findsOneWidget);
    expect(find.text('0', skipOffstage: false), findsWidgets); // Giros, Victorias, Pérdidas iniciales
    
    // Girar la ruleta
    await tester.tap(find.text('🎰 Girar Ruleta'));
    await tester.pump();
    
    // Verificar que el resultado cambió
    expect(find.text('Presiona Girar'), findsNothing);
    expect(find.text('1', skipOffstage: false), findsWidgets); // Contador de giros incrementó
  });

  testWidgets('Estadísticas se actualizan correctamente', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Girar varias veces
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.text('🎰 Girar Ruleta'));
      await tester.pump();
    }
    
    // Verificar que las estadísticas se actualizaron
    expect(find.text('5', skipOffstage: false), findsOneWidget); // 5 giros
  });

  testWidgets('Botón de reinicio funciona correctamente', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Girar la ruleta
    await tester.tap(find.text('🎰 Girar Ruleta'));
    await tester.pump();
    
    // Reiniciar
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    
    // Verificar que se reinició
    expect(find.text('Presiona Girar'), findsOneWidget);
    expect(find.text('Balance: \$1000.00'), findsOneWidget);
  });

  testWidgets('Predicción aparece después de 3 giros', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // No debería haber predicción inicialmente
    expect(find.text('🔮 Predicción siguiente giro'), findsNothing);
    
    // Girar 3 veces
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.text('🎰 Girar Ruleta'));
      await tester.pump();
    }
    
    // Ahora debería aparecer la predicción
    expect(find.text('🔮 Predicción siguiente giro'), findsOneWidget);
  });

  testWidgets('Historial se muestra correctamente', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Navegar a MainScreen
    await tester.enterText(find.byType(TextFormField), 'test@email.com');
    await tester.tap(find.text('Registrar y Continuar'));
    await tester.pumpAndSettle();
    
    // Inicialmente sin historial
    expect(find.text('Sin historial aún'), findsOneWidget);
    
    // Girar la ruleta
    await tester.tap(find.text('🎰 Girar Ruleta'));
    await tester.pump();
    
    // Debería haber historial ahora
    expect(find.text('Sin historial aún'), findsNothing);
    expect(find.text('Historial (últimos 20)'), findsOneWidget);
  });
}
