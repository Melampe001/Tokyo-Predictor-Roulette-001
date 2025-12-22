#!/bin/bash
set -e

echo "🤖 Iniciando entrenamiento de ML-Agents (RoulettePredictor)..."

# Verificar que Unity esté corriendo
if ! pgrep -x "Unity" > /dev/null; then
    echo "⚠️  Iniciando Unity en modo headless..."
    unity-editor -projectPath ./unity-project -quit -batchmode -executeMethod MLAgentsSetup.StartTraining &
    sleep 10
fi

# Entrenar con configuración optimizada
mlagents-learn ml-agents-config/trainer_config.yaml --run-id=roulette-predictor-v1 --force

echo "✅ Entrenamiento completado. Modelo guardado en: results/roulette-predictor-v1/"
echo "📊 Ver métricas en TensorBoard: tensorboard --logdir results/"
