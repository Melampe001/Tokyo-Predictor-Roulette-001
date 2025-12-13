# 🎰 Tokyo Roulette Predicciones - Quick Start Guide

## Para Usuarios (Descargar APK)

### Opción 1: Descarga Directa
1. Ve a la página de **Releases** de este repositorio
2. Descarga el archivo `app-release.apk`
3. En tu dispositivo Android, permite instalación de fuentes desconocidas
4. Instala el APK

### Opción 2: Build desde GitHub Actions
1. Ve a la pestaña **Actions** en este repositorio
2. Encuentra el workflow "Flutter Build" más reciente
3. Descarga el artifact `app-release-apk`
4. Descomprime y instala el APK

## Para Desarrolladores (Build Local)

### Prerequisitos
- **Flutter SDK 3.0+** - [Instalar Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** o **VS Code** con extensión Flutter
- **Java JDK 11+** para builds Android
- **Git**

### Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# 2. Verificar Flutter
flutter doctor

# 3. Instalar dependencias
flutter pub get

# 4. Conectar dispositivo Android o iniciar emulador
flutter devices

# 5. Ejecutar en modo desarrollo
flutter run

# 6. O construir APK de producción
flutter build apk --release
```

### El APK estará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Características de la App

### ✅ Versión Actual (1.0.0)
- 🎲 Simulador de ruleta (0-36)
- 📊 Historial de últimos 10 giros
- 🎨 Colores auténticos (rojo, negro, verde)
- 📱 Diseño responsive
- 🆓 Plan básico gratuito
- 💎 Planes premium (Avanzada $199, Premium $299)
- 🔮 Sistema de predicciones (solo premium)
- ⚙️ Configuración de idioma y plataforma
- 📖 Manual de usuario integrado

### Planes Disponibles

| Plan | Precio | Características |
|------|--------|-----------------|
| **Básica** | Gratis | Simulación básica de ruleta |
| **Avanzada** | $199 MXN | Predicciones simples + historial extendido |
| **Premium** | $299 MXN | Predicciones IA + estadísticas + soporte |

## Solución de Problemas

### "Flutter command not found"
```bash
# Asegúrate de tener Flutter en tu PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

### "License error" al hacer build
```bash
# Acepta las licencias de Android
flutter doctor --android-licenses
```

### Dependencias no se instalan
```bash
# Limpia cache y reinstala
flutter clean
flutter pub get
```

## Estructura del Proyecto

```
tokyo_roulette_predicciones/
├── lib/
│   └── main.dart              # App principal (todas las pantallas)
├── test/
│   └── widget_test.dart       # Tests unitarios
├── android/                   # Configuración Android
├── .github/workflows/         # CI/CD
├── pubspec.yaml              # Dependencias
├── DEVELOPMENT.md            # Guía detallada de desarrollo
└── QUICKSTART.md             # Esta guía
```

## Comandos Útiles

```bash
# Ejecutar en desarrollo
flutter run

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
flutter format .

# Limpiar build
flutter clean

# Build APK release
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release

# Verificar dispositivos conectados
flutter devices

# Ver logs
flutter logs
```

## Desarrollo

### Agregar Nuevas Características
1. Edita `lib/main.dart`
2. Ejecuta `flutter analyze` para verificar errores
3. Prueba con `flutter run`
4. Crea tests en `test/`

### Hot Reload
Mientras ejecutas `flutter run`:
- Presiona `r` para hot reload (recargar cambios)
- Presiona `R` para hot restart (reiniciar app)
- Presiona `q` para salir

## Deployment

### Distribución Directa
```bash
flutter build apk --release
# Comparte: build/app/outputs/flutter-apk/app-release.apk
```

### Google Play Store
1. Crea keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Configura `android/key.properties`:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<ruta-al-keystore>
   ```

3. Build signed bundle:
   ```bash
   flutter build appbundle --release
   ```

4. Sube a Play Console: `build/app/outputs/bundle/release/app-release.aab`

## Notas Importantes

⚠️ **Disclaimer**: Esta es una aplicación de simulación educativa. No promueve apuestas reales ni garantiza resultados.

⚠️ **Privacidad**: La app solo guarda el email localmente. No se envía información a servidores externos en esta versión básica.

⚠️ **Pagos**: La integración con Stripe está preparada pero requiere configuración adicional para funcionar. Ver `DEVELOPMENT.md`.

## Recursos

- [Documentación Flutter](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Material Design](https://material.io/design)

## Soporte

¿Problemas o preguntas?
1. Revisa los [Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
2. Crea un nuevo issue si es necesario
3. Consulta `DEVELOPMENT.md` para más detalles técnicos

## Licencia

Proyecto de código abierto para fines educativos.

---

**¡Disfruta desarrollando! 🚀**
