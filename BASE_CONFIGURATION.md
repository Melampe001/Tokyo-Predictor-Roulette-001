# Configuración Base del Proyecto

Este documento describe la configuración base establecida para el proyecto Tokyo Roulette Predicciones, que sirve como plantilla para proyectos Flutter similares.

## 📋 Tabla de Contenidos

1. [Estructura de Configuración](#estructura-de-configuración)
2. [Configuración de Android](#configuración-de-android)
3. [Configuración del Editor](#configuración-del-editor)
4. [Configuración de Linting](#configuración-de-linting)
5. [Configuración de VS Code](#configuración-de-vs-code)
6. [Variables de Entorno](#variables-de-entorno)
7. [Guía de Uso](#guía-de-uso)

---

## Estructura de Configuración

### Archivos de Configuración Incluidos

```
proyecto/
├── .editorconfig                    # Configuración de formato para todos los editores
├── .gitignore                       # Archivos a ignorar en Git
├── .vscode/                         # Configuración específica de VS Code
│   ├── settings.json               # Ajustes del editor
│   ├── launch.json                 # Configuraciones de depuración
│   └── extensions.json             # Extensiones recomendadas
├── analysis_options.yaml            # Reglas de linting de Dart/Flutter
├── pubspec.yaml                     # Dependencias del proyecto
└── android/                         # Configuración de Android
    ├── build.gradle                 # Configuración de build root
    ├── settings.gradle              # Configuración de módulos
    ├── gradle.properties            # Propiedades de Gradle
    ├── gradle/wrapper/              # Gradle Wrapper
    │   └── gradle-wrapper.properties
    ├── LOCAL_PROPERTIES_SETUP.md    # Guía de configuración local
    └── app/
        ├── build.gradle             # Configuración de build del módulo app
        └── proguard-rules.pro       # Reglas de ofuscación

```

---

## Configuración de Android

### 1. Gradle Build System

#### android/build.gradle (Root)
- **Kotlin version**: 1.9.10
- **Gradle plugin**: 8.1.0
- **Google Services**: 4.4.0 (para Firebase)
- Repositorios: Google, Maven Central

#### android/app/build.gradle (Módulo App)
- **Namespace**: `com.example.tokyo_roulette_predicciones`
- **Min SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: Determinado por Flutter
- **Compile SDK**: Determinado por Flutter
- **Java version**: 1.8
- **MultiDex**: Habilitado

#### Características Configuradas
- ✅ Firma de APK con keystore (opcional via key.properties)
- ✅ Minificación y ofuscación con R8
- ✅ ProGuard rules para Flutter, Firebase y Stripe
- ✅ Soporte para Firebase (comentado por defecto)
- ✅ Configuración de debug y release builds
- ✅ MultiDex para apps grandes

### 2. Gradle Properties

#### android/gradle.properties
```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
android.useAndroidX=true
android.enableJetifier=true
android.enableR8.fullMode=true
```

**Beneficios**:
- Mejora el rendimiento de compilación
- Habilita compilación paralela
- Usa caché para acelerar builds
- Soporte completo de AndroidX

### 3. Gradle Wrapper

#### android/gradle/wrapper/gradle-wrapper.properties
- **Versión de Gradle**: 8.3
- Distribución completa (-all) para mejor soporte de IDE
- Validación de URL habilitada para seguridad

### 4. ProGuard Rules

Reglas preconfiguradas para:
- Flutter framework
- Firebase SDK
- Stripe SDK
- Kotlin standard library

---

## Configuración del Editor

### .editorconfig

Configuración universal para mantener consistencia de código entre diferentes editores (VS Code, IntelliJ, Android Studio, etc.).

#### Configuraciones por Tipo de Archivo

| Tipo | Indent | Max Line Length | Notas |
|------|--------|-----------------|-------|
| `.dart` | 2 espacios | 80 | Estándar de Flutter |
| `.yaml`, `.yml` | 2 espacios | - | Para pubspec y CI configs |
| `.json` | 2 espacios | - | Configs y datos |
| `.gradle` | 4 espacios | - | Build scripts |
| `.kt`, `.kts` | 4 espacios | 120 | Kotlin |
| `.xml` | 4 espacios | - | Android manifests |
| `.md` | - | off | Markdown docs |

#### Configuraciones Generales
- **Charset**: UTF-8
- **End of Line**: LF (Unix style)
- **Insert Final Newline**: true
- **Trim Trailing Whitespace**: true

---

## Configuración de Linting

### analysis_options.yaml

Configuración estricta de linting basada en `flutter_lints`.

#### Categorías de Reglas

**Error Rules** (Previenen bugs):
- `avoid_empty_else`
- `avoid_returning_null_for_future`
- `hash_and_equals`
- `no_duplicate_case_values`
- `unrelated_type_equality_checks`
- Y más...

**Style Rules** (Código limpio):
- `always_declare_return_types`
- `prefer_single_quotes`
- `prefer_const_constructors`
- `avoid_print` (usar logging en producción)
- `prefer_final_fields`
- Y más...

#### Exclusiones
- `**/*.g.dart` (archivos generados)
- `**/*.freezed.dart` (archivos de freezed)

#### Niveles de Severidad
- `todo`: info (permite TODOs temporales)
- `deprecated_member_use`: warning
- `deprecated_member_use_from_same_package`: ignore

---

## Configuración de VS Code

### .vscode/settings.json

#### Configuración de Editor
- **Format on Save**: Habilitado
- **Rulers**: 80 caracteres (estándar Dart)
- **Auto Fix on Save**: Habilitado
- **Auto Organize Imports**: Habilitado

#### Configuración de Dart
- **Line Length**: 80
- **Format on Type**: Habilitado
- **Tab Completion**: Solo snippets
- **Debug External Libraries**: Deshabilitado (mejor performance)

#### Exclusiones de Archivos
Oculta archivos de build y temporales:
- `.dart_tool/`
- `build/`
- `.flutter-plugins*`
- `.packages`

### .vscode/launch.json

Configuraciones de depuración preconfiguradas:

1. **Flutter: Run Debug**
   - Modo: debug
   - Con hot reload y debugging completo

2. **Flutter: Run Profile**
   - Modo: profile
   - Para análisis de performance

3. **Flutter: Run Release**
   - Modo: release
   - Optimizado, sin debug

4. **Flutter: Attach to Device**
   - Para conectar a proceso existente

### .vscode/extensions.json

Extensiones recomendadas:
- `dart-code.dart-code`: Dart language support
- `dart-code.flutter`: Flutter tools
- `editorconfig.editorconfig`: EditorConfig support
- `streetsidesoftware.code-spell-checker`: Spell checker
- `usernamehw.errorlens`: Inline error display
- `ryanluker.vscode-coverage-gutters`: Test coverage

---

## Variables de Entorno

### Para Desarrollo Local

#### Android SDK
```bash
# Linux/macOS
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Windows (PowerShell)
$env:ANDROID_HOME = "C:\Users\TuUsuario\AppData\Local\Android\Sdk"
```

#### Flutter SDK
```bash
# Linux/macOS
export FLUTTER_ROOT=$HOME/flutter
export PATH=$PATH:$FLUTTER_ROOT/bin

# Windows (PowerShell)
$env:FLUTTER_ROOT = "C:\flutter"
$env:PATH = "$env:FLUTTER_ROOT\bin;$env:PATH"
```

### Para CI/CD (GitHub Actions)

```yaml
env:
  FLUTTER_VERSION: '3.0.0'
  JAVA_VERSION: '11'
  
# Para firma de APK (usar GitHub Secrets)
secrets:
  ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
  KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
  KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
  KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
```

---

## Guía de Uso

### 🚀 Configuración Inicial

#### 1. Clonar el Repositorio
```bash
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
```

#### 2. Instalar Dependencias
```bash
flutter pub get
```

Este comando automáticamente:
- Descarga las dependencias de `pubspec.yaml`
- Genera el archivo `android/local.properties` con las rutas del SDK

#### 3. Verificar Configuración
```bash
flutter doctor -v
```

Debe mostrar:
- ✅ Flutter SDK instalado
- ✅ Android toolchain completo
- ✅ VS Code o Android Studio configurado

#### 4. Ejecutar en Modo Debug
```bash
flutter run
```

O desde VS Code: F5 o "Run > Start Debugging"

### 🔨 Compilación

#### Debug (Desarrollo)
```bash
flutter build apk --debug
```

#### Release (Producción)
```bash
# Sin firma (para testing)
flutter build apk --release

# Con firma (para distribución)
# Requiere android/key.properties configurado
flutter build apk --release
```

### 🧪 Testing

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/roulette_logic_test.dart

# Con cobertura
flutter test --coverage
```

### 🔍 Análisis de Código

```bash
# Análisis completo
flutter analyze

# Solo errores críticos
flutter analyze --fatal-infos

# Con formato
dart format --set-exit-if-changed lib/ test/
```

### 📦 Limpieza de Build

```bash
# Limpiar builds anteriores
flutter clean

# Limpiar y reinstalar dependencias
flutter clean && flutter pub get
```

---

## 🔐 Configuración de Firma (Opcional)

### Generar Keystore

```bash
keytool -genkey -v -keystore ~/tokyo-roulette-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias tokyo-roulette
```

### Crear key.properties

Crear archivo `android/key.properties`:

```properties
storePassword=TU_PASSWORD_DEL_KEYSTORE
keyPassword=TU_PASSWORD_DE_LA_KEY
keyAlias=tokyo-roulette
storeFile=/ruta/absoluta/al/tokyo-roulette-keystore.jks
```

⚠️ **IMPORTANTE**: Este archivo está en `.gitignore` y NUNCA debe commitearse.

### Para CI/CD

Usar GitHub Secrets y decodificar el keystore en el workflow:

```yaml
- name: Decode keystore
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
```

---

## 📚 Recursos Adicionales

### Documentación Oficial
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Android Developers](https://developer.android.com/)

### Guías del Proyecto
- [README.md](../README.md) - Guía principal
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Cómo contribuir
- [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - Arquitectura técnica
- [LOCAL_PROPERTIES_SETUP.md](LOCAL_PROPERTIES_SETUP.md) - Setup de local.properties

### Herramientas Recomendadas
- [Android Studio](https://developer.android.com/studio) - IDE oficial de Android
- [VS Code](https://code.visualstudio.com/) - Editor ligero
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview) - Debugging y profiling

---

## ✅ Checklist de Configuración

Usa este checklist para verificar que todo está configurado correctamente:

### Prerequisitos
- [ ] Flutter SDK instalado (3.0+)
- [ ] Dart SDK incluido con Flutter (3.0+)
- [ ] Android Studio o VS Code instalado
- [ ] JDK 11+ instalado
- [ ] Android SDK configurado

### Archivos de Configuración
- [x] `.editorconfig` creado
- [x] `.vscode/settings.json` creado
- [x] `.vscode/launch.json` creado
- [x] `.vscode/extensions.json` creado
- [x] `analysis_options.yaml` configurado
- [x] `android/build.gradle` (root) creado
- [x] `android/app/build.gradle` creado
- [x] `android/gradle.properties` creado
- [x] `android/settings.gradle` creado
- [x] `android/gradle/wrapper/gradle-wrapper.properties` creado
- [x] `android/app/proguard-rules.pro` creado

### Verificación
- [ ] `flutter doctor` pasa sin errores críticos
- [ ] `flutter pub get` ejecutado exitosamente
- [ ] `flutter analyze` no muestra errores
- [ ] `flutter test` todos los tests pasan
- [ ] `flutter run` ejecuta la app correctamente
- [ ] Build de debug funciona: `flutter build apk --debug`

### Opcional (Para Release)
- [ ] Keystore generado
- [ ] `android/key.properties` configurado
- [ ] Build de release funciona: `flutter build apk --release`
- [ ] APK firmado se genera correctamente

---

## 🎯 Beneficios de esta Configuración

### ✨ Consistencia
- Formato de código uniforme entre todos los desarrolladores
- Mismas reglas de linting para todo el equipo
- Configuración de IDE compartida

### 🚀 Productividad
- Format on save automático
- Organize imports automático
- Debugging preconfigurado
- Build optimizado con caché

### 🔒 Seguridad
- Archivos sensibles en .gitignore
- ProGuard para ofuscación
- Firma de APK configurada
- R8 full mode habilitado

### 📈 Mantenibilidad
- Código limpio con linting estricto
- Documentación completa
- Fácil onboarding de nuevos desarrolladores
- Tests automatizados

### 🔧 Escalabilidad
- Soporte para Firebase preconfigurado
- Stripe integración lista
- MultiDex habilitado
- Build paralelo optimizado

---

## 🤝 Contribuciones

Si encuentras formas de mejorar esta configuración base, por favor:

1. Abre un issue describiendo la mejora
2. Crea un PR con los cambios propuestos
3. Documenta los cambios en este archivo

---

## 📝 Licencia

Esta configuración es parte del proyecto Tokyo Roulette Predicciones, licenciado bajo MIT License.

---

**Última actualización**: Diciembre 2024  
**Versión del proyecto**: 1.0.0  
**Mantenido por**: Melampe001
