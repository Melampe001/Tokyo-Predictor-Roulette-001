# TokyoIA Roulette Predictor — Repo Starter

Este repositorio contiene la documentación y los assets iniciales para la app **TokyoIA Roulette Predictor**.

---

## 📁 Estructura del Repositorio

```
tokyoia-roulette-predictor/
├── .github/
│   └── workflows/
│       ├── build-apk.yml          # Build APK para testing
│       └── build-aab.yml          # Build AAB para Play Store
├── android/                        # Código Android/Flutter
├── docs/
│   ├── privacy-policy.md          # Política de privacidad
│   ├── user-manual.md             # Manual de usuario
│   ├── setup-guide.md             # Guía de configuración
│   ├── play-store-listing.md      # Best practices Play Store
│   ├── marketing-guide.md         # Guía de marketing
│   ├── features-marketplace.md    # Features del marketplace
│   └── checklist_agents.md        # Checklist de agentes
├── lib/                            # Código Flutter
│   ├── core/                       # Servicios base
│   ├── features/                   # Features por dominio
│   ├── models/                     # Modelos de datos
│   └── README.md                   # Documentación de estructura
├── marketing_pack/                 # Assets de marketing
│   └── README.md                   # Guía de assets
├── menu/                           # Archivos de menú XML
│   └── drawer_menu.xml             # Menú lateral
├── test/                           # Tests
├── pubspec.yaml                    # Dependencias Flutter
├── README.md                       # Este archivo
└── LEGAL-README.md                 # Información legal
```

---

## 🚀 Instrucciones Rápidas

### 1. Configuración Inicial

```bash
# Clonar repositorio
git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
cd Tokyo-Predictor-Roulette-001

# Instalar dependencias
flutter pub get

# Ejecutar en desarrollo
flutter run
```

### 2. Reemplazar Placeholders

Busca y reemplaza estos valores en todo el proyecto:

| Placeholder | Reemplazar con |
|-------------|----------------|
| `privacy@tokyoia-apps.com` | Tu email real de privacidad |
| `support@tokyoia-apps.com` | Tu email real de soporte |
| `https://tokyoia-apps.com` | Tu dominio real |
| `com.tokyoia.roulette.predictor` | Tu package name |

### 3. Añadir Assets

Coloca tus assets en las siguientes ubicaciones:

```
android/app/src/main/res/
├── mipmap-hdpi/
│   ├── ic_launcher.png (72x72)
│   └── ic_launcher_foreground.png (162x162)
├── mipmap-mdpi/
│   ├── ic_launcher.png (48x48)
│   └── ic_launcher_foreground.png (108x108)
├── mipmap-xhdpi/
│   ├── ic_launcher.png (96x96)
│   └── ic_launcher_foreground.png (216x216)
├── mipmap-xxhdpi/
│   ├── ic_launcher.png (144x144)
│   └── ic_launcher_foreground.png (324x324)
└── mipmap-xxxhdpi/
    ├── ic_launcher.png (192x192)
    └── ic_launcher_foreground.png (432x432)

marketing_pack/
├── feature_graphic.png (1024x500)
├── screenshots/
│   ├── phone_01.png (1080x1920)
│   ├── phone_02.png (1080x1920)
│   ├── phone_03.png (1080x1920)
│   └── phone_04.png (1080x1920)
└── promo_video.mp4 (opcional)
```

### 4. Configurar GitHub Secrets

En tu repositorio: `Settings → Secrets and variables → Actions`

| Secret | Descripción |
|--------|-------------|
| `KEYSTORE_BASE64` | Keystore codificado en base64 |
| `KEYSTORE_PASSWORD` | Contraseña del keystore |
| `KEY_ALIAS` | Alias de la key |
| `KEY_PASSWORD` | Contraseña de la key |
| `SERVICE_ACCOUNT_JSON` | (Opcional) Para deploy automático a Play |

#### Cómo generar KEYSTORE_BASE64:

```bash
# Generar keystore (si no tienes uno)
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Codificar en base64
base64 -i my-release-key.jks -o keystore_base64.txt

# Copiar contenido de keystore_base64.txt al secret
```

### 5. Configurar Play Console

1. **Crear app** en [Google Play Console](https://play.google.com/console)
2. **Activar Play App Signing** (recomendado)
3. **Subir AAB** desde GitHub Actions artifacts
4. **Configurar productos** de suscripción:
   - `advanced_monthly`
   - `advanced_6months`
   - `advanced_yearly`
   - `premium_monthly`
   - `premium_yearly`

---

## 📋 Archivos Incluidos

| Archivo | Descripción |
|---------|-------------|
| `docs/features-marketplace.md` | Lista completa de features |
| `docs/play-store-listing.md` | Best practices para Play Store |
| `docs/marketing-guide.md` | Guía de marketing y social media |
| `docs/privacy-policy.md` | Política de privacidad |
| `docs/user-manual.md` | Manual de usuario |
| `docs/setup-guide.md` | Guía técnica de configuración |
| `.github/workflows/build-aab.yml` | Workflow para build AAB |
| `lib/README.md` | Checklist completo del proyecto |

---

## ✅ Checklist de Lanzamiento

### Pre-desarrollo
- [ ] Logo y assets preparados
- [ ] Cuenta de Google Play Developer ($25)
- [ ] Firebase project creado
- [ ] Keystore generado y respaldado

### Desarrollo
- [ ] Funcionalidades core implementadas
- [ ] Estrategias (Martingale, Fibonacci, D'Alembert, Paroli)
- [ ] Google Play Billing integrado
- [ ] Firebase Auth configurado
- [ ] Tests básicos pasando

### Pre-publicación
- [ ] Privacy policy publicada (URL activa)
- [ ] Screenshots preparados (mín. 4)
- [ ] Feature graphic lista
- [ ] Descripción en español e inglés
- [ ] Content rating completado
- [ ] Internal testing exitoso

### Publicación
- [ ] AAB firmado y subido
- [ ] Productos de suscripción activos
- [ ] Closed testing con feedback
- [ ] Gradual rollout configurado

---

## 🔗 Enlaces Útiles

- [Google Play Console](https://play.google.com/console)
- [Firebase Console](https://console.firebase.google.com)
- [Flutter Documentation](https://flutter.dev/docs)
- [Play Store Guidelines](https://support.google.com/googleplay/android-developer)

---

## ⚠️ Notas Legales

- Esta app es un **SIMULADOR EDUCATIVO**
- **NO** es una aplicación de apuestas reales
- **NO** predice resultados de casinos
- El programa de referidos es de **1 solo nivel** (no pirámide)
- Cumple con políticas de Google Play

---

## 📞 Soporte

- **Email**: support@tokyoia-apps.com
- **Issues**: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

---

**TokyoIA Apps** © 2024
