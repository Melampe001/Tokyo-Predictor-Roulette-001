# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

**Disclaimer**: Solo simulación. No promueve gambling real.

---

## 📋 Estado del Proyecto y Pendientes

**Estado actual:** 🟡 En desarrollo (40% completado)

Para ver qué falta para finalizar la app, consulta:

- 📊 **[RESUMEN_ESTADO_APP.md](./RESUMEN_ESTADO_APP.md)** - Vista rápida del estado actual (leer primero)
- 📝 **[PENDIENTES_FINALIZACION.md](./PENDIENTES_FINALIZACION.md)** - Lista completa y detallada de pendientes
- 🚀 **[PLAN_ACCION_INMEDIATA.md](./PLAN_ACCION_INMEDIATA.md)** - Guía paso a paso para completar el desarrollo

**Pendientes críticos:**
- ❌ Configurar Firebase (auth, firestore, remote config)
- ❌ Configurar Stripe para suscripciones
- ❌ Implementar autenticación funcional
- ❌ Completar UI de predicciones y estrategia Martingale
- ❌ Configurar keystore para release
- ❌ Crear términos y condiciones / política de privacidad

---

## Configuración de Keystore para Android

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

---

## Fases del Proyecto

### 1. Definición y planificación
- [ok] Redactar objetivo y alcance del proyecto
- [ok] Identificar requerimientos y entregables principales
- [ok] Crear roadmap con hitos y fechas estimadas
- [ok] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [ok] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [ok] Revisar dependencias y recursos necesarios
- [ok] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [ok] Implementar funcionalidades según el roadmap
- [ok] Realizar revisiones de código y PR siguiendo checklist
- [ok] Actualizar documentación según cambios realizados

### 4. Pruebas
- [ok] Ejecutar pruebas unitarias y funcionales
- [ok] Validar requisitos y criterios de aceptación
- [ok] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [ok] Preparar ambiente de release
- [ok] Documentar lecciones aprendidas
- [ok] Presentar entregables y cerrar fase
