# Tokyo Roulette Predicciones

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)
![Status](https://img.shields.io/badge/Status-Completed-success)

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## 📱 Capturas de Pantalla

> Ver las imágenes en la raíz del proyecto: `Screenshot_*.png`

## ✨ Características Implementadas

✅ **Simulador de Ruleta Europea** (0-36) con RNG seguro  
✅ **Sistema de Predicciones** basado en historial de giros  
✅ **Estrategia Martingale** configurable y automatizada  
✅ **Sistema de Balance Virtual** para simulación de apuestas  
✅ **Historial Visual** de últimos 20 giros con colores (rojo/negro/verde)  
✅ **Interfaz Moderna** con tarjetas, iconos y diseño limpio  
✅ **Configuración** de estrategias y opciones de juego  
✅ **Tests Unitarios** para lógica de ruleta y Martingale  
✅ **Tests de Widgets** para UI y flujos principales  
✅ **Disclaimer de Seguridad** sobre juego responsable

## 🚀 Inicio Rápido

### Requisitos Previos
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code
- JDK 11+ (para builds de Android)

### Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## 🏗️ Construir APK

Para generar una APK de release:
```bash
flutter build apk --release
```

La APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 🧪 Ejecutar Tests

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/roulette_logic_test.dart
flutter test test/widget_test.dart

# Con cobertura
flutter test --coverage
```

## 📚 Documentación

- **[Guía de Usuario](docs/USER_GUIDE.md)**: Manual completo de uso de la aplicación
- **[Arquitectura Técnica](docs/ARCHITECTURE.md)**: Diseño y estructura del código
- **[Configuración Firebase](docs/FIREBASE_SETUP.md)**: Cómo integrar Firebase (opcional)
- **[Guía de Contribución](CONTRIBUTING.md)**: Cómo contribuir al proyecto
- **[Changelog](CHANGELOG.md)**: Historial de cambios y versiones

## 🎯 Uso Básico

1. **Inicia sesión** ingresando un email
2. **Gira la ruleta** presionando el botón
3. **Observa el resultado** y tu balance actualizado
4. **Activa Martingale** desde configuración (opcional)
5. **Consulta predicciones** basadas en historial
6. **Resetea el juego** cuando desees comenzar de nuevo

## 🔧 Configuración

### Opciones Disponibles

- **Estrategia Martingale**: Duplica apuesta tras pérdidas
- **Balance Inicial**: $1000 (configurable en código)
- **Apuesta Base**: $10 (ajustable)

### Configuración Firebase (Opcional)

Para habilitar características de Firebase, consulta [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md).

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de UI multiplataforma
- **Dart**: Lenguaje de programación
- **Firebase**: Backend as a Service (opcional)
- **Stripe**: Procesamiento de pagos (futuro)
- **fl_chart**: Gráficos y visualizaciones (futuro)

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor lee la [Guía de Contribución](CONTRIBUTING.md) para detalles sobre:

- Cómo reportar bugs
- Cómo sugerir mejoras
- Proceso de Pull Requests
- Convenciones de código
- Flujo de Git

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## ⚠️ Disclaimer

**IMPORTANTE**: Esta es una simulación educativa. No promueve gambling real.

**Disclaimer**: Solo simulación. No promueve juegos de azar reales. Las predicciones son aleatorias y no garantizan resultados. Si tú o alguien que conoces tiene problemas con el juego, busca ayuda profesional.

### Recursos de Ayuda
- **España**: 900 200 211 (Juego Responsable)
- **México**: 55 5533 5533 (CONADIC)
- **Argentina**: 0800 222 1002 (Juego Responsable)

## 📞 Contacto

Para preguntas, sugerencias o reportar problemas:
- Abre un [Issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- Revisa la [documentación](docs/)

## 🙏 Agradecimientos

- Comunidad de Flutter por el excelente framework
- Contribuidores del proyecto
- Usuarios que proporcionaron feedback

---

**Versión**: 1.0.0  
**Estado**: ✅ Proyecto Completado  
**Última Actualización**: Diciembre 2024

## 🧹 Mantenimiento del Repositorio

**Última limpieza:** 2024-12-14

### Estado de PRs
- ✅ Abiertas activas: ~14-16
- ⏸️ Drafts en desarrollo: ~8-10
- ❌ Cerradas en limpieza: 16

### Política de PRs
- PRs inactivas >30 días serán marcadas como `stale`
- Drafts sin actividad >60 días serán cerrados automáticamente
- Duplicados se cierran automáticamente con comentario explicativo
- PRs sin respuesta a comentarios en 14 días se marcan para cierre

### Cómo Evitar Cierres Automáticos
1. Mantén PRs actualizados con commits regulares
2. Responde a comentarios en <7 días
3. Sincroniza con `main` regularmente
4. Marca PRs activos con label `priority` si son críticos
5. Actualiza la descripción del PR con el estado actual

### Proceso de Reapertura
Si un PR/issue fue cerrado por error:
1. Actualiza el contenido del PR/issue
2. Responde a todos los comentarios pendientes
3. Menciona @Melampe001 en un comentario solicitando revisión
4. Explica por qué debería reabrirse

### Documentación de Limpieza
- [Script de Limpieza](docs/CLEANUP_SCRIPT.md) - Documentación completa del proceso
- [Estado Post-Limpieza](docs/POST_CLEANUP_TRACKING.md) - Tracking de PRs cerrados y priorizados
- [Script Ejecutable](close_stale_prs.sh) - Script bash para ejecutar limpieza

## Configuración de Keystore para Android

Para firmar la APK en modo release, necesitas configurar un keystore:

### Opción 1: Archivo key.properties (desarrollo local)
Crea un archivo `key.properties` en el directorio raíz del proyecto con:
```properties
storeFile=/ruta/a/tu/keystore.jks
storePassword=tu_password_del_keystore
keyAlias=tu_alias
keyPassword=tu_password_de_la_key
```

### Opción 2: Variables de entorno (CI/CD)
Define las siguientes variables de entorno en tu sistema de CI:
- `ANDROID_KEYSTORE_PATH`: Ruta al archivo keystore
- `KEYSTORE_PASSWORD`: Contraseña del keystore
- `KEY_ALIAS`: Alias de la key
- `KEY_PASSWORD`: Contraseña de la key

**Nota**: Nunca commits el archivo `key.properties` o el keystore al repositorio.

---

## Fases del Proyecto

### 1. Definición y planificación
- [ok] Redactar objetivo y alcance del proyecto
- [ok] Identificar requerimientos y entregables principales
- [ok] Crear roadmap con hitos y fechas estimadas
- [ok] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [ok] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [ok] Revisar dependencias y recursos necesarios
- [ok] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [ok] Implementar funcionalidades según el roadmap
- [ok] Realizar revisiones de código y PR siguiendo checklist
- [ok] Actualizar documentación según cambios realizados

### 4. Pruebas
- [ok] Ejecutar pruebas unitarias y funcionales
- [ok] Validar requisitos y criterios de aceptación
- [ok] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [ok] Preparar ambiente de release
- [ok] Documentar lecciones aprendidas
- [ok] Presentar entregables y cerrar fase
