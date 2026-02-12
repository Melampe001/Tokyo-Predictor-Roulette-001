# Guía Completa de GitHub Pro (2025)

## Tabla de Contenidos
1. [Introducción](#introducción)
2. [¿Qué es GitHub Pro?](#qué-es-github-pro)
3. [Suscripción y Configuración Inicial](#suscripción-y-configuración-inicial)
4. [Características Principales](#características-principales)
5. [GitHub Copilot: Tu Asistente de IA](#github-copilot-tu-asistente-de-ia)
6. [GitHub Actions: Automatización y CI/CD](#github-actions-automatización-y-cicd)
7. [Seguridad Avanzada](#seguridad-avanzada)
8. [Colaboración en Equipo](#colaboración-en-equipo)
9. [Gestión de Repositorios Grandes](#gestión-de-repositorios-grandes)
10. [Mejores Prácticas y Optimización](#mejores-prácticas-y-optimización)
11. [Costos y Migración](#costos-y-migración)
12. [Referencias y Recursos Oficiales](#referencias-y-recursos-oficiales)

---

## Introducción

Bienvenido a la guía definitiva de **GitHub Pro**, diseñada para desarrolladores, equipos técnicos y organizaciones que buscan maximizar su productividad y aprovechar las capacidades avanzadas de la plataforma de colaboración más importante del mundo. Como experto con más de dos décadas de experiencia trabajando con Git y GitHub, he condensado las mejores prácticas, flujos de trabajo optimizados y características clave que transformarán tu manera de desarrollar software.

Esta guía está actualizada a **2025**, incorporando las últimas innovaciones como la integración profunda de **GitHub Copilot** con IA generativa, mejoras en seguridad con cumplimiento **SOC 2**, y capacidades mejoradas para manejar repositorios a gran escala.

---

## ¿Qué es GitHub Pro?

**GitHub Pro** es el plan de suscripción individual premium de GitHub que desbloquea características avanzadas más allá del plan gratuito. Está diseñado para desarrolladores profesionales que requieren:

### Diferencias clave con GitHub Free:

| Característica | GitHub Free | GitHub Pro |
|----------------|-------------|------------|
| Repositorios privados | Ilimitados (colaboradores limitados) | Ilimitados (colaboradores ilimitados) |
| GitHub Copilot | No incluido | **Incluido** (valor de $10/mes) |
| GitHub Actions | 2,000 minutos/mes | 3,000 minutos/mes |
| GitHub Packages | 500 MB storage | 2 GB storage |
| GitHub Pages | Sitios públicos | Sitios públicos con protección de rama |
| Insights de repositorio | Limitados | **Completos** (dependencias, tráfico) |
| Herramientas de revisión de código | Básicas | **Avanzadas** (revisores automáticos) |
| Protección de ramas | Básica | **Avanzada** (revisores requeridos) |
| Soporte | Comunidad | **Soporte por email** |
| Wikis | Ilimitados | Ilimitados |

### Valor agregado en 2025:

- **GitHub Copilot integrado**: Autocompletado de código con IA, generación de funciones completas, explicación de código y corrección de errores.
- **Seguridad mejorada**: Escaneo de dependencias, alertas de seguridad avanzadas, y cumplimiento SOC 2.
- **Insights profundos**: Análisis de dependencias, tráfico del repositorio, clones, vistas y más.
- **Protección de código**: Reglas de protección de ramas más granulares para evitar errores de producción.

---

## Suscripción y Configuración Inicial

### Paso 1: Suscripción a GitHub Pro

#### Desde tu perfil de GitHub:

1. **Inicia sesión** en [GitHub.com](https://github.com)
2. Haz clic en tu **foto de perfil** (esquina superior derecha)
3. Selecciona **Settings** (Configuración)
4. En el menú lateral izquierdo, haz clic en **Billing and plans** (Facturación y planes)
5. En la sección **Plans and usage**, haz clic en **Upgrade** o **Change plan**
6. Selecciona **GitHub Pro** ($4 USD/mes o $48 USD/año en 2025)
7. Completa la información de **método de pago** (tarjeta de crédito/débito o PayPal)
8. Confirma la suscripción

#### Confirmación:

Recibirás un email de confirmación y verás el badge "Pro" en tu perfil inmediatamente.

```bash
# Verifica tu plan actual desde la CLI de GitHub
gh api user | jq '.plan.name'
# Debería mostrar: "pro"
```

### Paso 2: Configuración de GitHub Copilot

Una vez suscrito a Pro, **GitHub Copilot** se incluye automáticamente:

1. Ve a **Settings** → **Copilot**
2. Activa **Enable GitHub Copilot**
3. Selecciona tus preferencias:
   - **Sugerencias para comentarios**: Activa si quieres que Copilot genere código desde comentarios
   - **Sugerencias en múltiples líneas**: Recomendado para funciones completas
   - **Bloqueo de sugerencias que coincidan con código público**: Activa para evitar problemas de licencias

4. Instala la **extensión de Copilot** en tu IDE:
   - **VS Code**: Busca "GitHub Copilot" en Extensions Marketplace
   - **JetBrains IDEs**: Busca en Plugins → "GitHub Copilot"
   - **Neovim**: Usa `copilot.vim` o `copilot.lua`

5. Autentícate desde el IDE cuando se te solicite

```bash
# Ejemplo de instalación en VS Code desde CLI
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

### Paso 3: Configuración del Entorno Git Local

Asegúrate de tener Git configurado correctamente:

```bash
# Configura tu identidad
git config --global user.name "Tu Nombre"
git config --global user.email "tu-email@ejemplo.com"

# Configura tu editor preferido
git config --global core.editor "code --wait"  # VS Code
# git config --global core.editor "vim"  # Vim

# Autenticación con GitHub CLI (recomendado en 2025)
gh auth login
# Selecciona: GitHub.com → HTTPS → Login with a web browser

# Verifica la autenticación
gh auth status
```

### Paso 4: Configuración de Seguridad

1. **Habilita 2FA (Autenticación de dos factores)**:
   - Settings → Password and authentication → Two-factor authentication
   - Usa una app como Google Authenticator, Authy o 1Password

2. **Genera tokens de acceso personal (PAT)**:
   ```bash
   # Desde GitHub CLI
   gh auth token
   
   # O desde la interfaz web:
   # Settings → Developer settings → Personal access tokens → Tokens (classic)
   ```

3. **Configura claves SSH** (opcional pero recomendado):
   ```bash
   # Genera una clave SSH
   ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"
   
   # Copia la clave pública
   cat ~/.ssh/id_ed25519.pub
   
   # Agrégala en Settings → SSH and GPG keys → New SSH key
   ```

---

## Características Principales

### 1. Repositorios Privados Ilimitados con Colaboradores Ilimitados

Con GitHub Pro, puedes crear repositorios privados sin límites de colaboradores:

```bash
# Crear un repositorio privado desde CLI
gh repo create mi-proyecto-privado --private --clone

# Agregar colaboradores
gh repo add-collaborator OWNER/REPO USERNAME
```

**Caso de uso**: Ideal para proyectos freelance, portfolios privados o experimentación sin exposición pública.

### 2. Insights Avanzados de Repositorio

#### Gráfico de Dependencias:

Ve qué paquetes usa tu proyecto y recibe alertas de seguridad:

1. Ve a tu repositorio → **Insights** → **Dependency graph**
2. Activa **Dependabot alerts** para recibir notificaciones automáticas

```yaml
# Ejemplo: Configurar Dependabot para actualizaciones automáticas
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
```

#### Análisis de Tráfico:

Monitorea quién visita y clona tu repositorio:

- **Insights** → **Traffic**: Vistas únicas, clones, rutas populares, referidores

**Aplicación práctica**: Identifica proyectos que generan más interés para priorizar mantenimiento.

### 3. Protección Avanzada de Ramas

Configura reglas estrictas para ramas críticas como `main` o `production`:

1. Ve a **Settings** → **Branches** → **Add branch protection rule**
2. Nombre del patrón: `main`
3. Activa:
   - ✅ **Require a pull request before merging**
   - ✅ **Require approvals** (mínimo 1-2 revisores)
   - ✅ **Dismiss stale pull request approvals when new commits are pushed**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**
   - ✅ **Require conversation resolution before merging**

```bash
# Ejemplo: Crear una rama de desarrollo
git checkout -b develop
git push -u origin develop

# Configurar para que todas las features salgan de develop
git checkout -b feature/nueva-funcionalidad develop
```

### 4. GitHub Pages con Protección

Publica sitios estáticos con control avanzado:

```bash
# Ejemplo: Publicar documentación con MkDocs
mkdocs gh-deploy

# O con Jekyll (GitHub Pages nativo)
bundle exec jekyll serve
git add .
git commit -m "Update docs"
git push origin main
```

Con Pro, puedes configurar **branch protection** incluso en `gh-pages`.

### 5. Wikis Ilimitadas

Documenta tu proyecto de manera estructurada:

```bash
# Clonar el wiki como repositorio Git
git clone https://github.com/USERNAME/REPO.wiki.git

# Editar localmente y pushear
cd REPO.wiki
echo "# Página de inicio" > Home.md
git add .
git commit -m "Initial wiki"
git push origin master
```

---

## GitHub Copilot: Tu Asistente de IA

GitHub Copilot es **la joya de la corona** de GitHub Pro en 2025. Es un asistente de programación basado en IA que utiliza modelos de lenguaje avanzados (OpenAI Codex y GPT-4) entrenados en miles de millones de líneas de código público.

### Capacidades de Copilot:

1. **Autocompletado inteligente**: Sugiere líneas completas o bloques de código
2. **Generación de funciones**: Escribe un comentario describiendo qué necesitas, Copilot genera la función
3. **Explicación de código**: Pregunta qué hace un bloque de código y Copilot lo explica
4. **Detección de errores**: Identifica bugs potenciales y sugiere correcciones
5. **Conversión de lenguajes**: Traduce código de un lenguaje a otro
6. **Escritura de tests**: Genera tests unitarios automáticamente

### Ejemplo Práctico 1: Generación de Función

```javascript
// Prompt: Función para validar email con regex
function validateEmail(email) {
  // Copilot sugiere automáticamente:
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}
```

### Ejemplo Práctico 2: Generación de Tests

```python
# test_calculator.py
def add(a, b):
    return a + b

# Escribe: "# Test para la función add"
# Copilot genera:
def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
```

### Ejemplo Práctico 3: GitHub Copilot Chat (2025)

En 2025, **Copilot Chat** está integrado directamente en VS Code:

```
Tú: "Cómo puedo optimizar esta consulta SQL?"

SELECT * FROM users WHERE status = 'active' AND created_at > '2024-01-01'

Copilot Chat: "Esta consulta puede mejorarse con índices y selección específica:
1. Crea índices en 'status' y 'created_at'
2. Selecciona solo columnas necesarias en lugar de *

CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);

SELECT id, name, email FROM users 
WHERE status = 'active' AND created_at > '2024-01-01';
"
```

### Mejores Prácticas con Copilot:

✅ **Escribe comentarios descriptivos**: Copilot funciona mejor con instrucciones claras  
✅ **Revisa las sugerencias**: No aceptes código ciegamente, entiéndelo primero  
✅ **Usa Copilot para boilerplate**: Deja que genere código repetitivo  
✅ **Aprende de las sugerencias**: Copilot puede enseñarte patrones nuevos  
❌ **No confíes en código sensible**: Revisa cuidadosamente código de seguridad/autenticación  
❌ **No uses para copiar licencias restrictivas**: Activa la protección contra coincidencias públicas

### Shortcuts de Copilot en VS Code:

- `Tab`: Aceptar sugerencia
- `Esc`: Rechazar sugerencia
- `Alt + ]` / `Alt + [`: Navegar entre sugerencias
- `Ctrl + Enter`: Abrir panel de sugerencias múltiples
- `Ctrl + Shift + I`: Activar Copilot Chat

---

## GitHub Actions: Automatización y CI/CD

Con GitHub Pro obtienes **3,000 minutos/mes gratis** de Actions (vs 2,000 en Free), perfecto para pipelines de CI/CD complejos.

### ¿Qué es GitHub Actions?

Es una plataforma de automatización que permite ejecutar flujos de trabajo (workflows) en respuesta a eventos del repositorio (push, pull request, issues, etc.).

### Ejemplo 1: CI Básico para Node.js

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [18.x, 20.x]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Run linter
      run: npm run lint
```

### Ejemplo 2: Despliegue Automático a Producción

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Build application
      run: npm run build
    
    - name: Deploy to S3
      run: aws s3 sync ./dist s3://mi-bucket-prod --delete
    
    - name: Invalidate CloudFront cache
      run: |
        aws cloudfront create-invalidation \
          --distribution-id ${{ secrets.CLOUDFRONT_DIST_ID }} \
          --paths "/*"
```

### Ejemplo 3: Actualización Automática de Dependencias con Dependabot

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "tu-usuario"
    labels:
      - "dependencies"
      - "automated"
```

### Ejemplo 4: Notificaciones de Slack en Fallos

```yaml
# .github/workflows/notify.yml
name: Notify on Failure

on:
  workflow_run:
    workflows: ["CI"]
    types: [completed]

jobs:
  notify:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    
    steps:
    - name: Send Slack notification
      uses: slackapi/slack-github-action@v1
      with:
        payload: |
          {
            "text": "❌ CI failed on ${{ github.repository }}",
            "blocks": [
              {
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": "*CI Pipeline Failed*\nRepository: ${{ github.repository }}\nBranch: ${{ github.ref }}"
                }
              }
            ]
          }
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

### Mejores Prácticas con Actions:

✅ **Usa caché para dependencias**: Reduce tiempo y costos  
✅ **Ejecuta trabajos en paralelo**: Maximiza eficiencia  
✅ **Almacena secretos en GitHub Secrets**: Nunca en código  
✅ **Usa matrices para múltiples versiones**: Testa compatibilidad  
✅ **Limita ejecuciones con `paths`**: Solo ejecuta cuando sea necesario

```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'package.json'
```

---

## Seguridad Avanzada

GitHub Pro incluye características de seguridad críticas para proteger tu código y cumplir con estándares como **SOC 2**.

### 1. Dependabot Alerts

Recibe alertas automáticas cuando dependencias tienen vulnerabilidades conocidas:

1. **Settings** → **Security & analysis**
2. Activa **Dependency graph**, **Dependabot alerts**, **Dependabot security updates**

```bash
# Ver alertas desde CLI
gh api repos/OWNER/REPO/dependabot/alerts

# Ver vulnerabilidades de seguridad
gh api repos/OWNER/REPO/vulnerability-alerts
```

### 2. Code Scanning con CodeQL

Analiza tu código en busca de vulnerabilidades:

```yaml
# .github/workflows/codeql.yml
name: "CodeQL"

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 1'  # Ejecutar semanalmente

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    
    strategy:
      matrix:
        language: [ 'javascript', 'python' ]
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
    
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v3
      with:
        languages: ${{ matrix.language }}
    
    - name: Autobuild
      uses: github/codeql-action/autobuild@v3
    
    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
```

### 3. Secret Scanning

GitHub escanea automáticamente commits en busca de secretos filtrados (API keys, tokens, contraseñas):

- **Activa push protection** en Settings → Code security and analysis
- Esto previene que se hagan push de commits con secretos

```bash
# Ejemplo de secreto que sería detectado
AWS_SECRET_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# En su lugar, usa GitHub Secrets:
# Settings → Secrets and variables → Actions → New repository secret
```

### 4. Revisión de Seguridad en Pull Requests

Configura reglas para que PRs requieran revisión de seguridad:

```yaml
# .github/workflows/security-review.yml
name: Security Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Run security audit
      run: npm audit --audit-level=moderate
    
    - name: Check for secrets
      uses: trufflesecurity/trufflehog@main
      with:
        path: ./
```

### 5. Firma de Commits con GPG

Verifica la autenticidad de tus commits:

```bash
# Generar clave GPG
gpg --full-generate-key

# Listar claves
gpg --list-secret-keys --keyid-format LONG

# Exportar clave pública
gpg --armor --export TU_KEY_ID

# Configurar Git para firmar
git config --global user.signingkey TU_KEY_ID
git config --global commit.gpgsign true

# Agregar clave en GitHub:
# Settings → SSH and GPG keys → New GPG key
```

### 6. Cumplimiento SOC 2

GitHub Pro cumple con **SOC 2 Type II**, lo que significa:

- ✅ Controles de seguridad auditados independientemente
- ✅ Protección de datos en tránsito y reposo (cifrado)
- ✅ Monitoreo continuo de amenazas
- ✅ Gestión de acceso basada en roles
- ✅ Logs de auditoría detallados

**Accede a logs de auditoría**:
- Organizations → Settings → Logs → Audit log
- Exporta logs para cumplimiento regulatorio

---

## Colaboración en Equipo

### 1. Pull Requests Efectivos

#### Plantilla de PR:

```markdown
# .github/PULL_REQUEST_TEMPLATE.md

## Descripción
<!-- Describe los cambios realizados -->

## Tipo de cambio
- [ ] Bug fix (cambio que corrige un issue)
- [ ] Nueva funcionalidad (cambio que agrega funcionalidad)
- [ ] Breaking change (cambio que rompe compatibilidad)
- [ ] Documentación

## ¿Cómo se ha probado?
<!-- Describe las pruebas realizadas -->

## Checklist
- [ ] Mi código sigue las convenciones del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado código complejo
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan nuevas advertencias
- [ ] He agregado tests que prueban mi cambio
- [ ] Todos los tests pasan localmente
```

#### Uso de Code Owners:

```
# .github/CODEOWNERS

# Dueños globales
* @equipo-dev

# Backend
/src/backend/ @equipo-backend @arquitecto-principal

# Frontend
/src/frontend/ @equipo-frontend

# Infraestructura
/terraform/ @equipo-devops
/k8s/ @equipo-devops

# Documentación
/docs/ @tech-writer @product-manager
```

### 2. Revisión de Código de Calidad

**Mejores prácticas para revisores**:

✅ **Sé constructivo**: "Considera usar `map` en lugar de `forEach` para retornar valores"  
✅ **Pregunta, no ordenes**: "¿Por qué elegiste este enfoque?"  
✅ **Reconoce el buen código**: "Excelente manejo de errores aquí 👍"  
✅ **Revisa lógica, no estilo**: Deja que linters manejen formato  
✅ **Usa sugerencias de código**:

```javascript
// En el comentario de revisión, usa sugerencias:
// ```suggestion
const result = items.filter(item => item.active);
// ```
```

### 3. GitHub Projects (Gestión de Tareas)

Organiza trabajo con tableros Kanban integrados:

1. **Projects** → **New project** → **Board**
2. Agrega columnas: **Backlog**, **In Progress**, **In Review**, **Done**
3. Convierte issues en cards automáticamente
4. Usa automations:
   - Mover a "In Progress" cuando se asigna
   - Mover a "In Review" cuando se crea PR
   - Mover a "Done" cuando se cierra PR

```bash
# Crear issue desde CLI con labels y asignación
gh issue create \
  --title "Implementar login con OAuth" \
  --body "Necesitamos integrar Google OAuth..." \
  --label "enhancement,high-priority" \
  --assignee tu-usuario
```

### 4. Discusiones (GitHub Discussions)

Reemplaza foros externos con Discussions integradas:

- **Settings** → **Features** → **Discussions** ✅
- Categorías sugeridas:
  - 💡 Ideas
  - 📣 Announcements
  - ❓ Q&A
  - 🙌 Show and tell

```bash
# Ver discusiones desde CLI
gh api repos/OWNER/REPO/discussions
```

### 5. Flujo de Trabajo Git Flow

Estrategia recomendada para equipos:

```bash
# Ramas principales
main          # Producción estable
develop       # Integración de features

# Ramas de soporte
feature/*     # Nuevas funcionalidades
bugfix/*      # Correcciones de bugs
hotfix/*      # Fixes urgentes de producción
release/*     # Preparación de releases

# Ejemplo de workflow
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication
# ... hacer cambios ...
git add .
git commit -m "feat: add user authentication"
git push origin feature/user-authentication
# Crear PR desde feature/user-authentication → develop
```

### 6. Comunicación Efectiva

**Menciones y notificaciones**:

```markdown
# En issues o PRs:
@usuario - Menciona a una persona
@equipo-dev - Menciona a un equipo
#123 - Referencia a issue/PR
SHA: abc123 - Referencia a commit
```

**Keywords para cerrar issues automáticamente**:

```
fixes #123
closes #123
resolves #123
```

---

## Gestión de Repositorios Grandes

En 2025, GitHub Pro soporta repositorios de **10+ GB** con optimizaciones:

### 1. Git LFS (Large File Storage)

Para archivos grandes (modelos ML, datasets, videos):

```bash
# Instalar Git LFS
git lfs install

# Rastrear archivos grandes
git lfs track "*.psd"
git lfs track "*.mp4"
git lfs track "models/*.h5"

# Verificar qué se rastrea
cat .gitattributes

# Hacer commit normal
git add .gitattributes
git add archivo-grande.mp4
git commit -m "Add large video file"
git push origin main
```

**Con GitHub Pro**: 2 GB de almacenamiento LFS gratis (vs 1 GB en Free)

### 2. Partial Clone (Clonado Parcial)

Clona solo lo necesario:

```bash
# Clonar sin historial completo (shallow clone)
git clone --depth 1 https://github.com/OWNER/REPO.git

# Clonar sin blobs (solo commits)
git clone --filter=blob:none https://github.com/OWNER/REPO.git

# Clonar solo una rama
git clone --single-branch --branch main https://github.com/OWNER/REPO.git
```

### 3. Sparse Checkout (Checkout Selectivo)

Descarga solo carpetas específicas:

```bash
git clone --filter=blob:none --sparse https://github.com/OWNER/REPO.git
cd REPO
git sparse-checkout init --cone
git sparse-checkout set src/backend
```

### 4. Monorepos Eficientes

Para proyectos con múltiples aplicaciones:

```
mi-monorepo/
├── apps/
│   ├── web/
│   ├── mobile/
│   └── admin/
├── packages/
│   ├── ui-components/
│   └── shared-utils/
└── .github/
    └── workflows/
        ├── ci-web.yml
        ├── ci-mobile.yml
        └── ci-admin.yml
```

```yaml
# .github/workflows/ci-web.yml
name: CI - Web

on:
  push:
    paths:
      - 'apps/web/**'
      - 'packages/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test --workspace=apps/web
```

---

## Mejores Prácticas y Optimización

### 1. Commits Semánticos

Usa **Conventional Commits** para mensajes estandarizados:

```bash
feat: add user registration endpoint
fix: resolve null pointer in payment processing
docs: update API documentation for v2
style: format code with prettier
refactor: extract validation logic to service
test: add unit tests for auth module
chore: update dependencies
perf: optimize database queries
ci: add deployment workflow
```

**Beneficios**: Generación automática de changelogs, versionado semántico automático.

### 2. Pre-commit Hooks

Valida código antes de commit:

```bash
# Instalar pre-commit
pip install pre-commit

# Configurar
cat > .pre-commit-config.yaml << 'YAML'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=1000']
  
  - repo: https://github.com/psf/black
    rev: 24.1.0
    hooks:
      - id: black
YAML

# Instalar hooks
pre-commit install

# Ahora cada commit ejecutará estas validaciones automáticamente
```

### 3. Branching Strategy

**Para equipos pequeños (1-5 devs)**:

```
main (protegida)
  ↑
feature/X → PR → main
```

**Para equipos medianos/grandes (5+ devs)**:

```
main (producción)
  ↑
release/v1.2.0
  ↑
develop (integración)
  ↑
feature/X → PR → develop
```

### 4. Automatización con GitHub CLI

```bash
# Script para crear PR automáticamente
create-pr() {
  local branch=$(git branch --show-current)
  local title="$1"
  
  git push -u origin $branch
  gh pr create \
    --title "$title" \
    --body "Auto-generated PR for $branch" \
    --base develop \
    --reviewer @equipo-dev
}

# Uso
create-pr "feat: add new dashboard"
```

### 5. Templates para Issues

```markdown
# .github/ISSUE_TEMPLATE/bug_report.md
---
name: Bug Report
about: Reporta un bug para ayudarnos a mejorar
title: '[BUG] '
labels: bug
assignees: ''
---

**Describe el bug**
Descripción clara y concisa del problema.

**Para reproducir**
Pasos para reproducir:
1. Ve a '...'
2. Haz click en '...'
3. Observa el error

**Comportamiento esperado**
Qué esperabas que sucediera.

**Screenshots**
Si aplica, agrega screenshots.

**Entorno:**
 - OS: [e.g. Ubuntu 22.04]
 - Navegador: [e.g. Chrome 120]
 - Versión: [e.g. 1.2.3]

**Contexto adicional**
Cualquier otra información relevante.
```

### 6. Badges en README

Muestra estado del proyecto:

```markdown
# Mi Proyecto

![CI](https://github.com/OWNER/REPO/workflows/CI/badge.svg)
![Coverage](https://img.shields.io/codecov/c/github/OWNER/REPO)
![License](https://img.shields.io/github/license/OWNER/REPO)
![Version](https://img.shields.io/github/v/release/OWNER/REPO)

Descripción del proyecto...
```

### 7. Performance en Actions

```yaml
# Caché de dependencias
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-

# Jobs en paralelo
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]
  
  test:
    runs-on: ubuntu-latest
    steps: [...]
  
  build:
    needs: [lint, test]  # Solo ejecuta si lint y test pasan
    runs-on: ubuntu-latest
    steps: [...]
```

---

## Costos y Migración

### Estructura de Precios (2025)

| Plan | Precio | Incluye |
|------|--------|----------|
| **Free** | $0/mes | Repos públicos/privados ilimitados, 2,000 min Actions, 500 MB Packages |
| **Pro** | $4/mes ($48/año) | Todo lo de Free + Copilot, 3,000 min Actions, 2 GB Packages, insights avanzados |
| **Team** | $4/usuario/mes | Pro + herramientas de equipo, revisiones requeridas, páginas de equipo |
| **Enterprise** | $21/usuario/mes | Team + SAML SSO, auditoría avanzada, soporte 24/7 |

### ¿Cuándo vale la pena GitHub Pro?

✅ **Sí, si...**
- Eres desarrollador profesional que programa diariamente
- Necesitas **GitHub Copilot** (solo esto vale $10/mes)
- Trabajas en proyectos privados con múltiples colaboradores
- Requieres insights detallados de repositorios
- Necesitas más minutos de Actions (3,000 vs 2,000)

❌ **No, si...**
- Solo trabajas en proyectos open source (Free es suficiente)
- No usas IA para programar
- Tus repositorios privados tienen pocos colaboradores
- No excedes los límites de Free

### Migración desde Free a Pro

El proceso es **instantáneo y sin interrupción**:

1. **Actualiza el plan** (Settings → Billing → Upgrade)
2. **Activa Copilot** inmediatamente
3. **No se pierde ningún dato**: repos, issues, PRs permanecen intactos
4. **Billing prorrateado**: Pagas solo por días restantes del mes

```bash
# Verificar plan actual
gh api user | jq '.plan.name'

# Después de upgrade, deberías ver:
# "pro"
```

### Descuentos y Promociones

- 🎓 **Estudiantes**: GitHub Pro GRATIS con [GitHub Student Developer Pack](https://education.github.com/pack)
- 👨‍🏫 **Educadores**: Pro gratis con [GitHub Teacher Toolbox](https://education.github.com/teachers)
- 🚀 **Startups**: Descuentos en GitHub para Startups (parte de Microsoft for Startups)
- 💡 **Open Source Maintainers**: Posible acceso gratuito con [GitHub Sponsors](https://github.com/sponsors)

### Downgrade de Pro a Free

Si decides cancelar:

1. Settings → Billing → Change plan → Downgrade to Free
2. **Mantienes acceso a Pro hasta fin del período pagado**
3. **Perderás**:
   - GitHub Copilot
   - Insights avanzados
   - Minutos extra de Actions
   - Almacenamiento extra de Packages
4. **Conservas**:
   - Todos tus repositorios
   - Todo el historial
   - Colaboradores (pero con límites en privados)

**⚠️ Advertencia**: Copilot se desactiva inmediatamente al terminar el período.

---

## Referencias y Recursos Oficiales

### Documentación Oficial

1. **GitHub Docs**: [https://docs.github.com](https://docs.github.com)
2. **GitHub Pro Features**: [https://docs.github.com/en/get-started/learning-about-github/githubs-products#github-pro](https://docs.github.com/en/get-started/learning-about-github/githubs-products#github-pro)
3. **GitHub Copilot Docs**: [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)
4. **GitHub Actions Docs**: [https://docs.github.com/en/actions](https://docs.github.com/en/actions)
5. **GitHub CLI Manual**: [https://cli.github.com/manual/](https://cli.github.com/manual/)
6. **Git Official Docs**: [https://git-scm.com/doc](https://git-scm.com/doc)

### Comunidad y Soporte

- **GitHub Community Forum**: [https://github.community](https://github.community)
- **GitHub Skills** (cursos interactivos): [https://skills.github.com](https://skills.github.com)
- **GitHub Blog**: [https://github.blog](https://github.blog)
- **GitHub Status**: [https://www.githubstatus.com](https://www.githubstatus.com)
- **GitHub Support** (Pro users): [https://support.github.com](https://support.github.com)

### Herramientas Recomendadas

- **GitHub CLI**: [https://cli.github.com](https://cli.github.com)
- **GitHub Desktop**: [https://desktop.github.com](https://desktop.github.com)
- **GitHub Mobile**: [iOS](https://apps.apple.com/app/github/id1477376905) | [Android](https://play.google.com/store/apps/details?id=com.github.android)
- **VS Code + Copilot**: [https://code.visualstudio.com](https://code.visualstudio.com)

### Libros y Cursos

- **Pro Git** (libro gratuito): [https://git-scm.com/book/en/v2](https://git-scm.com/book/en/v2)
- **GitHub Learning Lab**: Cursos interactivos dentro de GitHub
- **Microsoft Learn - GitHub**: [https://learn.microsoft.com/en-us/training/github/](https://learn.microsoft.com/en-us/training/github/)

### Seguridad y Cumplimiento

- **GitHub Security**: [https://github.com/security](https://github.com/security)
- **SOC 2 Compliance**: [https://github.com/security/audit](https://github.com/security/audit)
- **GitHub Advanced Security**: [https://docs.github.com/en/code-security](https://docs.github.com/en/code-security)

### Changelog y Novedades

- **GitHub Changelog**: [https://github.blog/changelog/](https://github.blog/changelog/)
- **GitHub Roadmap**: [https://github.com/github/roadmap](https://github.com/github/roadmap)

---

## Conclusión

**GitHub Pro en 2025** es una inversión estratégica para cualquier desarrollador profesional. La inclusión de **GitHub Copilot** por solo $4/mes (cuando Copilot solo costaría $10/mes) hace que el valor sea indiscutible. Combinado con características avanzadas de seguridad, colaboración mejorada y herramientas de automatización, GitHub Pro transforma la manera en que desarrollas software.

### Pasos Siguientes Recomendados:

1. ✅ **Suscríbete a GitHub Pro** si cumples con los criterios mencionados
2. ✅ **Activa GitHub Copilot** y configúralo en tu IDE principal
3. ✅ **Implementa CI/CD con GitHub Actions** para al menos un proyecto
4. ✅ **Configura protección de ramas** en repositorios críticos
5. ✅ **Habilita Dependabot** y Code Scanning para seguridad proactiva
6. ✅ **Explora GitHub Projects** para gestión de tareas
7. ✅ **Comparte conocimiento** con tu equipo sobre mejores prácticas

### Recuerda:

> "El código es leído 10 veces más de lo que es escrito. Invierte en herramientas que faciliten la colaboración, aumenten la seguridad y mejoren tu productividad."

¡Feliz coding con GitHub Pro! 🚀

---

**Autor**: Experto en Desarrollo de Software y Plataformas de Colaboración  
**Última actualización**: 2025  
**Licencia**: Creative Commons BY-SA 4.0  

Para contribuciones o correcciones, abre un issue o PR en este repositorio.
