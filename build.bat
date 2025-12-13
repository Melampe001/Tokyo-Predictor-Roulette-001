@echo off
REM Build script para Tokyo Roulette Predicciones (Windows)
REM Este script automatiza el proceso de build del APK

echo.
echo 🎰 Tokyo Roulette Predicciones - Build Script (Windows)
echo =======================================================
echo.

REM Verificar que Flutter está instalado
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error: Flutter no está instalado o no está en el PATH
    echo Por favor instala Flutter desde: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter encontrado
flutter --version | findstr /C:"Flutter"
echo.

REM Verificar estado de Flutter
echo 📋 Verificando instalación de Flutter...
flutter doctor -v
echo.

REM Limpiar builds anteriores
echo 🧹 Limpiando builds anteriores...
flutter clean
echo.

REM Obtener dependencias
echo 📦 Instalando dependencias...
flutter pub get
echo.

REM Analizar código
echo 🔍 Analizando código...
flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Advertencia: Se encontraron problemas en el análisis de código
    choice /C SN /M "¿Continuar de todos modos?"
    if errorlevel 2 exit /b 1
)
echo.

REM Ejecutar tests
echo 🧪 Ejecutando tests...
flutter test
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Advertencia: Algunos tests fallaron
    choice /C SN /M "¿Continuar de todos modos?"
    if errorlevel 2 exit /b 1
)
echo.

REM Build APK
echo 🔨 Construyendo APK de producción...
flutter build apk --release
echo.

REM Verificar que el APK fue creado
set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
if exist "%APK_PATH%" (
    echo ✅ ¡Build exitoso!
    echo.
    echo 📱 APK generado en:
    echo    %APK_PATH%
    echo.
    echo 🎉 ¡Listo! Ahora puedes instalar el APK en tu dispositivo Android
    echo.
    echo Para instalar:
    echo   1. Copia el APK a tu dispositivo Android
    echo   2. Abre el archivo en tu dispositivo
    echo   3. Permite instalación de fuentes desconocidas si es necesario
    echo   4. ¡Instala y disfruta!
) else (
    echo ❌ Error: No se pudo generar el APK
    pause
    exit /b 1
)

echo.
pause
