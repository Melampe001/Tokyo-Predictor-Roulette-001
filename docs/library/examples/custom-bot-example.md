# 💡 Custom Bot Example

Este ejemplo muestra cómo crear un bot personalizado completo.

## Caso de Uso: Bot de Limpieza de Assets

Vamos a crear un bot que limpia assets no utilizados del proyecto.

### 1. Crear el Bot

```dart
// bots/specialized/cleaner_bot.dart

import 'dart:io';
import '../core/bot_base.dart';

/// Bot que limpia assets no utilizados
class CleanerBot extends AutomationBot {
  @override
  String get name => 'Cleaner Bot';

  @override
  String get emoji => '🧹';

  @override
  String get role => 'Asset Cleaner';

  @override
  BotPriority get priority => BotPriority.low;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Starting cleanup process...');

    try {
      final results = <String, dynamic>{};

      // 1. Analizar assets declarados
      log('Analyzing declared assets...');
      final declaredAssets = await _getDeclaredAssets();
      results['declared_count'] = declaredAssets.length;

      // 2. Analizar assets referenciados en código
      log('Analyzing referenced assets...');
      final referencedAssets = await _getReferencedAssets();
      results['referenced_count'] = referencedAssets.length;

      // 3. Encontrar assets no utilizados
      final unusedAssets = declaredAssets
          .where((asset) => !referencedAssets.contains(asset))
          .toList();
      
      results['unused_count'] = unusedAssets.length;
      results['unused_assets'] = unusedAssets;

      // 4. Limpiar si está configurado
      if (context.getConfig<bool>('auto_clean', defaultValue: false)) {
        log('Auto-clean enabled, removing unused assets...');
        await _removeAssets(unusedAssets);
        results['cleaned'] = true;
      } else {
        log('Auto-clean disabled, reporting only');
        results['cleaned'] = false;
      }

      final duration = DateTime.now().difference(startTime);
      
      if (unusedAssets.isEmpty) {
        log('✅ No unused assets found');
      } else {
        log('⚠️  Found ${unusedAssets.length} unused assets');
      }

      return BotResult.success(
        message: 'Asset cleanup completed',
        data: results,
        duration: duration,
      );
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Asset cleanup failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<List<String>> _getDeclaredAssets() async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) return [];

    final content = await pubspecFile.readAsString();
    final assets = <String>[];

    // Parseo simple de assets declarados
    var inAssetsSection = false;
    for (final line in content.split('\n')) {
      if (line.trim().startsWith('assets:')) {
        inAssetsSection = true;
      } else if (inAssetsSection) {
        if (line.trim().startsWith('-')) {
          final asset = line.trim().substring(1).trim();
          assets.add(asset);
        } else if (!line.startsWith(' ')) {
          break;
        }
      }
    }

    return assets;
  }

  Future<List<String>> _getReferencedAssets() async {
    final assets = <String>{};
    
    // Buscar referencias en archivos Dart
    await for (final entity in Directory('lib').list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = await entity.readAsString();
        
        // Buscar patrones comunes de referencias a assets
        final patterns = [
          RegExp(r"'assets/[^']+"),
          RegExp(r'"assets/[^"]+'),
        ];

        for (final pattern in patterns) {
          for (final match in pattern.allMatches(content)) {
            var asset = match.group(0)!;
            asset = asset.replaceAll("'", '').replaceAll('"', '');
            assets.add(asset);
          }
        }
      }
    }

    return assets.toList();
  }

  Future<void> _removeAssets(List<String> assets) async {
    for (final asset in assets) {
      final file = File(asset);
      if (await file.exists()) {
        await file.delete();
        log('   Removed: $asset');
      }
    }
  }

  @override
  Future<bool> canExecute(BotContext context) async {
    // Solo ejecutar si hay un directorio de assets
    return await Directory('assets').exists();
  }
}
```

### 2. Registrar el Bot

En `bots/run_bots.dart`:

```dart
import 'specialized/cleaner_bot.dart';

// En main()
var bots = <AutomationBot>[
  // ... otros bots
  CleanerBot(),
];

// En _createRegistry()
registry.register('cleaner', BotConfig(
  name: 'Cleaner Bot',
  emoji: '🧹',
  role: 'Asset Cleaner',
  triggers: ['schedule'],  // Solo en mantenimiento programado
  capabilities: ['asset_cleanup', 'file_management'],
  priority: BotPriority.low,
  enabled: true,
));
```

### 3. Configurar en YAML

En `bots/registry/bot_registry.yaml`:

```yaml
bots:
  # ... otros bots
  cleaner:
    name: "Cleaner Bot"
    emoji: "🧹"
    role: "Asset Cleaner"
    description: "Limpia assets no utilizados del proyecto"
    triggers:
      - schedule
    capabilities:
      - asset_cleanup
      - file_management
    priority: low
    enabled: true
    config:
      auto_clean: false  # Cambiar a true para limpieza automática
```

### 4. Ejecutar el Bot

```bash
# Ejecutar solo el Cleaner Bot
dart bots/run_bots.dart --schedule --bot cleaner

# O como parte del mantenimiento programado
dart bots/run_bots.dart --schedule
```

### 5. Resultado Esperado

```
════════════════════════════════════════════════════════════
🤖 Bot Workflow Started: Scheduled Event
════════════════════════════════════════════════════════════

📋 Bots to execute: 3
   🔍 Scout Dependency Bot [medium]
   👁️ Guardian Monitor Bot [high]
   🧹 Cleaner Bot [low]

────────────────────────────────────────────────────────────
▶️  Executing: 🧹 Cleaner Bot
────────────────────────────────────────────────────────────
🧹 Cleaner Bot: Starting cleanup process...
🧹 Cleaner Bot: Analyzing declared assets...
🧹 Cleaner Bot: Analyzing referenced assets...
🧹 Cleaner Bot: Auto-clean disabled, reporting only
🧹 Cleaner Bot: ⚠️  Found 3 unused assets
🧹 Cleaner Bot: ✅ Completed successfully in 2s

════════════════════════════════════════════════════════════
📊 Workflow Summary
════════════════════════════════════════════════════════════
Total Bots: 3
✅ Successful: 3
❌ Failed: 0
⏱️  Duration: 45s
════════════════════════════════════════════════════════════
🎉 Workflow completed successfully!
```

## Características Avanzadas

### Configuración Dinámica

```dart
@override
Future<BotResult> execute(BotContext context) async {
  // Leer configuración específica
  final autoClean = context.getConfig<bool>('auto_clean', defaultValue: false);
  final dryRun = context.getConfig<bool>('dry_run', defaultValue: true);
  final ignoredPatterns = context.getConfig<List>('ignore_patterns', defaultValue: []);
  
  // Usar configuración...
}
```

### Reporte Detallado

```dart
return BotResult.success(
  message: 'Asset cleanup completed',
  data: {
    'declared_count': declaredAssets.length,
    'referenced_count': referencedAssets.length,
    'unused_count': unusedAssets.length,
    'unused_assets': unusedAssets,
    'size_saved_kb': savedSize,
    'cleaned': autoClean,
  },
  duration: duration,
);
```

### Hooks Personalizados

```dart
@override
Future<void> onSuccess(BotResult result) async {
  await super.onSuccess(result);
  
  final data = result.data;
  if (data != null && data['unused_count'] > 0) {
    log('📊 Report: ${data['unused_count']} unused assets found');
    log('💾 Potential space saved: ${data['size_saved_kb']} KB');
  }
}

@override
Future<void> onFailure(BotResult result) async {
  await super.onFailure(result);
  
  // Enviar notificación o crear issue
  log('⚠️  Consider running cleanup manually');
}
```

## Testing del Bot

```dart
import 'package:test/test.dart';
import '../bots/specialized/cleaner_bot.dart';

void main() {
  group('CleanerBot', () {
    test('identifies unused assets', () async {
      final bot = CleanerBot();
      final context = BotContext(
        trigger: 'schedule',
        config: {'auto_clean': false},
      );
      
      final result = await bot.execute(context);
      
      expect(result.isSuccess, isTrue);
      expect(result.data?['unused_count'], greaterThanOrEqualTo(0));
    });
    
    test('respects auto_clean configuration', () async {
      final bot = CleanerBot();
      final context = BotContext(
        trigger: 'schedule',
        config: {'auto_clean': false},
      );
      
      final result = await bot.execute(context);
      
      expect(result.data?['cleaned'], isFalse);
    });
  });
}
```

## Tips

1. **Mantén el bot enfocado**: Una tarea específica por bot
2. **Usa logging descriptivo**: Ayuda al debugging
3. **Configurable**: Usa `context.getConfig()` para opciones
4. **Manejo robusto**: Captura todas las excepciones
5. **Reporta datos útiles**: Incluye métricas en `data`

---

¡Crea bots que automaticen tu workflow! 🤖
