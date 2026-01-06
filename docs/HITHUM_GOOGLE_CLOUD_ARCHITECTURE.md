# Arquitectura HiThum - Google Cloud Integration

## Resumen Ejecutivo

Arquitectura para integrar HiThum (frontend en Vercel) con Google Cloud, incluyendo autenticación, backend y agentes de IA automatizados con controles de seguridad y monitoreo completo.

---

## 1. Arquitectura Recomendada

### 1.1 Arquitectura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────┐
│                     CAPA DE PRESENTACIÓN                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Frontend (Vercel)                                    │  │
│  │  - Next.js / React / Vue                             │  │
│  │  - Firebase SDK (Auth, Firestore)                    │  │
│  │  - API Cliente (axios/fetch)                         │  │
│  └────────────────┬─────────────────────────────────────┘  │
└────────────────────┼────────────────────────────────────────┘
                     │
                     │ HTTPS / Firebase Auth Token
                     │
┌────────────────────▼────────────────────────────────────────┐
│                  CAPA DE AUTENTICACIÓN                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Firebase Authentication                             │  │
│  │  - Email/Password, Google, Apple                     │  │
│  │  - JWT Tokens con claims personalizados             │  │
│  │  - Identity Platform (opcional: MFA, SSO)            │  │
│  └────────────────┬─────────────────────────────────────┘  │
└────────────────────┼────────────────────────────────────────┘
                     │
                     │ Auth Token Validation
                     │
┌────────────────────▼────────────────────────────────────────┐
│                    CAPA DE SERVICIOS                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Cloud Run / Cloud Functions                       │    │
│  │                                                     │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────┐ │    │
│  │  │ API Gateway  │  │  AI Agents   │  │ Workers │ │    │
│  │  │              │  │              │  │         │ │    │
│  │  │ - REST APIs  │  │ - Gemini     │  │ - Jobs  │ │    │
│  │  │ - GraphQL    │  │ - Vertex AI  │  │ - Cron  │ │    │
│  │  │ - Webhooks   │  │ - PaLM 2     │  │ - Queue │ │    │
│  │  └──────┬───────┘  └──────┬───────┘  └────┬────┘ │    │
│  └─────────┼─────────────────┼────────────────┼──────┘    │
└────────────┼─────────────────┼────────────────┼───────────┘
             │                 │                │
             │                 │                │
┌────────────▼─────────────────▼────────────────▼───────────┐
│                    CAPA DE DATOS                            │
│  ┌────────────────┐  ┌────────────┐  ┌─────────────────┐  │
│  │   Firestore    │  │  Cloud     │  │  Secret         │  │
│  │                │  │  Storage   │  │  Manager        │  │
│  │ - Users        │  │            │  │                 │  │
│  │ - Content      │  │ - Files    │  │ - API Keys      │  │
│  │ - Logs         │  │ - Media    │  │ - Credentials   │  │
│  │ - AI Actions   │  │ - Backups  │  │ - Configs       │  │
│  └────────────────┘  └────────────┘  └─────────────────┘  │
└────────────────────────────────────────────────────────────┘
                     │
                     │
┌────────────────────▼────────────────────────────────────────┐
│              CAPA DE MONITOREO Y LOGGING                     │
│  ┌────────────────┐  ┌────────────┐  ┌─────────────────┐  │
│  │  Cloud         │  │  Cloud     │  │  Cloud          │  │
│  │  Logging       │  │  Monitoring│  │  Trace          │  │
│  │                │  │            │  │                 │  │
│  │ - Request logs │  │ - Métricas │  │ - Distributed   │  │
│  │ - AI decisions │  │ - Alertas  │  │   tracing       │  │
│  │ - Errors       │  │ - Dashboards│ │ - Performance   │  │
│  └────────────────┘  └────────────┘  └─────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

### 1.2 Flujo de Petición Completo

```
Usuario → Vercel Frontend → Firebase Auth → Cloud Run API →
  → Valida Token → Verifica Permisos → Ejecuta Lógica →
  → (Opcional) Invoca AI Agent → Guarda Log → Firestore →
  → Retorna Respuesta → Frontend → Usuario
```

### 1.3 Componentes Clave

1. **Frontend (Vercel)**
   - Hosting estático optimizado con CDN global
   - Server-Side Rendering (SSR) / Static Site Generation (SSG)
   - Firebase SDK para auth y Firestore en tiempo real
   - API REST cliente para servicios backend

2. **Autenticación (Firebase Auth)**
   - Gestión de identidades sin servidor
   - Tokens JWT con claims personalizados (roles, permisos)
   - Integración con Identity Platform para MFA/SSO empresarial

3. **Backend (Cloud Run)**
   - Contenedores serverless con autoescalado
   - Más flexible que Cloud Functions (no límites de ejecución estrictos)
   - Soporta cualquier lenguaje (Node.js, Python, Go, etc.)
   - Manejo de tráfico con canary deployments

4. **AI Agents (Vertex AI + Cloud Run)**
   - Gemini Pro / PaLM 2 para generación de contenido
   - Vertex AI Workbench para modelos custom
   - Cloud Tasks para ejecución asíncrona con reintentos
   - Rate limiting por usuario/proyecto

5. **Datos (Firestore + Cloud Storage)**
   - Firestore: Base de datos NoSQL en tiempo real
   - Cloud Storage: Archivos multimedia
   - Security Rules para control granular de acceso

6. **Monitoreo (Cloud Operations Suite)**
   - Cloud Logging para todos los logs
   - Cloud Monitoring para métricas y alertas
   - Error Reporting para tracking de errores
   - Cloud Trace para análisis de latencia

### 1.4 Principios de Seguridad

- **Zero Trust**: Todo request requiere autenticación
- **Least Privilege**: Permisos mínimos por servicio
- **Defense in Depth**: Múltiples capas de validación
- **Audit Everything**: Log de todas las acciones sensibles
- **Rate Limiting**: Protección contra abuso

---

## 2. Servicios Específicos de Google Cloud

### 2.1 Autenticación y Datos

#### Firebase Authentication
- **Propósito**: Gestión de usuarios y autenticación
- **Métodos soportados**:
  - Email/Password
  - Google Sign-In
  - Apple Sign-In
  - Anonymous Auth (para usuarios guest)
- **Features**:
  - Custom Claims para roles (admin, premium, free)
  - Multi-factor Authentication (SMS, TOTP)
  - Email verification y password reset
- **Integración**: SDK en frontend, token validation en backend

#### Cloud Firestore
- **Propósito**: Base de datos principal
- **Colecciones recomendadas**:
  ```
  /users/{userId}
    - email, displayName, role, createdAt
    - settings, preferences, subscription
  
  /content/{contentId}
    - title, body, authorId, status
    - createdAt, updatedAt, tags
  
  /ai_logs/{logId}
    - userId, action, model, prompt
    - response, timestamp, duration, cost
  
  /notifications/{notificationId}
    - userId, type, message, read, timestamp
  ```
- **Security Rules**:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /users/{userId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow write: if request.auth != null && request.auth.uid == userId
                     && !request.resource.data.diff(resource.data).affectedKeys()
                        .hasAny(['role', 'subscription']);
      }
      
      match /ai_logs/{logId} {
        allow read: if request.auth != null && 
                    (request.auth.uid == resource.data.userId ||
                     request.auth.token.admin == true);
        allow write: if false; // Solo el backend puede escribir
      }
    }
  }
  ```

#### Cloud Storage
- **Propósito**: Almacenamiento de archivos
- **Buckets**:
  - `hithum-user-uploads`: Imágenes de usuarios
  - `hithum-generated-content`: Contenido generado por IA
  - `hithum-backups`: Backups automáticos
- **Security**: IAM roles + signed URLs con expiración

### 2.2 Ejecución de Agentes

#### Cloud Run
- **Propósito**: Backend APIs y AI Agent Services
- **Servicios recomendados**:
  1. `hithum-api`: API principal REST/GraphQL
  2. `hithum-ai-agent`: Servicio de agentes de IA
  3. `hithum-worker`: Jobs programados y async tasks
- **Configuración**:
  ```yaml
  # hithum-ai-agent
  apiVersion: serving.knative.dev/v1
  kind: Service
  metadata:
    name: hithum-ai-agent
  spec:
    template:
      spec:
        containers:
        - image: gcr.io/PROJECT_ID/hithum-ai-agent:latest
          env:
          - name: GEMINI_API_KEY
            valueFrom:
              secretKeyRef:
                name: gemini-api-key
                key: key
          resources:
            limits:
              memory: 2Gi
              cpu: 2000m
          timeoutSeconds: 300
        serviceAccountName: hithum-ai-agent@PROJECT_ID.iam.gserviceaccount.com
  ```
- **Ventajas**:
  - Autoescalado de 0 a N instancias
  - Solo paga por tiempo de ejecución
  - Integración nativa con Secret Manager
  - Tráfico split para canary deployments

#### Vertex AI (Gemini + PaLM 2)
- **Propósito**: Modelos de IA para automatización
- **Modelos recomendados**:
  - **Gemini Pro**: Generación de texto, resúmenes, clasificación
  - **Gemini Pro Vision**: Análisis de imágenes
  - **Text Embedding**: Búsqueda semántica
- **Ejemplo de uso**:
  ```python
  from vertexai.preview.generative_models import GenerativeModel
  
  model = GenerativeModel("gemini-pro")
  response = model.generate_content(
      prompt,
      generation_config={
          "max_output_tokens": 2048,
          "temperature": 0.4,
      }
  )
  ```
- **Control de costos**:
  - Cuotas por usuario/día
  - Timeouts configurables
  - Cache de respuestas frecuentes
  - Monitoreo de uso en tiempo real

#### Cloud Tasks
- **Propósito**: Ejecución asíncrona de agentes
- **Casos de uso**:
  - Procesamiento de lotes
  - Notificaciones programadas
  - Reintentos automáticos con backoff exponencial
- **Ejemplo**:
  ```python
  from google.cloud import tasks_v2
  
  client = tasks_v2.CloudTasksClient()
  task = {
      'http_request': {
          'http_method': tasks_v2.HttpMethod.POST,
          'url': 'https://hithum-ai-agent-xxx.run.app/process',
          'headers': {'Content-Type': 'application/json'},
          'body': json.dumps(payload).encode(),
          'oidc_token': {
              'service_account_email': 'ai-agent@PROJECT_ID.iam.gserviceaccount.com'
          }
      }
  }
  client.create_task(parent=queue_path, task=task)
  ```

### 2.3 Monitoreo y Logs

#### Cloud Logging
- **Propósito**: Centralizar todos los logs
- **Logs estructurados**:
  ```json
  {
    "severity": "INFO",
    "timestamp": "2025-12-23T00:00:00Z",
    "jsonPayload": {
      "userId": "user123",
      "action": "generate_summary",
      "model": "gemini-pro",
      "inputTokens": 150,
      "outputTokens": 300,
      "duration_ms": 1250,
      "cost_usd": 0.002,
      "status": "success"
    },
    "labels": {
      "service": "hithum-ai-agent",
      "environment": "production"
    }
  }
  ```
- **Retention**: 30 días por defecto (configurable hasta 3650 días)

#### Cloud Monitoring
- **Propósito**: Métricas y alertas
- **Dashboards**:
  1. **API Health**: Request rate, latency, errors
  2. **AI Agent Usage**: Invocaciones por usuario, costos
  3. **Firestore Performance**: Reads/writes, latency
  4. **Cloud Run Metrics**: CPU, memoria, instancias
- **Alertas configuradas**:
  - Error rate > 5% en 5 minutos
  - Latencia p95 > 2 segundos
  - Costo de IA por usuario > $10/día
  - Instancias de Cloud Run en máximo

#### Error Reporting
- **Propósito**: Tracking automático de errores
- **Integración**: Automática con Cloud Run/Functions
- **Features**:
  - Agrupación inteligente de errores similares
  - Stack traces completos
  - Notificaciones por email/Slack
  - Integración con issue trackers

#### Cloud Trace
- **Propósito**: Análisis de performance distribuida
- **Uso**: Identificar cuellos de botella en requests complejos
- **Ejemplo de trace**:
  ```
  Request → Cloud Run API (50ms)
    → Validate Token (10ms)
    → Query Firestore (30ms)
    → Call AI Agent (1200ms)
      → Vertex AI API (1150ms)
    → Write Log (20ms)
    → Return Response (5ms)
  Total: 1315ms
  ```

---

## 3. Pasos de Implementación

### Fase 1: Setup Inicial (Semana 1)

#### 3.1 Configurar Proyecto en Google Cloud
```bash
# Crear proyecto
gcloud projects create hithum-prod --name="HiThum Production"
gcloud config set project hithum-prod

# Habilitar APIs necesarias
gcloud services enable \
  cloudrun.googleapis.com \
  firestore.googleapis.com \
  firebase.googleapis.com \
  aiplatform.googleapis.com \
  cloudtasks.googleapis.com \
  secretmanager.googleapis.com \
  logging.googleapis.com \
  monitoring.googleapis.com

# Configurar facturación
gcloud billing projects link hithum-prod --billing-account=BILLING_ACCOUNT_ID

# Configurar región por defecto
gcloud config set run/region us-central1
```

#### 3.2 Setup Firebase
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login y crear proyecto Firebase
firebase login
firebase projects:addfirebase hithum-prod

# Configurar Firebase en proyecto
firebase init

# Seleccionar:
# - Authentication
# - Firestore
# - Storage
# - Hosting (para reglas y functions si las usas)

# Deploy reglas de seguridad
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

#### 3.3 Configurar Firestore
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function isAdmin() {
      return request.auth.token.admin == true;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated() && isOwner(userId);
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isAuthenticated() && isOwner(userId) 
                    && !request.resource.data.diff(resource.data).affectedKeys()
                       .hasAny(['role', 'subscription']);
      allow delete: if false; // No permitir borrado directo
    }
    
    // Content collection
    match /content/{contentId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.resource.data.authorId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.authorId == request.auth.uid;
      allow delete: if isAuthenticated() && (resource.data.authorId == request.auth.uid || isAdmin());
    }
    
    // AI Logs - solo lectura para owners/admins
    match /ai_logs/{logId} {
      allow read: if isAuthenticated() && 
                  (resource.data.userId == request.auth.uid || isAdmin());
      allow write: if false; // Solo backend puede escribir
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.userId == request.auth.uid
                    && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['read']);
      allow write: if false; // Backend crea notificaciones
    }
  }
}
```

#### 3.4 Crear Service Accounts
```bash
# Service account para AI Agent
gcloud iam service-accounts create hithum-ai-agent \
  --display-name="HiThum AI Agent Service Account"

# Asignar roles necesarios
gcloud projects add-iam-policy-binding hithum-prod \
  --member="serviceAccount:hithum-ai-agent@hithum-prod.iam.gserviceaccount.com" \
  --role="roles/aiplatform.user"

gcloud projects add-iam-policy-binding hithum-prod \
  --member="serviceAccount:hithum-ai-agent@hithum-prod.iam.gserviceaccount.com" \
  --role="roles/datastore.user"

gcloud projects add-iam-policy-binding hithum-prod \
  --member="serviceAccount:hithum-ai-agent@hithum-prod.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter"

# Service account para API
gcloud iam service-accounts create hithum-api \
  --display-name="HiThum API Service Account"

gcloud projects add-iam-policy-binding hithum-prod \
  --member="serviceAccount:hithum-api@hithum-prod.iam.gserviceaccount.com" \
  --role="roles/datastore.user"
```

### Fase 2: Desarrollo Backend (Semana 2-3)

#### 3.5 Crear API en Cloud Run
```javascript
// api/src/index.js (Node.js example)
const express = require('express');
const admin = require('firebase-admin');
const { validateFirebaseToken } = require('./middleware/auth');
const { rateLimiter } = require('./middleware/rateLimiter');

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Protected endpoint
app.post('/api/content', 
  validateFirebaseToken,
  rateLimiter({ maxRequests: 100, windowMs: 60000 }), // 100 req/min
  async (req, res) => {
    try {
      const { title, body } = req.body;
      const userId = req.user.uid;
      
      // Validar input
      if (!title || !body) {
        return res.status(400).json({ error: 'Missing required fields' });
      }
      
      // Crear documento en Firestore
      const contentRef = await db.collection('content').add({
        title,
        body,
        authorId: userId,
        status: 'draft',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      
      // Log de acción
      await db.collection('user_actions').add({
        userId,
        action: 'create_content',
        contentId: contentRef.id,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });
      
      res.status(201).json({
        id: contentRef.id,
        message: 'Content created successfully'
      });
    } catch (error) {
      console.error('Error creating content:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`API listening on port ${PORT}`);
});
```

```dockerfile
# api/Dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 8080
CMD ["node", "src/index.js"]
```

```bash
# Deploy a Cloud Run
gcloud run deploy hithum-api \
  --source . \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --service-account hithum-api@hithum-prod.iam.gserviceaccount.com \
  --set-env-vars="PROJECT_ID=hithum-prod" \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 100 \
  --timeout 60
```

#### 3.6 Implementar AI Agent Service
```python
# ai-agent/main.py
from flask import Flask, request, jsonify
from google.cloud import firestore, aiplatform
from vertexai.preview.generative_models import GenerativeModel
import time
from functools import wraps

app = Flask(__name__)
db = firestore.Client()
aiplatform.init(project='hithum-prod', location='us-central1')

# Rate limiter decorator
def rate_limit(max_per_user_per_day=50):
    def decorator(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            user_id = request.json.get('userId')
            today = time.strftime('%Y-%m-%d')
            
            # Check rate limit
            quota_ref = db.collection('ai_quotas').document(f'{user_id}_{today}')
            quota_doc = quota_ref.get()
            
            if quota_doc.exists:
                usage = quota_doc.to_dict().get('count', 0)
                if usage >= max_per_user_per_day:
                    return jsonify({
                        'error': 'Daily quota exceeded',
                        'quota': max_per_user_per_day,
                        'used': usage
                    }), 429
            
            # Execute function
            response = f(*args, **kwargs)
            
            # Increment quota
            quota_ref.set({
                'count': firestore.Increment(1),
                'lastUpdated': firestore.SERVER_TIMESTAMP
            }, merge=True)
            
            return response
        return wrapped
    return decorator

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'})

@app.route('/generate-summary', methods=['POST'])
@rate_limit(max_per_user_per_day=50)
def generate_summary():
    try:
        data = request.json
        user_id = data.get('userId')
        content = data.get('content')
        model_name = data.get('model', 'gemini-pro')
        
        # Validaciones
        if not user_id or not content:
            return jsonify({'error': 'Missing required fields'}), 400
        
        if len(content) > 10000:
            return jsonify({'error': 'Content too long (max 10000 chars)'}), 400
        
        # Invocar modelo
        start_time = time.time()
        model = GenerativeModel(model_name)
        
        prompt = f"""Genera un resumen conciso del siguiente texto.
        
Texto:
{content}

Resumen:"""
        
        response = model.generate_content(
            prompt,
            generation_config={
                'max_output_tokens': 500,
                'temperature': 0.4,
                'top_p': 0.8,
            }
        )
        
        duration_ms = int((time.time() - start_time) * 1000)
        summary = response.text
        
        # Calcular costo aproximado (ejemplo: $0.00025 per 1K tokens)
        input_tokens = len(content.split())
        output_tokens = len(summary.split())
        cost_usd = ((input_tokens + output_tokens) / 1000) * 0.00025
        
        # Guardar log en Firestore
        log_ref = db.collection('ai_logs').add({
            'userId': user_id,
            'action': 'generate_summary',
            'model': model_name,
            'inputLength': len(content),
            'outputLength': len(summary),
            'inputTokens': input_tokens,
            'outputTokens': output_tokens,
            'duration_ms': duration_ms,
            'cost_usd': cost_usd,
            'timestamp': firestore.SERVER_TIMESTAMP,
            'status': 'success'
        })
        
        return jsonify({
            'summary': summary,
            'metadata': {
                'duration_ms': duration_ms,
                'tokens': {
                    'input': input_tokens,
                    'output': output_tokens
                },
                'cost_usd': round(cost_usd, 6),
                'logId': log_ref[1].id
            }
        })
        
    except Exception as e:
        # Log error
        db.collection('ai_logs').add({
            'userId': user_id,
            'action': 'generate_summary',
            'model': model_name,
            'error': str(e),
            'timestamp': firestore.SERVER_TIMESTAMP,
            'status': 'error'
        })
        
        print(f'Error generating summary: {e}')
        return jsonify({'error': 'Failed to generate summary'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

```dockerfile
# ai-agent/Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "--timeout", "300", "main:app"]
```

```bash
# Deploy AI Agent
gcloud run deploy hithum-ai-agent \
  --source . \
  --region us-central1 \
  --platform managed \
  --no-allow-unauthenticated \
  --service-account hithum-ai-agent@hithum-prod.iam.gserviceaccount.com \
  --set-env-vars="PROJECT_ID=hithum-prod" \
  --memory 2Gi \
  --cpu 2 \
  --max-instances 50 \
  --timeout 300 \
  --concurrency 10
```

### Fase 3: Frontend Integration (Semana 3-4)

#### 3.7 Integrar Frontend en Vercel
```javascript
// lib/firebase.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
```

```javascript
// lib/api.js
import { auth } from './firebase';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL;
const AI_AGENT_URL = process.env.NEXT_PUBLIC_AI_AGENT_URL;

async function fetchWithAuth(url, options = {}) {
  const user = auth.currentUser;
  
  if (!user) {
    throw new Error('User not authenticated');
  }
  
  const token = await user.getIdToken();
  
  const response = await fetch(url, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
      ...options.headers
    }
  });
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.error || 'Request failed');
  }
  
  return response.json();
}

export async function createContent(title, body) {
  return fetchWithAuth(`${API_BASE_URL}/api/content`, {
    method: 'POST',
    body: JSON.stringify({ title, body })
  });
}

export async function generateSummary(content) {
  const user = auth.currentUser;
  
  return fetchWithAuth(`${AI_AGENT_URL}/generate-summary`, {
    method: 'POST',
    body: JSON.stringify({
      userId: user.uid,
      content,
      model: 'gemini-pro'
    })
  });
}
```

```javascript
// pages/dashboard.js
import { useState } from 'react';
import { useAuth } from '../hooks/useAuth';
import { generateSummary } from '../lib/api';

export default function Dashboard() {
  const { user } = useAuth();
  const [content, setContent] = useState('');
  const [summary, setSummary] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleGenerateSummary = async () => {
    if (!content.trim()) {
      setError('Por favor ingresa contenido');
      return;
    }

    setLoading(true);
    setError('');
    
    try {
      const result = await generateSummary(content);
      setSummary(result.summary);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container">
      <h1>Dashboard - {user?.email}</h1>
      
      <div className="section">
        <h2>Generar Resumen con IA</h2>
        
        <textarea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          placeholder="Ingresa el texto aquí..."
          rows={10}
          className="textarea"
        />
        
        <button 
          onClick={handleGenerateSummary}
          disabled={loading}
          className="button"
        >
          {loading ? 'Generando...' : 'Generar Resumen'}
        </button>
        
        {error && <div className="error">{error}</div>}
        
        {summary && (
          <div className="summary-result">
            <h3>Resumen:</h3>
            <p>{summary}</p>
          </div>
        )}
      </div>
    </div>
  );
}
```

#### 3.8 Configurar Variables de Entorno en Vercel
```bash
# En Vercel Dashboard > Settings > Environment Variables
NEXT_PUBLIC_FIREBASE_API_KEY=your-api-key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=hithum-prod.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=hithum-prod
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=hithum-prod.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=your-app-id

NEXT_PUBLIC_API_URL=https://hithum-api-xxx.run.app
NEXT_PUBLIC_AI_AGENT_URL=https://hithum-ai-agent-xxx.run.app
```

### Fase 4: Monitoreo y Dashboards (Semana 4)

#### 3.9 Configurar Cloud Monitoring Dashboards
```bash
# dashboard.json
{
  "displayName": "HiThum - Production Dashboard",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "API Request Rate",
          "xyChart": {
            "dataSets": [{
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"hithum-api\"",
                  "aggregation": {
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM"
                  }
                }
              }
            }]
          }
        }
      },
      {
        "xPos": 6,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "AI Agent Invocations",
          "xyChart": {
            "dataSets": [{
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"hithum-ai-agent\"",
                  "aggregation": {
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM"
                  }
                }
              }
            }]
          }
        }
      }
    ]
  }
}

# Crear dashboard
gcloud monitoring dashboards create --config-from-file=dashboard.json
```

#### 3.10 Configurar Alertas
```bash
# Alerta: Error rate alto
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="High Error Rate - API" \
  --condition-display-name="Error rate > 5%" \
  --condition-threshold-value=0.05 \
  --condition-threshold-duration=300s \
  --condition-threshold-comparison=COMPARISON_GT \
  --condition-filter='resource.type="cloud_run_revision" AND resource.labels.service_name="hithum-api" AND metric.type="run.googleapis.com/request_count"'

# Alerta: Costo de IA alto
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="High AI Cost Per User" \
  --condition-display-name="User AI cost > $10/day" \
  --condition-threshold-value=10 \
  --condition-threshold-duration=86400s \
  --condition-threshold-comparison=COMPARISON_GT
```

### Fase 5: Testing y Launch (Semana 5)

#### 3.11 Testing de Integración
```javascript
// tests/integration/ai-agent.test.js
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const fetch = require('node-fetch');

describe('AI Agent Integration', () => {
  let authToken;
  let userId;

  beforeAll(async () => {
    // Crear usuario de prueba
    const user = await getAuth().createUser({
      email: 'test@example.com',
      password: 'testPassword123'
    });
    userId = user.uid;
    authToken = await getAuth().createCustomToken(userId);
  });

  afterAll(async () => {
    // Limpiar usuario de prueba
    await getAuth().deleteUser(userId);
  });

  test('should generate summary successfully', async () => {
    const response = await fetch(`${process.env.AI_AGENT_URL}/generate-summary`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${authToken}`
      },
      body: JSON.stringify({
        userId,
        content: 'This is a test content that needs to be summarized.'
      })
    });

    expect(response.status).toBe(200);
    const data = await response.json();
    expect(data).toHaveProperty('summary');
    expect(data.summary).toBeTruthy();
  });

  test('should respect rate limits', async () => {
    // Hacer 51 requests (límite es 50)
    const requests = Array(51).fill().map(() =>
      fetch(`${process.env.AI_AGENT_URL}/generate-summary`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${authToken}`
        },
        body: JSON.stringify({
          userId,
          content: 'Test content'
        })
      })
    );

    const responses = await Promise.all(requests);
    const tooManyRequests = responses.filter(r => r.status === 429);
    
    expect(tooManyRequests.length).toBeGreaterThan(0);
  });
});
```

#### 3.12 Load Testing
```javascript
// load-test/script.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up to 100 users
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% of requests under 2s
    http_req_failed: ['rate<0.05'],    // Error rate under 5%
  },
};

export default function () {
  const url = 'https://hithum-api-xxx.run.app/api/content';
  const payload = JSON.stringify({
    title: 'Test Content',
    body: 'This is test content for load testing'
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${__ENV.TEST_TOKEN}`
    },
  };

  const response = http.post(url, payload, params);

  check(response, {
    'status is 201': (r) => r.status === 201,
    'response time < 2s': (r) => r.timings.duration < 2000,
  });

  sleep(1);
}
```

```bash
# Ejecutar load test
k6 run load-test/script.js
```

#### 3.13 Deploy a Producción
```bash
# 1. Tag versión estable
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 2. Deploy backend services
gcloud run deploy hithum-api --tag=v1-0-0 ...
gcloud run deploy hithum-ai-agent --tag=v1-0-0 ...

# 3. Enrutar 10% de tráfico a nueva versión (canary)
gcloud run services update-traffic hithum-api \
  --to-revisions=v1-0-0=10,LATEST=90

# 4. Monitorear métricas por 1 hora
# Si todo OK, enrutar 100%
gcloud run services update-traffic hithum-api \
  --to-revisions=v1-0-0=100

# 5. Deploy frontend en Vercel (automático con git push)
git push origin main

# 6. Verificar deployment
curl https://hithum.vercel.app/health
curl https://hithum-api-xxx.run.app/health
```

---

## 4. Arquitectura de Seguridad y Límites

### 4.1 Control de Acceso

#### Niveles de Autenticación
```
1. Frontend → Firebase Auth (usuario autenticado)
2. Backend APIs → Validación de JWT token
3. AI Agent → Invocación solo desde backend autenticado
4. Firestore → Security Rules por colección
5. Storage → IAM + Signed URLs
```

#### Policy de Acciones Permitidas (Whitelist)
```python
# ai-agent/policies.py
ALLOWED_ACTIONS = {
    'free_tier': [
        'generate_summary',  # Max 10/día
        'classify_content',  # Max 20/día
    ],
    'premium_tier': [
        'generate_summary',  # Max 100/día
        'classify_content',  # Max 200/día
        'generate_content',  # Max 50/día
        'analyze_sentiment', # Max 100/día
    ],
    'admin': [
        '*'  # Sin límites
    ]
}

def is_action_allowed(user_role, action):
    if user_role == 'admin':
        return True
    
    allowed = ALLOWED_ACTIONS.get(user_role, [])
    return action in allowed or '*' in allowed
```

### 4.2 Rate Limiting

#### Implementación Multi-nivel
```python
# middleware/rate_limiter.py
from google.cloud import firestore
from datetime import datetime, timedelta
from functools import wraps

class RateLimiter:
    def __init__(self, db):
        self.db = db
    
    def check_limit(self, user_id, action, limits):
        """
        limits: {
            'per_minute': 10,
            'per_hour': 100,
            'per_day': 1000
        }
        """
        now = datetime.utcnow()
        
        # Check minute limit
        if 'per_minute' in limits:
            count = self._count_actions(user_id, action, now - timedelta(minutes=1))
            if count >= limits['per_minute']:
                return False, f"Rate limit exceeded: {limits['per_minute']} per minute"
        
        # Check hour limit
        if 'per_hour' in limits:
            count = self._count_actions(user_id, action, now - timedelta(hours=1))
            if count >= limits['per_hour']:
                return False, f"Rate limit exceeded: {limits['per_hour']} per hour"
        
        # Check day limit
        if 'per_day' in limits:
            count = self._count_actions(user_id, action, now - timedelta(days=1))
            if count >= limits['per_day']:
                return False, f"Rate limit exceeded: {limits['per_day']} per day"
        
        return True, None
    
    def _count_actions(self, user_id, action, since):
        query = (self.db.collection('ai_logs')
                .where('userId', '==', user_id)
                .where('action', '==', action)
                .where('timestamp', '>=', since))
        
        return len(list(query.stream()))
    
    def record_action(self, user_id, action, metadata):
        self.db.collection('ai_logs').add({
            'userId': user_id,
            'action': action,
            'timestamp': firestore.SERVER_TIMESTAMP,
            **metadata
        })
```

### 4.3 Logging Completo

#### Estructura de Logs
```json
{
  "severity": "INFO",
  "timestamp": "2025-12-23T10:30:45.123Z",
  "jsonPayload": {
    "userId": "user_abc123",
    "action": "generate_summary",
    "model": "gemini-pro",
    "request": {
      "inputLength": 1500,
      "contentType": "text"
    },
    "response": {
      "outputLength": 300,
      "status": "success"
    },
    "performance": {
      "duration_ms": 1250,
      "inputTokens": 450,
      "outputTokens": 100
    },
    "cost": {
      "usd": 0.002
    },
    "rateLimit": {
      "used": 15,
      "limit": 50,
      "remaining": 35
    },
    "metadata": {
      "ip": "203.0.113.42",
      "userAgent": "Mozilla/5.0...",
      "sessionId": "sess_xyz789"
    }
  },
  "labels": {
    "service": "hithum-ai-agent",
    "environment": "production",
    "version": "1.0.0"
  },
  "resource": {
    "type": "cloud_run_revision",
    "labels": {
      "service_name": "hithum-ai-agent",
      "revision_name": "hithum-ai-agent-00001-abc"
    }
  }
}
```

### 4.4 Monitoreo desde Laptop y Celular

#### Dashboard Web Responsivo
```javascript
// pages/admin/dashboard.js
import { useEffect, useState } from 'react';
import { collection, query, where, orderBy, limit, onSnapshot } from 'firebase/firestore';
import { db } from '../../lib/firebase';

export default function AdminDashboard() {
  const [metrics, setMetrics] = useState({
    totalRequests: 0,
    activeUsers: 0,
    aiCost: 0,
    errorRate: 0
  });
  
  const [recentLogs, setRecentLogs] = useState([]);

  useEffect(() => {
    // Real-time logs
    const logsQuery = query(
      collection(db, 'ai_logs'),
      orderBy('timestamp', 'desc'),
      limit(20)
    );
    
    const unsubscribe = onSnapshot(logsQuery, (snapshot) => {
      const logs = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setRecentLogs(logs);
      
      // Calculate metrics
      const totalCost = logs.reduce((sum, log) => sum + (log.cost_usd || 0), 0);
      const errors = logs.filter(log => log.status === 'error').length;
      
      setMetrics({
        totalRequests: logs.length,
        aiCost: totalCost,
        errorRate: (errors / logs.length) * 100
      });
    });

    return () => unsubscribe();
  }, []);

  return (
    <div className="dashboard">
      <h1>Admin Dashboard</h1>
      
      <div className="metrics-grid">
        <div className="metric-card">
          <h3>Total Requests</h3>
          <p className="metric-value">{metrics.totalRequests}</p>
        </div>
        
        <div className="metric-card">
          <h3>AI Cost</h3>
          <p className="metric-value">${metrics.aiCost.toFixed(4)}</p>
        </div>
        
        <div className="metric-card">
          <h3>Error Rate</h3>
          <p className="metric-value">{metrics.errorRate.toFixed(1)}%</p>
        </div>
      </div>
      
      <div className="logs-section">
        <h2>Recent Activity</h2>
        <table className="logs-table">
          <thead>
            <tr>
              <th>Time</th>
              <th>User</th>
              <th>Action</th>
              <th>Status</th>
              <th>Duration</th>
              <th>Cost</th>
            </tr>
          </thead>
          <tbody>
            {recentLogs.map(log => (
              <tr key={log.id}>
                <td>{new Date(log.timestamp?.toDate()).toLocaleTimeString()}</td>
                <td>{log.userId.substring(0, 8)}...</td>
                <td>{log.action}</td>
                <td className={log.status === 'success' ? 'success' : 'error'}>
                  {log.status}
                </td>
                <td>{log.duration_ms}ms</td>
                <td>${(log.cost_usd || 0).toFixed(4)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
```

```css
/* styles/dashboard.css - Mobile responsive */
.dashboard {
  padding: 1rem;
  max-width: 1200px;
  margin: 0 auto;
}

.metrics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.metric-card {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.logs-table {
  width: 100%;
  overflow-x: auto;
}

@media (max-width: 768px) {
  .logs-table {
    font-size: 0.875rem;
  }
  
  .logs-table td, .logs-table th {
    padding: 0.5rem;
  }
}
```

#### Cloud Monitoring Mobile App
```
Opción 1: Google Cloud Console App
- Disponible en iOS y Android
- Ver dashboards, métricas, logs
- Recibir alertas push
- Responder a incidents

Opción 2: Dashboard Web PWA
- Crear Progressive Web App
- Instalar en home screen
- Notificaciones push
- Funciona offline
```

---

## 5. Estimación de Costos

### Cálculo Mensual Estimado

#### Escenario: 1,000 usuarios activos

| Servicio | Uso Mensual | Costo Mensual |
|----------|-------------|---------------|
| Firebase Auth | 1,000 usuarios | **Gratis** (hasta 50k) |
| Firestore | 2M reads, 500K writes | **$35** |
| Cloud Run (API) | 5M requests, 100 GB-hours | **$20** |
| Cloud Run (AI Agent) | 50K requests, 500 GB-hours | **$50** |
| Vertex AI (Gemini Pro) | 5M tokens input, 1M output | **$35** |
| Cloud Storage | 50 GB, 100K operations | **$3** |
| Cloud Logging | 50 GB logs | **$25** |
| Cloud Monitoring | Dashboards + alertas | **$10** |
| **Total** | | **~$178/mes** |

#### Escalamiento a 10,000 usuarios

| Servicio | Costo Mensual |
|----------|---------------|
| Firebase Auth | **$5** |
| Firestore | **$250** |
| Cloud Run (API) | **$120** |
| Cloud Run (AI Agent) | **$350** |
| Vertex AI | **$280** |
| Cloud Storage | **$20** |
| Cloud Logging | **$120** |
| Cloud Monitoring | **$30** |
| **Total** | **~$1,175/mes** |

### Optimizaciones de Costo

1. **Caching**: Reducir llamadas a Vertex AI en 30-40%
2. **Batching**: Agrupar requests a Firestore
3. **Compression**: Reducir tamaño de logs
4. **Retention**: Logs solo 7 días (reducir a $10-15/mes)
5. **Cold Start**: Mantener 1 instancia warm de Cloud Run
6. **Committed Use**: Descuento 25% con contrato anual

---

## 6. Resumen JSON

```json
{
  "arquitectura": [
    "Frontend en Vercel con Next.js + Firebase SDK para auth y Firestore en tiempo real",
    "Backend en Cloud Run con APIs REST autenticadas vía Firebase Auth tokens",
    "AI Agents en Cloud Run separado con Vertex AI (Gemini Pro) para automatización",
    "Firestore para datos estructurados + Security Rules granulares por colección",
    "Cloud Tasks para ejecución asíncrona con reintentos automáticos",
    "Cloud Logging + Monitoring para logs centralizados y dashboards en tiempo real",
    "Secret Manager para credenciales y API keys (nunca en código)",
    "Rate limiting multi-nivel (por minuto/hora/día) con quotas en Firestore"
  ],
  "servicios": [
    "Firebase Auth: Gestión de usuarios con JWT tokens y custom claims para roles",
    "Firestore: Base de datos principal con colecciones (users, content, ai_logs, notifications)",
    "Cloud Run: Servicios backend (hithum-api, hithum-ai-agent, hithum-worker)",
    "Vertex AI: Gemini Pro para generación de texto y resúmenes inteligentes",
    "Cloud Tasks: Ejecución de agentes de forma asíncrona con control de concurrencia",
    "Cloud Logging: Logs estructurados JSON con retention configurable (7-30 días)",
    "Cloud Monitoring: Dashboards personalizados + alertas automáticas vía email/Slack",
    "Secret Manager: Almacenamiento seguro de API keys y credenciales sensibles"
  ],
  "pasos": [
    "Semana 1: Setup Google Cloud project + Firebase (Auth, Firestore, Storage) + Security Rules",
    "Semana 2: Desarrollar API backend en Cloud Run con autenticación y rate limiting",
    "Semana 3: Implementar AI Agent service con Vertex AI + logging completo de decisiones",
    "Semana 3-4: Integrar frontend Vercel con Firebase SDK y APIs backend autenticadas",
    "Semana 4: Configurar Cloud Monitoring dashboards responsive + alertas críticas",
    "Semana 5: Testing end-to-end + load testing (k6) + deploy canary a producción",
    "Post-launch: Monitoreo 24/7 desde Cloud Console App (mobile) y dashboards web",
    "Optimización continua: Ajustar rate limits, costos y escalado basado en métricas reales"
  ]
}
```

---

## 7. Checklist de Verificación Pre-Launch

### Seguridad
- [ ] Security Rules de Firestore validadas y testeadas
- [ ] Todos los endpoints requieren autenticación
- [ ] API keys en Secret Manager (nunca hardcoded)
- [ ] Service accounts con principio de least privilege
- [ ] Rate limiting configurado en todos los servicios
- [ ] HTTPS forzado en todos los endpoints
- [ ] CORS configurado solo para dominios permitidos
- [ ] Input validation en todos los endpoints

### Performance
- [ ] Cloud Run configurado con min instances = 1 (evitar cold starts)
- [ ] Timeouts apropiados (60s API, 300s AI Agent)
- [ ] Caching implementado donde sea posible
- [ ] Database indexes creados en Firestore
- [ ] CDN habilitado en Vercel

### Monitoreo
- [ ] Dashboards configurados y accesibles en mobile
- [ ] Alertas críticas configuradas (error rate, latencia, costo)
- [ ] Logs estructurados con todos los campos requeridos
- [ ] Error Reporting activo
- [ ] Uptime checks configurados

### Testing
- [ ] Tests unitarios pasando (>80% coverage)
- [ ] Tests de integración pasando
- [ ] Load testing ejecutado exitosamente
- [ ] Security scanning ejecutado (sin vulnerabilidades críticas)
- [ ] Disaster recovery plan documentado

### Documentación
- [ ] README actualizado con arquitectura
- [ ] API documentation completa (Swagger/OpenAPI)
- [ ] Runbooks para incidentes comunes
- [ ] Onboarding guide para nuevos devs
- [ ] Diagramas de arquitectura actualizados

---

## 8. Recursos Adicionales

### Documentación Oficial
- [Firebase Documentation](https://firebase.google.com/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Vertex AI Documentation](https://cloud.google.com/vertex-ai/docs)
- [Firestore Best Practices](https://cloud.google.com/firestore/docs/best-practices)

### Herramientas Útiles
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) - Testing local
- [Cloud Code](https://cloud.google.com/code) - IDE extensions para GCP
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) - IaC
- [k6](https://k6.io/) - Load testing

### Comunidad y Soporte
- [Stack Overflow - Firebase](https://stackoverflow.com/questions/tagged/firebase)
- [Google Cloud Community](https://www.googlecloudcommunity.com/)
- [r/googlecloud](https://reddit.com/r/googlecloud)
- [Firebase Slack](https://firebase.community/)

---

**Documento generado**: 2025-12-23  
**Autor**: Arquitectura HiThum Team  
**Versión**: 1.0.0  
**Estado**: Producción-Ready ✅
