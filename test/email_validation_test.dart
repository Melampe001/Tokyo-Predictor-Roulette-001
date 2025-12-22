import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';
import 'package:flutter/material.dart';

void main() {
  group('Email Validation Tests', () {
    testWidgets('Should show error when email is empty', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Find the button and tap without entering email
      final button = find.text('Registrar y Continuar');
      await tester.tap(button);
      await tester.pump();
      
      // Should show empty error message
      expect(find.text('Por favor ingresa un email'), findsOneWidget);
    });
    
    testWidgets('Should show error for invalid email format', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter invalid email
      await tester.enterText(find.byType(TextField), 'invalid.email');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      
      // Should show invalid format error
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    });
    
    testWidgets('Should show error for email without domain', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email without domain
      await tester.enterText(find.byType(TextField), 'test@');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      
      // Should show invalid format error
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    });
    
    testWidgets('Should show error for email without @ symbol', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email without @ symbol
      await tester.enterText(find.byType(TextField), 'testexample.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      
      // Should show invalid format error
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    });
    
    testWidgets('Should accept valid email format', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter valid email
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should navigate to main screen (no error shown)
      expect(find.text('Por favor ingresa un email'), findsNothing);
      expect(find.text('Por favor ingresa un email válido'), findsNothing);
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('Should accept email with dots in username', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email with dots
      await tester.enterText(find.byType(TextField), 'user.name@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should navigate to main screen
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('Should accept email with plus sign', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email with plus sign
      await tester.enterText(find.byType(TextField), 'user+tag@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should navigate to main screen
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('Should accept email with subdomain', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email with subdomain
      await tester.enterText(find.byType(TextField), 'test@mail.example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should navigate to main screen
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('Should accept email with two-letter TLD', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email with two-letter TLD
      await tester.enterText(find.byType(TextField), 'test@example.co');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should navigate to main screen
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('Should clear error when user starts typing', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Trigger error first
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('Por favor ingresa un email'), findsOneWidget);
      
      // Start typing
      await tester.enterText(find.byType(TextField), 't');
      await tester.pump();
      
      // Error should be cleared
      expect(find.text('Por favor ingresa un email'), findsNothing);
    });
    
    testWidgets('Should trim whitespace from email', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Enter email with leading/trailing spaces
      await tester.enterText(find.byType(TextField), '  test@example.com  ');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should still be valid and navigate
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
    
    testWidgets('TextField should have email keyboard type', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Find TextField
      final textField = tester.widget<TextField>(find.byType(TextField));
      
      // Verify keyboard type is email
      expect(textField.keyboardType, TextInputType.emailAddress);
    });
    
    testWidgets('TextField should show hint text', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Find TextField
      final textField = tester.widget<TextField>(find.byType(TextField));
      
      // Verify hint text
      expect(textField.decoration?.hintText, 'ejemplo@correo.com');
    });
    
    testWidgets('TextField should show label text', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Find TextField
      final textField = tester.widget<TextField>(find.byType(TextField));
      
      // Verify label text
      expect(textField.decoration?.labelText, 'Email');
    });
  });
}
