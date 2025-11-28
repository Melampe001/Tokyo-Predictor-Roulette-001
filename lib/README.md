# 🎰 TokyoIA Roulette Predictor - Estructura del Proyecto

Este documento describe la arquitectura completa de la aplicación **TokyoIA Roulette Predictor**, un simulador/predictor probabilístico de ruleta (Europea/Americana) con modelo de suscripciones.

> ⚠️ **IMPORTANTE**: Esta app es un simulador educativo. NO predice resultados de casinos reales. Cumple con las políticas de Google Play Store.

---

## 📁 Estructura de Carpetas

```
lib/
├── core/                           # Servicios base y configuración core
│   └── firebase_service.dart       # Inicialización de Firebase
├── features/                       # Funcionalidades agrupadas por dominio
│   ├── auth/                       # Autenticación
│   │   └── auth_service.dart       # Servicio de Firebase Auth
│   ├── payments/                   # Pagos
│   │   └── stripe_service.dart     # Servicio de Stripe/Google Play Billing
│   ├── roulette/                   # Módulo de ruleta
│   │   ├── european_roulette.dart  # Ruleta Europea (0)
│   │   └── american_roulette.dart  # Ruleta Americana (00)
│   ├── strategies/                 # Estrategias de apuesta
│   │   ├── martingale.dart         # Estrategia Martingale
│   │   ├── fibonacci.dart          # Estrategia Fibonacci
│   │   ├── dalembert.dart          # Estrategia D'Alembert
│   │   └── anti_martingale.dart    # Estrategia Anti-Martingale (Paroli)
│   └── referrals/                  # Sistema de referidos
│       └── referral_service.dart   # Programa de referidos ético
├── models/                         # Modelos de datos/entidades
│   └── example_model.dart          # Modelo de ejemplo con fromJson
├── main.dart                       # Punto de entrada de la aplicación
├── roulette_logic.dart             # Lógica de ruleta existente
└── README.md                       # Este archivo
```

## 🗂️ Explicación de Cada Carpeta

### `/core`
Contiene servicios fundamentales que se usan en toda la aplicación:
- **Propósito**: Inicialización de Firebase, configuración de app, constantes globales
- **Cuándo usar**: Para código que no pertenece a ninguna feature específica
- **Ejemplos**: FirebaseService, ConfigService, AppConstants

### `/features`
Agrupa el código por funcionalidades de negocio (Feature-First Architecture):
- **Propósito**: Organizar código por dominio, no por tipo de archivo
- **Beneficios**: 
  - Fácil de escalar
  - Cada feature es autocontenida
  - Facilita trabajo en equipo
- **Estructura recomendada por feature**:
  ```
  features/auth/
  ├── auth_service.dart      # Lógica de negocio
  ├── auth_repository.dart   # Acceso a datos (opcional)
  ├── screens/               # Pantallas de la feature
  └── widgets/               # Widgets específicos
  ```

### `/models`
Modelos de datos y entidades de la aplicación:
- **Propósito**: Definir la estructura de datos
- **Cuándo usar**: Para clases que representan entidades de negocio
- **Contenido típico**: 
  - Factory `fromJson` para deserialización
  - Método `toJson` para serialización
  - Método `copyWith` para inmutabilidad

---

# ✅ CHECKLIST COMPLETO PARA APP "Predicción Ruleta – TokyoIA"

---

## 🧩 1. Definición del Proyecto

- [ ] Nombre de la app: TokyoIA Roulette Predictor
- [ ] Plataformas: Android (Play Store)
- [ ] Tipo de app: Predictor / simulador probabilístico (no gambling real)
- [ ] **Motores de Ruleta:**
  - [ ] Ruleta Americana (00)
  - [ ] Ruleta Europea (0)
- [ ] **Modelos probabilísticos:**
  - [ ] Martingale
  - [ ] Anti-Martingale
  - [ ] Fibonacci
  - [ ] D'Alembert
  - [ ] Labouchere
  - [ ] Parámetros ajustables por usuario
- [ ] RNG interno (pseudoaleatorio)
- [ ] Tablero y estadísticas en tiempo real

---

## 💰 2. Planes de Suscripción

### Free
- [ ] 1 predictor básico
- [ ] Resultados limitados
- [ ] No historial avanzado

### Advanced
- [ ] Pago mensual
- [ ] Pago 6 meses (-10% descuento)
- [ ] Pago 12 meses (-25% descuento)
- [ ] Estadísticas avanzadas
- [ ] Registro de sesiones
- [ ] Exportación CSV

### Premium (full unlock)
- [ ] Acceso a todos los módulos
- [ ] Predictores ilimitados
- [ ] RNG avanzado
- [ ] Soporte prioritario
- [ ] Funciones experimentales

---

## 🔐 3. Pagos e Integraciones

- [ ] Google Play Billing Library v6+
- [ ] **Configurar en Play Console:**
  - [ ] Productos de suscripción
  - [ ] Suscripción mensual
  - [ ] Suscripción 6 meses
  - [ ] Suscripción anual
  - [ ] Premium "full unlock"
  - [ ] Pruebas internas con testers
- [ ] Validación de recibos (server y en app)
- [ ] **Seguridad de transacciones:**
  - [ ] SHA-256 signing
  - [ ] Play Integrity API

---

## 📱 4. Requerimientos Técnicos Android

- [ ] Android Studio "Ladybug"
- [ ] SDK mínimo 23
- [ ] SDK target 34
- [ ] Java 17 / Kotlin 2.x
- [ ] Gradle actualizado
- [ ] **Firmas:**
  - [ ] Archivo keystore.jks creado y guardado
  - [ ] Contraseña guardada en GitHub Secrets (NO en código)
- [ ] **Permisos necesarios:**
  - [ ] INTERNET
  - [ ] QUERY_ALL_PACKAGES (solo si aplica y justificar)
  - [ ] BILLING vía Play Billing API
  - [ ] POST_NOTIFICATIONS si usas alertas

---

## 🏗 5. Arquitectura de la App

- [ ] Clean Architecture (Data – Domain – UI)
- [ ] **Data sources:**
  - [ ] RNG interno
  - [ ] Configuración del jugador
  - [ ] Módulo de pagos
  - [ ] API externa (si agregas)
- [ ] Cifrado local AES256 para datos sensibles
- [ ] Obfuscación con ProGuard / R8

---

## 🔢 6. Lógica de Predicción / Simulación

- [ ] Implementar RNG pseudoaleatorio (seed + entropy)
- [ ] **Parámetros:**
  - [ ] Probabilidad por número
  - [ ] Cálculo de Hot/Cold
  - [ ] Ventanas móviles (50, 100, 300 spins)
- [ ] **Algoritmos incluidos:**
  - [ ] Martingale
  - [ ] Fibonacci
  - [ ] D'Alembert
  - [ ] Secuencias personalizadas
- [ ] **Reportes:**
  - [ ] Heatmap
  - [ ] Frecuencias
  - [ ] Sesiones
  - [ ] Ganancias simuladas

> ⚠️ **NOTA**: Esto NO predice casinos reales, es simulación, como exige Play Store.

---

## 🎨 7. UI / UX

- [ ] Diseño Material 3
- [ ] Animaciones de ruleta
- [ ] Resultados en tiempo real
- [ ] Modo oscuro
- [ ] Pantalla de suscripciones
- [ ] Pantalla de estadísticas
- [ ] Historial

---

## 🔑 8. Seguridad

- [ ] API keys en local.properties (no en GitHub)
- [ ] Play Integrity API
- [ ] Firebase AppCheck (opcional)
- [ ] Cifrado de configuraciones
- [ ] Anti-debug tools
- [ ] Validación de firma de la app
- [ ] R8 + ProGuard configurado

---

## ☁️ 9. Backend Opcional

*(Solo si quieres servidor, no obligatorio)*

- [ ] Python / FastAPI
- [ ] **Endpoints:**
  - [ ] Validación de pagos
  - [ ] Registro de usuario
  - [ ] Estadísticas avanzadas
- [ ] **Base de datos:**
  - [ ] PostgreSQL o Supabase
- [ ] JWT tokens
- [ ] **Hosting:**
  - [ ] Render
  - [ ] Railway
  - [ ] Firebase Functions (alternativa)

---

## 🧪 10. Testing

- [ ] Unit tests (Kotlin/Dart)
- [ ] UI tests (Espresso / Flutter test)
- [ ] **Pruebas en Play Console:**
  - [ ] Closed testing
  - [ ] Internal testing
  - [ ] Production release

---

## 📦 11. Requisitos para Publicación en Play Store

- [ ] Paquete AAB (NO APK)
- [ ] Firma con Play App Signing activada
- [ ] App Bundle sin errores
- [ ] **Políticas de Play:**
  - [ ] No gambling real
  - [ ] "Simulación de juegos de azar"
  - [ ] RNG explicado en la descripción
  - [ ] Protección al usuario
- [ ] **Íconos:**
  - [ ] 512x512
  - [ ] 1024x500 banner
  - [ ] Capturas de pantalla
- [ ] Descripción completa
- [ ] Política de privacidad (URL en GitHub Pages)

---

## 📂 12. Repositorio GitHub (Checklist para Copilot)

- [ ] Carpeta /android o proyecto Flutter
- [ ] Carpeta /backend (si aplica)
- [ ] Archivo README.md con esta lista
- [ ] Archivo /docs/privacy-policy.md
- [ ] **GitHub Secrets configurados:**
  - [ ] KEYSTORE_PASSWORD
  - [ ] STORE_FILE
  - [ ] SIGNING_KEY_ALIAS
  - [ ] SIGNING_KEY_PASSWORD

---

## 🛠 13. Herramientas / Apps que debes instalar

- [ ] Android Studio
- [ ] Java 17
- [ ] Git
- [ ] GitHub Desktop (opcional)
- [ ] Python 3.11 (si usas backend)
- [ ] Node.js (si agregas dashboard)
- [ ] Postman
- [ ] Google Cloud CLI
- [ ] Firebase CLI
- [ ] Flutter SDK

---

## 🚀 14. Checklist Final Antes de Subir a Play Store

- [ ] Compilar AAB – release
- [ ] Firmado correcto
- [ ] Sin permisos no justificados
- [ ] Pruebas internas superadas
- [ ] Descripción lista
- [ ] Capturas subidas
- [ ] Precios configurados
- [ ] Suscripciones activas
- [ ] Protección anti-piratería
- [ ] Políticas aceptadas
- [ ] Enviar a revisión

---

## 🔗 Referencias Útiles

- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Stripe Flutter Documentation](https://stripe.com/docs/payments/accept-a-payment?platform=flutter)
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [Flutter Best Practices](https://dart.dev/guides/language/effective-dart)
- [Feature-First Architecture](https://codewithandrea.com/articles/flutter-project-structure/)
- [Play Store App Content Guidelines](https://support.google.com/googleplay/android-developer/answer/9859455)

---

## 📝 Notas para el Desarrollador

1. **Antes de empezar**: Ejecuta `flutterfire configure` para generar `firebase_options.dart`
2. **Para pagos**: Implementa un backend seguro para crear PaymentIntents o usa Google Play Billing
3. **Testing**: Usa el emulador de Firebase para desarrollo local
4. **CI/CD**: Configura secrets en GitHub Actions para las keys
5. **Documentación**: Mantén este README actualizado con cambios de arquitectura
6. **Play Store**: Asegúrate de cumplir todas las políticas de "Simulación de juegos de azar"

---

*Última actualización: Noviembre 2024*
