# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## 🎰 Características

- **Simulación de ruleta europea** (0-36) con RNG seguro
- **Sistema de predicciones** basado en historial de giros
- **Asesor Martingale** para gestión de apuestas
- **Estadísticas en tiempo real** (balance, victorias, pérdidas)
- **Interfaz moderna** con Material Design
- **Autenticación** (preparada para Firebase Auth)
- **Sistema de pagos** (preparado para Stripe)
- **Pruebas completas** unitarias y de widgets
- **CI/CD** con GitHub Actions

## 📱 Capturas de pantalla

Ver imágenes en la raíz del proyecto.

## 🚀 Instalación

### Requisitos previos
- Flutter SDK 3.0.0 o superior
- Dart SDK
- Android Studio / Xcode (para compilación móvil)

### Pasos de instalación

1. **Clonar el repositorio:**
```bash
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Ejecutar la aplicación:**
```bash
flutter run
```

## 🏗️ Construir APK

### Compilar APK para Android

```bash
flutter build apk --release
```

La APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

### Compilar para otras plataformas

```bash
# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🧪 Pruebas

### Ejecutar todas las pruebas

```bash
flutter test
```

### Ejecutar pruebas con cobertura

```bash
flutter test --coverage
```

### Ejecutar pruebas específicas

```bash
# Pruebas de lógica de ruleta
flutter test test/roulette_logic_test.dart

# Pruebas de widgets
flutter test test/widget_test.dart
```

## 🔧 Desarrollo

### Análisis de código

```bash
flutter analyze
```

### Formato de código

```bash
dart format .
```

### Comandos útiles

```bash
# Limpiar builds previos
flutter clean

# Ver dispositivos disponibles
flutter devices

# Ejecutar en modo debug con hot reload
flutter run

# Ejecutar en modo profile
flutter run --profile

# Ejecutar en modo release
flutter run --release
```

## 📚 Documentación

- [**Configuración de Firebase**](docs/FIREBASE_SETUP.md) - Guía completa para configurar Firebase
- [**Configuración de Stripe**](docs/STRIPE_SETUP.md) - Guía completa para integrar pagos
- [**API Documentation**](docs/API.md) - Documentación de clases y métodos
- [**Checklist de Agentes**](docs/checklist_agents.md) - Guía de CI/CD y agentes

## 🏗️ Arquitectura

### Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada, LoginScreen y MainScreen
└── roulette_logic.dart      # Lógica de ruleta y Martingale

test/
├── widget_test.dart         # Pruebas de widgets
└── roulette_logic_test.dart # Pruebas de lógica

docs/
├── API.md                   # Documentación de API
├── FIREBASE_SETUP.md        # Guía de Firebase
├── STRIPE_SETUP.md          # Guía de Stripe
└── checklist_agents.md      # Checklist de CI/CD

.github/
├── workflows/
│   ├── build-apk.yml        # CI/CD para builds y tests
│   └── README_AZURE.md      # Nota sobre workflow Azure
├── PULL_REQUEST_TEMPLATE.md
└── checklist.md
```

### Clases principales

- **`RouletteLogic`**: Genera giros aleatorios y predicciones
- **`MartingaleAdvisor`**: Calcula apuestas según estrategia Martingale
- **`LoginScreen`**: Pantalla de autenticación con validación
- **`MainScreen`**: Pantalla principal del juego con todas las características

## 🔐 Seguridad

⚠️ **IMPORTANTE**: Este proyecto implementa buenas prácticas de seguridad:

- ✅ RNG seguro (`Random.secure()`) para generación de números
- ✅ NO hardcodea claves API en el código
- ✅ Usa variables de entorno para configuración
- ✅ Las claves secretas deben estar en el backend (Firebase Functions)
- ✅ Validación de entrada en formularios
- ✅ Manejo seguro de estados y sesiones

Ver [FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) y [STRIPE_SETUP.md](docs/STRIPE_SETUP.md) para detalles sobre seguridad.

## 📋 Roadmap

- [x] **Fase 1**: Simulación básica de ruleta
- [x] **Fase 2**: Sistema de predicciones
- [x] **Fase 3**: Integración de Martingale
- [x] **Fase 4**: Interfaz completa con estadísticas
- [x] **Fase 5**: Tests unitarios y de widgets
- [x] **Fase 6**: Documentación completa
- [x] **Fase 7**: CI/CD con GitHub Actions
- [ ] **Fase 8**: Integración con Firebase (Auth, Firestore, Remote Config)
- [ ] **Fase 9**: Integración con Stripe (pagos premium)
- [ ] **Fase 10**: Notificaciones push
- [ ] **Fase 11**: Modo multijugador
- [ ] **Fase 12**: Gráficos avanzados con fl_chart

## 🔑 Configuración de Keystore para Android

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

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

Ver [PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md) para el checklist completo.

## 📄 Licencia

Este proyecto es un simulador educativo. No promueve el juego real.

## ⚠️ Disclaimer

**DISCLAIMER**: Esto es solo un simulador educativo con fines de aprendizaje sobre:
- Desarrollo de aplicaciones Flutter
- Integración con servicios en la nube
- Implementación de algoritmos de predicción
- Gestión de estado y UI

Este proyecto **NO promueve el juego real ni las apuestas**. Las predicciones son ilustrativas y no funcionan en ruletas reales, ya que cada giro es matemáticamente independiente.

La estrategia Martingale tiene riesgos significativos en juegos reales y puede llevar a pérdidas considerables. Este proyecto es solo para educación.

## 📞 Contacto

- **Repositorio**: [Tokyo-Predictor-Roulette-001](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001)
- **Issues**: [Reportar un problema](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

---

Hecho con ❤️ usando Flutter
