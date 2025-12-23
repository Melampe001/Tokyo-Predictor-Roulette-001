import 'dart:io';
import '../core/bot_base.dart';

/// Bot de construcción Atlas
class AtlasBuildBot extends AutomationBot {
  @override
  String get name => 'Atlas Build Bot';

  @override
  String get emoji => '🏗️';

  @override
  String get role => 'Build System Manager';

  @override
  BotPriority get priority => BotPriority.high;

  @override
  Future<BotResult> execute(BotContext context) async {
    final startTime = DateTime.now();
    log('Starting build process...');

    try {
      final results = <String, dynamic>{};

      // 1. Flutter Clean
      log('Cleaning previous builds...');
      await _runCommand('flutter', ['clean']);
      results['clean'] = 'success';

      // 2. Get Dependencies
      log('Fetching dependencies...');
      await _runCommand('flutter', ['pub', 'get']);
      results['dependencies'] = 'success';

      // 3. Analyze Code
      log('Analyzing code...');
      final analyzeResult = await _runCommand('flutter', ['analyze', '--no-fatal-infos']);
      results['analyze'] = analyzeResult.exitCode == 0 ? 'success' : 'warnings';

      // 4. Build APK (si está configurado)
      if (context.getConfig<bool>('build_apk', defaultValue: true)) {
        log('Building Android APK...');
        final apkResult = await _buildAPK();
        results['apk'] = apkResult;
      }

      // 5. Build Web (si está configurado)
      if (context.getConfig<bool>('build_web', defaultValue: false)) {
        log('Building Web app...');
        final webResult = await _buildWeb();
        results['web'] = webResult;
      }

      final duration = DateTime.now().difference(startTime);
      log('✅ Build completed successfully in ${duration.inSeconds}s');

      return BotResult.success(
        message: 'Build process completed',
        data: results,
        duration: duration,
      );
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      return BotResult.failure(
        message: 'Build failed',
        error: e.toString(),
        stackTrace: st,
        duration: duration,
      );
    }
  }

  Future<ProcessResult> _runCommand(String command, List<String> args) async {
    final result = await Process.run(command, args);

    if (result.exitCode != 0) {
      log('⚠️  Command failed: $command ${args.join(' ')}');
      if (result.stderr.toString().isNotEmpty) {
        log('   ${result.stderr}');
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> _buildAPK() async {
    try {
      final result = await Process.run(
        'flutter',
        ['build', 'apk', '--release'],
      );

      if (result.exitCode == 0) {
        // Calcular tamaño del APK
        final apkPath = 'build/app/outputs/flutter-apk/app-release.apk';
        final apkFile = File(apkPath);

        if (await apkFile.exists()) {
          final size = await apkFile.length();
          final sizeMB = (size / (1024 * 1024)).toStringAsFixed(2);

          return {
            'status': 'success',
            'path': apkPath,
            'size_mb': sizeMB,
          };
        }
      }

      return {'status': 'failed', 'error': result.stderr};
    } catch (e) {
      return {'status': 'failed', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _buildWeb() async {
    try {
      final result = await Process.run(
        'flutter',
        ['build', 'web', '--release'],
      );

      if (result.exitCode == 0) {
        return {
          'status': 'success',
          'path': 'build/web',
        };
      }

      return {'status': 'failed', 'error': result.stderr};
    } catch (e) {
      return {'status': 'failed', 'error': e.toString()};
    }
  }
}
