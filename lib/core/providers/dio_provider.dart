import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/dio_client.dart';

part 'dio_provider.g.dart';

/// Provider global del cliente HTTP.
///
/// keepAlive: true → vive durante toda la app, nunca se destruye.
/// Es el mismo DioClient que usan todos los data sources.
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  return DioClient();
}
