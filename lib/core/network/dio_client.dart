import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/app_environment.dart';
import '../error/failures.dart';

/// URLs que NO llevan el header Authorization del usuario.
/// Son endpoints públicos o que usan solo el anon key de Supabase.
const _publicPaths = [
  '/rest/v1/rpc/login_user',  // S01 — login, solo necesita apikey
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

  /// Callback que el interceptor usa para obtener el token guardado.
  /// Se conectará con [SecureStorageService] en el Bloque 9.
  String? Function()? _getToken;

  /// Callback que el interceptor usa para renovar el token cuando expira.
  /// Se conectará con el AuthRepository en el Bloque 1 (Feature Auth).
  Future<String?> Function()? _refreshToken;

  /// Callback que se invoca cuando el refresh falla → cerrar sesión.
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

  /// Registra las funciones que el interceptor necesita para manejar tokens.
  /// Se llama una vez durante la inicialización de la app (en main_*.dart).
  void configure({
    required String? Function() getToken,
    required Future<String?> Function() refreshToken,
    required void Function() onSessionExpired,
  }) {
    _getToken = getToken;
    _refreshToken = refreshToken;
    _onSessionExpired = onSessionExpired;
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

          if (!isPublic) {
            final token = _getToken?.call();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },

        // onError: se ejecuta cuando el servidor responde con error.
        // Si es un 401, intentamos renovar el token y reintentar.
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final newToken = await _refreshToken?.call();

              if (newToken != null) {
                // Reintenta el request original con el token nuevo.
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final retryResponse = await _dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              }
            } catch (_) {
              // El refresh también falló → sesión expirada definitivamente.
            }

            // No se pudo renovar → cerrar sesión y avisar a la app.
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
        final message = _extractMessage(e.response?.data) ??
            'Error del servidor ($statusCode)';

        if (statusCode == 401) {
          return Failure.unauthorized(message);
        }
        return Failure.server(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const Failure.network('Solicitud cancelada');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return Failure.unknown(e.message ?? 'Error desconocido');
    }
  }

  /// Intenta extraer el campo "message" o "error" del body de la respuesta.
  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }
}
