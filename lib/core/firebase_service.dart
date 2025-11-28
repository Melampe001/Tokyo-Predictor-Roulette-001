// =============================================================================
// Firebase Service - Servicio Base para Firebase
// =============================================================================
//
// Este archivo proporciona una clase singleton para inicializar Firebase
// de forma segura y centralizada en la aplicación.
//
// MEJORES PRÁCTICAS:
// - Usa un singleton para evitar múltiples inicializaciones de Firebase.
// - Siempre inicializa Firebase antes de usar cualquier servicio de Firebase.
// - Maneja errores de inicialización de forma elegante.
// - Usa firebase_options.dart generado por FlutterFire CLI para configuraciones
//   específicas de cada plataforma.
//
// SEGURIDAD:
// - NUNCA hardcodees credenciales de Firebase directamente en el código.
// - Usa firebase_options.dart que genera FlutterFire CLI con configuraciones
//   seguras por plataforma.
// - Protege tu archivo google-services.json (Android) y GoogleService-Info.plist
//   (iOS) - aunque estén en el repo, las reglas de Firebase son la verdadera
//   protección.
// - Configura reglas de Firestore/Realtime Database restrictivas en producción.
//
// INSTRUCCIONES DE CONFIGURACIÓN:
// 1. Instala FlutterFire CLI: dart pub global activate flutterfire_cli
// 2. Ejecuta: flutterfire configure
// 3. Esto generará firebase_options.dart automáticamente
// 4. Descomenta el import de firebase_options.dart
// =============================================================================

import 'package:firebase_core/firebase_core.dart';
// TODO: Descomenta cuando ejecutes 'flutterfire configure'
// import '../firebase_options.dart';

/// Servicio singleton para gestionar la inicialización de Firebase.
///
/// Ejemplo de uso:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await FirebaseService.instance.initialize();
///   runApp(MyApp());
/// }
/// ```
class FirebaseService {
  // Instancia singleton
  static final FirebaseService _instance = FirebaseService._internal();
  
  /// Obtiene la instancia singleton del servicio Firebase
  static FirebaseService get instance => _instance;
  
  // Constructor privado para patrón singleton
  FirebaseService._internal();
  
  // Estado de inicialización
  bool _initialized = false;
  
  /// Indica si Firebase ha sido inicializado correctamente
  bool get isInitialized => _initialized;
  
  /// Inicializa Firebase de forma segura.
  /// 
  /// [enableCrashlytics] - Habilita o deshabilita Crashlytics (default: true)
  /// [enableAnalytics] - Habilita o deshabilita Analytics (default: true)
  /// 
  /// Retorna `true` si la inicialización fue exitosa, `false` en caso contrario.
  /// 
  /// NOTA: Esta función es idempotente - múltiples llamadas son seguras.
  Future<bool> initialize({
    bool enableCrashlytics = true,
    bool enableAnalytics = true,
  }) async {
    // Evita reinicialización
    if (_initialized) {
      return true;
    }
    
    try {
      // TODO: Descomenta cuando firebase_options.dart esté generado
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      
      // EJEMPLO: Inicialización básica sin opciones de plataforma
      // (Solo para desarrollo - NO usar en producción sin firebase_options.dart)
      await Firebase.initializeApp();
      
      _initialized = true;
      
      // Log de éxito (usar logging framework en producción)
      // ignore: avoid_print
      print('[FirebaseService] Firebase inicializado correctamente');
      
      return true;
    } on FirebaseException catch (e) {
      // Manejo específico de errores de Firebase
      // En producción: usar Crashlytics o servicio de logging
      // ignore: avoid_print
      print('[FirebaseService] Error de Firebase: ${e.message}');
      return false;
    } catch (e) {
      // Manejo de errores genéricos
      // ignore: avoid_print
      print('[FirebaseService] Error inesperado al inicializar Firebase: $e');
      return false;
    }
  }
  
  /// Verifica si Firebase está listo para usar.
  /// 
  /// Útil para verificar el estado antes de usar otros servicios de Firebase.
  void ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'Firebase no ha sido inicializado. '
        'Llama a FirebaseService.instance.initialize() primero.',
      );
    }
  }
}
