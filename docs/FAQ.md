# Preguntas Frecuentes (FAQ)

## 📋 Tabla de Contenidos

- [General](#-general)
- [Instalación y Setup](#-instalación-y-setup)
- [Uso de la Aplicación](#-uso-de-la-aplicación)
- [Estrategia Martingale](#-estrategia-martingale)
- [Predicciones](#-predicciones)
- [Problemas Técnicos](#-problemas-técnicos)
- [Desarrollo y Contribución](#-desarrollo-y-contribución)
- [Seguridad y Privacidad](#-seguridad-y-privacidad)

---

## 🎯 General

### ¿Qué es Tokyo Roulette Predicciones?

Es un **simulador educativo** de ruleta europea que incluye:
- Sistema de predicciones basado en historial
- Estrategia Martingale automatizada
- Balance virtual (sin dinero real)
- Interfaz moderna con Flutter

**Importante**: Es solo para fines educativos, NO para gambling real.

### ¿Es una app de gambling real?

**NO.** Esta es una aplicación completamente educativa:
- ❌ NO hay dinero real
- ❌ NO se pueden hacer apuestas reales
- ❌ NO hay integración con casinos
- ✅ Solo simulación con balance virtual

### ¿Es gratis?

Sí, el proyecto es open source con licencia MIT. Es completamente gratuito.

### ¿En qué plataformas funciona?

- ✅ Android
- ✅ iOS (configuración adicional requerida)
- ✅ Web
- ✅ Linux Desktop
- ⚠️ Windows/Mac (soporte futuro)

---

## 💾 Instalación y Setup

### ¿Qué necesito para instalar la app?

**Para usuarios**:
- Dispositivo Android 5.0+ o iOS 12+
- ~50MB de espacio libre
- Conexión a internet (opcional después de instalar)

**Para desarrolladores**:
- Flutter 3.0+
- Dart 3.0+
- Android Studio o VS Code
- JDK 11+

### ¿Cómo descargo la APK?

```bash
# Desde GitHub Releases
1. Ve a https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases
2. Descarga la última APK
3. Instala en tu dispositivo Android

# O construye desde código
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001
flutter pub get
flutter build apk --release
```

### La app no se instala en mi Android, ¿qué hago?

1. **Habilita "Instalar apps desconocidas"**:
   - Configuración → Seguridad → Fuentes desconocidas
   - O Configuración → Apps → Acceso especial → Instalar apps desconocidas

2. **Verifica espacio disponible**: Necesitas ~50MB

3. **Versión de Android**: Requiere Android 5.0+

### ¿Necesito Firebase configurado?

**No es obligatorio**. Firebase es opcional para:
- Remote Config (actualizaciones dinámicas)
- Analytics (estadísticas de uso)
- Cloud Firestore (almacenamiento de emails)

La app funciona sin Firebase en modo local.

Ver [FIREBASE_SETUP.md](FIREBASE_SETUP.md) para configuración completa.

---

## 🎮 Uso de la Aplicación

### ¿Cómo empiezo a jugar?

1. **Abre la app**
2. **Ingresa un email** (simulado, no se verifica)
3. **Presiona "Girar"** para comenzar
4. **Observa el resultado** y tu balance actualizado

### ¿De dónde sale mi balance inicial?

Recibes **$1000 virtuales** al iniciar. Este dinero:
- ❌ NO tiene valor real
- ❌ NO se puede convertir a dinero real
- ✅ Es solo para simulación

### ¿Puedo perder mi progreso?

Actualmente, el progreso **NO se guarda** entre sesiones. Al cerrar la app:
- Se resetea el balance a $1000
- Se borra el historial
- Se pierden las estadísticas

### ¿Cómo funciona el historial de giros?

La app guarda los **últimos 20 giros** y muestra:
- 🔴 Números rojos
- ⚫ Números negros
- 🟢 Cero (verde)

El historial se usa para generar predicciones simples.

### ¿Puedo cambiar mi apuesta?

La apuesta base es **$10** por defecto. Para cambiarla:
- Edita el código en `main.dart`
- Busca `currentBet = 10.0`
- Cambia a tu valor preferido

**Nota**: En futuras versiones habrá UI para esto.

---

## 🎲 Estrategia Martingale

### ¿Qué es Martingale?

Es una estrategia de apuestas donde:
- Después de **perder**: Duplicas tu apuesta
- Después de **ganar**: Vuelves a la apuesta base

**Objetivo**: Recuperar pérdidas + ganar la apuesta base.

### ¿Cómo activo Martingale?

1. Ve a Configuración (icono ⚙️)
2. Activa el toggle "Martingale"
3. Regresa y juega normalmente

La estrategia se aplicará automáticamente.

### ¿Martingale garantiza ganancias?

**NO.** Martingale tiene riesgos:
- 📈 Apuestas crecen exponencialmente
- 💸 Puedes quedarte sin balance
- 📊 Rachas largas de pérdidas son posibles
- 🚫 Casinos reales tienen límites de apuesta

**Esta es solo una demostración educativa.**

### ¿Cuál es la apuesta máxima?

La apuesta máxima es tu **balance actual**. Si Martingale intenta apostar más:
- Se apuesta todo el balance restante
- La estrategia se reinicia después

---

## 🔮 Predicciones

### ¿Cómo funcionan las predicciones?

Las predicciones son **simuladas y simples**:
1. Analiza los últimos giros
2. Identifica patrones básicos (más comunes, menos comunes)
3. Sugiere números basándose en frecuencia

**Importante**: Las predicciones NO tienen valor real en gambling.

### ¿Las predicciones realmente funcionan?

**NO para gambling real**. 

Cada giro de ruleta es **independiente** y **aleatorio**. No hay "memoria" ni patrones reales. Las predicciones son solo para:
- Demostración educativa
- Entender probabilidad
- Practicar programación

### ¿Puedo mejorar las predicciones?

Sí, puedes:
1. Fork el repositorio
2. Edita `roulette_logic.dart`
3. Implementa tu algoritmo
4. Testa y comparte

Acepta PRs con mejoras documentadas.

### ¿Puedo usar Machine Learning para predicciones?

**Técnicamente sí, pero es educacionalmente inútil** porque:
- La ruleta es **verdaderamente aleatoria** (RNG seguro)
- ML no puede predecir aleatoriedad pura
- Sería "overfitting" a ruido

Pero puedes intentarlo como ejercicio de ML. 🧠

---

## 🔧 Problemas Técnicos

### La app crashea al iniciar

**Soluciones**:

1. **Limpia y reinstala**:
```bash
flutter clean
flutter pub get
flutter run
```

2. **Verifica versiones**:
```bash
flutter doctor
```

3. **Revisa logs**:
```bash
flutter run --verbose
```

Ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para más detalles.

### "flutter: command not found"

Flutter no está en tu PATH. Solución:

```bash
# Mac/Linux
export PATH="$PATH:`pwd`/flutter/bin"

# O agrega a ~/.bashrc o ~/.zshrc
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### El build de Android falla

**Causas comunes**:

1. **JDK no instalado o versión incorrecta**:
```bash
java -version  # Debe ser 11+
```

2. **Gradle sync issues**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

3. **Keystore faltante** (solo en release):
   - Crea keystore o usa debug build
   - Ver [README.md](../README.md#configuración-de-keystore-para-android)

### Los tests fallan

```bash
# Limpiar y re-ejecutar
flutter clean
flutter pub get
flutter test

# Test específico
flutter test test/roulette_logic_test.dart --verbose
```

---

## 💻 Desarrollo y Contribución

### ¿Cómo contribuyo al proyecto?

1. **Fork** el repositorio
2. **Crea una rama**: `git checkout -b feature/MiFeature`
3. **Desarrolla** y prueba tus cambios
4. **Commit**: `git commit -m 'feat: Mi nueva feature'`
5. **Push**: `git push origin feature/MiFeature`
6. **Abre PR** en GitHub

Ver [CONTRIBUTING.md](../CONTRIBUTING.md) para detalles completos.

### ¿Qué puedo contribuir?

Ideas bienvenidas:
- 🐛 **Fixes de bugs**
- ✨ **Nuevas features**
- 📝 **Documentación**
- 🧪 **Tests**
- 🎨 **Mejoras de UI**
- 🌐 **Traducciones**

### ¿Necesito experiencia en Flutter?

No necesariamente:
- **Documentación**: No requiere código
- **Issues**: Reportar bugs ayuda
- **Testing**: Probar la app en diferentes dispositivos
- **Diseño**: Mockups y propuestas UI

Para código, conocimientos básicos de Dart/Flutter ayudan.

### ¿Cómo ejecuto los tests?

```bash
# Todos los tests
flutter test

# Solo unitarios
flutter test test/roulette_logic_test.dart

# Solo widgets
flutter test test/widget_test.dart

# Con coverage
flutter test --coverage
```

### ¿Cómo agrego una nueva feature?

1. **Abre un issue** discutiendo la feature
2. **Espera feedback** de maintainers
3. **Implementa** con tests
4. **Documenta** en código y docs
5. **Abre PR** con descripción completa

---

## 🔐 Seguridad y Privacidad

### ¿La app recolecta datos personales?

**No actualmente**. La app:
- ✅ NO recolecta datos personales
- ✅ NO requiere permisos invasivos
- ✅ NO envía datos a servidores
- ⚠️ El email ingresado es solo local (no se envía)

**Si se habilita Firebase** (opcional):
- Analytics puede recolectar datos anónimos de uso
- Puedes deshabilitarlo en configuración

### ¿Es seguro mi balance virtual?

El balance es **local** y **virtual**:
- Se almacena solo en tu dispositivo
- NO tiene valor monetario
- Se resetea al cerrar la app

### ¿Puedo usar esta app para gambling real?

**¡NO!** Esta app es:
- ❌ NO para gambling real
- ❌ NO conectada a casinos
- ❌ NO maneja dinero real
- ✅ Solo para educación

**Usar información de esta app para gambling real es bajo tu propio riesgo y responsabilidad.**

### ¿Dónde reporto vulnerabilidades de seguridad?

**NO abras un issue público.**

Envía email privado a: Thenewtokyocompany@gmail.com

Ver [SECURITY.md](../SECURITY.md) para proceso completo.

### ¿El RNG es realmente aleatorio?

Sí, usamos `Random.secure()` de Dart que:
- ✅ Es criptográficamente seguro
- ✅ Usa fuentes de entropía del OS
- ✅ NO es predecible
- ✅ NO usa semilla fija

Esto garantiza equidad en la simulación.

---

## 📞 Más Preguntas

### ¿No encuentras tu pregunta?

1. **Busca en Issues**: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
2. **Revisa Docs**: [docs/](../docs/)
3. **Abre un Issue**: [New Issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues/new)
4. **Email**: Thenewtokyocompany@gmail.com

### ¿Dónde está el roadmap?

Ver [README.md - Roadmap](../README.md#-roadmap-del-proyecto) para planes futuros.

### ¿Cómo me entero de nuevas versiones?

- ⭐ **Star el repositorio** en GitHub
- 👁️ **Watch** el repositorio para notificaciones
- 📰 **Revisa** [Releases](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/releases)
- 📧 **Suscríbete** a GitHub Discussions

---

**Última actualización**: Diciembre 2024  
**Mantenido por**: Tokyo Apps Team

**¿Tu pregunta no está aquí?**  
[Abre un issue](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues/new) o [discussion](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions) 💬
