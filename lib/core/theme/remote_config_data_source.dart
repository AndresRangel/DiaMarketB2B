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

  /// S43 — Descarga la configuración de tema/branding/features.
  ///
  /// [countryCode] es el código de país ISO 3166-1 alpha-2 (ej: "CO", "MX").
  /// Se toma del dispositivo; el backend devuelve la config del tenant
  /// correspondiente a ese país.
  Future<RemoteAppConfig> getConfig({String countryCode = 'CO'}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.themeConfig,
      data: {'p_country_code': countryCode},
    );
    return RemoteAppConfig.fromJson(response.data ?? {});
  }
}

@riverpod
RemoteConfigDataSource remoteConfigDataSource(Ref ref) =>
    RemoteConfigDataSource(ref.watch(dioClientProvider));
