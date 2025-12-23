# Google Services Configuration for Firebase

## ⚠️ IMPORTANT: Este archivo NO debe ser committeado con datos reales

El archivo `google-services.json` contiene configuraciones sensibles de Firebase y ya está incluido en `.gitignore`.

## 📋 Cómo obtener google-services.json

### Opción 1: Firebase Console (Recomendado)

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto (o crea uno nuevo)
3. Haz clic en el ícono de Android
4. Registra tu app con el package name: `com.tokyoapps.roulette`
5. Descarga el archivo `google-services.json`
6. Colócalo en la carpeta `android/app/`

### Opción 2: Firebase CLI

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Iniciar sesión
firebase login

# Configurar proyecto
flutterfire configure
```

Esto generará automáticamente:
- `google-services.json` para Android
- `GoogleService-Info.plist` para iOS
- `lib/firebase_options.dart` para Flutter

## 📁 Ubicación del archivo

El archivo debe estar ubicado en:
```
android/app/google-services.json
```

## 🔧 Estructura esperada

El archivo debe tener esta estructura (con tus valores reales):

```json
{
  "project_info": {
    "project_number": "TU_PROJECT_NUMBER",
    "project_id": "tokyo-roulette-predictor",
    "storage_bucket": "tokyo-roulette-predictor.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "TU_APP_ID",
        "android_client_info": {
          "package_name": "com.tokyoapps.roulette"
        }
      },
      "oauth_client": [
        {
          "client_id": "TU_CLIENT_ID",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "TU_API_KEY"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

## ✅ Verificación

Después de agregar el archivo, verifica que:

1. El archivo esté en `android/app/google-services.json`
2. El package name coincida: `com.tokyoapps.roulette`
3. No esté committeado en git (debe aparecer en `.gitignore`)
4. La app compile sin errores

## 🏗️ Compilación

Para compilar la app con Firebase:

```bash
# Obtener dependencias
flutter pub get

# Compilar APK de debug
flutter build apk --debug

# Compilar APK de release
flutter build apk --release

# Ejecutar app
flutter run
```

## 🧪 Testing Local con Emulador

Para usar el emulador de Firebase localmente:

1. Instalar Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Iniciar emuladores:
```bash
firebase emulators:start
```

3. Configurar la app para usar emuladores (ver `docs/FIREBASE_TESTING.md`)

## 📚 Recursos

- [Documentación de Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Firebase Console](https://console.firebase.google.com/)

## 🔐 Seguridad

**NUNCA** hagas lo siguiente:
- ❌ Commitear google-services.json con datos reales a git público
- ❌ Compartir el archivo en canales públicos
- ❌ Incluir el archivo en capturas de pantalla
- ❌ Hardcodear API keys en el código fuente

## 🚀 Despliegue

Para producción, asegúrate de:
- ✅ Usar un proyecto Firebase de producción separado
- ✅ Configurar reglas de seguridad de Firestore
- ✅ Configurar reglas de seguridad de Storage
- ✅ Habilitar autenticación de usuario
- ✅ Configurar límites de cuota
- ✅ Monitorear uso y costos

## 📞 Soporte

Si tienes problemas:
1. Verifica que el package name sea correcto
2. Revisa la consola de Firebase para errores
3. Consulta la documentación de FlutterFire
4. Revisa los logs de Android Studio

---

**Nota**: Este es un archivo de documentación. El archivo real `google-services.json` debe ser generado desde Firebase Console para tu proyecto específico.
