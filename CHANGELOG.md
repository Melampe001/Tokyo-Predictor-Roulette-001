# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

---

## [1.0.0] - 2024-11-28

### ✨ Añadido
- **Splash Screen** con branding TokyoApps® y slogan
- **About Screen** con disclaimer educativo completo
- **Suite de tests** completa para lógica de ruleta y UI
- **CI/CD Pipeline** con GitHub Actions:
  - Análisis estático y linting
  - Tests automatizados con cobertura
  - Build de APK release optimizada
  - Build de App Bundle para Play Store
  - Validación automática de branding
  - Generación de checklist de compliance
- **Configuración Android** completa:
  - `build.gradle` con signing configs
  - ProGuard rules para optimización
  - Soporte para keystore y variables de entorno
- **Documentación** actualizada:
  - README con instrucciones completas
  - Estructura del proyecto
  - Guías de instalación y build

### 🔧 Cambiado
- Actualizado `main.dart` con Material Design 3
- Mejorada UI con iconos y estilos modernos
- Namespace actualizado a `com.tokyoapps.roulette`

### 🔒 Seguridad
- ProGuard habilitado para release builds
- Configuración de firma con keystore seguro
- Variables de entorno para credenciales en CI/CD

### 📋 Branding
- TokyoApps® visible en Splash y About
- Slogan: "Simulación inteligente para entretenimiento"
- Disclaimer educativo prominente
- Metadatos de branding en AndroidManifest

---

## [Unreleased]

### Por hacer
- Integración completa con Firebase
- Sistema de pagos con Stripe
- Notificaciones push
- Soporte multi-idioma
- Gráficos estadísticos con fl_chart

---

## Convenciones de versionado

- **MAJOR**: Cambios incompatibles con versiones anteriores
- **MINOR**: Nuevas funcionalidades compatibles
- **PATCH**: Correcciones de bugs compatibles

---

© 2024 TokyoApps® - Simulación inteligente para entretenimiento
