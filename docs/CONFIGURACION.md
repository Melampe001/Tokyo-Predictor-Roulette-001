# Guía de Configuración - Tokyo Roulette Predicciones

Este documento proporciona instrucciones detalladas para configurar Firebase y Stripe en el proyecto.

## ⚠️ IMPORTANTE: Configuración Obligatoria

Este proyecto NO funcionará sin configurar Firebase y Stripe con tus propias credenciales. Los archivos actuales contienen valores placeholder que deben ser reemplazados.

## 1. Configuración de Firebase

### Paso 1: Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto"
3. Nombra tu proyecto (ej: "Tokyo Roulette")
4. Sigue los pasos del asistente

### Paso 2: Agregar App Android

1. En la consola de Firebase, haz clic en el ícono de Android
2. Ingresa el package name: `com.example.tokyo_roulette_predicciones`
3. Descarga el archivo `google-services.json`
4. Coloca `google-services.json` en la carpeta: `android/app/`
   - **Reemplaza** el archivo placeholder existente

### Paso 3: Habilitar Servicios de Firebase

En Firebase Console, habilita los siguientes servicios:

1. **Authentication**
   - Ve a Authentication > Sign-in method
   - Habilita "Email/Password"
   
2. **Cloud Firestore**
   - Ve a Firestore Database
   - Crea una base de datos en modo de prueba
   
3. **Remote Config**
   - Ve a Remote Config
   - Configura parámetros según necesites
   
4. **Cloud Messaging**
   - Ya está habilitado por defecto
   - Configura las notificaciones según necesites

### Paso 4: Configurar Flutter con Firebase

1. Instala FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Ejecuta el comando de configuración:
```bash
flutterfire configure
```

3. Selecciona tu proyecto de Firebase
4. Selecciona las plataformas (Android, iOS, etc.)
5. Esto generará automáticamente el archivo `lib/firebase_options.dart` con tus credenciales reales

**Nota**: Si ya tienes `firebase_options.dart`, será sobrescrito con las credenciales correctas.

## 2. Configuración de Stripe

### Paso 1: Crear Cuenta en Stripe

1. Ve a [Stripe](https://stripe.com/)
2. Crea una cuenta o inicia sesión
3. Ve al [Dashboard](https://dashboard.stripe.com/)

### Paso 2: Obtener API Keys

1. En el Dashboard, ve a "Developers" > "API keys"
2. Copia tu **Publishable key** (comienza con `pk_test_` en modo test)
3. Guarda también tu **Secret key** para el backend (comienza con `sk_test_`)

### Paso 3: Configurar en la App

1. Abre el archivo `lib/main.dart`
2. Encuentra la línea:
```dart
Stripe.publishableKey = 'tu_publishable_key_de_stripe';
```
3. Reemplaza con tu clave real:
```dart
Stripe.publishableKey = 'pk_test_XXXXXXXXXXXXXXXXXXXXXXXX';
```

### Modo Test vs Producción

- **Test Mode**: Usa claves que empiezan con `pk_test_` y `sk_test_`
- **Live Mode**: Usa claves que empiezan con `pk_live_` y `sk_live_`

⚠️ **Nunca** incluyas tu Secret Key en el código de la app. Esta debe estar solo en tu backend.

## 3. Verificar la Configuración

Después de configurar todo:

1. Limpia el proyecto:
```bash
flutter clean
```

2. Obtén las dependencias:
```bash
flutter pub get
```

3. Ejecuta la app:
```bash
flutter run
```

4. Verifica que no haya errores de Firebase o Stripe en la consola

## 4. Seguridad

### ❌ NO Hacer:
- No incluyas `google-services.json` real en el control de versiones si es público
- No incluyas Secret Keys de Stripe en el código
- No uses credenciales de producción durante el desarrollo

### ✅ Hacer:
- Usa variables de entorno para datos sensibles
- Mantén las Secret Keys solo en el backend
- Usa modo test de Stripe durante desarrollo
- Configura reglas de seguridad en Firestore

## 5. Archivos que Debes Reemplazar

Antes de construir el APK de producción, asegúrate de reemplazar:

- [ ] `android/app/google-services.json` - Con el real de Firebase Console
- [ ] `lib/firebase_options.dart` - Genera con `flutterfire configure`
- [ ] `lib/main.dart` - Actualiza la clave de Stripe (línea 9)

## 6. Construir APK

Una vez configurado todo:

```bash
flutter build apk --release
```

El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

## Solución de Problemas

### Error: "FirebaseOptions have not been configured"
- Ejecuta `flutterfire configure` para generar el archivo correcto

### Error: "google-services.json is missing"
- Descarga el archivo desde Firebase Console y colócalo en `android/app/`

### Error: Stripe no se inicializa
- Verifica que la clave Publishable Key sea correcta
- Asegúrate de usar la clave de test durante desarrollo

### Error de compilación en Android
- Ejecuta `flutter clean` y luego `flutter pub get`
- Verifica que Java JDK 17 esté instalado
- Sincroniza el proyecto de Android Studio

## Recursos Adicionales

- [Documentación de FlutterFire](https://firebase.flutter.dev/)
- [Documentación de Flutter Stripe](https://pub.dev/packages/flutter_stripe)
- [Guía de Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Guía de Stripe para Flutter](https://stripe.com/docs/payments/accept-a-payment?platform=flutter)

## Soporte

Si tienes problemas con la configuración, revisa:
1. Los logs de la consola de Flutter
2. La documentación oficial de Firebase y Stripe
3. Los issues del repositorio en GitHub
