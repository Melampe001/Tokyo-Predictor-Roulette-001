# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Comandos de Desarrollo con Makefile

Este proyecto incluye un **Makefile** que estandariza los flujos de trabajo de desarrollo en Dart/Flutter, siguiendo mejores prácticas profesionales. Los comandos disponibles son:

### Comandos Disponibles

#### `make fmt`
**Propósito**: Formatear el código Dart/Flutter de forma consistente.

Aplica el formato estándar de Dart a todo el código fuente, asegurando un estilo uniforme en todo el proyecto.
```bash
make fmt
```

#### `make lint`
**Propósito**: Analizar el código en busca de problemas potenciales.

Ejecuta el analizador estático de Dart para detectar errores, advertencias y sugerencias de mejora en el código.
```bash
make lint
```

#### `make test`
**Propósito**: Ejecutar todas las pruebas del proyecto.

Corre las pruebas unitarias y de widgets definidas en el directorio `test/`, validando la funcionalidad del código.
```bash
make test
```

#### `make build`
**Propósito**: Construir la aplicación Flutter para producción.

Genera un APK release para Android, optimizado y listo para distribución.
```bash
make build
```

#### `make ci`
**Propósito**: Ejecutar el pipeline completo de integración continua.

Ejecuta todos los comandos anteriores en secuencia (fmt → lint → test → build), simulando un entorno de CI/CD local.
```bash
make ci
```

#### `make help`
**Propósito**: Mostrar ayuda sobre los comandos disponibles.
```bash
make help
```

### Flujo de Trabajo Recomendado

1. **Antes de hacer commit**: Ejecuta `make fmt` y `make lint` para asegurar calidad de código.
2. **Durante desarrollo**: Usa `make test` frecuentemente para validar cambios.
3. **Antes de crear un PR**: Ejecuta `make ci` para verificar que todo funciona correctamente.
4. **Para builds de producción**: Usa `make build` para generar el APK release.

**Disclaimer**: Solo simulación. No promueve gambling real.

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
