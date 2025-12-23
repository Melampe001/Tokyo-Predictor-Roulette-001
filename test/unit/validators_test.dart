import 'package:flutter_test/flutter_test.dart';

/// Validadores de entrada para la aplicación
/// Estos validadores son probados en este archivo de test
class Validators {
  /// Valida formato de email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida la fortaleza de una contraseña
  /// Requisitos: mínimo 8 caracteres, al menos una letra y un número
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  /// Valida que la cantidad de apuesta sea válida
  static bool isValidBetAmount(double amount, double balance, double minBet, double maxBet) {
    if (amount <= 0) return false;
    if (amount < minBet) return false;
    if (amount > maxBet) return false;
    if (amount > balance) return false;
    return true;
  }

  /// Valida que un número esté en el rango de la ruleta (0-36)
  static bool isValidRouletteNumber(int number) {
    return number >= 0 && number <= 36;
  }

  /// Sanitiza entrada de texto para prevenir XSS
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('&', '&amp;');
  }

  /// Valida formato de nombre de usuario
  static bool isValidUsername(String username) {
    if (username.isEmpty || username.length < 3 || username.length > 20) {
      return false;
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(username);
  }

  /// Valida que un valor numérico esté en un rango específico
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }
}

void main() {
  group('Email Validation', () {
    test('acepta email válido simple', () {
      expect(Validators.isValidEmail('test@example.com'), isTrue);
    });

    test('acepta email con subdominios', () {
      expect(Validators.isValidEmail('user@mail.example.com'), isTrue);
    });

    test('acepta email con números', () {
      expect(Validators.isValidEmail('user123@example456.com'), isTrue);
    });

    test('acepta email con caracteres especiales permitidos', () {
      expect(Validators.isValidEmail('user.name+tag@example.com'), isTrue);
    });

    test('acepta email con guiones', () {
      expect(Validators.isValidEmail('user-name@example-domain.com'), isTrue);
    });

    test('rechaza email sin @', () {
      expect(Validators.isValidEmail('testexample.com'), isFalse);
    });

    test('rechaza email sin dominio', () {
      expect(Validators.isValidEmail('test@'), isFalse);
    });

    test('rechaza email sin usuario', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
    });

    test('rechaza email sin extensión', () {
      expect(Validators.isValidEmail('test@example'), isFalse);
    });

    test('rechaza email con espacios', () {
      expect(Validators.isValidEmail('test @example.com'), isFalse);
    });

    test('rechaza email vacío', () {
      expect(Validators.isValidEmail(''), isFalse);
    });

    test('rechaza email con múltiples @', () {
      expect(Validators.isValidEmail('test@@example.com'), isFalse);
    });

    test('rechaza email con caracteres inválidos', () {
      expect(Validators.isValidEmail('test<script>@example.com'), isFalse);
    });
  });

  group('Password Strength Validation', () {
    test('acepta contraseña válida con letras y números', () {
      expect(Validators.isStrongPassword('password123'), isTrue);
    });

    test('acepta contraseña con mayúsculas y números', () {
      expect(Validators.isStrongPassword('Password123'), isTrue);
    });

    test('acepta contraseña con caracteres especiales', () {
      expect(Validators.isStrongPassword('Pass@word123'), isTrue);
    });

    test('acepta contraseña larga', () {
      expect(Validators.isStrongPassword('verylongpassword123'), isTrue);
    });

    test('rechaza contraseña corta', () {
      expect(Validators.isStrongPassword('pass1'), isFalse);
    });

    test('rechaza contraseña de exactamente 7 caracteres', () {
      expect(Validators.isStrongPassword('pass123'), isFalse);
    });

    test('acepta contraseña de exactamente 8 caracteres', () {
      expect(Validators.isStrongPassword('passwor1'), isTrue);
    });

    test('rechaza contraseña solo con letras', () {
      expect(Validators.isStrongPassword('password'), isFalse);
    });

    test('rechaza contraseña solo con números', () {
      expect(Validators.isStrongPassword('12345678'), isFalse);
    });

    test('rechaza contraseña vacía', () {
      expect(Validators.isStrongPassword(''), isFalse);
    });

    test('rechaza contraseña solo con caracteres especiales', () {
      expect(Validators.isStrongPassword('!@#$%^&*'), isFalse);
    });
  });

  group('Bet Amount Validation', () {
    const double balance = 1000.0;
    const double minBet = 1.0;
    const double maxBet = 100.0;

    test('acepta apuesta válida', () {
      expect(Validators.isValidBetAmount(10.0, balance, minBet, maxBet), isTrue);
    });

    test('acepta apuesta en el límite mínimo', () {
      expect(Validators.isValidBetAmount(minBet, balance, minBet, maxBet), isTrue);
    });

    test('acepta apuesta en el límite máximo', () {
      expect(Validators.isValidBetAmount(maxBet, balance, minBet, maxBet), isTrue);
    });

    test('acepta apuesta igual al balance', () {
      expect(Validators.isValidBetAmount(balance, balance, minBet, 2000.0), isTrue);
    });

    test('rechaza apuesta de cero', () {
      expect(Validators.isValidBetAmount(0.0, balance, minBet, maxBet), isFalse);
    });

    test('rechaza apuesta negativa', () {
      expect(Validators.isValidBetAmount(-10.0, balance, minBet, maxBet), isFalse);
    });

    test('rechaza apuesta menor al mínimo', () {
      expect(Validators.isValidBetAmount(0.5, balance, minBet, maxBet), isFalse);
    });

    test('rechaza apuesta mayor al máximo', () {
      expect(Validators.isValidBetAmount(150.0, balance, minBet, maxBet), isFalse);
    });

    test('rechaza apuesta mayor al balance', () {
      expect(Validators.isValidBetAmount(1500.0, balance, minBet, 2000.0), isFalse);
    });

    test('maneja balance cero correctamente', () {
      expect(Validators.isValidBetAmount(10.0, 0.0, minBet, maxBet), isFalse);
    });

    test('maneja apuestas decimales', () {
      expect(Validators.isValidBetAmount(10.5, balance, minBet, maxBet), isTrue);
    });
  });

  group('Roulette Number Validation', () {
    test('acepta número 0', () {
      expect(Validators.isValidRouletteNumber(0), isTrue);
    });

    test('acepta número 36', () {
      expect(Validators.isValidRouletteNumber(36), isTrue);
    });

    test('acepta números intermedios', () {
      for (int i = 0; i <= 36; i++) {
        expect(Validators.isValidRouletteNumber(i), isTrue);
      }
    });

    test('rechaza número negativo', () {
      expect(Validators.isValidRouletteNumber(-1), isFalse);
    });

    test('rechaza número 37', () {
      expect(Validators.isValidRouletteNumber(37), isFalse);
    });

    test('rechaza números mayores a 36', () {
      expect(Validators.isValidRouletteNumber(100), isFalse);
    });
  });

  group('Input Sanitization', () {
    test('sanitiza tags HTML básicos', () {
      expect(Validators.sanitizeInput('<script>'), equals('&lt;script&gt;'));
    });

    test('sanitiza comillas dobles', () {
      expect(Validators.sanitizeInput('Say "hello"'), equals('Say &quot;hello&quot;'));
    });

    test('sanitiza comillas simples', () {
      expect(Validators.sanitizeInput("It's"), equals("It&#x27;s"));
    });

    test('sanitiza ampersand', () {
      expect(Validators.sanitizeInput('Tom & Jerry'), equals('Tom &amp; Jerry'));
    });

    test('maneja input vacío', () {
      expect(Validators.sanitizeInput(''), equals(''));
    });

    test('maneja input sin caracteres especiales', () {
      expect(Validators.sanitizeInput('Hello World'), equals('Hello World'));
    });

    test('sanitiza múltiples caracteres especiales', () {
      expect(
        Validators.sanitizeInput('<div>"test" & \'value\'</div>'),
        equals('&lt;div&gt;&quot;test&quot; &amp; &#x27;value&#x27;&lt;/div&gt;'),
      );
    });

    test('previene XSS básico', () {
      expect(
        Validators.sanitizeInput('<script>alert("XSS")</script>'),
        equals('&lt;script&gt;alert(&quot;XSS&quot;)&lt;/script&gt;'),
      );
    });
  });

  group('Username Validation', () {
    test('acepta username válido', () {
      expect(Validators.isValidUsername('user123'), isTrue);
    });

    test('acepta username con guiones bajos', () {
      expect(Validators.isValidUsername('user_name'), isTrue);
    });

    test('acepta username de 3 caracteres', () {
      expect(Validators.isValidUsername('abc'), isTrue);
    });

    test('acepta username de 20 caracteres', () {
      expect(Validators.isValidUsername('a' * 20), isTrue);
    });

    test('rechaza username vacío', () {
      expect(Validators.isValidUsername(''), isFalse);
    });

    test('rechaza username de 2 caracteres', () {
      expect(Validators.isValidUsername('ab'), isFalse);
    });

    test('rechaza username de 21 caracteres', () {
      expect(Validators.isValidUsername('a' * 21), isFalse);
    });

    test('rechaza username con espacios', () {
      expect(Validators.isValidUsername('user name'), isFalse);
    });

    test('rechaza username con caracteres especiales', () {
      expect(Validators.isValidUsername('user@name'), isFalse);
    });

    test('rechaza username con guiones', () {
      expect(Validators.isValidUsername('user-name'), isFalse);
    });
  });

  group('Range Validation', () {
    test('acepta valor dentro del rango', () {
      expect(Validators.isInRange(5, 0, 10), isTrue);
    });

    test('acepta valor en el límite inferior', () {
      expect(Validators.isInRange(0, 0, 10), isTrue);
    });

    test('acepta valor en el límite superior', () {
      expect(Validators.isInRange(10, 0, 10), isTrue);
    });

    test('rechaza valor menor al límite inferior', () {
      expect(Validators.isInRange(-1, 0, 10), isFalse);
    });

    test('rechaza valor mayor al límite superior', () {
      expect(Validators.isInRange(11, 0, 10), isFalse);
    });

    test('maneja rangos negativos', () {
      expect(Validators.isInRange(-5, -10, 0), isTrue);
    });

    test('maneja valores decimales', () {
      expect(Validators.isInRange(5.5, 0.0, 10.0), isTrue);
    });

    test('maneja rango de un solo valor', () {
      expect(Validators.isInRange(5, 5, 5), isTrue);
    });
  });
}
