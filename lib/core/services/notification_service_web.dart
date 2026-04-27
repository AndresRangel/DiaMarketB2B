import 'notification_service.dart';

/// Implementación web de notificaciones.
/// Web requiere Service Worker + VAPID key — se implementa en Fase 7.
class NotificationServiceWeb implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // TODO(fase7): usar Web Notifications API
  }

  @override
  Future<bool> requestPermission() async => false;
}
