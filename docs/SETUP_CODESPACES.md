# 🚀 Guía de Inicio Rápido en Codespaces

## 1. Abrir el Proyecto
1. Ve a GitHub → Code → Codespaces → Create codespace on main
2. Espera 3-5 minutos mientras se configura el entorno

## 2. Verificar Instalación
```bash
# Verificar ML-Agents
mlagents-learn --version

# Verificar Unity
unity-editor -version
```

## 3. Entrenar el Agente de IA
```bash
bash scripts/train-ml-agents.sh
```

## 4. Construir APK para Android
```bash
bash scripts/build-android.sh
```

## 5. Ver Métricas de Entrenamiento
```bash
tensorboard --logdir results/ --port 6006
```

## ⚠️ Requisitos
- Licencia de Unity (Personal o Pro)
- Credenciales de Android Keystore para firma de APK
