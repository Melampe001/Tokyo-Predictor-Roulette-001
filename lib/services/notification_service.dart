import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' if (dart.library.html) '';

/// Handler para mensajes en background (debe ser top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Mensaje recibido en background: ${message.messageId}');
  debugPrint('Título: ${message.notification?.title}');
  debugPrint('Cuerpo: ${message.notification?.body}');
}

/// Servicio de notificaciones push con Firebase Cloud Messaging
/// 
/// Gestiona:
/// - Permisos de notificaciones
/// - Tokens FCM
/// - Mensajes en foreground y background
/// - Suscripciones a topics
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // Plugin para notificaciones locales (solo móvil)
  FlutterLocalNotificationsPlugin? _localNotifications;
  
  // Token FCM actual
  String? _fcmToken;
  
  /// Obtener token FCM actual
  String? get fcmToken => _fcmToken;

  /// Inicializar servicio de notificaciones
  /// 
  /// Debe llamarse al inicio de la app
  Future<void> initialize() async {
    try {
      // Solicitar permisos
      await requestPermission();
      
      // Obtener token FCM
      _fcmToken = await getToken();
      debugPrint('Token FCM: $_fcmToken');
      
      // Configurar handlers de mensajes
      _setupMessageHandlers();
      
      // Inicializar notificaciones locales (solo en móvil)
      if (!kIsWeb) {
        await _initializeLocalNotifications();
      }
      
      // Listener para cambios en el token
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('Token FCM actualizado: $newToken');
        // Aquí podrías guardar el nuevo token en Firestore
      });
    } catch (e) {
      debugPrint('Error al inicializar notificaciones: $e');
    }
  }

  /// Inicializar plugin de notificaciones locales
  Future<void> _initializeLocalNotifications() async {
    try {
      // Solo disponible en móvil
      if (kIsWeb) return;
      
      _localNotifications = FlutterLocalNotificationsPlugin();
      
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _localNotifications?.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      
      // Crear canal de notificaciones para Android
      if (defaultTargetPlatform == TargetPlatform.android) {
        const androidChannel = AndroidNotificationChannel(
          'tokyo_roulette_channel', // ID
          'Tokyo Roulette', // Nombre
          description: 'Notificaciones de Tokyo Roulette Predictor',
          importance: Importance.high,
        );
        
        await _localNotifications
            ?.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(androidChannel);
      }
    } catch (e) {
      debugPrint('Error al inicializar notificaciones locales: $e');
    }
  }

  /// Handler cuando se toca una notificación
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notificación tocada: ${response.payload}');
    // Aquí puedes navegar a una pantalla específica basándote en el payload
  }

  /// Configurar handlers de mensajes
  void _setupMessageHandlers() {
    // Mensajes mientras la app está en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensaje recibido en foreground: ${message.messageId}');
      
      if (message.notification != null) {
        debugPrint('Título: ${message.notification!.title}');
        debugPrint('Cuerpo: ${message.notification!.body}');
        
        // Mostrar notificación local
        _showLocalNotification(
          title: message.notification!.title ?? 'Tokyo Roulette',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
      
      // Procesar datos del mensaje
      if (message.data.isNotEmpty) {
        debugPrint('Datos del mensaje: ${message.data}');
        _handleMessageData(message.data);
      }
    });
    
    // Handler para cuando se toca una notificación que abrió la app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notificación tocada que abrió la app: ${message.messageId}');
      
      if (message.data.isNotEmpty) {
        _handleMessageData(message.data);
      }
    });
  }

  /// Procesar datos del mensaje
  void _handleMessageData(Map<String, dynamic> data) {
    // Aquí puedes implementar lógica específica basada en el tipo de mensaje
    final type = data['type'] as String?;
    
    switch (type) {
      case 'invitation':
        debugPrint('Invitación recibida');
        // Manejar invitación
        break;
      case 'achievement':
        debugPrint('Logro desbloqueado');
        // Manejar logro
        break;
      case 'reminder':
        debugPrint('Recordatorio');
        // Manejar recordatorio
        break;
      default:
        debugPrint('Tipo de mensaje desconocido: $type');
    }
  }

  /// Solicitar permisos de notificaciones
  /// 
  /// Returns: Settings con los permisos otorgados
  Future<NotificationSettings> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      debugPrint('Estado de permisos: ${settings.authorizationStatus}');
      
      return settings;
    } catch (e) {
      debugPrint('Error al solicitar permisos: $e');
      rethrow;
    }
  }

  /// Obtener token FCM
  /// 
  /// Returns: Token FCM o null si hay error
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      return token;
    } catch (e) {
      debugPrint('Error al obtener token: $e');
      return null;
    }
  }

  /// Eliminar token FCM
  /// 
  /// Útil cuando el usuario cierra sesión
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
    } catch (e) {
      debugPrint('Error al eliminar token: $e');
    }
  }

  /// Suscribirse a un topic
  /// 
  /// [topic] Nombre del topic (ej: 'all_users', 'premium_users')
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Suscrito al topic: $topic');
    } catch (e) {
      debugPrint('Error al suscribirse al topic: $e');
    }
  }

  /// Desuscribirse de un topic
  /// 
  /// [topic] Nombre del topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Desuscrito del topic: $topic');
    } catch (e) {
      debugPrint('Error al desuscribirse del topic: $e');
    }
  }

  /// Mostrar notificación local
  /// 
  /// [title] Título de la notificación
  /// [body] Cuerpo de la notificación
  /// [payload] Datos adicionales (opcional)
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      if (_localNotifications == null || kIsWeb) return;
      
      const androidDetails = AndroidNotificationDetails(
        'tokyo_roulette_channel',
        'Tokyo Roulette',
        channelDescription: 'Notificaciones de Tokyo Roulette Predictor',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications?.show(
        DateTime.now().millisecond, // ID único
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error al mostrar notificación local: $e');
    }
  }

  /// Mostrar notificación local pública
  /// 
  /// Útil para notificaciones programadas o acciones del usuario
  /// 
  /// [title] Título de la notificación
  /// [body] Cuerpo de la notificación
  /// [payload] Datos adicionales (opcional)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Programar notificación local
  /// 
  /// [id] ID único de la notificación
  /// [title] Título
  /// [body] Cuerpo
  /// [scheduledDate] Fecha programada
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      if (_localNotifications == null || kIsWeb) return;
      
      // Nota: Requiere el paquete timezone para notificaciones programadas
      // Por ahora, solo muestra un mensaje
      debugPrint('Notificación programada para: $scheduledDate');
      debugPrint('Título: $title, Cuerpo: $body');
      
      // TODO: Implementar con timezone si se necesita funcionalidad completa
    } catch (e) {
      debugPrint('Error al programar notificación: $e');
    }
  }

  /// Cancelar notificación programada
  /// 
  /// [id] ID de la notificación a cancelar
  Future<void> cancelNotification(int id) async {
    try {
      if (_localNotifications == null || kIsWeb) return;
      
      await _localNotifications?.cancel(id);
    } catch (e) {
      debugPrint('Error al cancelar notificación: $e');
    }
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    try {
      if (_localNotifications == null || kIsWeb) return;
      
      await _localNotifications?.cancelAll();
    } catch (e) {
      debugPrint('Error al cancelar todas las notificaciones: $e');
    }
  }

  /// Obtener mensaje inicial (si la app se abrió desde una notificación)
  /// 
  /// Returns: Mensaje inicial o null
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      return await _messaging.getInitialMessage();
    } catch (e) {
      debugPrint('Error al obtener mensaje inicial: $e');
      return null;
    }
  }

  /// Habilitar entrega automática (iOS)
  Future<void> setAutoInitEnabled(bool enabled) async {
    try {
      await _messaging.setAutoInitEnabled(enabled);
    } catch (e) {
      debugPrint('Error al establecer auto init: $e');
    }
  }
}
