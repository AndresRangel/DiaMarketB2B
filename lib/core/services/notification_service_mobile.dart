import 'notification_service.dart';

/// Implementación móvil de notificaciones.
/// La integración real con firebase_messaging y flutter_local_notifications
/// se completa en el Bloque 7 (Fase 7 — Comunicación + Notificaciones).
class NotificationServiceMobile implements NotificationService {
  @override
  Future<void> initialize() async {
    // TODO(fase7): inicializar firebase_messaging y flutter_local_notifications
  }

  @override
  Future<String?> getToken() async {
    // TODO(fase7): return await FirebaseMessaging.instance.getToken();
    return null;
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // TODO(fase7): mostrar con flutter_local_notifications
  }

  @override
  Future<bool> requestPermission() async {
    // TODO(fase7): solicitar permiso con firebase_messaging
    return true;
  }
}
