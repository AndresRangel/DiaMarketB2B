import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/app_environment.dart';
import '../error/failures.dart';
import 'api_endpoints.dart';

/// URLs que NO llevan el header Authorization del usuario.
/// Son endpoints públicos o que usan solo el anon key de Supabase.
const _publicPaths = [
  '/auth/v1/token',           // S01 login + S06 refresh — Supabase Auth, solo apikey
  '/registro',
  '/recuperar-contrasena',
  '/pre-registro',
  '/rest/v1/rpc/get_config',  // S43 — config pública, solo necesita apikey
];

/// Cliente HTTP centralizado de la app.
///
/// Toda llamada a la API pasa por aquí. Esto nos permite:
/// - Añadir el token de auth automáticamente en cada request.
/// - Interceptar errores 401 para renovar el token sin que el resto
///   de la app se entere.
/// - Tener logs claros en consola durante desarrollo.
///
/// En GetX esto sería algo que pondrías en un GetConnect o configurarías
/// manualmente. Aquí es una clase plana que Riverpod inyectará donde se necesite.
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  /// Access token JWT — se actualiza tras login/refresh, se borra en logout.
  String? _accessToken;

  /// Refresh token — se usa cuando el access token expira (401).
  String? _refreshTokenValue;

  /// Tenant ID — viene de app_metadata.tenant_id en el JWT de Supabase.
  String? _tenantId;

  /// Callback invocado cuando el refresh falla → la app cierra la sesión.
  void Function()? _onSessionExpired;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.current.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Supabase requiere este header en TODAS las requests.
          // El anon key es público por diseño — RLS controla los permisos reales.
          'apikey': AppConfig.current.supabaseAnonKey,
        },
      ),
    );

    _setupInterceptors();
  }

  // ── Configuración pública ────────────────────────────────────────────────

  /// Actualiza los tokens en memoria. Llamar tras login o refresh exitoso.
  void setTokens({
    required String accessToken,
    required String refreshToken,
    String? tenantId,
    void Function()? onSessionExpired,
  }) {
    _accessToken = accessToken;
    _refreshTokenValue = refreshToken;
    _tenantId = tenantId;
    if (onSessionExpired != null) _onSessionExpired = onSessionExpired;
  }

  /// Borra los tokens. Llamar al hacer logout.
  void clearTokens() {
    _accessToken = null;
    _refreshTokenValue = null;
    _tenantId = null;
  }

  /// Registra el callback que se invoca cuando el refresh falla (sesión muerta).
  /// Normalmente redirige al login limpiando el estado de auth.
  void setSessionExpiredHandler(void Function() handler) {
    _onSessionExpired = handler;
  }

  // ── Métodos HTTP públicos ────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
  }) =>
      _dio.delete<T>(path, options: options);

  // ── Interceptores ────────────────────────────────────────────────────────

  void _setupInterceptors() {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        // onRequest: se ejecuta ANTES de enviar cada request.
        // Aquí inyectamos el token si la ruta lo requiere.
        onRequest: (options, handler) {
          final isPublic = _publicPaths.any(
            (path) => options.path.contains(path),
          );

          if (!isPublic && _accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
            if (_tenantId != null) {
              options.headers['x-tenant-id'] = _tenantId;
            }
          }

          handler.next(options);
        },

        // onError: se ejecuta cuando el servidor responde con error.
        // Si es un 401, intentamos renovar el token y reintentar.
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              _refreshTokenValue != null) {
            try {
              final refreshResponse = await _dio.post<Map<String, dynamic>>(
                ApiEndpoints.refreshToken,
                data: {'refresh_token': _refreshTokenValue},
              );
              final newAccessToken =
                  refreshResponse.data?['access_token'] as String?;
              final newRefreshToken =
                  refreshResponse.data?['refresh_token'] as String?;

              if (newAccessToken != null) {
                _accessToken = newAccessToken;
                if (newRefreshToken != null) {
                  _refreshTokenValue = newRefreshToken;
                }
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final retryResponse = await _dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              }
            } catch (_) {
              // Refresh falló → sesión expirada definitivamente.
            }

            _accessToken = null;
            _refreshTokenValue = null;
            _onSessionExpired?.call();
          }

          handler.next(error);
        },
      ),
    );

    // Log de requests/responses — solo en QA para no llenar la consola en prod.
    if (AppConfig.current.isQa) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => _logger.d(object),
        ),
      );
    }
  }

  // ── Conversión de errores ────────────────────────────────────────────────

  /// Convierte un [DioException] en un [Failure] tipificado.
  ///
  /// Los repositorios llaman a este método en su bloque catch para que
  /// NUNCA propaguen un DioException hacia arriba — siempre devuelven Failure.
  static Failure handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const Failure.network('Sin conexión o tiempo de espera agotado');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        final errorCode = data is Map ? data['error_code'] as String? : null;

        // Supabase Auth usa 400 para credenciales inválidas — mapeamos
        // a Failure.unauthorized para que LoginNotifier muestre mensaje claro.
        if (statusCode == 400 && _isAuthCredentialsError(errorCode)) {
          return const Failure.unauthorized('Usuario o contraseña incorrectos.');
        }
        if (statusCode == 400 && errorCode == 'email_not_confirmed') {
          return const Failure.unauthorized('Debes confirmar tu email antes de ingresar.');
        }
        if (statusCode == 429) {
          return const Failure.server('Demasiados intentos. Espera un momento.', statusCode: 429);
        }
        if (statusCode == 401) {
          return Failure.unauthorized(
            _extractMessage(data) ?? 'Sesión expirada. Inicia sesión de nuevo.',
          );
        }

        final message = _extractMessage(data) ?? 'Error del servidor ($statusCode)';
        return Failure.server(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const Failure.network('Solicitud cancelada');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return Failure.unknown(e.message ?? 'Error desconocido');
    }
  }

  /// Supabase usa distintos error_code para credenciales inválidas.
  static bool _isAuthCredentialsError(String? errorCode) {
    const credentialErrors = {
      'invalid_credentials',
      'user_not_found',
      'invalid_grant',
    };
    return credentialErrors.contains(errorCode);
  }

  /// Extrae mensaje legible del body. Supabase usa "msg", REST estándar usa "message"/"error".
  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['msg'] as String? ??
          data['message'] as String? ??
          data['error'] as String?;
    }
    return null;
  }
}
