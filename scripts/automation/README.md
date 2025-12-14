# 🤖 Bots de Automatización

## Test Runner Bot

Ejecuta tests de Flutter en paralelo:

```bash
# Ejecutar todos los tests
python3 scripts/automation/test_runner.py

# Genera: test_report.json
```

## Build Bot

Automatiza el proceso de build:

```bash
# Build completo
python3 scripts/automation/build_bot.py
```

## Integración CI/CD

Agregar a `.github/workflows/ci.yml`:

```yaml
- name: Run automated tests
  run: python3 scripts/automation/test_runner.py
  
- name: Build APK
  run: python3 scripts/automation/build_bot.py
```
