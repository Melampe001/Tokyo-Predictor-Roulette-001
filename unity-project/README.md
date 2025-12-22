# Unity ML-Agents Roulette Simulator

Este directorio contiene el proyecto Unity para el simulador de ruleta con IA predictiva usando ML-Agents.

## 📁 Estructura del Proyecto

```
unity-project/
├── Assets/
│   └── Scripts/
│       ├── RouletteAgent.cs          # Agente ML-Agents con algoritmo PPO
│       ├── RouletteController.cs     # Controlador de lógica de juego
│       └── AISentisInference.cs      # Inferencia ONNX en dispositivos móviles
├── Library/                          # Generado por Unity (ignorado en git)
├── Temp/                             # Archivos temporales (ignorado en git)
└── ProjectSettings/                  # Configuración del proyecto Unity
```

## 🚀 Inicio Rápido

### Requisitos Previos
- Unity 2022.3 LTS o superior
- Unity ML-Agents Package instalado
- Python 3.10 con ML-Agents Toolkit

### Instalación

1. **Abrir en Unity Hub:**
   ```bash
   unity-hub --projectPath /path/to/unity-project
   ```

2. **Instalar ML-Agents Package:**
   - Window → Package Manager
   - Add package from git URL: `com.unity.ml-agents`

3. **Instalar Unity Sentis:**
   - Window → Package Manager
   - Add package from git URL: `com.unity.sentis`

### Entrenamiento del Agente

1. **Iniciar entrenamiento desde raíz del repositorio:**
   ```bash
   cd /path/to/Tokyo-Predictor-Roulette-001
   bash scripts/train-ml-agents.sh
   ```

2. **Monitorear progreso con TensorBoard:**
   ```bash
   tensorboard --logdir results/ --port 6006
   ```

3. **Exportar modelo a ONNX:**
   - Después del entrenamiento, el modelo se exporta automáticamente
   - Ubicación: `results/roulette-predictor-v1/*.onnx`

## 🎮 Componentes Principales

### RouletteAgent.cs
Agente de ML-Agents que aprende a predecir resultados de ruleta:

**Observaciones:**
- Últimos 10 números normalizados (0-1)
- Color del último resultado (rojo/negro)
- Velocidad de la bola
- Velocidad de rotación de la ruleta

**Acciones:**
- 0: Sugerir apuesta a Rojo
- 1: Sugerir apuesta a Negro
- 2: Sugerir apuesta a Par
- 3: Sugerir apuesta a Impar
- 4: Sugerir número "caliente"

**Sistema de Recompensas:**
- +1.0: Predicción de número caliente correcta
- +0.1: Sugerencia de color/par/impar correcta
- -0.05: Predicción incorrecta
- +2.0: Bonus por racha de 3+ aciertos

### RouletteController.cs
Controlador que gestiona:
- Estado del juego (números anteriores, frecuencias)
- Identificación de números "calientes" (≥3 apariciones)
- Validación de resultados contra predicciones
- Visualización de sugerencias de IA

### AISentisInference.cs
Motor de inferencia ONNX para ejecución en dispositivos:
- Carga modelo ONNX entrenado
- Ejecuta inferencia en GPU móvil (GPUCompute backend)
- Optimizado para latencia < 50ms
- Manejo eficiente de memoria

## 🔧 Configuración

### Parámetros de Entrenamiento
Ver `ml-agents-config/trainer_config.yaml` en la raíz del repositorio:

```yaml
behaviors:
  RoulettePredictor:
    trainer_type: ppo
    max_steps: 500000
    batch_size: 64
    learning_rate: 3.0e-4
    hidden_units: 128
    num_layers: 2
```

### Ajustar Recompensas
Editar `RouletteAgent.cs` método `EvaluateSpin()`:
```csharp
public void EvaluateSpin(int winningNumber) {
    if (table.IsHotNumber(winningNumber)) {
        AddReward(1.0f);  // Ajustar según necesidad
    } else {
        AddReward(-0.05f);
    }
    EndEpisode();
}
```

## 📊 Testing del Agente

### Modo Manual (Heuristic)
Para probar manualmente:
1. Presiona `R` para sugerir Rojo
2. Presiona `N` para sugerir Negro
3. Observa las recompensas en consola

### Modo Entrenamiento
El agente aprende automáticamente durante el entrenamiento con `mlagents-learn`.

### Modo Inferencia
Una vez entrenado, el modelo ONNX se usa para predicciones en tiempo real.

## 🎯 Performance Targets

- **Tiempo de Inferencia**: < 50ms en dispositivos móviles
- **Tamaño de Modelo**: < 10 MB ONNX
- **Precisión**: > 25% (baseline aleatoria: 18%)
- **FPS en Unity**: ≥ 60 FPS

## 🐛 Troubleshooting

### Error: "ML-Agents package not found"
Solución: Instalar desde Package Manager con URL:
```
com.unity.ml-agents
```

### Error: "Python mlagents-learn not found"
Solución: Instalar ML-Agents toolkit:
```bash
pip install mlagents==1.0.0
```

### Error: "Unity license not activated"
Solución: Activar licencia personal o pro:
```bash
unity-editor -quit -batchmode -serial YOUR-SERIAL-KEY
```

## 📚 Recursos

- [Unity ML-Agents Documentation](https://github.com/Unity-Technologies/ml-agents/blob/main/docs/Readme.md)
- [Unity Sentis Manual](https://docs.unity3d.com/Packages/com.unity.sentis@latest)
- [PPO Algorithm Explanation](https://spinningup.openai.com/en/latest/algorithms/ppo.html)

## ⚠️ Notas Importantes

1. **No commitear** archivos de `Library/`, `Temp/`, o builds
2. Los modelos entrenados (`.onnx`) van en `results/` (ignorado en git)
3. Para producción, exportar modelo ONNX y copiarlo a `Assets/Models/`
4. Siempre usar `Random.secure()` para RNG en C#

## 📝 Licencia

Este proyecto Unity está bajo la misma licencia MIT del repositorio principal.

---

**Versión**: 1.0.0  
**Unity Version**: 2022.3 LTS  
**ML-Agents**: 1.0.0  
**Última Actualización**: Diciembre 2024
