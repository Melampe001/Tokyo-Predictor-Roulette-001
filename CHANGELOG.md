# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-14

### Added

#### Base Configuration
- **Android Gradle Build Configuration**: Complete build.gradle files for root and app module
  - Kotlin version 1.9.10
  - Gradle plugin 8.1.0
  - Google Services 4.4.0 for Firebase support
  - Min SDK 21, optimized for modern Android versions
  - R8 full mode with ProGuard rules
  - MultiDex support enabled
  - Signing configuration with key.properties support
- **Gradle Wrapper**: gradle-wrapper.properties with Gradle 8.3
- **Gradle Properties**: Performance-optimized build configuration
  - Parallel builds enabled
  - Build cache enabled
  - AndroidX and Jetifier enabled
  - JVM args optimized for large projects
- **ProGuard Rules**: Code obfuscation rules for Flutter, Firebase, and Stripe
- **EditorConfig**: Cross-editor configuration for consistent formatting
  - Dart: 2 spaces, 80 char line length
  - Gradle: 4 spaces
  - YAML/JSON: 2 spaces
  - UTF-8 encoding, LF line endings
- **VS Code Configuration**:
  - settings.json: Format on save, organize imports, Dart-specific settings
  - launch.json: Debug, profile, and release configurations
  - extensions.json: Recommended extensions for Flutter development
- **Documentation**:
  - BASE_CONFIGURATION.md: Comprehensive guide to project configuration (12k+ words)
  - android/LOCAL_PROPERTIES_SETUP.md: Guide for local.properties and keystore setup

#### Configuration Files
- `android/build.gradle` - Root Gradle configuration
- `android/settings.gradle` - Module configuration with Flutter plugin support
- `android/app/build.gradle` - App module configuration
- `android/gradle.properties` - Build optimization properties
- `android/gradle/wrapper/gradle-wrapper.properties` - Gradle wrapper
- `android/app/proguard-rules.pro` - Code obfuscation rules
- `.editorconfig` - Universal editor configuration
- `.vscode/settings.json` - VS Code workspace settings
- `.vscode/launch.json` - Debug configurations
- `.vscode/extensions.json` - Recommended extensions

### Changed
- **README.md**: Added reference to BASE_CONFIGURATION.md and LOCAL_PROPERTIES_SETUP.md
- Updated documentation section with new configuration guides

### Documentation
- Complete base configuration documentation
- Setup guides for development environment
- CI/CD configuration examples
- Keystore generation and signing instructions
- Troubleshooting guide for common setup issues

### Benefits
- ✅ Consistent code formatting across all editors
- ✅ Optimized build performance with caching and parallel builds
- ✅ Code obfuscation and security hardening
- ✅ Easy onboarding for new developers
- ✅ VS Code integration out-of-the-box
- ✅ Production-ready Android build configuration

## [1.0.0] - 2024-12-12

### Added

#### Core Features
- **Simulador de Ruleta Europea**: Implementación completa con números 0-36
- **Sistema de Predicciones**: Analiza historial y sugiere números frecuentes
- **Estrategia Martingale**: Sistema configurable que duplica apuestas tras pérdidas
- **Sistema de Balance Virtual**: Simulación de $1000 iniciales con apuestas
- **Historial Visual**: Muestra últimos 20 giros con colores (rojo/negro/verde)

#### Interfaz de Usuario
- Pantalla de login con captura de email
- Pantalla principal con diseño moderno usando Cards
- Visualización de resultado en círculo grande con colores
- Panel de balance y apuesta actual
- Indicador de ganancia/pérdida tras cada giro
- Historial de giros en círculos coloreados
- Tarjeta de predicción con icono de bombilla
- Banner de estrategia Martingale cuando está activa
- Disclaimer de seguridad siempre visible

#### Configuración
- Diálogo de configuración accesible desde AppBar
- Toggle para activar/desactivar Martingale
- Botón de reset para reiniciar el juego
- Deshabilitar "Girar" cuando balance insuficiente

#### Lógica de Negocio
- `RouletteLogic`: Clase para generación de números con RNG seguro
- `MartingaleAdvisor`: Clase para gestión de estrategia de apuestas
- Cálculo automático de ganancias/pérdidas
- Ajuste dinámico de apuesta según Martingale
- Límite de historial a 20 giros para optimizar memoria

#### Testing
- Tests unitarios para `RouletteLogic`:
  - Validación de rango de números (0-36)
  - Predicción con historial vacío
  - Predicción del número más frecuente
- Tests unitarios para `MartingaleAdvisor`:
  - Duplicación de apuesta tras pérdida
  - Reset a apuesta base tras ganancia
  - Persistencia en pérdidas consecutivas
  - Funcionalidad de reset
  - Apuesta base personalizada
- Tests de widgets:
  - Navegación login → main screen
  - Funcionalidad del botón girar
  - Apertura de diálogo de configuración
  - Reset del juego
  - Visibilidad del disclaimer

#### Documentación
- **README.md**: Guía de inicio rápido y características
- **docs/USER_GUIDE.md**: Manual completo de usuario (8.5k+ palabras)
  - Explicación de todas las características
  - Cómo usar la aplicación paso a paso
  - Explicación de estrategia Martingale
  - Sistema de predicciones educativo
  - Consejos y problemas comunes
- **docs/ARCHITECTURE.md**: Documentación técnica (15k+ palabras)
  - Stack tecnológico completo
  - Arquitectura de componentes
  - Flujos de datos y diagramas
  - Gestión de estado
  - Seguridad (RNG, validación)
  - Estrategia de testing
  - Consideraciones de rendimiento
  - CI/CD pipeline
  - Escalabilidad futura
- **docs/FIREBASE_SETUP.md**: Guía de configuración Firebase (5.7k+ palabras)
  - Setup paso a paso
  - Configuración de Authentication
  - Integración con Firestore
  - Remote Config
  - Consideraciones de seguridad
  - Testing sin Firebase
- **CONTRIBUTING.md**: Guía para contribuidores (11k+ palabras)
  - Código de conducta
  - Cómo reportar bugs
  - Proceso de Pull Requests
  - Convenciones de código
  - Arquitectura y patrones
  - Flujo de Git
  - Prácticas de seguridad
  - FAQs
- **LICENSE**: MIT License con disclaimer educativo
- **CHANGELOG.md**: Este archivo

#### Configuración del Proyecto
- **analysis_options.yaml**: Reglas de linting estrictas
- **flutter_lints**: Agregado como dependencia de desarrollo
- **.gitignore**: Configurado para Flutter/Dart
- **pubspec.yaml**: Todas las dependencias documentadas

#### CI/CD
- **GitHub Actions**: Workflow completo de build
  - Setup de Flutter y Java
  - Análisis de código con `flutter analyze`
  - Compilación de APK release
  - Subida de artefactos (30 días de retención)

### Security
- Uso de `Random.secure()` para generación criptográficamente segura
- Validación de balance antes de permitir apuestas
- Límite de apuesta automático basado en balance disponible
- Comentarios sobre no hardcodear claves API
- Preparación para variables de entorno en Firebase/Stripe

### Documentation
- Documentación completa en español
- Diagramas de flujo y arquitectura
- Ejemplos de código en todos los documentos
- Referencias a recursos externos
- Disclaimers legales y de seguridad

### Performance
- Historial limitado a 20 giros para optimizar memoria
- Uso de `const` widgets donde es posible
- `setState` quirúrgico para minimizar rebuilds
- `SingleChildScrollView` para pantallas pequeñas

## [Unreleased] - Futuras Mejoras

### Planned
- Integración real con Firebase Authentication
- Integración con Firebase Remote Config
- Persistencia local con SharedPreferences
- Gráficos avanzados con fl_chart
- Más tipos de apuestas (números directos, docenas, columnas)
- Múltiples estrategias de apuestas
- Estadísticas a largo plazo
- Modo multijugador
- Desafíos y logros
- Internacionalización (i18n) para múltiples idiomas
- Tema oscuro
- Animaciones de giro de ruleta
- Sonidos y efectos
- Tutorial interactivo
- Modelo freemium con Stripe/In-App Purchases

### Under Consideration
- Soporte para ruleta americana (con 00)
- Exportar historial de giros
- Compartir resultados en redes sociales
- Clasificaciones y competencias
- Modo offline completo

## Versiones Anteriores

No hay versiones anteriores documentadas. Este es el release inicial después de completar el proyecto.

---

## Tipos de Cambios

- **Added**: Nuevas características
- **Changed**: Cambios en funcionalidad existente
- **Deprecated**: Características que pronto se eliminarán
- **Removed**: Características eliminadas
- **Fixed**: Correcciones de bugs
- **Security**: Cambios relacionados con seguridad
- **Documentation**: Cambios solo en documentación
- **Performance**: Mejoras de rendimiento

[1.0.0]: https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases/tag/v1.0.0
