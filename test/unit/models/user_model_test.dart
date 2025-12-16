import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/models/user_model.dart';

void main() {
  group('UserModel', () {
    const testUser = UserModel(
      id: 'test_123',
      email: 'test@example.com',
      balance: 1000.0,
      currentBet: 10.0,
      totalSpins: 100,
      totalWins: 45,
      totalLosses: 55,
      unlockedAchievements: ['first_win', 'streak_5'],
    );

    group('constructor', () {
      test('crea un usuario con todos los campos', () {
        expect(testUser.id, equals('test_123'));
        expect(testUser.email, equals('test@example.com'));
        expect(testUser.balance, equals(1000.0));
        expect(testUser.currentBet, equals(10.0));
        expect(testUser.totalSpins, equals(100));
        expect(testUser.totalWins, equals(45));
        expect(testUser.totalLosses, equals(55));
        expect(testUser.unlockedAchievements.length, equals(2));
      });

      test('usa valores por defecto correctos', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
        );
        
        expect(user.balance, equals(1000.0));
        expect(user.currentBet, equals(10.0));
        expect(user.totalSpins, equals(0));
        expect(user.totalWins, equals(0));
        expect(user.totalLosses, equals(0));
        expect(user.unlockedAchievements, isEmpty);
      });
    });

    group('copyWith', () {
      test('copia el modelo sin cambios', () {
        final copy = testUser.copyWith();
        
        expect(copy.id, equals(testUser.id));
        expect(copy.email, equals(testUser.email));
        expect(copy.balance, equals(testUser.balance));
      });

      test('actualiza solo el balance', () {
        final updated = testUser.copyWith(balance: 2000.0);
        
        expect(updated.balance, equals(2000.0));
        expect(updated.id, equals(testUser.id));
        expect(updated.email, equals(testUser.email));
        expect(updated.totalSpins, equals(testUser.totalSpins));
      });

      test('actualiza múltiples campos', () {
        final updated = testUser.copyWith(
          balance: 1500.0,
          totalSpins: 150,
          totalWins: 75,
        );
        
        expect(updated.balance, equals(1500.0));
        expect(updated.totalSpins, equals(150));
        expect(updated.totalWins, equals(75));
        expect(updated.totalLosses, equals(testUser.totalLosses));
      });

      test('actualiza logros', () {
        final updated = testUser.copyWith(
          unlockedAchievements: ['first_win', 'streak_5', 'big_spender'],
        );
        
        expect(updated.unlockedAchievements.length, equals(3));
        expect(updated.unlockedAchievements.contains('big_spender'), isTrue);
      });
    });

    group('winRate', () {
      test('calcula el ratio de victorias correctamente', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
          totalSpins: 100,
          totalWins: 60,
        );
        
        expect(user.winRate, equals(0.6));
      });

      test('retorna 0 cuando no hay giros', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
          totalSpins: 0,
          totalWins: 0,
        );
        
        expect(user.winRate, equals(0.0));
      });

      test('maneja 100% de victorias', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
          totalSpins: 50,
          totalWins: 50,
        );
        
        expect(user.winRate, equals(1.0));
      });

      test('maneja 0% de victorias', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
          totalSpins: 50,
          totalWins: 0,
        );
        
        expect(user.winRate, equals(0.0));
      });

      test('calcula con decimales precisos', () {
        const user = UserModel(
          id: 'test',
          email: 'test@example.com',
          totalSpins: 7,
          totalWins: 3,
        );
        
        expect(user.winRate, closeTo(0.4286, 0.0001));
      });
    });

    group('equality', () {
      test('dos usuarios idénticos son iguales', () {
        const user1 = UserModel(
          id: 'test',
          email: 'test@example.com',
          balance: 1000.0,
        );
        
        const user2 = UserModel(
          id: 'test',
          email: 'test@example.com',
          balance: 1000.0,
        );
        
        expect(user1, equals(user2));
      });

      test('usuarios con diferente id no son iguales', () {
        const user1 = UserModel(
          id: 'test1',
          email: 'test@example.com',
        );
        
        const user2 = UserModel(
          id: 'test2',
          email: 'test@example.com',
        );
        
        expect(user1, isNot(equals(user2)));
      });

      test('usuarios con diferente balance no son iguales', () {
        const user1 = UserModel(
          id: 'test',
          email: 'test@example.com',
          balance: 1000.0,
        );
        
        const user2 = UserModel(
          id: 'test',
          email: 'test@example.com',
          balance: 2000.0,
        );
        
        expect(user1, isNot(equals(user2)));
      });

      test('usuarios con diferentes logros no son iguales', () {
        const user1 = UserModel(
          id: 'test',
          email: 'test@example.com',
          unlockedAchievements: ['first_win'],
        );
        
        const user2 = UserModel(
          id: 'test',
          email: 'test@example.com',
          unlockedAchievements: ['first_win', 'streak_5'],
        );
        
        expect(user1, isNot(equals(user2)));
      });
    });

    group('escenarios realistas', () {
      test('simula una sesión de juego ganadora', () {
        var user = const UserModel(
          id: 'player1',
          email: 'player@example.com',
          balance: 1000.0,
          currentBet: 10.0,
        );
        
        // Gana 3 apuestas
        for (int i = 0; i < 3; i++) {
          user = user.copyWith(
            balance: user.balance + user.currentBet,
            totalSpins: user.totalSpins + 1,
            totalWins: user.totalWins + 1,
          );
        }
        
        expect(user.balance, equals(1030.0));
        expect(user.totalSpins, equals(3));
        expect(user.totalWins, equals(3));
        expect(user.winRate, equals(1.0));
      });

      test('simula una sesión de juego perdedora', () {
        var user = const UserModel(
          id: 'player1',
          email: 'player@example.com',
          balance: 1000.0,
          currentBet: 10.0,
        );
        
        // Pierde 5 apuestas
        for (int i = 0; i < 5; i++) {
          user = user.copyWith(
            balance: user.balance - user.currentBet,
            totalSpins: user.totalSpins + 1,
            totalLosses: user.totalLosses + 1,
          );
        }
        
        expect(user.balance, equals(950.0));
        expect(user.totalSpins, equals(5));
        expect(user.totalLosses, equals(5));
        expect(user.winRate, equals(0.0));
      });

      test('simula desbloqueo de logros', () {
        var user = const UserModel(
          id: 'player1',
          email: 'player@example.com',
        );
        
        // Desbloquea primer logro
        user = user.copyWith(
          unlockedAchievements: ['first_win'],
        );
        expect(user.unlockedAchievements.length, equals(1));
        
        // Desbloquea segundo logro
        user = user.copyWith(
          unlockedAchievements: [...user.unlockedAchievements, 'streak_5'],
        );
        expect(user.unlockedAchievements.length, equals(2));
      });
    });
  });
}
