# Política de Seguridad

## Tokyo Predictor Roulette - Guías de Seguridad

**Desarrollador**: TokyoApps/TokRaggcorp  
**Package**: com.tokraggcorp.tokyopredictorroulett  
**Contacto**: tokraagcorp@gmail.com

## Versiones Soportadas

Proporcionamos actualizaciones de seguridad para las siguientes versiones:

| Versión | Soportada          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reportar una Vulnerabilidad

Tomamos la seguridad de Tokyo Predictor Roulette seriamente. Si descubres una vulnerabilidad de seguridad, por favor sigue estas guías:

### Cómo Reportar

1. **NO** divulgues la vulnerabilidad públicamente hasta que haya sido abordada
2. Envía un reporte detallado a: **tokraagcorp@gmail.com**
3. Incluye la siguiente información:
   - Descripción de la vulnerabilidad
   - Pasos para reproducir el problema
   - Impacto potencial de la vulnerabilidad
   - Cualquier sugerencia de corrección (si aplica)

### Qué Esperar

- **Reconocimiento**: Confirmaremos recibo de tu reporte dentro de 48 horas
- **Evaluación Inicial**: Evaluaremos la vulnerabilidad dentro de 7 días
- **Tiempo de Resolución**: Las vulnerabilidades críticas se abordarán dentro de 30 días
- **Divulgación**: Coordinaremos contigo respecto a la divulgación pública

### Contacto de Seguridad

**Contacto Principal**: tokraagcorp@gmail.com  
**Tiempo de Respuesta**: 48 horas para respuesta inicial

## Mejores Prácticas de Seguridad

### Para Usuarios

1. **Mantén la app actualizada**: Siempre usa la última versión de Google Play Store
2. **Descarga de fuentes oficiales**: Solo descarga de Google Play Store
3. **Ten cuidado con los permisos**: Revisa los permisos de la app antes de otorgar acceso
4. **Reporta actividad sospechosa**: Contáctanos si notas algún comportamiento inusual

### Medidas de Seguridad de la Aplicación

Tokyo Predictor Roulette implementa las siguientes medidas de seguridad:

#### Protección de Datos
- ✅ Transmisión de datos encriptada (HTTPS/TLS)
- ✅ Almacenamiento local seguro usando SharedPreferences encriptado
- ✅ Sin almacenamiento de información sensible en texto plano
- ✅ Política de recopilación mínima de datos

#### Autenticación
- ✅ Integración con Firebase Authentication
- ✅ Gestión segura de sesiones
- ✅ Aplicación de requisitos de contraseña (cuando aplica)

#### Seguridad del Código
- ✅ Ofuscación de código habilitada para builds de release
- ✅ Reglas ProGuard/R8 aplicadas
- ✅ Sin secretos o claves API hardcodeadas en código fuente
- ✅ Variables de entorno para configuración sensible

#### Seguridad de Red
- ✅ Certificate pinning (donde aplica)
- ✅ Tráfico en texto plano deshabilitado
- ✅ Solo endpoints API seguros

#### Seguridad de Build
- ✅ APK/AAB firmado con keystore privado
- ✅ Keystore y credenciales de firma excluidas del control de versiones
- ✅ Gestión de secretos CI/CD para builds automatizados

## Guías de Desarrollo Seguro

### Para Contribuidores

1. **Nunca subas secretos**: Claves API, contraseñas, keystores nunca deben ser subidos
2. **Usa variables de entorno**: Para toda configuración sensible
3. **Revisa dependencias**: Verifica vulnerabilidades conocidas antes de agregar dependencias
4. **Sigue prácticas de codificación segura**: Validación de entrada, codificación de salida, etc.
5. **Prueba la seguridad**: Incluye pruebas de seguridad en tu flujo de desarrollo

### Archivos que Nunca Debes Subir

```
*.jks
*.keystore
key.properties
.env
.env.*
secrets.yaml
api_keys.dart
google-services.json (con credenciales de producción)
```

## Cumplimiento

Tokyo Predictor Roulette está diseñado para cumplir con:

- ✅ Políticas del Programa de Desarrolladores de Google Play
- ✅ Principios del Reglamento General de Protección de Datos (GDPR)
- ✅ Principios de la Ley de Privacidad del Consumidor de California (CCPA)
- ✅ Ley de Protección de la Privacidad en Línea de los Niños (COPPA)

## Declaración de Cumplimiento sobre Juegos de Azar

⚠️ **IMPORTANTE**: Tokyo Predictor Roulette es estrictamente una **aplicación de simulación y educativa**.

- **NO** tiene funcionalidad de juego con dinero real
- **NO** tiene conexión con servicios de juego reales
- **NO** promueve comportamiento de juego
- Avisos educativos mostrados en toda la app
- Guías de contenido apropiado para la edad seguidas

## Seguridad de Terceros

Usamos los siguientes servicios de terceros con sus respectivas medidas de seguridad:

| Servicio | Propósito | Info de Seguridad |
|----------|-----------|-------------------|
| Firebase | Servicios de backend | [Seguridad de Firebase](https://firebase.google.com/support/privacy) |
| Stripe | Pagos | [Seguridad de Stripe](https://stripe.com/docs/security/stripe) |
| Google Play | Distribución | [Seguridad de Play](https://support.google.com/googleplay/android-developer/answer/9859455) |

## Respuesta a Incidentes

En caso de un incidente de seguridad:

1. **Identificación**: Detectar e identificar el incidente de seguridad
2. **Contención**: Implementar medidas inmediatas para contener el problema
3. **Investigación**: Realizar investigación exhaustiva
4. **Notificación**: Notificar a usuarios afectados dentro de 72 horas (si aplica)
5. **Resolución**: Implementar correcciones permanentes
6. **Revisión**: Revisión post-incidente y mejoras

## Actualizaciones a Esta Política

Esta política de seguridad puede ser actualizada periódicamente. Revisa el repositorio para la última versión.

**Última Actualización**: Noviembre 2024

---

Para cualquier pregunta relacionada con seguridad, contacta: tokraagcorp@gmail.com

© 2024 TokyoApps/TokRaggcorp. Todos los derechos reservados.
