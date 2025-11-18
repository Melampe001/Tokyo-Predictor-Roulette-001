# Tokyo Roulette Predicciones

![CI](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/CI/badge.svg)
![Build](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Build/badge.svg)
![Test](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Test/badge.svg)
![Lint](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/workflows/Lint/badge.svg)

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

## Desarrollo

### Tests
```bash
# Ejecutar todos los tests
flutter test

# Tests con cobertura
flutter test --coverage

# Solo tests de performance
flutter test test/roulette_logic_test.dart
```

### Calidad de Código
```bash
# Análisis estático
flutter analyze

# Formato
dart format .
```

### CI/CD
El proyecto incluye workflows de GitHub Actions para:
- ✅ Build automático (Android, iOS, Web)
- ✅ Tests unitarios y de performance
- ✅ Análisis estático y formato
- ✅ Reportes de cobertura

Ver [.github/workflows/README.md](.github/workflows/README.md) para más detalles.

**Disclaimer**: Solo simulación. No promueve gambling real.
