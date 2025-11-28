import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/main.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  // ============================================
  // Unit Tests: Roulette Logic
  // ============================================
  group('RouletteLogic Tests', () {
    late RouletteLogic rouletteLogic;

    setUp(() {
      rouletteLogic = RouletteLogic();
    });

    test('generateSpin returns value between 0 and 36', () {
      for (int i = 0; i < 100; i++) {
        final result = rouletteLogic.generateSpin();
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThanOrEqualTo(36));
      }
    });

    test('wheel contains all European roulette numbers (0-36)', () {
      expect(rouletteLogic.wheel.length, 37);
      expect(rouletteLogic.wheel.first, 0);
      expect(rouletteLogic.wheel.last, 36);
    });

    test('predictNext returns valid number', () {
      final history = [7, 14, 21, 7, 7];
      final prediction = rouletteLogic.predictNext(history);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext with empty history returns valid number', () {
      final prediction = rouletteLogic.predictNext([]);
      expect(prediction, greaterThanOrEqualTo(0));
      expect(prediction, lessThanOrEqualTo(36));
    });

    test('predictNext returns most frequent number from history', () {
      // 7 appears 3 times, should be predicted
      final history = [7, 14, 7, 21, 7];
      final prediction = rouletteLogic.predictNext(history);
      expect(prediction, 7);
    });
  });

  // ============================================
  // Unit Tests: Martingale Advisor
  // ============================================
  group('MartingaleAdvisor Tests', () {
    late MartingaleAdvisor advisor;

    setUp(() {
      advisor = MartingaleAdvisor();
    });

    test('initial bet equals base bet', () {
      expect(advisor.currentBet, 1.0);
      expect(advisor.baseBet, 1.0);
    });

    test('winning resets bet to base', () {
      advisor.getNextBet(false); // lose: 2.0
      advisor.getNextBet(false); // lose: 4.0
      final nextBet = advisor.getNextBet(true); // win: back to 1.0
      expect(nextBet, 1.0);
    });

    test('losing doubles the bet', () {
      expect(advisor.getNextBet(false), 2.0);
      expect(advisor.getNextBet(false), 4.0);
      expect(advisor.getNextBet(false), 8.0);
    });

    test('reset brings back to initial state', () {
      advisor.getNextBet(false);
      advisor.getNextBet(false);
      advisor.reset();
      expect(advisor.currentBet, 1.0);
      expect(advisor.lastWin, true);
    });
  });

  // ============================================
  // Widget Tests: UI Components
  // ============================================
  group('Widget Tests', () {
    testWidgets('App starts with SplashScreen', (tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Verify splash screen elements
      expect(find.text('Tokyo Roulette'), findsOneWidget);
      expect(find.text('TokyoApps®'), findsOneWidget);
    });

    testWidgets('SplashScreen shows branding and slogan', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      
      expect(find.text('Tokyo Roulette'), findsOneWidget);
      expect(find.text('TokyoApps®'), findsOneWidget);
      expect(find.textContaining('Simulación'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('LoginScreen shows email field and button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Registrar y Continuar'), findsOneWidget);
    });

    testWidgets('LoginScreen has About button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('MainScreen shows spin button and results', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));
      
      expect(find.text('Girar Ruleta'), findsOneWidget);
      expect(find.textContaining('Resultado'), findsOneWidget);
      expect(find.textContaining('Historia'), findsOneWidget);
    });

    testWidgets('Spin button updates result', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));
      
      // Initial state
      expect(find.text('Resultado: Presiona Girar'), findsOneWidget);
      
      // Tap spin button
      await tester.tap(find.text('Girar Ruleta'));
      await tester.pump();
      
      // Result should change (not "Presiona Girar" anymore)
      expect(find.text('Resultado: Presiona Girar'), findsNothing);
    });

    testWidgets('AboutScreen shows branding and disclaimer', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      
      // Check branding
      expect(find.text('Tokyo Roulette'), findsOneWidget);
      expect(find.text('TokyoApps®'), findsOneWidget);
      
      // Check disclaimer
      expect(find.text('Disclaimer'), findsOneWidget);
      expect(find.textContaining('entretenimiento'), findsAtLeastNWidgets(1));
      
      // Check features
      expect(find.text('Características'), findsOneWidget);
      expect(find.text('RNG Seguro certificado'), findsOneWidget);
    });

    testWidgets('Navigate from Login to About', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Tap info button
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      
      // Should show About screen
      expect(find.text('Acerca de'), findsOneWidget);
    });

    testWidgets('Navigate from Login to MainScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Enter email and tap continue
      await tester.enterText(find.byType(TextField), 'test@email.com');
      await tester.tap(find.text('Registrar y Continuar'));
      await tester.pumpAndSettle();
      
      // Should show main screen
      expect(find.text('Girar Ruleta'), findsOneWidget);
    });
  });

  // ============================================
  // Branding Validation Tests
  // ============================================
  group('Branding Validation Tests', () {
    test('App constants are correctly defined', () {
      expect(kAppName, 'Tokyo Roulette');
      expect(kAppVersion, '1.0.0');
      // kAppBrand and kAppSlogan use environment variables with defaults
    });

    testWidgets('All screens show TokyoApps branding', (tester) async {
      // Test SplashScreen
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      expect(find.text('TokyoApps®'), findsOneWidget);
      
      // Test AboutScreen
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      expect(find.text('TokyoApps®'), findsOneWidget);
    });

    testWidgets('Disclaimer is visible in AboutScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      
      expect(find.text('Disclaimer'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });
  });
}