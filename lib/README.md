# Estructura del Proyecto Flutter - lib/

Este documento describe la arquitectura de carpetas bajo `lib/` siguiendo las mejores prácticas de Flutter para proyectos con Firebase y Stripe.

## 📁 Estructura de Carpetas

```
lib/
├── core/                           # Servicios base y configuración core
│   └── firebase_service.dart       # Inicialización de Firebase
├── features/                       # Funcionalidades agrupadas por dominio
│   ├── auth/                       # Autenticación
│   │   └── auth_service.dart       # Servicio de Firebase Auth
│   └── payments/                   # Pagos
│       └── stripe_service.dart     # Servicio de Stripe
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

## ✅ Checklist de Verificación

### 🔒 Seguridad Básica

- [ ] **Firebase**
  - [ ] `firebase_options.dart` generado con FlutterFire CLI (no manual)
  - [ ] Reglas de Firestore/Realtime Database configuradas restrictivamente
  - [ ] Security Rules probadas en emulador local
  - [ ] `google-services.json` y `GoogleService-Info.plist` en `.gitignore` (opcional)
  
- [ ] **Stripe**
  - [ ] Publishable Key obtenida de variables de entorno (`--dart-define`)
  - [ ] Secret Key NUNCA en código fuente o cliente
  - [ ] PaymentIntents creados SIEMPRE en backend
  - [ ] Webhooks configurados y firma verificada
  - [ ] Claves de test vs producción correctamente separadas

- [ ] **Autenticación**
  - [ ] Validación de email implementada
  - [ ] Requisitos de contraseña fuertes (mínimo 8 caracteres)
  - [ ] Verificación de email habilitada
  - [ ] Mensajes de error no revelan información sensible
  - [ ] Rate limiting configurado en backend
  - [ ] Sesiones tienen timeout apropiado

- [ ] **Datos Sensibles**
  - [ ] No hay credenciales hardcodeadas en código
  - [ ] `.env` y archivos de configuración en `.gitignore`
  - [ ] Secrets manejados via CI/CD secrets
  - [ ] Logs no exponen datos sensibles

### 📦 Integridad de Servicios

- [ ] **FirebaseService**
  - [ ] Patrón Singleton implementado correctamente
  - [ ] Manejo de errores de inicialización
  - [ ] Método `ensureInitialized()` disponible
  - [ ] No permite reinicialización accidental

- [ ] **AuthService**
  - [ ] Métodos de registro con validación
  - [ ] Métodos de login con manejo de errores
  - [ ] Método de signOut limpia datos locales
  - [ ] Stream de authStateChanges disponible
  - [ ] Recuperación de contraseña implementada

- [ ] **StripeService**
  - [ ] Validación de Publishable Key (no acepta Secret Key)
  - [ ] Métodos de pago retornan resultados tipados
  - [ ] Manejo de estados: success, failure, cancelled, requiresAction
  - [ ] Payment Sheet configurado correctamente

- [ ] **Models**
  - [ ] Factory `fromJson` maneja datos nulos/inválidos
  - [ ] Método `toJson` serializa correctamente
  - [ ] Validaciones en constructores
  - [ ] `copyWith` implementado para inmutabilidad
  - [ ] `equals` y `hashCode` si se usa en colecciones

### 🏗️ Arquitectura y Código

- [ ] **Organización**
  - [ ] Features separadas en sus propias carpetas
  - [ ] No hay imports circulares
  - [ ] Dependencias claras entre capas
  - [ ] Código común en `/core`

- [ ] **Calidad de Código**
  - [ ] Linter configurado y sin warnings
  - [ ] Documentación en clases públicas
  - [ ] Nombres descriptivos de variables y métodos
  - [ ] Sin código comentado innecesario (excepto TODOs válidos)

- [ ] **Testing**
  - [ ] Tests unitarios para servicios
  - [ ] Tests de integración para flujos críticos
  - [ ] Mocks para Firebase y Stripe en tests
  - [ ] Coverage mínimo definido

### 🚀 Preparación para Producción

- [ ] **Variables de Entorno**
  - [ ] Todas las keys configurables por entorno
  - [ ] Documentación de variables requeridas
  - [ ] Valores por defecto seguros

- [ ] **Logging y Monitoreo**
  - [ ] Crashlytics configurado
  - [ ] Analytics para eventos importantes
  - [ ] Logs estructurados (no `print` en producción)

- [ ] **Performance**
  - [ ] Inicializaciones lazy cuando sea posible
  - [ ] No hay llamadas síncronas bloqueantes
  - [ ] Imágenes y assets optimizados

---

## 🔗 Referencias Útiles

- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Stripe Flutter Documentation](https://stripe.com/docs/payments/accept-a-payment?platform=flutter)
- [Flutter Best Practices](https://dart.dev/guides/language/effective-dart)
- [Feature-First Architecture](https://codewithandrea.com/articles/flutter-project-structure/)

---

## 📝 Notas para el Desarrollador

1. **Antes de empezar**: Ejecuta `flutterfire configure` para generar `firebase_options.dart`
2. **Para pagos**: Implementa un backend seguro para crear PaymentIntents
3. **Testing**: Usa el emulador de Firebase para desarrollo local
4. **CI/CD**: Configura secrets en GitHub Actions para las keys
5. **Documentación**: Mantén este README actualizado con cambios de arquitectura

---

*Última actualización: Noviembre 2024*
