# 🛠️ Creating Custom Bots

Esta guía te enseña cómo crear tus propios bots de automatización.

## 📋 Requisitos

Para crear un bot personalizado necesitas:
- Conocimiento básico de Dart
- Entender el ciclo de vida de los bots
- Tener una tarea específica a automatizar

## 🎯 Anatomía de un Bot

Un bot se compone de:

1. **Metadata** - Nombre, emoji, rol, prioridad
2. **Execute** - Lógica principal
3. **Hooks** - onSuccess, onFailure
4. **Configuration** - Triggers y capabilities

## 📝 Plantilla Básica

```dart
import 'dart:io';
import '../core/bot_base.dart';

/// Mi bot personalizado
class MyCustomBot extends AutomationBot {
  @override
  String get name => 'My Custom Bot';

  @override
  String get emoji => '🎯';

  @override
  String get role => 'Custom Task Executor';

  @override
  BotPriority get priority => BotPriority.medium;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Starting my custom task...');

    try {
      // Tu lógica aquí
      final result = await _doMyCustomTask();

      final duration = DateTime.now().difference(startTime);
      log('✅ Task completed successfully');

      return BotResult.success(
        message: 'Custom task completed',
        data: {'result': result},
        duration: duration,
      );
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Custom task failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<String> _doMyCustomTask() async {
    // Implementa tu tarea aquí
    return 'success';
  }
}
```

## 🔧 Componentes Detallados

### 1. Metadata

```dart
@override
String get name => 'My Custom Bot';  // Nombre descriptivo

@override
String get emoji => '🎯';  // Emoji único

@override
String get role => 'Custom Task Executor';  // Rol breve

@override
BotPriority get priority => BotPriority.medium;  // Prioridad
```

**Prioridades disponibles**:
- `BotPriority.critical` - Bloquea workflow si falla
- `BotPriority.high` - Importante pero no bloquea
- `BotPriority.medium` - Normal
- `BotPriority.low` - Baja prioridad

### 2. Execute Method

```dart
@override
Future<BotResult> execute(BotContext context) async {
  final startTime = DateTime.now();
  
  try {
    // 1. Log inicio
    log('Starting task...');
    
    // 2. Obtener configuración
    final config = context.getConfig<bool>('my_option', defaultValue: true);
    
    // 3. Ejecutar tarea
    final result = await _myTask();
    
    // 4. Calcular duración
    final duration = DateTime.now().difference(startTime);
    
    // 5. Retornar resultado exitoso
    return BotResult.success(
      message: 'Task completed',
      data: {'result': result},
      duration: duration,
    );
  } catch (e, st) {
    // Manejo de errores
    final duration = DateTime.now().difference(startTime);
    return BotResult.failure(
      message: 'Task failed',
      error: e.toString(),
      stackTrace: st,
      duration: duration,
    );
  }
}
```

### 3. Context API

```dart
// Obtener configuración
final value = context.getConfig<String>('key', defaultValue: 'default');

// Acceder al trigger
final trigger = context.trigger;  // 'on_push', 'on_pr', etc.

// Tiempo transcurrido
final elapsed = context.elapsed;

// Metadata adicional
final metadata = context.metadata;
```

### 4. Hooks Opcionales

```dart
@override
Future<bool> canExecute(BotContext context) async {
  // Lógica para determinar si el bot debe ejecutarse
  return true;
}

@override
Future<void> onSuccess(BotResult result) async {
  await super.onSuccess(result);
  // Lógica adicional después del éxito
  log('Additional success handling');
}

@override
Future<void> onFailure(BotResult result) async {
  await super.onFailure(result);
  // Lógica adicional después del fallo
  log('Additional failure handling');
}

@override
Duration get timeout => const Duration(minutes: 10);  // Timeout personalizado
```

## 📦 Registrar el Bot

1. **Crea el archivo**: `bots/specialized/my_custom_bot.dart`

2. **Importa en el runner**: `bots/run_bots.dart`
```dart
import 'specialized/my_custom_bot.dart';

// En main()
var bots = <AutomationBot>[
  // ... otros bots
  MyCustomBot(),
];
```

3. **Agrega al registry**: `bots/run_bots.dart`
```dart
registry.register('my_custom', BotConfig(
  name: 'My Custom Bot',
  emoji: '🎯',
  role: 'Custom Task Executor',
  triggers: ['on_push'],
  capabilities: ['custom_task'],
  priority: BotPriority.medium,
  enabled: true,
));
```

4. **Actualiza el YAML**: `bots/registry/bot_registry.yaml`
```yaml
bots:
  my_custom:
    name: "My Custom Bot"
    emoji: "🎯"
    role: "Custom Task Executor"
    triggers:
      - on_push
    capabilities:
      - custom_task
    priority: medium
    enabled: true
```

## 💡 Ejemplos Avanzados

### Bot que ejecuta comandos

```dart
Future<Map<String, dynamic>> _runCommand(String cmd, List<String> args) async {
  final result = await Process.run(cmd, args);
  
  return {
    'exit_code': result.exitCode,
    'stdout': result.stdout.toString(),
    'stderr': result.stderr.toString(),
  };
}
```

### Bot que lee archivos

```dart
Future<List<String>> _scanFiles(String pattern) async {
  final files = <String>[];
  
  await for (final entity in Directory('.').list(recursive: true)) {
    if (entity is File && entity.path.contains(pattern)) {
      files.add(entity.path);
    }
  }
  
  return files;
}
```

### Bot con configuración específica

```dart
@override
Future<BotResult> execute(BotContext context) async {
  // Leer opciones específicas
  final enabled = context.getConfig<bool>('feature_enabled', defaultValue: false);
  final threshold = context.getConfig<int>('threshold', defaultValue: 100);
  final targets = context.getConfig<List>('targets', defaultValue: []);
  
  if (!enabled) {
    return BotResult.success(
      message: 'Feature disabled, skipping',
      duration: Duration.zero,
    );
  }
  
  // ... resto de la lógica
}
```

## 🧪 Testing de Bots

```dart
void main() {
  test('MyCustomBot executes successfully', () async {
    final bot = MyCustomBot();
    final context = BotContext(
      trigger: 'on_push',
      config: {},
    );
    
    final result = await bot.execute(context);
    
    expect(result.isSuccess, isTrue);
  });
}
```

## 🎯 Best Practices

1. **Single Responsibility**: Un bot = una tarea
2. **Logging Descriptivo**: Usa `log()` frecuentemente
3. **Manejo de Errores**: Siempre captura excepciones
4. **Timeouts**: Define timeouts apropiados
5. **Idempotencia**: Mismos resultados en múltiples ejecuciones
6. **Cleanup**: Limpia recursos temporales
7. **Testing**: Crea tests para tus bots

## 📚 Recursos

- [Bot Base API](../../api/bot-api.md)
- [Ejemplos de Bots](../../examples/custom-bot-example.md)
- [Bot System Overview](bot-system-overview.md)

---

¡Crea bots poderosos! 🤖
