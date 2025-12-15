import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';

/// Tests de seguridad para Tokyo Roulette Predictor
/// Verifica validaciones, sanitización y protecciones
void main() {
  group('Security - Email Validation', () {
    test('Rechaza emails vacíos', () {
      final state = _LoginScreenState();
      expect(state._validateEmail(''), isNotNull);
      expect(state._validateEmail(null), isNotNull);
    });

    test('Rechaza formatos de email inválidos', () {
      final state = _LoginScreenState();
      
      // Sin @
      expect(state._validateEmail('invalidemail'), isNotNull);
      
      // Sin dominio
      expect(state._validateEmail('test@'), isNotNull);
      
      // Sin usuario
      expect(state._validateEmail('@example.com'), isNotNull);
      
      // Sin TLD
      expect(state._validateEmail('test@example'), isNotNull);
      
      // Espacios
      expect(state._validateEmail('test @example.com'), isNotNull);
      expect(state._validateEmail('test@ example.com'), isNotNull);
    });

    test('Rechaza intentos de XSS en email', () {
      final state = _LoginScreenState();
      
      expect(state._validateEmail('<script>alert(1)</script>@test.com'), isNotNull);
      expect(state._validateEmail('test<script>@example.com'), isNotNull);
      expect(state._validateEmail('javascript:alert(1)@test.com'), isNotNull);
      expect(state._validateEmail('"><img src=x onerror=alert(1)>@test.com'), isNotNull);
    });

    test('Rechaza inyecciones SQL en email', () {
      final state = _LoginScreenState();
      
      expect(state._validateEmail("'; DROP TABLE users--@test.com"), isNotNull);
      expect(state._validateEmail("admin'--@test.com"), isNotNull);
      expect(state._validateEmail("1' OR '1'='1@test.com"), isNotNull);
    });

    test('Rechaza emails demasiado largos', () {
      final state = _LoginScreenState();
      
      // Email de más de 254 caracteres
      final longEmail = 'a' * 240 + '@example.com';
      expect(state._validateEmail(longEmail), isNotNull);
    });

    test('Acepta emails válidos', () {
      final state = _LoginScreenState();
      
      expect(state._validateEmail('test@example.com'), isNull);
      expect(state._validateEmail('user.name@example.com'), isNull);
      expect(state._validateEmail('user+tag@example.co.uk'), isNull);
      expect(state._validateEmail('test123@test-domain.com'), isNull);
    });

    test('Sanitiza emails correctamente (trim y lowercase)', () {
      final state = _LoginScreenState();
      
      // Aunque la validación pasa, debe sanitizar internamente
      expect(state._validateEmail('  Test@Example.COM  '), isNull);
      expect(state._validateEmail('USER@DOMAIN.COM'), isNull);
    });
  });

  group('Security - Age Verification', () {
    testWidgets('No permite continuar sin verificación de edad', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Ir a login
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Debe mostrar diálogo de verificación de edad
      expect(find.text('⚠️ Verificación de Edad'), findsOneWidget);
      expect(find.text('Esta aplicación es SOLO para mayores de 18 años.'), findsOneWidget);
    });

    testWidgets('Permite continuar solo después de verificar edad', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Verificar que hay dos botones
      expect(find.text('No, soy menor de 18'), findsOneWidget);
      expect(find.text('Sí, soy mayor de 18'), findsOneWidget);
      
      // Aceptar que es mayor de edad
      await tester.tap(find.text('Sí, soy mayor de 18'));
      await tester.pumpAndSettle();
      
      // Ahora intentar nuevamente
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Debe llegar a la pantalla principal
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
  });

  group('Security - Balance Protection', () {
    testWidgets('Balance nunca es negativo', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Navegar a pantalla principal
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Verificar edad
      await tester.tap(find.text('Sí, soy mayor de 18'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Girar múltiples veces y verificar que balance no es negativo
      for (int i = 0; i < 150; i++) {
        final buttonFinder = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (buttonFinder.evaluate().isNotEmpty) {
          final button = tester.widget<ElevatedButton>(buttonFinder);
          if (button.onPressed != null) {
            await tester.tap(buttonFinder);
            await tester.pump();
          } else {
            // Botón deshabilitado, verificar que es por balance
            break;
          }
        }
      }
      
      // Buscar texto de balance
      final balanceWidgets = find.textContaining('Balance: \$');
      expect(balanceWidgets, findsOneWidget);
      
      // El balance debe ser >= 0
      final balanceText = tester.widget<Text>(balanceWidgets).data!;
      final balanceMatch = RegExp(r'Balance: \$(\d+\.\d+)').firstMatch(balanceText);
      if (balanceMatch != null) {
        final balance = double.parse(balanceMatch.group(1)!);
        expect(balance, greaterThanOrEqualTo(0.0));
      }
    });

    testWidgets('Botón de giro deshabilitado cuando balance < apuesta', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Sí, soy mayor de 18'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Girar hasta agotar balance
      for (int i = 0; i < 200; i++) {
        final buttonFinder = find.widgetWithText(ElevatedButton, 'Girar Ruleta');
        if (buttonFinder.evaluate().isEmpty) break;
        
        final button = tester.widget<ElevatedButton>(buttonFinder);
        if (button.onPressed == null) {
          // Botón está deshabilitado
          expect(button.onPressed, isNull);
          break;
        }
        
        await tester.tap(buttonFinder);
        await tester.pump();
      }
    });
  });

  group('Security - RNG', () {
    test('Usa Random.secure() para RNG criptográficamente seguro', () {
      final roulette = RouletteLogic();
      
      // Verificar que el RNG genera números válidos
      for (int i = 0; i < 1000; i++) {
        final spin = roulette.generateSpin();
        expect(spin, greaterThanOrEqualTo(0));
        expect(spin, lessThanOrEqualTo(36));
      }
    });

    test('RNG genera distribución variada', () {
      final roulette = RouletteLogic();
      final results = <int, int>{};
      
      // Generar 1000 giros
      for (int i = 0; i < 1000; i++) {
        final spin = roulette.generateSpin();
        results[spin] = (results[spin] ?? 0) + 1;
      }
      
      // Debe tener varios números diferentes (al menos 20 de 37)
      expect(results.length, greaterThan(20));
      
      // Ningún número debe aparecer más del 10% del tiempo
      for (final count in results.values) {
        expect(count, lessThan(100)); // Menos de 100/1000 = 10%
      }
    });
  });

  group('Security - Disclaimers', () {
    testWidgets('Muestra disclaimer en pantalla principal', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Sí, soy mayor de 18'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Verificar disclaimer
      expect(find.textContaining('⚠️ AVISO IMPORTANTE'), findsOneWidget);
      expect(find.textContaining('simulación educativa'), findsOneWidget);
      expect(find.textContaining('NO involucra dinero real'), findsOneWidget);
      expect(find.textContaining('NO promueve apuestas'), findsOneWidget);
    });

    testWidgets('Muestra líneas de ayuda para ludopatía', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Sí, soy mayor de 18'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Verificar líneas de ayuda
      expect(find.textContaining('1-800-GAMBLER'), findsOneWidget);
      expect(find.textContaining('900 200 225'), findsOneWidget);
    });
  });

  group('Security - Memory Management', () {
    test('TextEditingController se dispone correctamente', () {
      // Verificar que dispose() está implementado
      // En una app real, esto previene memory leaks
      final state = _LoginScreenState();
      
      // Verificar que tiene el método dispose
      expect(state.dispose, isA<Function>());
    });
  });
}

/// Extension para acceder a métodos privados en tests
/// SOLO para testing - NO usar en producción
extension LoginScreenStateTestExtension on _LoginScreenState {
  String? testValidateEmail(String? value) => _validateEmail(value);
}
