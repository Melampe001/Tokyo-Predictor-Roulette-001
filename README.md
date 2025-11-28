# Tokyo Predictor Roulette

<p align="center">
  <img src="assets/images/icon.png" alt="Tokyo Predictor Roulette" width="120"/>
</p>

<p align="center">
  <strong>Simulador Educativo de Ruleta por TokyoApps/TokRaggcorp</strong>
</p>

<p align="center">
  <a href="#características">Características</a> •
  <a href="#instalación">Instalación</a> •
  <a href="#compilación">Compilación</a> •
  <a href="#pruebas-qa">Pruebas QA</a> •
  <a href="#release">Release</a> •
  <a href="#contacto">Contacto</a>
</p>

---

## Información de la App

| Campo | Valor |
|-------|-------|
| **Nombre de la App** | Tokyo Predictor Roulette |
| **Package** | `com.tokraggcorp.tokyopredictorroulett` |
| **Desarrollador** | TokyoApps/TokRaggcorp |
| **Correo de Soporte** | tokraagcorp@gmail.com |
| **Versión** | 1.0.0 |

## Descripción

Tokyo Predictor Roulette es un **simulador educativo** de ruleta con predicciones, RNG seguro, asesor de estrategia Martingale y modelo freemium. Incluye integración con Stripe para pagos y Firebase para configuraciones remotas.

⚠️ **AVISO LEGAL**: Esta es una **aplicación de simulación y educativa ÚNICAMENTE**. NO promueve el juego real. No se involucra dinero real.

## Características

- 🎰 **Simulación de Ruleta Europea** - Simulación auténtica de rueda 0-36
- 🔮 **Sistema de Predicción** - Predicción educativa basada en historial
- 📊 **Asesor de Estrategia Martingale** - Aprende estrategias de apuestas
- 🔐 **RNG Seguro** - Generación de números aleatorios criptográficamente seguros
- 💳 **Modelo Freemium** - Integración con Stripe para funciones premium
- 🔥 **Backend Firebase** - Configuración remota y analíticas
- 📱 **Soporte Multi-idioma** - Listo para internacionalización

## Instalación

### Requisitos Previos

- Flutter SDK 3.0.0 o superior
- Dart SDK
- Android Studio / VS Code
- JDK 17 o superior

### Configuración

```bash
# Clonar el repositorio
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# Obtener dependencias
flutter pub get

# Ejecutar la app (desarrollo)
flutter run
```

## Compilación

### APK de Depuración

```bash
flutter build apk --debug
```

### APK de Release

```bash
flutter build apk --release
```

### App Bundle (Play Store)

```bash
flutter build appbundle --release
```

### Archivos de Salida

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

## Configuración del Keystore

Para firmar builds de release, configura tu keystore:

### Opción 1: key.properties (Desarrollo Local)

Crear `android/key.properties`:

```properties
storeFile=/ruta/a/tu/keystore.jks
storePassword=tu_password_del_keystore
keyAlias=tu_alias_de_clave
keyPassword=tu_password_de_clave
```

### Opción 2: Variables de Entorno (CI/CD)

Configura los siguientes secretos en GitHub Actions:

| Secreto | Descripción |
|---------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Archivo keystore codificado en Base64 |
| `KEYSTORE_PASSWORD` | Contraseña del keystore |
| `KEY_ALIAS` | Alias de la clave |
| `KEY_PASSWORD` | Contraseña de la clave |

⚠️ **SEGURIDAD**: Nunca subas `key.properties` o archivos keystore al repositorio.

## Pruebas QA

### Ejecutar Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura
flutter test --coverage

# Ejecutar archivo de prueba específico
flutter test test/widget_test.dart
```

### Análisis de Código

```bash
# Analizar código
flutter analyze

# Formatear código
dart format lib/ test/
```

### Lista de Verificación QA Manual

- [ ] La app inicia sin fallos
- [ ] El flujo de login/registro funciona
- [ ] El giro de ruleta genera números válidos (0-36)
- [ ] El seguimiento del historial es preciso
- [ ] Los elementos de UI son responsivos
- [ ] No hay credenciales hardcodeadas en logs
- [ ] Las peticiones de red usan HTTPS

## CI/CD

El repositorio incluye workflows automatizados:

| Workflow | Archivo | Propósito |
|----------|---------|-----------|
| **Pipeline CI** | `.github/workflows/ci.yml` | Test, Lint, Build APK/AAB |
| **Build APK** | `.github/workflows/build-apk.yml` | Compilar APK de release |

### Jobs del Pipeline CI

1. **Analizar & Lint** - Análisis de código y verificación de formato
2. **Ejecutar Pruebas** - Pruebas unitarias y de widgets con cobertura
3. **Build APK Release** - Generar APK firmada
4. **Build AAB Release** - Generar App Bundle para Play Store

## Proceso de Release

### Lista de Verificación Pre-Release

- [ ] Todas las pruebas pasando
- [ ] Revisión de código completada
- [ ] Versión actualizada en `pubspec.yaml`
- [ ] Changelog actualizado
- [ ] Política de privacidad revisada
- [ ] Screenshots actualizados
- [ ] Listado de tienda actualizado

### Envío a Play Store

1. Generar AAB firmado: `flutter build appbundle --release`
2. Subir a Google Play Console
3. Completar listado de tienda con screenshots
4. Enviar para revisión

### Assets Requeridos para Play Store

- Gráfico destacado (1024x500)
- Screenshots (teléfono + tablet)
- Icono de app (512x512)
- URL de política de privacidad
- Cuestionario de clasificación de contenido

## Estructura del Proyecto

```
tokyo-predictor-roulette/
├── android/                    # Código de plataforma Android
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml
├── assets/                     # Assets de la app
│   └── images/                 # Iconos y pantalla splash
├── docs/                       # Documentación
│   └── hojas-menbretadas-tokyo/  # Papelería oficial
├── lib/                        # Código fuente Dart
│   ├── main.dart              # Punto de entrada de la app
│   └── roulette_logic.dart    # Lógica del juego de ruleta
├── test/                       # Archivos de prueba
├── .github/workflows/          # Workflows CI/CD
├── privacy-policy.md           # Política de privacidad
├── SECURITY.md                 # Política de seguridad
├── pubspec.yaml               # Dependencias
└── README.md                  # Este archivo
```

## Documentación

| Documento | Descripción |
|-----------|-------------|
| [Política de Privacidad](privacy-policy.md) | Política de recopilación y uso de datos |
| [Política de Seguridad](SECURITY.md) | Guías de seguridad y reporte de vulnerabilidades |
| [Papelería](docs/hojas-menbretadas-tokyo/) | Papelería oficial de la marca |

## Contacto

**Desarrollador**: TokyoApps/TokRaggcorp  
**Correo de Soporte**: tokraagcorp@gmail.com  
**Package**: com.tokraggcorp.tokyopredictorroulett

Para reportes de bugs, solicitudes de funciones o problemas de seguridad:
- 📧 Email: tokraagcorp@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

## Licencia

© 2024 TokyoApps/TokRaggcorp. Todos los derechos reservados.

---

## Fases de Desarrollo

### ✅ Fase 1: Definición y Planificación
- [x] Alcance y objetivos del proyecto definidos
- [x] Requerimientos y entregables identificados
- [x] Roadmap con hitos creado
- [x] Asignaciones de tareas completadas

### ✅ Fase 2: Diseño Técnico y Documentación
- [x] Documentación técnica (arquitectura, flujo, APIs)
- [x] Dependencias y recursos revisados
- [x] Diseño validado y feedback recibido

### ✅ Fase 3: Desarrollo Incremental
- [x] Funcionalidades implementadas según roadmap
- [x] Revisiones de código y PRs siguiendo checklist
- [x] Documentación actualizada con cambios

### ✅ Fase 4: Pruebas
- [x] Pruebas unitarias y funcionales ejecutadas
- [x] Requerimientos y criterios de aceptación validados
- [x] Bugs detectados y corregidos

### ✅ Fase 5: Despliegue y Release
- [x] Ambiente de release preparado
- [x] Lecciones aprendidas documentadas
- [x] Entregables presentados y fase cerrada
