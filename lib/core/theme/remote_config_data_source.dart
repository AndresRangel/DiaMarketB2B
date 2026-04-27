import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_endpoints.dart';
import '../network/dio_client.dart';
import '../providers/dio_provider.dart';
import 'app_config_model.dart';

part 'remote_config_data_source.g.dart';

/// Data source del servicio S43 — Config tema/branding.
///
/// URL placeholder: '/api/config/theme'
/// Reemplazar con el endpoint real cuando el backend lo confirme.
///
/// Lanza DioException si la red falla — el repositorio la convierte en Failure.
class RemoteConfigDataSource {
  final DioClient _dio;

  const RemoteConfigDataSource(this._dio);

  /// S43 — Descarga la configuración de tema/branding/features para una empresa.
  ///
  /// [empresaId] es opcional: si no se tiene (primera apertura sin sesión),
  /// el backend devuelve la config por defecto del distribuidor.
  Future<RemoteAppConfig> getConfig({String? empresaId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.themeConfig,
      queryParameters: {
        if (empresaId != null && empresaId.isNotEmpty) 'empresa_id': empresaId,
      },
    );
    // RemoteAppConfig.fromJson ya tiene fallbacks campo por campo,
    // así que si el JSON viene incompleto nunca lanza excepción.
    return RemoteAppConfig.fromJson(response.data ?? {});
  }
}

@riverpod
RemoteConfigDataSource remoteConfigDataSource(Ref ref) =>
    RemoteConfigDataSource(ref.watch(dioClientProvider));
