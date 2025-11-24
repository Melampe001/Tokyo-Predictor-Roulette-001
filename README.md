# Tokyo Roulette Predicciones

**Herramienta educativa de simulación estadística** para el análisis de patrones en sistemas de números aleatorios. Este proyecto tiene un propósito exclusivamente educativo y de investigación estadística.

## ⚠️ AVISO LEGAL IMPORTANTE

**PROPÓSITO EXCLUSIVAMENTE EDUCATIVO Y DE SIMULACIÓN**

Este software es una herramienta educativa diseñada para:
- Demostrar conceptos de probabilidad y estadística
- Ilustrar el funcionamiento de generadores de números aleatorios (RNG)
- Analizar estrategias de gestión de recursos en contextos simulados
- Enseñar principios de desarrollo de software y análisis de datos

**ESTE SOFTWARE NO ESTÁ DISEÑADO NI DEBE SER UTILIZADO PARA:**
- Realizar apuestas con dinero real
- Gambling o juegos de azar con dinero real
- Predecir resultados en casinos o plataformas de apuestas reales
- Cualquier actividad que involucre dinero real o apuestas legales

Los "créditos" mencionados en la aplicación son puramente **virtuales y sin valor monetario**. Cualquier referencia a pagos o suscripciones se refiere únicamente a funcionalidades premium del software educativo, no a apuestas o juegos de azar.

**El uso de este software para actividades de gambling real es responsabilidad exclusiva del usuario y está expresamente desaconsejado por los desarrolladores.**

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK
`flutter build apk --release`

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
