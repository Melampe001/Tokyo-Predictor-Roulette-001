# 🎰 Tokyo Predictor Roulette - Simulador Premium con IA

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)
![Unity](https://img.shields.io/badge/Unity-2022.3%20LTS-black?logo=unity)
![ML-Agents](https://img.shields.io/badge/ML--Agents-1.0.0-orange)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

Simulador de ruleta educativo y de entretenimiento con asistente predictivo impulsado por **Unity ML-Agents** y **Sentis**. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## 🚀 Desarrollo en Codespaces
Este proyecto está optimizado para GitHub Codespaces. [Ver guía de setup](docs/SETUP_CODESPACES.md)

## 📱 Capturas de Pantalla

> Ver las imágenes en la raíz del proyecto: `Screenshot_*.png`

## ✨ Características Implementadas

### Flutter App (Versión Actual)
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

### Unity ML-Agents (En Desarrollo) 🤖
🔄 **Agente PPO entrenado** con 500k pasos  
🔄 **Análisis de patrones** de últimos 50 giros  
🔄 **Inferencia local en móvil** usando ONNX via Sentis  
🔄 **Sugerencias de apuestas inteligentes** basadas en IA  
🔄 **Desafíos diarios con IA** y sistema de recompensas  
🔄 **Observación de física** (velocidad de bola y ruleta)

## 🚀 Inicio Rápido

### Desarrollo Flutter (Versión Actual)

#### Requisitos Previos
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code
- JDK 11+ (para builds de Android)

#### Instalación

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

### Desarrollo Unity ML-Agents (GitHub Codespaces)

Para trabajar con la versión Unity + ML-Agents:

1. **Abrir en Codespaces**: GitHub → Code → Codespaces → Create codespace
2. **Setup automático**: Espera 3-5 minutos mientras se instala Unity, ML-Agents, y Android SDK
3. **Entrenar IA**: `bash scripts/train-ml-agents.sh`
4. **Ver métricas**: `tensorboard --logdir results/ --port 6006`

📖 Guía completa: [docs/SETUP_CODESPACES.md](docs/SETUP_CODESPACES.md)

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
- **[Health Agent](docs/HEALTH_AGENT.md)**: Sistema de auditoría de salud del proyecto
- **[Guía de Contribución](CONTRIBUTING.md)**: Cómo contribuir al proyecto
- **[Changelog](CHANGELOG.md)**: Historial de cambios y versiones

## 🎯 Uso Básico

### Flutter App
1. **Inicia sesión** ingresando un email
2. **Gira la ruleta** presionando el botón
3. **Observa el resultado** y tu balance actualizado
4. **Activa Martingale** desde configuración (opcional)
5. **Consulta predicciones** basadas en historial
6. **Resetea el juego** cuando desees comenzar de nuevo

### Unity ML-Agents (Próximamente)
1. **Inicia el entorno**: Unity carga el simulador 3D
2. **Observa la IA**: El agente analiza patrones en tiempo real
3. **Recibe sugerencias**: La IA sugiere apuestas basadas en análisis
4. **Entrena tu propio modelo**: Modifica hiperparámetros y re-entrena
5. **Compara resultados**: Evalúa diferentes estrategias

## 🤖 Características IA

El sistema de inteligencia artificial está basado en **Unity ML-Agents** con algoritmo PPO:

### Capacidades del Agente
- 📊 **Análisis de Patrones**: Procesa últimos 50 giros para detectar tendencias
- 🎯 **Predicciones Inteligentes**: Sugiere apuestas basadas en probabilidades calculadas
- 🔬 **Observación de Física**: Analiza velocidad de bola y ruleta para mejor precisión
- 📈 **Aprendizaje Continuo**: Modelo entrenado con 500,000 pasos de experiencia
- 📱 **Inferencia Local**: Ejecución en dispositivo usando ONNX (< 50ms latencia)

### Arquitectura
```
Observaciones → Red Neuronal (128x2) → Acciones Discretas → Recompensas → Aprendizaje
```

**Modelo**: PPO con 128 unidades ocultas, 2 capas, normalización automática  
**Entrenamiento**: 500k pasos, checkpoint cada 50k, TensorBoard para métricas  
**Deployment**: Exportación a ONNX, inferencia via Unity Sentis en GPU móvil

📖 Plan completo: [docs/STRATEGIC_PLAN.md](docs/STRATEGIC_PLAN.md)

## 🏥 Project Health Agent

Este proyecto incluye un **sistema automatizado de auditoría** que verifica la salud del proyecto:

```bash
# Ejecutar auditoría completa
python scripts/health_agent.py --full-scan

# Ver reporte generado
cat reports/project-health-report-*.md
```

**Características**:
- ✅ Verifica estructura de archivos y dependencias
- ✅ Analiza seguridad y configuración de Git
- ✅ Revisa CI/CD y documentación
- ✅ Genera reportes con score de salud (0-100)
- ✅ Se ejecuta automáticamente cada semana vía GitHub Actions

**Score actual**: 🟢 92/100 (Excelente)

Para más detalles, consulta [docs/HEALTH_AGENT.md](docs/HEALTH_AGENT.md).

## 🔧 Configuración

### Opciones Disponibles

- **Estrategia Martingale**: Duplica apuesta tras pérdidas
- **Balance Inicial**: $1000 (configurable en código)
- **Apuesta Base**: $10 (ajustable)

### Configuración Firebase (Opcional)

Para habilitar características de Firebase, consulta [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md).

## 🛠️ Tecnologías Utilizadas

### Flutter App (Actual)
- **Flutter**: Framework de UI multiplataforma
- **Dart**: Lenguaje de programación
- **Firebase**: Backend as a Service (opcional)
- **Stripe**: Procesamiento de pagos (futuro)
- **fl_chart**: Gráficos y visualizaciones

### Unity ML-Agents (En Desarrollo)
- **Unity 2022.3 LTS**: Motor de juego 3D
- **ML-Agents Toolkit 1.0.0**: Framework de aprendizaje por refuerzo
- **Unity Sentis**: Inferencia de modelos ONNX en dispositivos
- **Python 3.10**: Entrenamiento de modelos
- **PyTorch**: Backend de deep learning
- **TensorBoard**: Visualización de métricas de entrenamiento

### Plataformas
- **Android 8.0+** (API 26): Target principal
- **iOS**: Soporte futuro
- **Web**: Considerado para dashboard de métricas

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor lee la [Guía de Contribución](CONTRIBUTING.md) para detalles sobre:

- Cómo reportar bugs
- Cómo sugerir mejoras
- Proceso de Pull Requests
- Convenciones de código
- Flujo de Git

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## ⚠️ Disclaimer y Cumplimiento Legal

**IMPORTANTE**: Esta es una simulación educativa. **NO se apuesta dinero real.**

### Aviso Legal Obligatorio
"Esta aplicación es un **SIMULADOR EDUCATIVO**. No se apuesta dinero real. Los resultados de la IA son con fines de entretenimiento y educación, y **NO garantizan éxito en juegos de azar reales**. La ruleta usa generadores de números aleatorios seguros. +18 solamente."

### Compliance Google Play 2025
✅ Categoría: **Entretenimiento Educativo** (NO Casino)  
✅ Sin keywords prohibidas (Real Money, Win Cash, etc.)  
✅ Disclaimers visibles en splash screen y configuración  
✅ Sistema de descansos saludables cada 60 minutos  
✅ Restricción de edad +18 en metadata  
✅ Política de privacidad publicada  

📖 Checklist completo: [docs/LEGAL_COMPLIANCE.md](docs/LEGAL_COMPLIANCE.md)

### Recursos de Ayuda para Juego Problemático
- **España**: 900 200 211 (Juego Responsable)
- **México**: 55 5533 5533 (CONADIC)
- **Argentina**: 0800 222 1002 (Juego Responsable)
- **Internacional**: [Gamblers Anonymous](https://www.gamblersanonymous.org/)

## 📞 Contacto

Para preguntas, sugerencias o reportar problemas:
- Abre un [Issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- Revisa la [documentación](docs/)

## 🙏 Agradecimientos

- Comunidad de Flutter por el excelente framework
- Unity Technologies por ML-Agents Toolkit
- Comunidad de machine learning por recursos educativos
- Contribuidores del proyecto
- Usuarios que proporcionaron feedback

## 📚 Referencias Técnicas

### Unity ML-Agents
- [Unity ML-Agents Toolkit](https://github.com/Unity-Technologies/ml-agents) - Repositorio oficial
- [ML-Agents Documentation](https://github.com/Unity-Technologies/ml-agents/blob/main/docs/Readme.md) - Documentación completa
- [PPO Algorithm](https://spinningup.openai.com/en/latest/algorithms/ppo.html) - Explicación del algoritmo

### Unity Sentis
- [Unity Sentis Documentation](https://docs.unity3d.com/Packages/com.unity.sentis@latest) - Guía oficial
- [ONNX Runtime](https://onnxruntime.ai/) - Runtime para inferencia

### DevContainers
- [Devcontainers Specification](https://containers.dev/) - Especificación oficial
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) - Guía de uso

---

**Versión**: 1.0.0  
**Estado**: 🔄 En Desarrollo Activo  
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

## 🤖 Automatización y CI/CD

Este proyecto incluye un sistema completo de automatización para desarrollo, builds y releases.

### AGENTE 5: Release Master 🚀

Scripts para gestión de releases y builds de producción:

#### Scripts Disponibles

```bash
# Build APK/AAB release firmado
./scripts/release_builder.sh --all

# Gestionar keystore
./scripts/keystore_manager.sh --generate
./scripts/keystore_manager.sh --create-properties

# Gestionar versiones
./scripts/version_manager.sh current
./scripts/version_manager.sh patch  # 1.0.0 -> 1.0.1
./scripts/version_manager.sh minor  # 1.0.0 -> 1.1.0
./scripts/version_manager.sh major  # 1.0.0 -> 2.0.0
```

**Documentación completa:** [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md)

### AGENTE 7: CI/CD Master ⚙️

Scripts para cobertura de tests y seguridad:

```bash
# Generar reporte de cobertura
./scripts/coverage_reporter.sh --html

# Escaneo de seguridad
./scripts/security_scanner.sh
```

**Documentación completa:** [docs/CI_CD_SETUP.md](docs/CI_CD_SETUP.md)

### GitHub Actions Workflows

El proyecto incluye tres workflows automáticos:

1. **CI** (`.github/workflows/ci.yml`)
   - ✅ Lint y análisis de código
   - ✅ Tests unitarios con coverage
   - ✅ Build APK debug
   - ✅ Escaneo de seguridad
   - 🚀 Ejecuta en cada push y PR

2. **Release** (`.github/workflows/release.yml`)
   - 🚀 Build APK/AAB release firmado
   - 📦 Crear GitHub Release automáticamente
   - 📄 Generar release notes
   - 🚀 Ejecuta al crear tags `v*.*.*`

3. **PR Checks** (`.github/workflows/pr-checks.yml`)
   - 📝 Validar formato de código
   - 🧪 Verificar cobertura de tests (≥80%)
   - 🔒 Escaneo de seguridad
   - 💬 Comentarios automáticos en PR
   - 🚀 Ejecuta en cada PR

### Proceso de Release Automático

```bash
# 1. Incrementar versión
./scripts/version_manager.sh minor

# 2. Commit cambios
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to 1.1.0"
git push origin main

# 3. Crear y push tag (dispara release automático)
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0

# El workflow automáticamente:
# - Build APK/AAB firmado
# - Crea GitHub Release
# - Sube archivos como assets
```

## Configuración de Keystore para Android

Para firmar la APK en modo release, usa el script automatizado:

### Configuración Rápida (Recomendado)

```bash
# 1. Generar keystore
./scripts/keystore_manager.sh --generate

# 2. Crear key.properties automáticamente
./scripts/keystore_manager.sh --create-properties

# 3. Verificar configuración
./scripts/keystore_manager.sh --check-gradle

# 4. Ver instrucciones para GitHub Secrets (CI/CD)
./scripts/keystore_manager.sh --github-secrets
```

### Configuración Manual

Si prefieres configurar manualmente:

#### Opción 1: Archivo key.properties (desarrollo local)
Crea un archivo `android/key.properties` con:
```properties
storeFile=/ruta/a/tu/keystore.jks
storePassword=tu_password_del_keystore
keyAlias=tu_alias
keyPassword=tu_password_de_la_key
```

#### Opción 2: Variables de entorno (CI/CD)
Define las siguientes variables de entorno:
- `ANDROID_KEYSTORE_PATH`: Ruta al archivo keystore
- `KEYSTORE_PASSWORD`: Contraseña del keystore
- `KEY_ALIAS`: Alias de la key
- `KEY_PASSWORD`: Contraseña de la key

**⚠️ IMPORTANTE**: 
- Nunca commitees el archivo `key.properties` o el keystore al repositorio
- Los archivos ya están en `.gitignore`
- Para CI/CD, usa GitHub Secrets (ver [docs/CI_CD_SETUP.md](docs/CI_CD_SETUP.md))

**Documentación completa:** [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md)

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
