#!/bin/bash
set -e

echo "🎰 Configurando entorno de desarrollo para Simulador de Ruleta..."

# Instalar ML-Agents
pip install --upgrade pip
pip install mlagents==1.0.0
pip install torch tensorboard onnx

# Instalar Unity Hub (headless para CLI)
wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -
sudo sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
sudo apt update
sudo apt install -y unityhub

# Activar licencia de Unity (requiere credenciales)
echo "⚠️  Configura tu licencia de Unity con: unity-editor -quit -batchmode -serial YOUR-SERIAL"

# Instalar Android SDK
sudo apt install -y android-sdk

echo "✅ Entorno configurado. Ejecuta 'bash scripts/train-ml-agents.sh' para entrenar la IA."
