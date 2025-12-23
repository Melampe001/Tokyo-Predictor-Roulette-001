import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen renderiza correctamente', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Verificar que los elementos principales están presentes
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Registrar y Continuar'), findsOneWidget);
    });

    testWidgets('TextField tiene configuración correcta', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(textField.decoration?.labelText, 'Email');
      expect(textField.decoration?.hintText, 'ejemplo@correo.com');
    });

    testWidgets('muestra error cuando email está vacío', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Tap en el botón sin ingresar email
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();

      // Verificar mensaje de error
      expect(find.text('Por favor ingresa un email'), findsOneWidget);
    });

    testWidgets('muestra error cuando email es inválido', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Ingresar email inválido
      await tester.enterText(find.byType(TextField), 'invalid-email');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();

      // Verificar mensaje de error
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    });

    testWidgets('limpia error cuando usuario comienza a escribir', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Mostrar error primero
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      expect(find.text('Por favor ingresa un email'), findsOneWidget);

      // Escribir en el campo
      await tester.enterText(find.byType(TextField), 't');
      await tester.pump();

      // Error debe desaparecer
      expect(find.text('Por favor ingresa un email'), findsNothing);
    });

    testWidgets('navega a MainScreen con email válido', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Ingresar email válido
      await tester.enterText(find.byType(TextField), 'test@email.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Verificar navegación
      expect(find.text('Girar Ruleta'), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('acepta diferentes formatos de email válido', (tester) async {
      final validEmails = [
        'test@example.com',
        'user123@domain.co.uk',
        'name.surname@company.com',
      ];

      for (final email in validEmails) {
        await tester.pumpWidget(const MyApp());

        await tester.enterText(find.byType(TextField), email);
        await tester.tap(find.text('Registrar y Continuar'));
        await tester.pumpAndSettle();

        // Verificar navegación exitosa
        expect(find.text('Girar Ruleta'), findsOneWidget);

        // Reset para siguiente test
        await tester.pageBack();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('muestra error con emails inválidos', (tester) async {
      final invalidEmails = [
        'notanemail',
        'missing@domain',
        '@nodomain.com',
        'spaces in@email.com',
      ];

      for (final email in invalidEmails) {
        await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

        await tester.enterText(find.byType(TextField), email);
        await tester.tap(find.text('Registrar y Continuar'));
        await tester.pump();

        // Verificar que muestra error y no navega
        expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
        expect(find.text('Girar Ruleta'), findsNothing);
      }
    });

    testWidgets('trim elimina espacios en blanco del email', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Ingresar email con espacios
      await tester.enterText(find.byType(TextField), '  test@email.com  ');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Debe navegar exitosamente (trim eliminó los espacios)
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });

    testWidgets('botón es interactivo', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final button = find.widgetWithText(ElevatedButton, 'Registrar y Continuar');
      expect(button, findsOneWidget);

      final elevatedButton = tester.widget<ElevatedButton>(button);
      expect(elevatedButton.onPressed, isNotNull);
    });
  });

  group('LoginScreen Accessibility', () {
    testWidgets('elementos son accesibles para lectores de pantalla', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Verificar que elementos clave tienen semántica
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('TextField es navegable por teclado', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final textField = find.byType(TextField);
      await tester.tap(textField);
      await tester.pump();

      // Verificar que el campo tiene foco
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.focusNode, isNotNull);
    });
  });

  group('LoginScreen Edge Cases', () {
    testWidgets('maneja múltiples clics en botón', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byType(TextField), 'test@email.com');
      
      // Múltiples clics rápidos
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      
      // Debe manejar correctamente
      expect(tester.takeException(), isNull);
    });

    testWidgets('maneja email extremadamente largo', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final longEmail = '${'a' * 100}@example.com';
      await tester.enterText(find.byType(TextField), longEmail);
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();

      // Debe validar correctamente
      expect(tester.takeException(), isNull);
    });

    testWidgets('maneja caracteres especiales en email', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.enterText(find.byType(TextField), 'test+tag@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();

      // Email válido con +, debe navegar
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
  });
}
