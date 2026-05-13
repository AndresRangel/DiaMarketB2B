import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../network/dio_client.dart';

part 'dio_provider.g.dart';

/// Provider global del cliente HTTP.
///
/// keepAlive: true → vive durante toda la app, nunca se destruye.
/// Es el mismo DioClient que usan todos los data sources.
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final client = DioClient();

  // Cuando el refresh token falla (sesión definitivamente expirada),
  // llamamos logout() en AuthNotifier → el router redirige al login.
  // Usamos ref.read (lazy) para evitar dependencia circular en build-time:
  // dioClient no "escucha" authProvider, solo lo lee cuando ocurre el 401.
  client.setSessionExpiredHandler(() {
    ref.read(authProvider.notifier).logout();
  });

  return client;
}
