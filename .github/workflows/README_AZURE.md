# NOTA sobre azure-webapps-node.yml.disabled

Este archivo de workflow está deshabilitado porque:

1. **Tokyo Roulette Predicciones es una aplicación Flutter**, no una aplicación Node.js
2. El proyecto no requiere un backend web Node.js desplegado en Azure
3. Si en el futuro necesitas un backend, considera:
   - Firebase Cloud Functions (recomendado para este proyecto)
   - Azure Functions
   - Cualquier otro servicio serverless

## Si necesitas habilitar este workflow:

1. Renombra el archivo a `azure-webapps-node.yml`
2. Configura las variables de entorno:
   - `AZURE_WEBAPP_NAME`: Nombre de tu app en Azure
   - `AZURE_WEBAPP_PUBLISH_PROFILE`: Perfil de publicación (secret)
3. Crea el proyecto Node.js correspondiente
4. Agrega `package.json` con scripts de build y test

## Alternativa recomendada: Firebase

Para este proyecto, se recomienda usar Firebase Cloud Functions:

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Inicializar functions
firebase init functions

# Desplegar
firebase deploy --only functions
```

Ver [docs/FIREBASE_SETUP.md](../../docs/FIREBASE_SETUP.md) y [docs/STRIPE_SETUP.md](../../docs/STRIPE_SETUP.md) para más detalles.
