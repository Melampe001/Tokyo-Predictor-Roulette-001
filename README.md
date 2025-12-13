# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Características

- **Simulador de Ruleta Europea**: Ruleta de 37 números (0-36) con RNG seguro
- **Validación de Email**: Sistema de login con validación básica
- **Balance Virtual**: Sistema de gestión de balance con monitoreo en tiempo real
- **Predicciones**: Algoritmo de predicción basado en historial de giros
- **Estrategia Martingale**: Asesor automático de estrategia con:
  - Duplicación de apuesta en pérdidas
  - Reset a apuesta base en victorias
  - Visualización de mensajes de estrategia
- **Historial Visual**: Muestra los últimos 10 resultados con código de colores
- **Protección de Balance**: Previene apuestas cuando el balance es insuficiente
- **Advertencias Educativas**: Disclaimers sobre riesgos de gambling
- **Reinicio de Juego**: Funcionalidad para resetear el estado del juego

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

**Disclaimer**: Solo simulación. No promueve gambling real.

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

## Estado del Proyecto

✅ **Todos los TODO items completados** (ver [docs/completed_todos.md](docs/completed_todos.md))

### Reciente actualización
- Implementada validación de email en pantalla de login
- Agregados widgets completos para Martingale y predicciones
- Mejorada documentación de configuración Firebase y Stripe
- Actualizado suite de tests
- Todas las funcionalidades principales están implementadas

### Próximos pasos para producción
1. Ejecutar `flutterfire configure` para generar `firebase_options.dart`
2. Configurar variable de entorno `STRIPE_PUBLISHABLE_KEY`
3. Descomentar inicializaciones en `lib/main.dart`
4. Implementar Firebase Authentication completo
5. (Opcional) Eliminar workflow Azure Node.js si no se necesita backend
