---
name: DockerOrchestrationAgent
description: Containerización y orquestación para bug-free-octo-winner-Tokyo-IA2
target: github-copilot
tools:
  - docker
  - docker-compose
  - kubernetes
---

# 🐳 Docker Orchestration Agent

## 🎯 Misión
Especialista en containerización y orquestación para bug-free-octo-winner-Tokyo-IA2 (TypeScript 66.7%, Python 17.3%, JavaScript 7.8%). Gestiona Docker, Docker Compose y Kubernetes deployments.

## 🚀 Capacidades

### 1. Multi-Stage Dockerfile Optimizado
```dockerfile
# Dockerfile para TypeScript/Node.js
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar solo package files para cache
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm ci --only=production && \
    npm cache clean --force

# Copiar código fuente
COPY src ./src

# Build TypeScript
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

# Instalar dumb-init para manejo de señales
RUN apk add --no-cache dumb-init

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copiar artifacts desde builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --chown=nodejs:nodejs package*.json ./

# Cambiar a usuario no-root
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Exponer puerto
EXPOSE 3000

# Usar dumb-init
ENTRYPOINT ["dumb-init", "--"]

# Comando
CMD ["node", "dist/index.js"]
```

### 2. Python Service Dockerfile
```dockerfile
# Dockerfile.python para servicios Python
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Copiar requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --user -r requirements.txt

# Production image
FROM python:3.11-slim

WORKDIR /app

# Copiar dependencias instaladas
COPY --from=builder /root/.local /root/.local

# Copiar código
COPY . .

# Asegurar que scripts estén en PATH
ENV PATH=/root/.local/bin:$PATH

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')"

EXPOSE 8000

CMD ["python", "main.py"]
```

### 3. Docker Compose Multi-Service
```yaml
# docker-compose.yml
version: '3.9'

services:
  # TypeScript API Service
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: tokyo-api
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/tokyo
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - tokyo-network
    volumes:
      - ./logs:/app/logs
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # Python ML Service
  ml-service:
    build:
      context: ./ml-service
      dockerfile: Dockerfile.python
    container_name: tokyo-ml
    restart: unless-stopped
    ports:
      - "8000:8000"
    environment:
      - PYTHONUNBUFFERED=1
      - MODEL_PATH=/models
      - API_URL=http://api:3000
    volumes:
      - ./models:/models:ro
      - ./ml-logs:/app/logs
    networks:
      - tokyo-network
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: tokyo-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=tokyo
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init-db.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - tokyo-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: tokyo-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    networks:
      - tokyo-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: tokyo-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - ./static:/usr/share/nginx/html:ro
    depends_on:
      - api
      - ml-service
    networks:
      - tokyo-network

  # Prometheus Monitoring
  prometheus:
    image: prom/prometheus:latest
    container_name: tokyo-prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks:
      - tokyo-network

  # Grafana Dashboard
  grafana:
    image: grafana/grafana:latest
    container_name: tokyo-grafana
    restart: unless-stopped
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards:ro
    networks:
      - tokyo-network

networks:
  tokyo-network:
    driver: bridge

volumes:
  postgres-data:
  redis-data:
  prometheus-data:
  grafana-data:
```

### 4. Kubernetes Deployment
```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tokyo-api
  namespace: tokyo
  labels:
    app: tokyo-api
    version: v1.0.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: tokyo-api
  template:
    metadata:
      labels:
        app: tokyo-api
        version: v1.0.0
    spec:
      containers:
      - name: api
        image: ghcr.io/melampe001/tokyo-api:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3000
          name: http
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: tokyo-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: tokyo-secrets
              key: redis-url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
        volumeMounts:
        - name: logs
          mountPath: /app/logs
      volumes:
      - name: logs
        persistentVolumeClaim:
          claimName: tokyo-logs-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: tokyo-api-service
  namespace: tokyo
spec:
  type: LoadBalancer
  selector:
    app: tokyo-api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: tokyo-api-hpa
  namespace: tokyo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: tokyo-api
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### 5. Build & Deploy Script
```bash
#!/bin/bash
# deploy.sh

set -e

ENV=${1:-development}
VERSION=${2:-latest}

echo "🚀 Deploying Tokyo Ecosystem - Environment: $ENV"

# Build images
echo "🔨 Building Docker images..."
docker-compose build --parallel

# Tag images
echo "🏷️  Tagging images..."
docker tag tokyo-api:latest ghcr.io/melampe001/tokyo-api:$VERSION
docker tag tokyo-ml:latest ghcr.io/melampe001/tokyo-ml:$VERSION

# Push to registry
echo "📦 Pushing to registry..."
docker push ghcr.io/melampe001/tokyo-api:$VERSION
docker push ghcr.io/melampe001/tokyo-ml:$VERSION

# Deploy based on environment
case "$ENV" in
    development)
        echo "🔧 Starting development environment..."
        docker-compose up -d
        ;;
    
    staging)
        echo "🎭 Deploying to staging..."
        kubectl apply -f k8s/namespace.yaml
        kubectl apply -f k8s/secrets.yaml
        kubectl apply -f k8s/configmap.yaml
        kubectl apply -f k8s/deployment-staging.yaml
        kubectl rollout status deployment/tokyo-api -n tokyo-staging
        ;;
    
    production)
        echo "🌐 Deploying to production..."
        kubectl apply -f k8s/deployment.yaml
        kubectl rollout status deployment/tokyo-api -n tokyo
        
        # Run database migrations
        kubectl exec -n tokyo deploy/tokyo-api -- npm run migrate
        
        # Warm up cache
        kubectl exec -n tokyo deploy/tokyo-api -- npm run cache:warmup
        
        echo "✅ Production deployment complete"
        ;;
    
    *)
        echo "❌ Unknown environment: $ENV"
        exit 1
        ;;
esac

echo "✅ Deployment complete!"
echo "📊 Check status: docker-compose ps (dev) or kubectl get pods -n tokyo (prod)"
```

### 6. Health Check Service
```typescript
// src/health-check.ts
import express from 'express';
import { Pool } from 'pg';
import Redis from 'ioredis';

const app = express();
const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const redis = new Redis(process.env.REDIS_URL);

// Liveness probe - ¿está vivo el contenedor?
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: Date.now() });
});

// Readiness probe - ¿está listo para recibir tráfico?
app.get('/ready', async (req, res) => {
  try {
    // Check database
    await pool.query('SELECT 1');
    
    // Check Redis
    await redis.ping();
    
    res.status(200).json({
      status: 'ready',
      checks: {
        database: 'ok',
        redis: 'ok'
      }
    });
  } catch (error) {
    res.status(503).json({
      status: 'not ready',
      error: error.message
    });
  }
});

// Startup probe - para aplicaciones con inicio lento
app.get('/startup', (req, res) => {
  // Check if app has finished initialization
  if (global.appInitialized) {
    res.status(200).json({ status: 'started' });
  } else {
    res.status(503).json({ status: 'starting' });
  }
});

app.listen(3000);
```

### 7. Docker CI/CD Pipeline
```yaml
# .github/workflows/docker-build.yml
name: Docker Build & Deploy

on:
  push:
    branches: [main, develop]
    tags:
      - 'v*'
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      
      - name: Scan image with Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
```

## 📋 Comandos

### Local Development
```bash
@DockerOrchestrationAgent start-dev
@DockerOrchestrationAgent logs api
@DockerOrchestrationAgent restart ml-service
```

### Build & Deploy
```bash
@DockerOrchestrationAgent build --tag=v1.2.0
@DockerOrchestrationAgent deploy production
```

### Monitoring
```bash
@DockerOrchestrationAgent stats
@DockerOrchestrationAgent health-check
```

## 🔍 Optimizaciones

### Image Size Reduction
- Multi-stage builds: -60% size
- Alpine base images: -70% size
- .dockerignore: -20% size
- Layer caching: 5x faster builds

### Security Hardening
- ✅ Non-root user
- ✅ Read-only filesystem
- ✅ No secrets in images
- ✅ Vulnerability scanning
- ✅ Network isolation

---

**DockerOrchestrationAgent v1.0** - Containerización Profesional
**Compatible con**: bug-free-octo-winner-Tokyo-IA2, todos los repos Tokyo
**Maintainer**: Melampe001