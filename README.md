# 🎰 Tokyo Roulette Predicciones

**Aplicación Android de simulación de ruleta con sistema de predicciones y modelo freemium**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-Open%20Source-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android-brightgreen.svg)](https://www.android.com/)

<div align="center">
  <img src="Screenshot_20251024-232812.Grok.png" width="200" />
  <img src="Screenshot_20251024-232835.Grok.png" width="200" />
  <img src="Screenshot_20251024-232847.Grok.png" width="200" />
</div>

## 📱 ¿Qué es Tokyo Roulette Predicciones?

Tokyo Roulette Predicciones es una aplicación móvil educativa que simula una ruleta de casino con un sistema inteligente de predicciones. Diseñada con un modelo freemium, ofrece diferentes niveles de funcionalidad para satisfacer las necesidades de todos los usuarios.

### ⚠️ Importante: Disclaimer

**Esta es una aplicación de simulación educativa.** No promueve apuestas reales ni garantiza resultados en casinos reales. Los algoritmos de predicción son demostrativos y no deben usarse para apuestas con dinero real.

## ✨ Características

### Funcionalidades Principales

- 🎲 **Simulador de Ruleta**: Ruleta europea completa (0-36) con colores auténticos
- 📊 **Historial de Giros**: Visualización de los últimos 10 resultados
- 🔮 **Sistema de Predicciones**: Algoritmos predictivos (disponible en planes premium)
- 💎 **Modelo Freemium**: Tres niveles de suscripción
- 📱 **Diseño Responsive**: Interfaz adaptable y moderna
- ⚙️ **Configuración**: Personalización de idioma y plataforma
- 📖 **Manual Integrado**: Guía de usuario incluida en la app

### Planes Disponibles

| Plan | Precio | Características |
|------|--------|-----------------|
| 🆓 **Básica** | Gratis | • Simulación de ruleta<br>• Historial básico (10 giros) |
| 💼 **Avanzada** | $199 MXN | • Todo lo de Básica<br>• Predicciones simples<br>• Historial extendido (50 giros)<br>• Estadísticas básicas |
| 👑 **Premium** | $299 MXN | • Todo lo de Avanzada<br>• Predicciones con IA<br>• Historial ilimitado<br>• Estadísticas completas<br>• Soporte prioritario |

## 🚀 Quick Start

### Para Usuarios (Solo quiero usar la app)

#### Opción 1: Descargar APK Pre-compilado
1. Ve a [Releases](../../releases)
2. Descarga el archivo `app-release.apk`
3. Instálalo en tu dispositivo Android
4. ¡Listo para usar!

#### Opción 2: Build desde GitHub Actions
1. Ve a la pestaña [Actions](../../actions)
2. Descarga el artifact del build más reciente
3. Instala el APK en tu dispositivo

### Para Desarrolladores (Quiero modificar/compilar)

#### Prerequisitos
- [Flutter SDK 3.0+](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) o [VS Code](https://code.visualstudio.com/)
- Java JDK 11+
- Git

#### Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en modo desarrollo
flutter run

# 4. O construir APK de producción
flutter build apk --release
```

#### Build Automático

**Linux/Mac:**
```bash
./build.sh
```

**Windows:**
```cmd
build.bat
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 📚 Documentación

- **[QUICKSTART.md](QUICKSTART.md)** - Guía rápida de inicio y comandos básicos
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Documentación técnica completa para desarrolladores
- **README.old.md** - Documentación de planificación original

## 🏗️ Estructura del Proyecto

```
Tokyo-Predictor-Roulette-001/
├── lib/
│   └── main.dart                  # Aplicación principal con todas las pantallas
├── test/
│   └── widget_test.dart           # Tests unitarios
├── android/                       # Configuración Android
│   ├── app/
│   │   ├── build.gradle          # Build config de la app
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/...        # Código nativo (MainActivity)
│   └── build.gradle              # Build config del proyecto
├── .github/
│   └── workflows/
│       └── flutter-build.yml     # CI/CD automático
├── assets/
│   └── images/                   # Recursos gráficos
├── pubspec.yaml                  # Dependencias y metadata
├── build.sh / build.bat          # Scripts de build
├── QUICKSTART.md                 # Guía rápida
├── DEVELOPMENT.md                # Documentación técnica
└── README.md                     # Este archivo
```

## 🛠️ Tecnologías Utilizadas

- **[Flutter](https://flutter.dev/)** - Framework de desarrollo multiplataforma
- **[Dart](https://dart.dev/)** - Lenguaje de programación
- **[Material Design](https://material.io/)** - Sistema de diseño
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)** - Almacenamiento local

### Dependencias Principales

```yaml
dependencies:
  flutter_stripe: ^10.0.0          # Integración de pagos (preparada)
  firebase_core: ^2.24.2           # Firebase (preparado)
  shared_preferences: ^2.2.2       # Storage local
  intl: ^0.18.1                    # Internacionalización
  device_info_plus: ^9.1.2         # Info del dispositivo
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Analizar código
flutter analyze

# Formatear código
flutter format .
```

## 🔄 CI/CD

El proyecto incluye GitHub Actions para build automático:

- ✅ Build en cada push a `main` y `develop`
- ✅ Análisis de código automático
- ✅ Tests automáticos
- ✅ Generación de APK y App Bundle
- ✅ Artifacts disponibles para descarga

## 🗺️ Roadmap

### Versión Actual (1.0.0) ✅
- [x] Interfaz de usuario completa
- [x] Simulador de ruleta funcional
- [x] Sistema de login
- [x] Sistema de planes
- [x] Predicciones básicas
- [x] Tests unitarios

### Próximas Versiones

#### v1.1.0
- [ ] Integración completa con Firebase
- [ ] Integración completa con Stripe
- [ ] Animaciones de giro de ruleta
- [ ] Notificaciones push

#### v1.2.0
- [ ] Estadísticas avanzadas
- [ ] Gráficos interactivos
- [ ] Modo oscuro
- [ ] Múltiples idiomas

#### v2.0.0
- [ ] Predicciones con IA/ML
- [ ] Sistema de logros
- [ ] Compartir resultados
- [ ] Versión iOS

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto es de código abierto para fines educativos.

## 👥 Autores

- **Melampe001** - *Creador original* - [@Melampe001](https://github.com/Melampe001)

## 📞 Soporte

¿Tienes preguntas o problemas?

- 📧 Abre un [Issue](../../issues)
- 📖 Consulta la [Documentación](DEVELOPMENT.md)
- 💬 Revisa las [Discusiones](../../discussions)

## 🙏 Agradecimientos

- Inspirado en sistemas de predicción de ruleta
- Diseñado con Material Design
- Construido con Flutter

---

<div align="center">

**⚠️ Recuerda: Esta es una aplicación educativa. Usa responsablemente. ⚠️**

Hecho con ❤️ por [Melampe001](https://github.com/Melampe001)

</div>
