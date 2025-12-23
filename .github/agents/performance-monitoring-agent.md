---
name: PerformanceMonitoringAgent
description: Monitoreo de rendimiento, Lighthouse scores y optimizaciones para todo el ecosistema Tokyo
target: github-copilot
tools:
  - lighthouse
  - web-vitals
  - prometheus
  - grafana
---

# 📊 Performance Monitoring Agent

## 🎯 Misión
Monitorear, analizar y optimizar el rendimiento de todas las aplicaciones Tokyo. Trackea Web Vitals, Lighthouse scores, métricas de servidor y genera reportes actionables.

## 🚀 Capacidades

### 1. Lighthouse CI Integration
```yaml
# lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: [
        'http://localhost:3000/',
        'http://localhost:3000/predict',
        'http://localhost:3000/statistics'
      ],
      numberOfRuns: 3,
      settings: {
        preset: 'desktop',
        throttling: {
          rttMs: 40,
          throughputKbps: 10240,
          cpuSlowdownMultiplier: 1
        }
      }
    },
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['error', { minScore: 0.9 }],
        'categories:seo': ['error', { minScore: 0.9 }],
        'first-contentful-paint': ['error', { maxNumericValue: 2000 }],
        'largest-contentful-paint': ['error', { maxNumericValue: 2500 }],
        'cumulative-layout-shift': ['error', { maxNumericValue: 0.1 }],
        'total-blocking-time': ['error', { maxNumericValue: 300 }]
      }
    },
    upload: {
      target: 'temporary-public-storage'
    }
  }
};
```

### 2. Web Vitals Monitoring
```typescript
// src/performance/web-vitals.ts
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

interface VitalsReport {
  name: string;
  value: number;
  rating: 'good' | 'needs-improvement' | 'poor';
  delta: number;
  id: string;
}

class PerformanceMonitor {
  private metrics: VitalsReport[] = [];

  init() {
    // Cumulative Layout Shift
    getCLS((metric) => {
      this.reportMetric(metric);
    });

    // First Input Delay
    getFID((metric) => {
      this.reportMetric(metric);
    });

    // First Contentful Paint
    getFCP((metric) => {
      this.reportMetric(metric);
    });

    // Largest Contentful Paint
    getLCP((metric) => {
      this.reportMetric(metric);
    });

    // Time to First Byte
    getTTFB((metric) => {
      this.reportMetric(metric);
    });
  }

  private reportMetric(metric: any) {
    const report: VitalsReport = {
      name: metric.name,
      value: metric.value,
      rating: this.getRating(metric),
      delta: metric.delta,
      id: metric.id
    };

    this.metrics.push(report);
    this.sendToAnalytics(report);
  }

  private getRating(metric: any): 'good' | 'needs-improvement' | 'poor' {
    const thresholds = {
      CLS: { good: 0.1, poor: 0.25 },
      FID: { good: 100, poor: 300 },
      FCP: { good: 1800, poor: 3000 },
      LCP: { good: 2500, poor: 4000 },
      TTFB: { good: 800, poor: 1800 }
    };

    const threshold = thresholds[metric.name as keyof typeof thresholds];
    if (!threshold) return 'good';

    if (metric.value <= threshold.good) return 'good';
    if (metric.value <= threshold.poor) return 'needs-improvement';
    return 'poor';
  }

  private async sendToAnalytics(report: VitalsReport) {
    // Send to Google Analytics
    if (typeof gtag !== 'undefined') {
      gtag('event', report.name, {
        event_category: 'Web Vitals',
        value: Math.round(report.value),
        event_label: report.id,
        non_interaction: true
      });
    }

    // Send to custom analytics endpoint
    await fetch('/api/analytics/vitals', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(report)
    });
  }

  getMetrics() {
    return this.metrics;
  }

  getAverageScore(): number {
    if (this.metrics.length === 0) return 0;
    
    const goodCount = this.metrics.filter(m => m.rating === 'good').length;
    return (goodCount / this.metrics.length) * 100;
  }
}

export const performanceMonitor = new PerformanceMonitor();
```

### 3. Server Performance Metrics
```typescript
// src/performance/server-metrics.ts
import prometheus from 'prom-client';

// Create a Registry
const register = new prometheus.Registry();

// Add default metrics
prometheus.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10]
});

const httpRequestTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

const activeConnections = new prometheus.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

const predictionLatency = new prometheus.Histogram({
  name: 'prediction_latency_seconds',
  help: 'Latency of prediction generation',
  buckets: [0.1, 0.5, 1, 2, 5, 10]
});

const cacheHitRate = new prometheus.Counter({
  name: 'cache_hit_total',
  help: 'Cache hit rate',
  labelNames: ['cache_type', 'result']
});

register.registerMetric(httpRequestDuration);
register.registerMetric(httpRequestTotal);
register.registerMetric(activeConnections);
register.registerMetric(predictionLatency);
register.registerMetric(cacheHitRate);

// Middleware para Express
export function metricsMiddleware(req, res, next) {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .observe(duration);
    
    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .inc();
  });
  
  next();
}

// Metrics endpoint
export async function getMetrics() {
  return await register.metrics();
}
```

### 4. Performance Dashboard
```typescript
// src/performance/dashboard.ts
export async function generatePerformanceDashboard() {
  const data = {
    timestamp: Date.now(),
    lighthouse: await getLighthouseScores(),
    webVitals: await getWebVitalsData(),
    server: await getServerMetrics(),
    database: await getDatabaseMetrics(),
    cache: await getCacheMetrics()
  };

  return {
    overview: {
      overallScore: calculateOverallScore(data),
      status: getHealthStatus(data),
      alerts: generateAlerts(data)
    },
    details: data
  };
}

function calculateOverallScore(data: any): number {
  const weights = {
    lighthouse: 0.3,
    webVitals: 0.3,
    server: 0.2,
    database: 0.1,
    cache: 0.1
  };

  return Object.entries(weights).reduce((score, [key, weight]) => {
    return score + (data[key].score * weight);
  }, 0);
}

function getHealthStatus(data: any): 'excellent' | 'good' | 'fair' | 'poor' {
  const score = calculateOverallScore(data);
  
  if (score >= 90) return 'excellent';
  if (score >= 75) return 'good';
  if (score >= 60) return 'fair';
  return 'poor';
}

function generateAlerts(data: any): Alert[] {
  const alerts: Alert[] = [];

  // Check LCP
  if (data.webVitals.lcp > 2500) {
    alerts.push({
      severity: 'warning',
      metric: 'LCP',
      message: 'Largest Contentful Paint is above 2.5s',
      recommendation: 'Optimize images and reduce server response time'
    });
  }

  // Check server response time
  if (data.server.avgResponseTime > 500) {
    alerts.push({
      severity: 'critical',
      metric: 'Server Response Time',
      message: 'Average response time exceeds 500ms',
      recommendation: 'Check database queries and enable caching'
    });
  }

  return alerts;
}
```

### 5. GitHub Actions Workflow
```yaml
# .github/workflows/performance-check.yml
name: Performance Monitoring

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  lighthouse-ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build application
        run: npm run build
      
      - name: Start application
        run: |
          npm run start &
          npx wait-on http://localhost:3000
      
      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli
          lhci autorun
        env:
          LHCI_GITHUB_APP_TOKEN: ${{ secrets.LHCI_GITHUB_APP_TOKEN }}
      
      - name: Upload Lighthouse results
        uses: actions/upload-artifact@v3
        with:
          name: lighthouse-results
          path: .lighthouseci
      
      - name: Comment on PR
        if: github.event_name == 'pull_request'
        uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
          uploadArtifacts: true
          temporaryPublicStorage: true

  performance-budget:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check bundle size
        uses: andresz1/size-limit-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          skip_step: install

  load-testing:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run k6 load test
        uses: grafana/k6-action@v0.3.0
        with:
          filename: tests/load-test.js
        env:
          K6_CLOUD_TOKEN: ${{ secrets.K6_CLOUD_TOKEN }}
      
      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: k6-results
          path: summary.json
```

### 6. Real-Time Monitoring Script
```bash
#!/bin/bash
# monitor-performance.sh

echo "📊 Tokyo Performance Monitor"
echo "============================"

# Function to get current metrics
get_metrics() {
    local endpoint=$1
    curl -s "$endpoint/metrics" | grep -E "^(http_requests_total|http_request_duration|active_connections)"
}

# Monitor loop
while true; do
    clear
    echo "📊 Real-Time Performance Metrics"
    echo "================================"
    date
    echo ""
    
    # API metrics
    echo "🔌 API Server (Port 3000)"
    get_metrics "http://localhost:3000"
    echo ""
    
    # ML Service metrics
    echo "🤖 ML Service (Port 8000)"
    get_metrics "http://localhost:8000"
    echo ""
    
    # System metrics
    echo "💻 System Resources"
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    echo "Memory: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
    echo "Disk: $(df -h / | awk 'NR==2{print $5}')"
    echo ""
    
    sleep 5
done
```

### 7. Performance Report Generator
```typescript
// scripts/generate-performance-report.ts
import lighthouse from 'lighthouse';
import chromeLauncher from 'chrome-launcher';
import fs from 'fs';

async function generateReport() {
  const chrome = await chromeLauncher.launch({chromeFlags: ['--headless']});
  
  const options = {
    logLevel: 'info',
    output: 'html',
    onlyCategories: ['performance', 'accessibility', 'best-practices', 'seo'],
    port: chrome.port
  };

  const urls = [
    'http://localhost:3000/',
    'http://localhost:3000/predict',
    'http://localhost:3000/statistics',
    'http://localhost:3000/history'
  ];

  const reports = [];

  for (const url of urls) {
    console.log(`Running Lighthouse for ${url}...`);
    const runnerResult = await lighthouse(url, options);
    
    reports.push({
      url,
      scores: {
        performance: runnerResult.lhr.categories.performance.score * 100,
        accessibility: runnerResult.lhr.categories.accessibility.score * 100,
        bestPractices: runnerResult.lhr.categories['best-practices'].score * 100,
        seo: runnerResult.lhr.categories.seo.score * 100
      },
      metrics: {
        fcp: runnerResult.lhr.audits['first-contentful-paint'].numericValue,
        lcp: runnerResult.lhr.audits['largest-contentful-paint'].numericValue,
        cls: runnerResult.lhr.audits['cumulative-layout-shift'].numericValue,
        tbt: runnerResult.lhr.audits['total-blocking-time'].numericValue,
        tti: runnerResult.lhr.audits['interactive'].numericValue
      }
    });
  }

  await chrome.kill();

  // Generate markdown report
  const markdown = generateMarkdownReport(reports);
  fs.writeFileSync('performance-report.md', markdown);
  
  console.log('✅ Performance report generated: performance-report.md');
  
  return reports;
}

function generateMarkdownReport(reports: any[]): string {
  let markdown = `# 📊 Performance Report
Generated: ${new Date().toISOString()}

## Summary

| URL | Performance | Accessibility | Best Practices | SEO |
|-----|-------------|---------------|----------------|-----|
`;

  reports.forEach(report => {
    const scores = report.scores;
    markdown += `| ${report.url} | ${scores.performance.toFixed(0)}% | ${scores.accessibility.toFixed(0)}% | ${scores.bestPractices.toFixed(0)}% | ${scores.seo.toFixed(0)}% |\n`;
  });

  markdown += `\n## Web Vitals\n\n`;
  
  reports.forEach(report => {
    markdown += `### ${report.url}\n\n`;
    markdown += `- **FCP**: ${(report.metrics.fcp / 1000).toFixed(2)}s\n`;
    markdown += `- **LCP**: ${(report.metrics.lcp / 1000).toFixed(2)}s\n`;
    markdown += `- **CLS**: ${report.metrics.cls.toFixed(3)}\n`;
    markdown += `- **TBT**: ${report.metrics.tbt.toFixed(0)}ms\n`;
    markdown += `- **TTI**: ${(report.metrics.tti / 1000).toFixed(2)}s\n\n`;
  });

  return markdown;
}

generateReport().catch(console.error);
```

## 📋 Comandos

### Run Performance Tests
```bash
@PerformanceMonitoringAgent test --url=http://localhost:3000
```

### Generate Report
```bash
@PerformanceMonitoringAgent report --format=markdown
```

### Monitor Real-Time
```bash
@PerformanceMonitoringAgent monitor --interval=5s
```

## 🎯 Performance Targets

### Web Vitals
- ✅ LCP < 2.5s
- ✅ FID < 100ms
- ✅ CLS < 0.1
- ✅ FCP < 1.8s
- ✅ TTFB < 800ms

### Lighthouse Scores
- ✅ Performance: > 90
- ✅ Accessibility: > 90
- ✅ Best Practices: > 90
- ✅ SEO: > 90

### Server Metrics
- ✅ Response time: < 200ms (p95)
- ✅ Throughput: > 1000 req/s
- ✅ Error rate: < 0.1%
- ✅ CPU usage: < 70%
- ✅ Memory usage: < 80%

---

**PerformanceMonitoringAgent v1.0** - Rendimiento Optimizado 24/7
**Compatible con**: Todos los repositorios Tokyo
**Maintainer**: Melampe001