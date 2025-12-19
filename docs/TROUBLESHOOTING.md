# Solución de Problemas (Troubleshooting)

Esta guía te ayudará a resolver problemas comunes al usar o desarrollar Tokyo Roulette.

## 📑 Tabla de Contenidos

- [Problemas de Instalación](#-problemas-de-instalación)
- [Problemas de Build](#-problemas-de-build)
- [Problemas de Ejecución](#-problemas-de-ejecución)
- [Problemas de Testing](#-problemas-de-testing)
- [Problemas de Firebase](#-problemas-de-firebase)
- [Problemas de UI](#-problemas-de-ui)
- [Problemas de Performance](#-problemas-de-performance)
- [Obtener Ayuda](#-obtener-ayuda)

---

## 🔧 Problemas de Instalación

### ❌ Error: "flutter: command not found"

**Causa**: Flutter no está en el PATH del sistema.

**Solución**:

```bash
# Verificar instalación de Flutter
which flutter

# Si no está instalado, descarga desde:
# https://docs.flutter.dev/get-started/install

# Agregar al PATH (Linux/Mac)
export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"

# Permanente: Agrega a ~/.bashrc o ~/.zshrc
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Windows: Agrega a Variables de Entorno
```

### ❌ Error: "flutter doctor" muestra errores

**Diagnóstico**:
```bash
flutter doctor -v
```

**Soluciones comunes**:

1. **Android toolchain - No Android SDK**:
```bash
# Instala Android Studio
# https://developer.android.com/studio

# Acepta licencias
flutter doctor --android-licenses
```

2. **cmdline-tools component is missing**:
```bash
# En Android Studio:
# Tools → SDK Manager → SDK Tools → 
# ✅ Android SDK Command-line Tools (latest)
```

3. **JDK no encontrado**:
```bash
# Instala OpenJDK 11
# Ubuntu/Debian
sudo apt-get install openjdk-11-jdk

# Mac
brew install openjdk@11

# Verifica
java -version
```

### ❌ Error: "pub get failed"

**Causa**: Problemas de red o dependencias.

**Solución**:

```bash
# Limpiar caché
flutter pub cache repair

# Retry
flutter pub get

# Si persiste, verifica pubspec.yaml
flutter pub outdated

# Actualizar dependencias
flutter pub upgrade
```

---

## 🏗️ Problemas de Build

### ❌ Error: "Gradle build failed"

**Solución 1: Limpiar proyecto**

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Solución 2: Verificar versión de Gradle**

```gradle
// android/gradle/wrapper/gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

**Solución 3: Sincronizar Gradle**

```bash
cd android
./gradlew --refresh-dependencies
cd ..
```

### ❌ Error: "JAVA_HOME not set"

**Solución**:

```bash
# Encontrar ruta de Java
# Linux/Mac
which java
/usr/libexec/java_home -V  # Mac

# Establecer JAVA_HOME
export JAVA_HOME=/path/to/java

# Permanente (Linux/Mac)
echo 'export JAVA_HOME=/path/to/java' >> ~/.bashrc
source ~/.bashrc

# Windows
# System Properties → Environment Variables → 
# New → JAVA_HOME = C:\Program Files\Java\jdk-11
```

### ❌ Error: "Execution failed for task ':app:lintVitalRelease'"

**Solución**:

```gradle
// android/app/build.gradle
android {
    lintOptions {
        checkReleaseBuilds false
        // O específicamente:
        abortOnError false
    }
}
```

### ❌ Error: "Keystore file not found" (Release build)

**Causa**: Faltan credenciales de firma.

**Solución para desarrollo**:

```bash
# Usar debug build
flutter build apk --debug

# O crear keystore
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

Ver [README.md - Keystore](../README.md#configuración-de-keystore-para-android).

### ❌ Error: "Out of memory" durante build

**Solución**:

```gradle
// android/gradle.properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
```

---

## 🚀 Problemas de Ejecución

### ❌ La app crashea al iniciar

**Diagnóstico**:

```bash
# Ejecutar con logs detallados
flutter run --verbose

# Ver logs de Android
adb logcat | grep Flutter
```

**Soluciones**:

1. **Limpiar y reconstruir**:
```bash
flutter clean
flutter pub get
flutter run
```

2. **Verificar dependencias**:
```yaml
# pubspec.yaml - Asegura versiones compatibles
dependencies:
  flutter:
    sdk: flutter
  # Otras dependencias actualizadas
```

3. **Hot restart** (si ya está corriendo):
```bash
# En terminal de flutter run
R  # Hot restart completo
```

### ❌ Error: "Waiting for another flutter command to release the startup lock"

**Causa**: Proceso de Flutter colgado.

**Solución**:

```bash
# Matar procesos de Flutter
pkill -f flutter

# Eliminar lockfile
rm [FLUTTER_DIRECTORY]/bin/cache/lockfile

# Reintentar
flutter run
```

### ❌ Hot reload no funciona

**Solución**:

```bash
# Hot restart completo
R  # En terminal de flutter run

# O detener y reiniciar
q  # Quit
flutter run
```

### ❌ La app se ve diferente en dispositivo vs emulador

**Causa**: Diferencias de densidad de pantalla o versión de Android.

**Diagnóstico**:
```bash
# Info del dispositivo
flutter devices

# Ejecutar en dispositivo específico
flutter run -d [device-id]
```

**Solución**: Prueba responsive design en múltiples dispositivos.

---

## 🧪 Problemas de Testing

### ❌ Tests fallan con "No tests found"

**Causa**: Estructura de tests incorrecta.

**Solución**:

```dart
// Asegura que test tenga esta estructura
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('descripción del test', () {
    expect(actual, equals(expected));
  });
}
```

### ❌ Widget tests fallan con "Null check operator used on a null value"

**Causa**: Falta inicialización de binding de testing.

**Solución**:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mi test', (WidgetTester tester) async {
    // Inicializar binding si es necesario
    TestWidgetsFlutterBinding.ensureInitialized();
    
    await tester.pumpWidget(MyApp());
    // ...
  });
}
```

### ❌ Coverage no se genera

**Solución**:

```bash
# Instalar lcov (si falta)
# Ubuntu
sudo apt-get install lcov

# Mac
brew install lcov

# Generar coverage
flutter test --coverage

# Verificar archivo generado
ls -la coverage/lcov.info
```

---

## 🔥 Problemas de Firebase

### ❌ Error: "com.google.firebase:firebase-core not found"

**Solución**:

```bash
# Actualizar google-services
# android/build.gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}

# Limpiar y rebuild
flutter clean
flutter pub get
```

### ❌ Error: "google-services.json is missing"

**Causa**: Configuración de Firebase incompleta.

**Solución**:

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Descarga `google-services.json`
3. Coloca en `android/app/`
4. Verifica `android/app/build.gradle` tiene:
```gradle
apply plugin: 'com.google.gms.google-services'
```

Ver [FIREBASE_SETUP.md](FIREBASE_SETUP.md) para configuración completa.

### ❌ Firebase no inicializa

**Diagnóstico**:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('✅ Firebase inicializado');
  } catch (e) {
    print('❌ Error Firebase: $e');
  }
  runApp(MyApp());
}
```

---

## 🎨 Problemas de UI

### ❌ Overflow errors (yellow/black stripes)

**Causa**: Widget más grande que espacio disponible.

**Solución**:

```dart
// Usar Expanded o Flexible
Column(
  children: [
    Expanded(  // ← Agrega esto
      child: ListView(...),
    ),
  ],
)

// O usar SingleChildScrollView
SingleChildScrollView(
  child: Column(children: [...]),
)
```

### ❌ "RenderBox was not laid out"

**Causa**: Widget sin constraints definidos.

**Solución**:

```dart
// Agrega SizedBox con dimensiones
SizedBox(
  width: 100,
  height: 100,
  child: MyWidget(),
)

// O usa LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    return Container(
      width: constraints.maxWidth,
      child: MyWidget(),
    );
  },
)
```

### ❌ Texto se corta o desborda

**Solución**:

```dart
Text(
  'Texto largo...',
  overflow: TextOverflow.ellipsis,  // ← Agrega esto
  maxLines: 2,
)

// O usa FittedBox
FittedBox(
  child: Text('Texto largo...'),
)
```

---

## ⚡ Problemas de Performance

### ❌ App lenta o con lag

**Diagnóstico**:

```bash
# Ejecutar con performance overlay
flutter run --profile --trace-skia

# O usar Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**Soluciones**:

1. **Evitar rebuild innecesarios**:
```dart
// Usar const widgets cuando sea posible
const Text('Static text');

// Extraer widgets a const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  // ...
}
```

2. **Optimizar listas largas**:
```dart
// Usar ListView.builder en lugar de ListView
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)
```

3. **Profile mode para testing**:
```bash
flutter run --profile
```

### ❌ Memoria creciente

**Causa**: Memory leaks.

**Diagnóstico**:
- Usa Flutter DevTools Memory tab
- Busca objetos que no se liberan

**Solución**:
```dart
// Disponer controllers y listeners
@override
void dispose() {
  myController.dispose();
  myStream.cancel();
  super.dispose();
}
```

---

## 📞 Obtener Ayuda

### Stack Trace no es claro

**Obtener más información**:

```bash
# Run con verbose
flutter run --verbose

# Android logs
adb logcat | grep "flutter\|dart"

# Logs específicos de crash
flutter logs
```

### Reportar un Bug

Si ninguna solución funciona:

1. **Revisa Issues existentes**: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

2. **Abre nuevo Issue** con:
   - Título descriptivo
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Stack trace completo
   - Versiones:
   ```bash
   flutter doctor -v
   ```
   - Screenshots si es UI

3. **Template de Issue**:
```markdown
**Descripción del problema:**
[Describe el problema]

**Pasos para reproducir:**
1. Abre la app
2. Ve a ...
3. Click en ...
4. Observa el error

**Comportamiento esperado:**
[Qué debería suceder]

**Comportamiento actual:**
[Qué sucede realmente]

**Screenshots:**
[Si aplica]

**Entorno:**
- Dispositivo: [Samsung Galaxy S21]
- OS: [Android 13]
- Flutter: [Output de flutter --version]
- Versión de la app: [1.0.0]

**Stack trace:**
```
[Pega stack trace aquí]
```
```

### Contacto Directo

- 📧 **Email**: Thenewtokyocompany@gmail.com
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

---

## 🔧 Comandos de Diagnóstico Útiles

```bash
# Información completa del entorno
flutter doctor -v

# Listar dispositivos disponibles
flutter devices

# Limpiar todo
flutter clean
cd android && ./gradlew clean && cd ..

# Ver logs en tiempo real
flutter logs

# Analizar código
flutter analyze

# Ver dependencias
flutter pub deps

# Verificar actualizaciones
flutter pub outdated

# Ejecutar tests con detalles
flutter test --verbose

# Build con logs
flutter build apk --verbose
```

---

## 📚 Recursos Adicionales

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Debugging](https://docs.flutter.dev/testing/debugging)
- [Common Flutter Errors](https://docs.flutter.dev/testing/common-errors)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Community](https://flutter.dev/community)

---

**¿Tu problema no está listado?**  
[Abre un issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues/new) con detalles completos.

**Última actualización**: Diciembre 2024  
**Mantenido por**: Tokyo Apps Team
