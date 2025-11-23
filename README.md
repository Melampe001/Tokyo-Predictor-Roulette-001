# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

**Disclaimer**: Solo simulación. No promueve gambling real.

// BEGIN: Carga de propiedades de keystore con fallback a variables de entorno
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
} else {
    // Fallback: leer desde variables de entorno (definir en CI)
    keystoreProperties.setProperty('storeFile', System.getenv('ANDROID_KEYSTORE_PATH') ?: '')
    keystoreProperties.setProperty('storePassword', System.getenv('KEYSTORE_PASSWORD') ?: '')
    keystoreProperties.setProperty('keyAlias', System.getenv('KEY_ALIAS') ?: '')
    keystoreProperties.setProperty('keyPassword', System.getenv('KEY_PASSWORD') ?: '')
}
// END

---

## Fases del Proyecto

### 1. Definición y planificación
- [ ] Redactar objetivo y alcance del proyecto
- [ ] Identificar requerimientos y entregables principales
- [ ] Crear roadmap con hitos y fechas estimadas
- [ ] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [ ] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [ ] Revisar dependencias y recursos necesarios
- [ ] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [ ] Implementar funcionalidades según el roadmap
- [ ] Realizar revisiones de código y PR siguiendo checklist
- [ ] Actualizar documentación según cambios realizados

### 4. Pruebas
- [ ] Ejecutar pruebas unitarias y funcionales
- [ ] Validar requisitos y criterios de aceptación
- [ ] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [ ] Preparar ambiente de release
- [ ] Documentar lecciones aprendidas
- [ ] Presentar entregables y cerrar fase