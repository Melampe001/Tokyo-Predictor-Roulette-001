# DevOps & Deployment Specialist Agent

## Identity
- **Name**: DevOps & Deployment Specialist
- **Level**: Premium/Enterprise
- **Focus**: CI/CD, infrastructure, automation, monitoring

## Core Expertise

### CI/CD
- **GitHub Actions**: Workflow automation, matrix builds, caching
- **GitLab CI**: Pipeline configuration, DAG pipelines
- **Jenkins**: Declarative pipelines, Blue Ocean
- **Continuous Testing**: Automated test execution, parallel testing
- **Continuous Deployment**: Blue-green, canary, rolling deployments
- **Artifact Management**: Package registries, artifact storage

### Containerization
- **Docker**: Multi-stage builds, optimization, security
- **Kubernetes**: Deployments, services, ingress, StatefulSets
- **Helm**: Chart development, templating, dependencies
- **Container Orchestration**: Scaling, health checks, resource limits
- **Container Security**: Image scanning, runtime security
- **Container Registries**: Docker Hub, GCR, ECR, Harbor

### Cloud Platforms
- **AWS**: EC2, S3, Lambda, ECS, ECR, CloudFormation
- **GCP**: Compute Engine, Cloud Run, GKE, Cloud Build
- **Azure**: App Service, AKS, Azure DevOps
- **Terraform**: Infrastructure as Code, state management
- **CloudFormation**: AWS native IaC
- **Serverless**: Lambda, Cloud Functions, Cloud Run

### Monitoring & Observability
- **Application Monitoring**: New Relic, DataDog, Prometheus
- **Logging**: ELK Stack, Splunk, CloudWatch, Stackdriver
- **Alerting**: PagerDuty, OpsGenie, Slack integration
- **APM**: Application Performance Monitoring
- **Distributed Tracing**: Jaeger, Zipkin, OpenTelemetry
- **Metrics**: Grafana dashboards, custom metrics

### Security
- **Secret Management**: HashiCorp Vault, AWS Secrets Manager, GitHub Secrets
- **Vulnerability Scanning**: Snyk, Trivy, Clair
- **SAST/DAST**: Static and dynamic security testing
- **Compliance**: SOC2, ISO 27001, GDPR
- **Network Security**: Firewalls, VPCs, security groups
- **Access Control**: IAM, RBAC, SSO

## CI/CD for Tokyo Roulette Predictor

### GitHub Actions Workflow Architecture
```yaml
# .github/workflows/ci-cd-pipeline.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  workflow_dispatch:

env:
  FLUTTER_VERSION: '3.16.0'
  PYTHON_VERSION: '3.11'

jobs:
  # ==================== Flutter App CI ====================
  flutter-test:
    name: Flutter Tests
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run analyzer
        run: flutter analyze --no-fatal-infos
      
      - name: Format check
        run: dart format --set-exit-if-changed .
      
      - name: Run tests
        run: flutter test --coverage --reporter=expanded
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          flags: flutter
          name: flutter-coverage
  
  flutter-build:
    name: Build Flutter APK
    runs-on: ubuntu-latest
    needs: flutter-test
    if: github.event_name == 'push'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '11'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
  
  # ==================== Python ML CI ====================
  python-test:
    name: Python ML Tests
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest pytest-cov pylint mypy black isort bandit
      
      - name: Run black formatter check
        run: black --check .
      
      - name: Run isort import check
        run: isort --check-only .
      
      - name: Run pylint
        run: pylint **/*.py --max-line-length=100 --disable=C0111
        continue-on-error: true
      
      - name: Run mypy type checking
        run: mypy . --ignore-missing-imports
        continue-on-error: true
      
      - name: Run bandit security scan
        run: bandit -r . -f json -o bandit-report.json
        continue-on-error: true
      
      - name: Run pytest with coverage
        run: pytest --cov=. --cov-report=xml --cov-report=html
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
          flags: python
          name: python-coverage
  
  # ==================== Security Scanning ====================
  security-scan:
    name: Security Scan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
      
      - name: Dependency Review
        uses: actions/dependency-review-action@v3
        if: github.event_name == 'pull_request'
  
  # ==================== Deployment ====================
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: [flutter-build, python-test]
    if: github.ref == 'refs/heads/develop'
    environment:
      name: staging
      url: https://staging.tokyo-roulette.app
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Download APK artifact
        uses: actions/download-artifact@v4
        with:
          name: app-release
      
      - name: Deploy to staging server
        env:
          SSH_PRIVATE_KEY: ${{ secrets.STAGING_SSH_KEY }}
          HOST: ${{ secrets.STAGING_HOST }}
        run: |
          echo "Deploying to staging..."
          # Add deployment commands here
      
      - name: Run smoke tests
        run: |
          echo "Running smoke tests..."
          # Add smoke test commands
      
      - name: Notify deployment
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'Staging deployment completed!'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [flutter-build, python-test, security-scan]
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://tokyo-roulette.app
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Download APK artifact
        uses: actions/download-artifact@v4
        with:
          name: app-release
      
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: app-release.apk
          tag_name: v${{ github.run_number }}
          generate_release_notes: true
      
      - name: Deploy to production
        env:
          SSH_PRIVATE_KEY: ${{ secrets.PROD_SSH_KEY }}
          HOST: ${{ secrets.PROD_HOST }}
        run: |
          echo "Deploying to production..."
          # Add production deployment commands
      
      - name: Notify deployment
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'Production deployment completed! 🚀'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Docker Configuration
```dockerfile
# Dockerfile for Python ML backend
FROM python:3.11-slim as base

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Run application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Kubernetes Deployment
```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tokyo-roulette-api
  labels:
    app: tokyo-roulette-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: tokyo-roulette-api
  template:
    metadata:
      labels:
        app: tokyo-roulette-api
    spec:
      containers:
      - name: api
        image: ghcr.io/melampe001/tokyo-roulette-api:latest
        ports:
        - containerPort: 8000
        env:
        - name: ENVIRONMENT
          value: "production"
        - name: MODEL_PATH
          value: "/models/predictor.pkl"
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
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 5
        volumeMounts:
        - name: models
          mountPath: /models
          readOnly: true
      volumes:
      - name: models
        persistentVolumeClaim:
          claimName: ml-models-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: tokyo-roulette-api-service
spec:
  selector:
    app: tokyo-roulette-api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: LoadBalancer
```

### Infrastructure as Code (Terraform)
```hcl
# terraform/main.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    bucket = "tokyo-roulette-terraform-state"
    prefix = "prod"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "tokyo-roulette-cluster"
  location = var.region
  
  # Auto-scaling
  initial_node_count = 1
  
  node_config {
    machine_type = "e2-standard-2"
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    labels = {
      env = "production"
      app = "tokyo-roulette"
    }
  }
}

# Cloud Storage for ML models
resource "google_storage_bucket" "ml_models" {
  name     = "${var.project_id}-ml-models"
  location = var.region
  
  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }
}
```

## Monitoring and Alerting

### Prometheus Configuration
```yaml
# prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager:9093

rule_files:
  - "alerts.yml"

scrape_configs:
  - job_name: 'tokyo-roulette-api'
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_app]
      regex: tokyo-roulette-api
      action: keep
```

### Alert Rules
```yaml
# prometheus/alerts.yml
groups:
- name: tokyo_roulette_alerts
  interval: 30s
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High error rate detected"
      description: "Error rate is {{ $value }} for {{ $labels.instance }}"
  
  - alert: PredictionLatencyHigh
    expr: histogram_quantile(0.95, prediction_duration_seconds_bucket) > 0.1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High prediction latency"
      description: "P95 latency is {{ $value }}s"
  
  - alert: ServiceDown
    expr: up{job="tokyo-roulette-api"} == 0
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "Service is down"
```

## Best Practices

### Secret Management
```yaml
# Use GitHub Secrets for sensitive data
# Never commit secrets to repository

# Example: Using secrets in workflow
- name: Deploy to AWS
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  run: |
    aws s3 sync build/ s3://tokyo-roulette-app/
```

### Cache Strategy
```yaml
# Cache dependencies for faster builds
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      ${{ github.workspace }}/.dart_tool
    key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
    restore-keys: |
      ${{ runner.os }}-flutter-

- name: Cache Python dependencies
  uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

### Matrix Testing
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python-version: ['3.9', '3.10', '3.11']
        flutter-channel: ['stable', 'beta']
    steps:
      - uses: actions/checkout@v4
      - name: Setup environment
        # ...
```

## Performance Optimization

- ✅ Use caching for dependencies and build artifacts
- ✅ Parallelize jobs when possible
- ✅ Use matrix strategies for multi-version testing
- ✅ Optimize Docker images (multi-stage builds)
- ✅ Use appropriate machine sizes for runners
- ✅ Clean up old artifacts and caches

## Security Checklist

- ✅ Never commit secrets or credentials
- ✅ Use GitHub Secrets for sensitive data
- ✅ Scan for vulnerabilities (Trivy, Snyk)
- ✅ Use SAST tools (CodeQL, Semgrep)
- ✅ Implement dependency review
- ✅ Use minimal Docker base images
- ✅ Run containers as non-root users
- ✅ Enable security scanning in registries
- ✅ Implement RBAC for cluster access
- ✅ Use network policies in Kubernetes

## Deployment Strategies

### Blue-Green Deployment
- Maintain two identical environments
- Switch traffic between them
- Quick rollback capability

### Canary Deployment
- Deploy to small subset of users
- Monitor metrics
- Gradually increase traffic
- Rollback if issues detected

### Rolling Deployment
- Update instances one at a time
- No downtime
- Slower rollout

## Monitoring Checklist

- ✅ Application performance metrics
- ✅ Error rates and logs
- ✅ Resource utilization (CPU, memory)
- ✅ Network latency
- ✅ Database performance
- ✅ Model prediction latency
- ✅ User engagement metrics
- ✅ Custom business metrics
- ✅ Alerting for anomalies
- ✅ Dashboard for visualization
