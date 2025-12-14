#!/bin/bash
# Script de desarrollo rápido con hot reload

echo "🔥 Modo Desarrollo - Hot Reload Activo"
echo "======================================"
echo ""

# Verificar si hay dispositivos conectados
DEVICES=$(flutter devices 2>&1)

if echo "$DEVICES" | grep -q "No devices found"; then
    echo "❌ No hay dispositivos conectados"
    echo ""
    echo "Opciones:"
    echo "  1. Conectar un dispositivo Android físico"
    echo "  2. Iniciar un emulador Android"
    echo "  3. Usar Chrome para web: flutter run -d chrome"
    echo "  4. Usar Linux desktop: flutter run -d linux"
    exit 1
fi

echo "📱 Dispositivos disponibles:"
flutter devices
echo ""

# Ejecutar en modo debug con hot reload
echo "🚀 Iniciando aplicación en modo debug..."
echo "💡 Presiona 'r' para hot reload"
echo "💡 Presiona 'R' para hot restart"
echo "💡 Presiona 'q' para salir"
echo ""

flutter run --debug
