# Pendientes para Finalizar la App - Tokyo Roulette Predicciones

## 📋 Resumen Ejecutivo

Esta aplicación de Flutter está en una fase avanzada de desarrollo, pero requiere completar varios componentes críticos antes de considerarse lista para producción. Este documento detalla todos los pendientes organizados por prioridad y área funcional.

---

## 🔴 PRIORIDAD ALTA - Funcionalidades Core Faltantes

### 1. Configuración de Firebase
**Estado:** ❌ No configurado  
**Ubicación:** `lib/main.dart` líneas 7-14  
**Descripción:** Firebase no está inicializado en la aplicación.

**Tareas específicas:**
- [ ] Ejecutar `flutterfire configure` para generar `firebase_options.dart`
- [ ] Crear proyecto Firebase en Firebase Console
- [ ] Configurar Firebase para Android (agregar google-services.json)
- [ ] Configurar Firebase para iOS (agregar GoogleService-Info.plist)
- [ ] Descomentar código de inicialización en `main.dart`:
  ```dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ```
- [ ] Configurar Firebase Remote Config para actualizaciones dinámicas
- [ ] Configurar Cloud Firestore para almacenar emails
- [ ] Configurar Firebase Authentication
- [ ] Configurar Firebase Messaging para notificaciones

**Impacto:** CRÍTICO - Sin Firebase, no funcionan: auth, almacenamiento de emails, notificaciones, ni configuraciones remotas.

---

### 2. Integración de Stripe
**Estado:** ❌ No configurado  
**Ubicación:** `lib/main.dart` líneas 16-21  
**Descripción:** Stripe no está configurado para el modelo freemium.

**Tareas específicas:**
- [ ] Crear cuenta Stripe y obtener claves API
- [ ] Configurar variable de entorno `STRIPE_PUBLISHABLE_KEY`
- [ ] Descomentar código de inicialización de Stripe en `main.dart`
- [ ] Implementar pantalla de planes de suscripción (Free vs Premium)
- [ ] Crear lógica de verificación de suscripción activa
- [ ] Implementar flujo de pago con Stripe
- [ ] Configurar webhooks de Stripe para eventos de pago
- [ ] Implementar manejo de errores de pago
- [ ] Agregar restauración de compras (para in-app purchases)

**Impacto:** CRÍTICO - Sin esto, el modelo de negocio freemium no funciona.

---

### 3. Sistema de Autenticación
**Estado:** ⚠️ Parcialmente implementado  
**Ubicación:** `lib/main.dart` línea 63  
**Descripción:** Existe UI de login pero no hay lógica de autenticación.

**Tareas específicas:**
- [ ] Implementar registro con Firebase Auth (email/password)
- [ ] Implementar login con email
- [ ] Agregar validación de email
- [ ] Implementar recuperación de contraseña
- [ ] Guardar estado de autenticación con `shared_preferences`
- [ ] Implementar logout
- [ ] Agregar verificación de email
- [ ] Opcional: Agregar autenticación con Google/Apple

**Impacto:** ALTO - Necesario para identificar usuarios y gestionar suscripciones.

---

### 4. Sistema de Predicciones y Estrategia Martingale
**Estado:** ⚠️ Parcialmente implementado  
**Ubicación:** `lib/main.dart` línea 114, `lib/roulette_logic.dart`  
**Descripción:** Existe lógica base pero no está integrada en la UI.

**Tareas específicas:**
- [ ] Agregar widget de visualización de predicciones en MainScreen
- [ ] Integrar `RouletteLogic.predictNext()` en la UI
- [ ] Mostrar predicción antes del giro
- [ ] Agregar widget para estrategia Martingale
- [ ] Integrar `MartingaleAdvisor` en la UI
- [ ] Mostrar historial de apuestas y resultados
- [ ] Calcular y mostrar estadísticas (win rate, profit/loss)
- [ ] Implementar límites de apuesta para versión gratuita
- [ ] Agregar gráficos de rendimiento con `fl_chart`
- [ ] Implementar sistema de bankroll (gestión de fondos virtuales)

**Impacto:** ALTO - Estas son las funcionalidades principales de la app.

---

## 🟡 PRIORIDAD MEDIA - Funcionalidades Adicionales

### 5. Visualizaciones y Gráficos
**Estado:** ❌ No implementado  
**Dependencia:** `fl_chart: ^0.65.0` (ya agregada en pubspec.yaml)

**Tareas específicas:**
- [ ] Crear gráfico de historial de números
- [ ] Crear gráfico de distribución de rojos/negros/pares/impares
- [ ] Crear gráfico de rendimiento de estrategia Martingale
- [ ] Agregar gráfico de progresión de bankroll
- [ ] Implementar filtros de tiempo (últimos 10, 50, 100 giros)

**Impacto:** MEDIO - Mejora experiencia de usuario y valor percibido.

---

### 6. Sistema de Notificaciones
**Estado:** ❌ No implementado  
**Dependencia:** `firebase_messaging: ^14.7.10` (ya agregada)

**Tareas específicas:**
- [ ] Configurar Firebase Cloud Messaging
- [ ] Solicitar permisos de notificaciones
- [ ] Implementar manejo de notificaciones en foreground/background
- [ ] Crear notificaciones para:
  - Invitaciones de amigos
  - Ofertas especiales
  - Recordatorios
  - Actualizaciones de app

**Impacto:** MEDIO - Aumenta engagement y retención de usuarios.

---

### 7. Configuración Remota (Remote Config)
**Estado:** ❌ No implementado  
**Dependencia:** `firebase_remote_config: ^4.3.12` (ya agregada)

**Tareas específicas:**
- [ ] Configurar parámetros en Firebase Remote Config:
  - Límites de giros gratuitos
  - Precio de suscripciones
  - Features habilitadas/deshabilitadas
  - Mensajes promocionales
- [ ] Implementar fetch y activación de configuraciones
- [ ] Agregar caché local de configuraciones
- [ ] Implementar actualización cada 4 meses (como se menciona en pubspec.yaml)

**Impacto:** MEDIO - Permite ajustes sin actualizar la app.

---

### 8. Sistema de Referidos/Invitaciones
**Estado:** ❌ No implementado  
**Descripción:** Mencionado en el roadmap pero no implementado.

**Tareas específicas:**
- [ ] Crear pantalla de invitaciones
- [ ] Generar código de referido único por usuario
- [ ] Implementar sistema de compartir (WhatsApp, email, etc.)
- [ ] Crear tabla en Firestore para tracking de referidos
- [ ] Implementar recompensas por referidos
- [ ] Mostrar estadísticas de referidos en perfil

**Impacto:** MEDIO - Importante para crecimiento orgánico.

---

## 🟢 PRIORIDAD BAJA - Mejoras y Pulido

### 9. Internacionalización (i18n)
**Estado:** ❌ No implementado  
**Dependencia:** `intl: ^0.18.1` (ya agregada)

**Tareas específicas:**
- [ ] Crear archivos de traducciones (español, inglés)
- [ ] Extraer textos hardcodeados a archivos de idioma
- [ ] Implementar selector de idioma
- [ ] Configurar formato de números/moneda según locale

**Impacto:** BAJO - Útil para expansión internacional.

---

### 10. Información del Dispositivo
**Estado:** ❌ No implementado  
**Dependencia:** `device_info_plus: ^9.1.2` (ya agregada)

**Tareas específicas:**
- [ ] Obtener información del dispositivo para analytics
- [ ] Guardar información del dispositivo en Firestore (opcional)
- [ ] Usar para debugging y soporte técnico

**Impacto:** BAJO - Útil para analytics y soporte.

---

### 11. Sistema de Feedback
**Estado:** ❌ No implementado  
**Dependencia:** `url_launcher: ^6.2.4` (ya agregada)

**Tareas específicas:**
- [ ] Crear pantalla de feedback/contacto
- [ ] Implementar envío de email con `url_launcher`
- [ ] Agregar formulario de reporte de bugs
- [ ] Opcional: Integrar con sistema de tickets

**Impacto:** BAJO - Mejora comunicación con usuarios.

---

### 12. Persistencia de Datos Local
**Estado:** ⚠️ Parcialmente implementado  
**Dependencia:** `shared_preferences: ^2.2.2` (ya agregada)

**Tareas específicas:**
- [ ] Guardar historial de giros localmente
- [ ] Guardar preferencias de usuario (tema, idioma)
- [ ] Guardar estado de autenticación
- [ ] Implementar caché de datos de Firebase
- [ ] Agregar sincronización online/offline

**Impacto:** BAJO - Mejora experiencia offline.

---

## 🔧 INFRAESTRUCTURA Y CALIDAD

### 13. Tests
**Estado:** ⚠️ Mínimo  
**Ubicación:** `test/widget_test.dart`  
**Descripción:** Solo existe un test básico.

**Tareas específicas:**
- [ ] Agregar tests unitarios para `RouletteLogic`
- [ ] Agregar tests unitarios para `MartingaleAdvisor`
- [ ] Agregar tests de widget para pantallas principales
- [ ] Agregar tests de integración para flujos críticos
- [ ] Configurar coverage mínimo (ej: 70%)
- [ ] Agregar tests en CI/CD workflow

**Impacto:** MEDIO - Esencial para mantenibilidad.

---

### 14. CI/CD
**Estado:** ⚠️ Parcial  
**Ubicación:** `.github/workflows/build-apk.yml`  
**Descripción:** Existe workflow de build pero faltan tests automáticos.

**Tareas específicas:**
- [ ] Agregar job de tests al workflow
- [ ] Agregar job de lint (dart analyze)
- [ ] Agregar job de format check
- [ ] Configurar build matrix (debug/release)
- [ ] Agregar deployment automático opcional
- [ ] Configurar notificaciones de build

**Impacto:** MEDIO - Mejora calidad y productividad.

---

### 15. Keystore para Release
**Estado:** ❌ No configurado  
**Ubicación:** `android/app/build.gradle`  
**Descripción:** Documentado en README pero no configurado.

**Tareas específicas:**
- [ ] Generar keystore con keytool
- [ ] Configurar `key.properties` (no commitear)
- [ ] Configurar variables de entorno en CI/CD
- [ ] Actualizar build.gradle si es necesario
- [ ] Documentar proceso en README

**Impacto:** CRÍTICO para producción - Sin keystore no se puede publicar en Play Store.

---

### 16. Assets e Imágenes
**Estado:** ⚠️ Parcial  
**Ubicación:** `assets/images/`  
**Descripción:** Carpeta configurada pero probablemente vacía o incompleta.

**Tareas específicas:**
- [ ] Agregar logo de la app
- [ ] Agregar iconos de app (Android/iOS)
- [ ] Agregar splash screen
- [ ] Agregar imágenes de ruleta
- [ ] Agregar iconos de UI
- [ ] Optimizar tamaños de imágenes

**Impacto:** MEDIO - Necesario para aspecto profesional.

---

## 📱 CONFIGURACIÓN DE PLATAFORMAS

### 17. Android
**Tareas pendientes:**
- [ ] Configurar ApplicationId único
- [ ] Configurar versión mínima de SDK (recomendado: 21+)
- [ ] Agregar permisos necesarios en AndroidManifest.xml:
  - INTERNET
  - ACCESS_NETWORK_STATE (opcional)
- [ ] Configurar google-services.json
- [ ] Configurar íconos de app
- [ ] Configurar splash screen

---

### 18. iOS (Si aplica)
**Tareas pendientes:**
- [ ] Configurar Bundle Identifier único
- [ ] Configurar GoogleService-Info.plist
- [ ] Configurar permisos en Info.plist
- [ ] Configurar íconos de app
- [ ] Configurar splash screen
- [ ] Configurar provisioning profiles

---

## 📄 DOCUMENTACIÓN

### 19. Documentación de Código
**Estado:** ⚠️ Mínima

**Tareas específicas:**
- [ ] Agregar comentarios Dart doc a clases públicas
- [ ] Documentar parámetros de métodos
- [ ] Agregar ejemplos de uso
- [ ] Documentar arquitectura en docs/
- [ ] Crear diagramas de flujo

---

### 20. Documentación de Usuario
**Estado:** ❌ No existe

**Tareas específicas:**
- [ ] Crear guía de usuario
- [ ] Crear FAQ
- [ ] Crear tutoriales en app (onboarding)
- [ ] Documentar estrategia Martingale y sus riesgos
- [ ] Agregar disclaimers legales

---

## ⚖️ LEGAL Y COMPLIANCE

### 21. Políticas y Términos
**Estado:** ❌ No implementado

**Tareas específicas:**
- [ ] Crear Términos y Condiciones
- [ ] Crear Política de Privacidad
- [ ] Agregar pantalla de aceptación en primer uso
- [ ] Implementar GDPR compliance (si aplica)
- [ ] Agregar disclaimers sobre gambling simulado
- [ ] Revisar requisitos de App Store/Play Store

---

## 📊 RESUMEN DE PRIORIDADES

### Para MVP (Producto Mínimo Viable):
1. ✅ Configuración de Firebase (CRÍTICO)
2. ✅ Integración de Stripe (CRÍTICO)
3. ✅ Sistema de Autenticación (ALTO)
4. ✅ Sistema de Predicciones completo en UI (ALTO)
5. ✅ Keystore para release (CRÍTICO)
6. ✅ Políticas legales básicas (CRÍTICO)
7. ✅ Assets básicos (logo, iconos) (MEDIO)

### Para V1.0 Completa:
- Todo lo anterior +
- Sistema de Notificaciones
- Visualizaciones y Gráficos
- Remote Config
- Sistema de Referidos
- Tests completos
- Documentación completa

### Para Futuras Versiones:
- Internacionalización
- Mejoras de UI/UX
- Analytics avanzado
- Features premium adicionales

---

## 🎯 ESTIMACIÓN DE ESFUERZO

**MVP (Mínimo viable):** ~50-70 horas de desarrollo
**V1.0 (Completa):** ~100-140 horas de desarrollo
**V2.0 (Todas las mejoras):** ~180-240 horas de desarrollo

---

## 📝 NOTAS IMPORTANTES

1. **Seguridad:** NUNCA commitear claves API, keystore, o credenciales al repositorio.
2. **Testing:** Probar exhaustivamente flujos de pago antes de producción.
3. **Disclaimers:** La app debe dejar claro que es simulación educativa, no gambling real.
4. **Compliance:** Verificar requisitos legales del país donde se publicará.
5. **Firebase Costs:** Monitorear uso de Firebase para evitar costos inesperados.

---

## 🔗 RECURSOS ÚTILES

- [Firebase Setup for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Stripe Flutter Integration](https://stripe.com/docs/payments/accept-a-payment?platform=flutter)
- [Flutter App Distribution](https://docs.flutter.dev/deployment/android)
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config/get-started?platform=flutter)

---

**Última actualización:** 2025-12-12
**Versión del documento:** 1.0
