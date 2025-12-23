import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extensiones útiles para WidgetTester en tests
extension WidgetTesterExtensions on WidgetTester {
  /// Busca un widget por tipo y texto
  Finder findWidgetWithText<T extends Widget>(String text) {
    return find.widgetWithText(T, text);
  }

  /// Pump y settle con timeout personalizado
  Future<void> pumpAndSettleWithTimeout([
    Duration timeout = const Duration(seconds: 10),
  ]) async {
    await pumpAndSettle(timeout);
  }

  /// Espera a que aparezca un widget
  Future<void> waitFor(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final end = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(end)) {
      await pump();
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    throw Exception('Widget not found within timeout: $finder');
  }

  /// Scroll hasta que un widget sea visible
  Future<void> scrollUntilVisible(
    Finder finder,
    Finder scrollable, {
    double delta = 100.0,
    int maxScrolls = 50,
  }) async {
    for (int i = 0; i < maxScrolls; i++) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await drag(scrollable, Offset(0, -delta));
      await pump();
    }
    throw Exception('Widget not found after $maxScrolls scrolls');
  }

  /// Ingresa texto y hace submit (presiona enter)
  Future<void> enterTextAndSubmit(Finder finder, String text) async {
    await enterText(finder, text);
    await testTextInput.receiveAction(TextInputAction.done);
    await pump();
  }

  /// Verifica que no haya excepciones
  void expectNoExceptions() {
    expect(takeException(), isNull);
  }

  /// Tap múltiple en un widget
  Future<void> tapMultiple(Finder finder, int times) async {
    for (int i = 0; i < times; i++) {
      await tap(finder);
      await pump();
    }
  }

  /// Verifica que un widget esté visible en la pantalla
  void expectVisible(Finder finder) {
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;
    expect(widget, isNotNull);
  }

  /// Verifica que un widget NO esté visible
  void expectNotVisible(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Pump con duración específica
  Future<void> pumpFor(Duration duration) async {
    await pump(duration);
  }

  /// Pump múltiples frames
  Future<void> pumpFrames(int frames) async {
    for (int i = 0; i < frames; i++) {
      await pump();
    }
  }
}

/// Helper class para crear apps de prueba
class TestAppWrapper {
  /// Crea una MaterialApp básica para tests
  static Widget wrap(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  /// Crea una MaterialApp con tema personalizado
  static Widget wrapWithTheme(Widget child, ThemeData theme) {
    return MaterialApp(
      theme: theme,
      home: child,
    );
  }

  /// Crea una app con Scaffold para tests
  static Widget wrapWithScaffold(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Crea una app con navegación
  static Widget wrapWithNavigation(
    Widget home, {
    Map<String, WidgetBuilder>? routes,
  }) {
    return MaterialApp(
      home: home,
      routes: routes ?? {},
    );
  }
}

/// Matchers personalizados para tests
class CustomMatchers {
  /// Matcher para verificar que un número está en el rango de la ruleta
  static Matcher isValidRouletteNumber() {
    return inInclusiveRange(0, 36);
  }

  /// Matcher para verificar email válido
  static Matcher isValidEmail() {
    return matches(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  }

  /// Matcher para verificar que un valor es positivo
  static Matcher isPositive() {
    return greaterThan(0);
  }

  /// Matcher para verificar que un valor es no negativo
  static Matcher isNonNegative() {
    return greaterThanOrEqualTo(0);
  }
}

/// Helper para crear delays en tests
class TestDelays {
  static const Duration short = Duration(milliseconds: 100);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(seconds: 1);
  static const Duration veryLong = Duration(seconds: 3);

  /// Espera un delay
  static Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }
}

/// Helper para generar datos aleatorios de prueba
class TestDataGenerator {
  /// Genera un email de prueba único
  static String generateEmail() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test$timestamp@example.com';
  }

  /// Genera un username de prueba único
  static String generateUsername() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'user$timestamp';
  }

  /// Genera un balance aleatorio
  static double generateBalance({double min = 0, double max = 10000}) {
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    return min + (random / 1000) * (max - min);
  }

  /// Genera una lista de números de ruleta aleatorios
  static List<int> generateRouletteHistory(int count) {
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(count, (i) => (random + i) % 37);
  }
}
