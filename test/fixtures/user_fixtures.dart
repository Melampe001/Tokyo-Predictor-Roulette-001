/// Fixtures de prueba para datos de usuario
/// Proporciona datos de prueba consistentes para tests
class UserFixtures {
  /// Usuario válido con todos los campos
  static Map<String, dynamic> validUser() => {
        'id': 'user123',
        'email': 'test@example.com',
        'username': 'testuser',
        'balance': 1000.0,
        'created_at': '2024-01-01T00:00:00Z',
      };

  /// Usuario sin email (caso inválido)
  static Map<String, dynamic> userWithoutEmail() => {
        'id': 'user456',
        'username': 'nouser',
        'balance': 500.0,
      };

  /// Usuario con balance cero
  static Map<String, dynamic> userWithZeroBalance() => {
        'id': 'user789',
        'email': 'broke@example.com',
        'username': 'brokeuser',
        'balance': 0.0,
      };

  /// Usuario con balance alto
  static Map<String, dynamic> userWithHighBalance() => {
        'id': 'richuser',
        'email': 'rich@example.com',
        'username': 'richuser',
        'balance': 10000.0,
      };

  /// Lista de usuarios válidos
  static List<Map<String, dynamic>> validUsers() => [
        validUser(),
        {
          'id': 'user2',
          'email': 'user2@example.com',
          'username': 'user2',
          'balance': 750.0,
        },
        {
          'id': 'user3',
          'email': 'user3@example.com',
          'username': 'user3',
          'balance': 250.0,
        },
      ];

  /// Emails válidos para testing
  static List<String> validEmails() => [
        'test@example.com',
        'user@domain.co.uk',
        'name.surname@company.com',
        'user+tag@example.com',
        'user123@example456.com',
      ];

  /// Emails inválidos para testing
  static List<String> invalidEmails() => [
        'notanemail',
        'missing@domain',
        '@nodomain.com',
        'spaces in@email.com',
        'double@@at.com',
        '',
      ];

  /// Usernames válidos
  static List<String> validUsernames() => [
        'user123',
        'test_user',
        'abc',
        'username_20chars_',
      ];

  /// Usernames inválidos
  static List<String> invalidUsernames() => [
        'ab', // muy corto
        'a' * 21, // muy largo
        'user name', // espacios
        'user-name', // guiones
        'user@name', // caracteres especiales
        '',
      ];
}
