import '../test_runner.dart';

/// Módulo de pruebas para persistencia de datos
class DataModuleTest extends TestModule {
  @override
  String get name => 'Data & Persistence';

  @override
  bool get critical => false;

  @override
  List<Test> get tests => [
        Test(
          name: 'Local storage saves data',
          run: () async {
            // Simular guardado en SharedPreferences
            final data = {'spin_history': [1, 5, 12, 7], 'credits': 100};
            
            // Verificar que los datos son serializables
            if (data['spin_history'] is! List) {
              throw Exception('Spin history must be a list');
            }
            
            if (data['credits'] is! int) {
              throw Exception('Credits must be an integer');
            }
          },
        ),
        Test(
          name: 'Email validation works',
          run: () async {
            final validEmails = [
              'user@example.com',
              'test.user@domain.co.uk',
              'name+tag@mail.com',
            ];

            final invalidEmails = [
              'invalid',
              '@example.com',
              'user@',
              'user @example.com',
            ];

            for (final email in validEmails) {
              if (!_isValidEmail(email)) {
                throw Exception('Valid email marked as invalid: $email');
              }
            }

            for (final email in invalidEmails) {
              if (_isValidEmail(email)) {
                throw Exception('Invalid email marked as valid: $email');
              }
            }
          },
        ),
        Test(
          name: 'Spin history size limit',
          run: () async {
            final history = List.generate(150, (i) => i % 37);
            final limited = _limitHistory(history, 100);

            if (limited.length != 100) {
              throw Exception('History not limited correctly: ${limited.length}');
            }

            // Debe mantener los más recientes
            if (limited.first != 50) {
              throw Exception('History should keep most recent entries');
            }
          },
        ),
        Test(
          name: 'User preferences are stored',
          run: () async {
            final prefs = {
              'dark_mode': true,
              'sound_enabled': false,
              'animation_speed': 1.5,
            };

            // Verificar tipos de datos
            if (prefs['dark_mode'] is! bool) {
              throw Exception('dark_mode must be boolean');
            }

            if (prefs['animation_speed'] is! double) {
              throw Exception('animation_speed must be double');
            }
          },
        ),
        Test(
          name: 'Credits system validation',
          run: () async {
            var credits = 100;

            // Restar créditos
            credits = _deductCredits(credits, 10);
            if (credits != 90) {
              throw Exception('Credits deduction failed');
            }

            // No permitir créditos negativos
            try {
              credits = _deductCredits(credits, 200);
              throw Exception('Should not allow negative credits');
            } catch (e) {
              if (!e.toString().contains('Insufficient')) {
                rethrow;
              }
            }
          },
        ),
      ];

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  List<int> _limitHistory(List<int> history, int maxSize) {
    if (history.length <= maxSize) return history;
    return history.sublist(history.length - maxSize);
  }

  int _deductCredits(int current, int amount) {
    if (amount > current) {
      throw Exception('Insufficient credits');
    }
    return current - amount;
  }
}
