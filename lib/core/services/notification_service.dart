import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'notification_service_mobile.dart';
import 'notification_service_web.dart';

part 'notification_service.g.dart';

/// Contrato para el servicio de notificaciones.
abstract class NotificationService {
  /// Inicializa el servicio (llamar al arrancar la app).
  Future<void> initialize();

  /// Devuelve el token FCM del dispositivo para registrarlo en el backend (S05).
  Future<String?> getToken();

  /// Muestra una notificación local (cuando la app está en foreground).
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  });

  /// Solicita permiso de notificaciones al usuario.
  Future<bool> requestPermission();
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  if (kIsWeb) return NotificationServiceWeb();
  return NotificationServiceMobile();
}
