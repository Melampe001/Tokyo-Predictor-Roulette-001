#!/bin/bash
# Script de validación de configuración Android para Tokyo Roulette Predictor
# Este script verifica que todos los archivos de configuración estén correctos

echo "=================================="
echo "Validación de Configuración Android"
echo "=================================="
echo ""

ERRORS=0
WARNINGS=0

# Función para mostrar OK
show_ok() {
    echo "✅ $1"
}

# Función para mostrar error
show_error() {
    echo "❌ $1"
    ERRORS=$((ERRORS + 1))
}

# Función para mostrar advertencia
show_warning() {
    echo "⚠️  $1"
    WARNINGS=$((WARNINGS + 1))
}

# Verificar archivos de configuración Gradle
echo "1. Verificando archivos de configuración Gradle..."
echo ""

if [ -f "android/build.gradle" ]; then
    show_ok "android/build.gradle existe"
    if grep -q "kotlin_version = '1.9.22'" android/build.gradle; then
        show_ok "Kotlin version 1.9.22 configurado"
    else
        show_error "Kotlin version incorrecta"
    fi
    if grep -q "com.android.tools.build:gradle:8.1.4" android/build.gradle; then
        show_ok "Android Gradle Plugin 8.1.4 configurado"
    else
        show_error "AGP version incorrecta"
    fi
else
    show_error "android/build.gradle no existe"
fi

if [ -f "android/app/build.gradle" ]; then
    show_ok "android/app/build.gradle existe"
    if grep -q 'namespace "com.tokyoapps.roulette"' android/app/build.gradle; then
        show_ok "Namespace correcto: com.tokyoapps.roulette"
    else
        show_error "Namespace incorrecto"
    fi
    if grep -q "minSdkVersion 23" android/app/build.gradle; then
        show_ok "minSdkVersion 23 configurado"
    else
        show_error "minSdkVersion incorrecto"
    fi
    if grep -q "compileSdkVersion 34" android/app/build.gradle; then
        show_ok "compileSdkVersion 34 configurado"
    else
        show_error "compileSdkVersion incorrecto"
    fi
else
    show_error "android/app/build.gradle no existe"
fi

if [ -f "android/settings.gradle" ]; then
    show_ok "android/settings.gradle existe"
else
    show_error "android/settings.gradle no existe"
fi

if [ -f "android/gradle.properties" ]; then
    show_ok "android/gradle.properties existe"
    if grep -q "android.useAndroidX=true" android/gradle.properties; then
        show_ok "AndroidX habilitado"
    else
        show_error "AndroidX no habilitado"
    fi
else
    show_error "android/gradle.properties no existe"
fi

if [ -f "android/gradle/wrapper/gradle-wrapper.properties" ]; then
    show_ok "gradle-wrapper.properties existe"
    if grep -q "gradle-8.4-all.zip" android/gradle/wrapper/gradle-wrapper.properties; then
        show_ok "Gradle 8.4 configurado"
    else
        show_error "Gradle version incorrecta"
    fi
else
    show_error "gradle-wrapper.properties no existe"
fi

echo ""
echo "2. Verificando código fuente Android..."
echo ""

if [ -f "android/app/src/main/kotlin/com/tokyoapps/roulette/MainActivity.kt" ]; then
    show_ok "MainActivity.kt existe en el paquete correcto"
    if grep -q "package com.tokyoapps.roulette" android/app/src/main/kotlin/com/tokyoapps/roulette/MainActivity.kt; then
        show_ok "Package name correcto en MainActivity"
    else
        show_error "Package name incorrecto en MainActivity"
    fi
else
    show_error "MainActivity.kt no existe en la ubicación correcta"
fi

echo ""
echo "3. Verificando AndroidManifest.xml..."
echo ""

if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    show_ok "AndroidManifest.xml existe"
    if grep -q 'package="com.tokyoapps.roulette"' android/app/src/main/AndroidManifest.xml; then
        show_ok "Package correcto en AndroidManifest"
    else
        show_error "Package incorrecto en AndroidManifest"
    fi
    if grep -q "android.permission.INTERNET" android/app/src/main/AndroidManifest.xml; then
        show_ok "Permiso INTERNET configurado"
    else
        show_error "Permiso INTERNET no configurado"
    fi
    if grep -q "io.flutter.embedding.android.NormalTheme" android/app/src/main/AndroidManifest.xml; then
        show_ok "NormalTheme meta-data configurado"
    else
        show_warning "NormalTheme meta-data no configurado"
    fi
else
    show_error "AndroidManifest.xml no existe"
fi

echo ""
echo "4. Verificando recursos (styles, icons)..."
echo ""

if [ -f "android/app/src/main/res/values/styles.xml" ]; then
    show_ok "styles.xml existe"
    if grep -q "LaunchTheme" android/app/src/main/res/values/styles.xml; then
        show_ok "LaunchTheme definido"
    else
        show_error "LaunchTheme no definido"
    fi
    if grep -q "NormalTheme" android/app/src/main/res/values/styles.xml; then
        show_ok "NormalTheme definido"
    else
        show_error "NormalTheme no definido"
    fi
else
    show_error "styles.xml no existe"
fi

if [ -f "android/app/src/main/res/values-night/styles.xml" ]; then
    show_ok "styles.xml (night mode) existe"
else
    show_warning "styles.xml (night mode) no existe"
fi

# Verificar iconos
ICON_COUNT=$(find android/app/src/main/res -name "ic_launcher.png" 2>/dev/null | wc -l)
if [ "$ICON_COUNT" -ge 5 ]; then
    show_ok "Launcher icons encontrados ($ICON_COUNT densidades)"
else
    show_error "Launcher icons insuficientes (encontrados: $ICON_COUNT, esperados: >= 5)"
fi

if [ -f "android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml" ]; then
    show_ok "Adaptive icon (API 26+) configurado"
else
    show_warning "Adaptive icon no configurado"
fi

echo ""
echo "5. Verificando local.properties..."
echo ""

if [ -f "android/local.properties" ]; then
    show_ok "local.properties existe"
    if grep -q "flutter.sdk=" android/local.properties; then
        FLUTTER_SDK=$(grep "flutter.sdk=" android/local.properties | cut -d= -f2)
        show_ok "Flutter SDK path: $FLUTTER_SDK"
    else
        show_error "Flutter SDK path no configurado"
    fi
else
    show_error "local.properties no existe"
fi

echo ""
echo "6. Verificando documentación..."
echo ""

if [ -f "docs/ANDROID_BUILD_SETUP.md" ]; then
    show_ok "ANDROID_BUILD_SETUP.md existe"
else
    show_warning "ANDROID_BUILD_SETUP.md no existe"
fi

if [ -f "docs/QUICK_BUILD_GUIDE.md" ]; then
    show_ok "QUICK_BUILD_GUIDE.md existe"
else
    show_warning "QUICK_BUILD_GUIDE.md no existe"
fi

echo ""
echo "=================================="
echo "Resumen de Validación"
echo "=================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ ¡TODO PERFECTO! La configuración está lista para build."
    echo ""
    echo "Siguiente paso:"
    echo "  flutter build apk --release"
    echo ""
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "✅ Configuración válida con $WARNINGS advertencia(s)."
    echo ""
    echo "La configuración debería funcionar, pero hay algunas advertencias."
    echo ""
    echo "Siguiente paso:"
    echo "  flutter build apk --release"
    echo ""
    exit 0
else
    echo "❌ Se encontraron $ERRORS error(es) y $WARNINGS advertencia(s)."
    echo ""
    echo "Por favor, corrige los errores antes de intentar el build."
    echo ""
    exit 1
fi
