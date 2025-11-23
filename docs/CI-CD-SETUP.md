# Configuración de CI/CD para Tokyo Roulette Predicciones

Este documento explica cómo configurar y usar el sistema de integración continua para construir APKs automáticamente.

## Resumen

El proyecto utiliza GitHub Actions para:
- Ejecutar análisis de código y pruebas automáticamente
- Construir APKs release en cada push/PR
- Generar App Bundles para Google Play Store
- Publicar artefactos descargables

## Workflow Automático

### Archivo: `.github/workflows/flutter-ci.yml`

El workflow se ejecuta automáticamente en:
- Pushes a las ramas: `main`, `develop`, `feature/**`, `release/**`
- Pull requests hacia: `main`, `develop`
- Ejecución manual desde la pestaña Actions

### Jobs Incluidos

1. **analyze-and-test**: Análisis de código y ejecución de pruebas
2. **build-apk**: Construcción de APKs por arquitectura y universal
3. **build-appbundle**: Construcción de App Bundle (solo en main)
4. **build-summary**: Resumen del proceso de build

## Configuración de Secretos para Firma

Para que el CI/CD firme automáticamente los APKs, configura estos secretos en GitHub:

### Pasos para Configurar Secretos

1. Ve a tu repositorio en GitHub
2. Click en `Settings` → `Secrets and variables` → `Actions`
3. Click en `New repository secret`
4. Agrega los siguientes secretos:

#### Secretos Requeridos

| Nombre del Secreto | Descripción | Cómo obtenerlo |
|-------------------|-------------|----------------|
| `ANDROID_KEYSTORE_BASE64` | Keystore codificado en base64 | `base64 -i upload-keystore.jks` |
| `KEYSTORE_PASSWORD` | Contraseña del keystore | La que usaste al crear el keystore |
| `KEY_ALIAS` | Alias de la clave | Normalmente "upload" |
| `KEY_PASSWORD` | Contraseña de la clave | La que usaste al crear la clave |

### Generar el Keystore Base64

```bash
# Generar el keystore (si aún no lo tienes)
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload

# Convertir a base64 para GitHub Secrets
# En macOS:
base64 -i upload-keystore.jks | pbcopy

# En Linux:
base64 -i upload-keystore.jks

# Pega el resultado en el secreto ANDROID_KEYSTORE_BASE64
```

## Descargar Artefactos

### Desde GitHub Actions

1. Ve a la pestaña `Actions` de tu repositorio
2. Click en el workflow run que deseas
3. Scroll hasta la sección `Artifacts`
4. Descarga los APKs:
   - `apk-universal-stable`: APK que funciona en todas las arquitecturas
   - `apk-split-per-abi-stable`: APKs optimizados por arquitectura
   - `app-bundle-release`: App Bundle para Google Play Store

### Tipos de Artefactos

- **APK Universal**: `app-release.apk` - Tamaño mayor, compatible con todos los dispositivos
- **APK Split**:
  - `app-armeabi-v7a-release.apk` - ARM 32-bit (dispositivos antiguos)
  - `app-arm64-v8a-release.apk` - ARM 64-bit (mayoría de dispositivos modernos)
  - `app-x86_64-release.apk` - x86 (emuladores y algunos tablets)
- **App Bundle**: `app-release.aab` - Para subir a Google Play Store

## Personalizar el Workflow

### Cambiar la Versión de Flutter

Edita `.github/workflows/flutter-ci.yml`:

```yaml
env:
  FLUTTER_VERSION: '3.24.0'  # Cambia a la versión deseada
```

### Agregar Más Canales de Flutter

Para probar con múltiples versiones de Flutter, edita la matriz en el job `build-apk`:

```yaml
strategy:
  matrix:
    flutter-channel: ['stable', 'beta']  # Agregar 'dev' si lo deseas
```

### Deshabilitar Análisis de Código

Si el análisis falla y quieres saltar temporalmente este paso:

```yaml
- name: Analizar código
  run: flutter analyze
  continue-on-error: true  # Agregar esta línea
```

## Ejecutar el Workflow Manualmente

1. Ve a la pestaña `Actions`
2. Selecciona `Flutter CI - Build APK`
3. Click en `Run workflow`
4. Selecciona la rama y click en `Run workflow`

## Solución de Problemas

### Error: "Keystore not found"

**Causa**: Los secretos de GitHub no están configurados o son incorrectos.

**Solución**: 
- Verifica que todos los secretos estén configurados correctamente
- Asegúrate de que el keystore base64 no tenga espacios o saltos de línea extras

### Error: "Flutter doctor shows issues"

**Causa**: Problemas con la configuración del entorno Flutter.

**Solución**: 
- Revisa el log completo del job `analyze-and-test`
- Verifica que las versiones de Flutter y Java sean compatibles

### Error: "Gradle build failed"

**Causa**: Problemas con la configuración de Gradle o dependencias.

**Solución**:
- Verifica que `android/build.gradle` y `android/app/build.gradle` estén correctos
- Asegúrate de que todas las dependencias en `pubspec.yaml` sean compatibles

### El workflow no se ejecuta

**Causa**: El workflow puede estar deshabilitado o la rama no coincide con los triggers.

**Solución**:
- Verifica que el archivo workflow esté en `.github/workflows/`
- Asegúrate de hacer push a una rama que active el workflow (main, develop, feature/*)
- Verifica que GitHub Actions esté habilitado en Settings > Actions

## Mejores Prácticas

1. **Siempre ejecuta pruebas localmente** antes de hacer push
2. **Revisa los logs del workflow** si falla algún job
3. **Mantén los secretos seguros** - nunca los compartas o expongas
4. **Actualiza las versiones** de Flutter y dependencias regularmente
5. **Prueba los APKs** descargados en dispositivos reales antes de distribuir

## Recursos Adicionales

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Signing Android Apps](https://developer.android.com/studio/publish/app-signing)

## Contacto y Soporte

Si encuentras problemas con el CI/CD, abre un issue en el repositorio con:
- Logs del workflow (desde la pestaña Actions)
- Descripción del problema
- Pasos para reproducir el error
