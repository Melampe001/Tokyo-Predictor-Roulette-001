# 🛠️ Guía de Configuración - TokyoIA Roulette Predictor

## Setup Completo para Desarrollo y Publicación

---

## 1. 🎨 Configuración del Logo e Icono

### 1.1 Assets Necesarios

Prepara estos archivos desde tu logo original:

| Asset | Tamaño | Formato | Uso |
|-------|--------|---------|-----|
| `ic_launcher_foreground.png` | 432x432 px | PNG/SVG | Adaptive icon (foreground) |
| `ic_launcher_background.png` | 432x432 px | PNG | Adaptive icon (background) |
| `ic_launcher.png` | 512x512 px | PNG | Legacy icon |
| `ic_launcher_round.png` | 512x512 px | PNG | Round icon (legacy) |
| `feature_graphic.png` | 1024x500 px | PNG/JPEG | Play Store banner |
| `app_icon_playstore.png` | 512x512 px | PNG | Play Store listing |

### 1.2 Estructura de Carpetas (Android)

```
android/app/src/main/res/
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml
│   └── ic_launcher_round.xml
├── mipmap-hdpi/
│   ├── ic_launcher.png (72x72)
│   ├── ic_launcher_round.png (72x72)
│   ├── ic_launcher_foreground.png (162x162)
│   └── ic_launcher_background.png (162x162)
├── mipmap-mdpi/
│   ├── ic_launcher.png (48x48)
│   ├── ic_launcher_round.png (48x48)
│   ├── ic_launcher_foreground.png (108x108)
│   └── ic_launcher_background.png (108x108)
├── mipmap-xhdpi/
│   ├── ic_launcher.png (96x96)
│   ├── ic_launcher_round.png (96x96)
│   ├── ic_launcher_foreground.png (216x216)
│   └── ic_launcher_background.png (216x216)
├── mipmap-xxhdpi/
│   ├── ic_launcher.png (144x144)
│   ├── ic_launcher_round.png (144x144)
│   ├── ic_launcher_foreground.png (324x324)
│   └── ic_launcher_background.png (324x324)
└── mipmap-xxxhdpi/
    ├── ic_launcher.png (192x192)
    ├── ic_launcher_round.png (192x192)
    ├── ic_launcher_foreground.png (432x432)
    └── ic_launcher_background.png (432x432)
```

### 1.3 Adaptive Icon XML

Crear `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
```

Crear `ic_launcher_round.xml` con el mismo contenido.

### 1.4 Usar Android Studio Image Asset

1. Abre Android Studio
2. `File → New → Image Asset`
3. Selecciona **Launcher Icons (Adaptive and Legacy)**
4. **Foreground Layer**: Selecciona tu logo (SVG/PNG)
5. **Background Layer**: Color sólido o imagen
6. **Scaling**: Ajusta para que el logo quede centrado
7. Click **Next → Finish**

---

## 2. 📱 AndroidManifest.xml

### 2.1 Configuración Completa

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.tokyoia.roulette.predictor">

    <!-- PERMISOS -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="com.android.vending.BILLING" />
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <uses-permission android:name="android.permission.USE_FINGERPRINT" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <!-- NO incluir sin justificación:
    <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
    -->

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:label="@string/app_name"
        android:theme="@style/LaunchTheme"
        android:name="${applicationName}"
        android:enableOnBackInvokedCallback="true">
        
        <!-- Actividad principal Flutter -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            
            <!-- Deep linking para referidos -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data
                    android:scheme="https"
                    android:host="tokyoia-apps.com"
                    android:pathPrefix="/referral" />
            </intent-filter>
        </activity>
        
        <!-- Meta-data para Flutter -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
            
    </application>
    
    <!-- Queries para Play Billing -->
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
    </queries>

</manifest>
```

### 2.2 Explicación de Permisos

| Permiso | Justificación |
|---------|---------------|
| `INTERNET` | Conexión a Firebase, pagos, analytics |
| `BILLING` | Google Play Billing para suscripciones |
| `USE_BIOMETRIC` | Login con huella digital |
| `USE_FINGERPRINT` | Compatibilidad con dispositivos antiguos |
| `POST_NOTIFICATIONS` | Notificaciones push (ofertas, recordatorios) |

---

## 3. 🧭 Navegación y Menús

### 3.1 Drawer Menu XML (Android nativo)

```xml
<!-- res/menu/drawer_menu.xml -->
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <group android:checkableBehavior="single">
        <item 
            android:id="@+id/nav_home" 
            android:title="Inicio" 
            android:icon="@drawable/ic_home"/>
        <item 
            android:id="@+id/nav_ruleta" 
            android:title="Ruleta" 
            android:icon="@drawable/ic_ruleta"/>
        <item 
            android:id="@+id/nav_predicciones" 
            android:title="Predicciones" 
            android:icon="@drawable/ic_stats"/>
        <item 
            android:id="@+id/nav_estrategias" 
            android:title="Estrategias" 
            android:icon="@drawable/ic_strategy"/>
        <item 
            android:id="@+id/nav_subs" 
            android:title="Suscripciones" 
            android:icon="@drawable/ic_subs"/>
        <item 
            android:id="@+id/nav_referidos" 
            android:title="Referidos" 
            android:icon="@drawable/ic_refer"/>
        <item 
            android:id="@+id/nav_settings" 
            android:title="Ajustes" 
            android:icon="@drawable/ic_settings"/>
    </group>
    
    <item android:title="Soporte">
        <menu>
            <item 
                android:id="@+id/nav_help" 
                android:title="Manual de uso" />
            <item 
                android:id="@+id/nav_privacy" 
                android:title="Política de privacidad" />
            <item 
                android:id="@+id/nav_terms" 
                android:title="Términos de servicio" />
        </menu>
    </item>
</menu>
```

### 3.2 Flutter Navigation (Drawer)

```dart
// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header con logo
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF7C4DFF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 10),
                Text('TokyoIA Roulette',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Simulador de Estrategias',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          
          // Menú principal
          _buildMenuItem(context, Icons.home, 'Inicio', '/home'),
          _buildMenuItem(context, Icons.casino, 'Ruleta', '/roulette'),
          _buildMenuItem(context, Icons.analytics, 'Predicciones', '/predictions'),
          
          // Submenu Estrategias
          ExpansionTile(
            leading: Icon(Icons.psychology),
            title: Text('Estrategias'),
            children: [
              _buildSubMenuItem(context, 'Martingale', '/strategy/martingale'),
              _buildSubMenuItem(context, 'Fibonacci', '/strategy/fibonacci'),
              _buildSubMenuItem(context, "D'Alembert", '/strategy/dalembert'),
              _buildSubMenuItem(context, 'Anti-Martingale', '/strategy/paroli'),
            ],
          ),
          
          _buildMenuItem(context, Icons.card_membership, 'Suscripciones', '/subscriptions'),
          _buildMenuItem(context, Icons.people, 'Referidos', '/referrals'),
          
          Divider(),
          
          _buildMenuItem(context, Icons.settings, 'Ajustes', '/settings'),
          _buildMenuItem(context, Icons.help, 'Manual', '/help'),
          _buildMenuItem(context, Icons.privacy_tip, 'Privacidad', '/privacy'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildSubMenuItem(BuildContext context, String title, String route) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 72),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
```

---

## 4. 🔐 Autenticación con Biometría

### 4.1 Flutter (local_auth)

```yaml
# pubspec.yaml
dependencies:
  local_auth: ^2.1.6
```

```dart
// lib/features/auth/biometric_service.dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  
  /// Verifica si el dispositivo soporta biometría
  Future<bool> isBiometricAvailable() async {
    final canCheckBiometrics = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheckBiometrics && isDeviceSupported;
  }
  
  /// Obtiene tipos de biometría disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }
  
  /// Autentica con biometría
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Iniciar sesión con huella digital',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Permite PIN como fallback
        ),
      );
    } catch (e) {
      print('Error de autenticación biométrica: $e');
      return false;
    }
  }
}
```

### 4.2 Kotlin (Android Nativo)

```kotlin
// MainActivity.kt
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import java.util.concurrent.Executor

class BiometricHelper(private val activity: FragmentActivity) {
    
    private lateinit var executor: Executor
    private lateinit var biometricPrompt: BiometricPrompt
    private lateinit var promptInfo: BiometricPrompt.PromptInfo
    
    fun setupBiometric(onSuccess: () -> Unit, onError: (String) -> Unit) {
        executor = ContextCompat.getMainExecutor(activity)
        
        biometricPrompt = BiometricPrompt(activity, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(
                    result: BiometricPrompt.AuthenticationResult
                ) {
                    super.onAuthenticationSucceeded(result)
                    onSuccess()
                }
                
                override fun onAuthenticationError(
                    errorCode: Int,
                    errString: CharSequence
                ) {
                    super.onAuthenticationError(errorCode, errString)
                    onError(errString.toString())
                }
                
                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    onError("Autenticación fallida")
                }
            })
        
        promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Iniciar sesión")
            .setSubtitle("Usa tu huella digital para acceder")
            .setNegativeButtonText("Usar contraseña")
            .build()
    }
    
    fun authenticate() {
        biometricPrompt.authenticate(promptInfo)
    }
}
```

---

## 5. 📦 GitHub Secrets para CI/CD

### 5.1 Secrets Necesarios

Configura en `Settings → Secrets and variables → Actions`:

| Secret | Descripción |
|--------|-------------|
| `KEYSTORE_BASE64` | Keystore codificado en base64 |
| `KEYSTORE_PASSWORD` | Contraseña del keystore |
| `KEY_ALIAS` | Alias de la key |
| `KEY_PASSWORD` | Contraseña de la key |
| `PLAY_SERVICE_ACCOUNT_JSON` | Service account para Play Console |

### 5.2 Codificar Keystore

```bash
# En terminal local
base64 -i your-keystore.jks -o keystore_base64.txt
# Copia el contenido y pégalo en KEYSTORE_BASE64
```

---

## 6. 🎨 Assets 4K y Diseño

### 6.1 Estructura de Assets

```
assets/
├── images/
│   ├── logo.png (512x512)
│   ├── logo_4k.png (2048x2048)
│   ├── onboarding/
│   │   ├── screen1_4k.webp (3840x2160)
│   │   ├── screen2_4k.webp (3840x2160)
│   │   └── screen3_4k.webp (3840x2160)
│   ├── roulette/
│   │   ├── european_wheel.png
│   │   ├── american_wheel.png
│   │   └── table_layout.png
│   └── marketing/
│       ├── feature_graphic.png (1024x500)
│       └── screenshots/
│           ├── screenshot_1.png (1080x1920)
│           ├── screenshot_2.png (1080x1920)
│           └── ...
├── animations/
│   └── wheel_spin.json (Lottie)
└── icons/
    └── (vectores SVG)
```

### 6.2 Paleta de Colores Recomendada

```dart
// lib/core/app_colors.dart
class AppColors {
  // Primarios (basados en tu logo)
  static const primary = Color(0xFF1A237E);       // Azul oscuro
  static const primaryLight = Color(0xFF534BAE);  // Azul medio
  static const primaryDark = Color(0xFF000051);   // Azul muy oscuro
  
  // Acentos
  static const accent = Color(0xFF7C4DFF);        // Púrpura neón
  static const accentLight = Color(0xFFB47CFF);   // Púrpura claro
  
  // Fondos
  static const background = Color(0xFF121212);    // Fondo oscuro
  static const surface = Color(0xFF1E1E1E);       // Superficie cards
  
  // Texto
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
  
  // Estados
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFB300);
  
  // Ruleta
  static const rouletteRed = Color(0xFFE53935);
  static const rouletteBlack = Color(0xFF212121);
  static const rouletteGreen = Color(0xFF4CAF50);
}
```

### 6.3 Tipografía

```dart
// lib/core/app_typography.dart
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get headline1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  
  static TextStyle get headline2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle get body1 => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static TextStyle get body2 => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );
}
```

---

## 7. 🔧 Configuración de ProGuard/R8

### 7.1 proguard-rules.pro

```proguard
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Play Billing
-keep class com.android.vending.billing.** { *; }

# Biometric
-keep class androidx.biometric.** { *; }

# JSON / Serialization
-keepattributes *Annotation*
-keepattributes Signature
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Prevent obfuscation of models
-keep class com.tokyoia.roulette.models.** { *; }
```

### 7.2 build.gradle (app level)

```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## 8. ✅ Checklist de Configuración

### Pre-desarrollo
- [ ] Logo preparado en todos los tamaños
- [ ] Adaptive icon configurado
- [ ] AndroidManifest.xml con permisos correctos
- [ ] Paleta de colores definida
- [ ] Tipografías seleccionadas

### Desarrollo
- [ ] Navegación drawer implementada
- [ ] Rutas configuradas
- [ ] Biometría integrada
- [ ] Firebase configurado
- [ ] ProGuard configurado

### Pre-publicación
- [ ] Keystore creado y respaldado
- [ ] Secrets en GitHub configurados
- [ ] Screenshots para Play Store
- [ ] Feature graphic lista
- [ ] Política de privacidad publicada
- [ ] Build AAB sin errores

---

*Guía v1.0 - Noviembre 2024*
