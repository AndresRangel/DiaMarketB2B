import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../dtos/company_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/user_dto.dart';

part 'auth_remote_data_source.g.dart';

/// Data source remoto de autenticación.
///
/// Responsabilidad única: hablar con el servidor y retornar DTOs.
/// NO convierte a Entidades (eso lo hace el repositorio con los mappers).
/// NO captura errores (los lanza como DioException; el repositorio los convierte a Failure).
///
/// Los endpoints son placeholders — ajustar con la documentación real del backend.
class AuthRemoteDataSource {
  final DioClient _dio;

  const AuthRemoteDataSource(this._dio);

  /// S01 — Login.
  /// Endpoint real: /rest/v1/rpc/login_user
  /// ⚠️  [TEMP] El RPC actual solo recibe p_email y retorna [{id, email}].
  ///     Cuando el backend entregue el endpoint definitivo (con token real,
  ///     empresas, etc.) actualizar aquí y en LoginResponseDto.
  Future<LoginResponseDto> login({
    required String username,
    required String password,
    String? fcmToken,
    String? imei,
    String? companyCode,
  }) async {
    final response = await _dio.post<List<dynamic>>(
      ApiEndpoints.login,
      data: {'p_email': username},
    );

    final list = response.data ?? [];
    if (list.isEmpty) {
      throw Exception('Credenciales inválidas');
    }

    final item = list.first as Map<String, dynamic>;
    final id = item['id'] as String;
    final email = item['email'] as String;

    // Construimos el DTO manualmente con los datos mínimos del endpoint actual.
    // sessionToken usa el ID como token temporal hasta que el backend entregue JWT.
    return LoginResponseDto(
      sessionToken: id,
      user: UserDto(
        id: id,
        username: email,
        email: email,
        isApproved: true,
      ),
      // [TEMP] Empresa por defecto hasta que el backend retorne empresas reales.
      companies: [
        CompanyDto(id: 'default', code: 'DEFAULT', name: 'Mi Empresa'),
      ],
      selectedCompanyId: 'default',
    );
  }

  /// S02 (envío) — Solicita reenvío del OTP al celular
  Future<void> sendOtp(String phone) async {
    await _dio.post<void>(
      ApiEndpoints.otpSend,
      data: {'phone': phone},
    );
  }

  /// S02 (validación) — Valida el código OTP ingresado
  Future<bool> validateOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.otpValidate,
      data: {'phone': phone, 'code': code},
    );
    // Placeholder: asume que el backend devuelve { "valid": true/false }
    return response.data?['valid'] as bool? ?? false;
  }

  /// S03 — Recuperar contraseña
  Future<void> recoverPassword({
    String? username,
    String? email,
  }) async {
    await _dio.post<void>(
      ApiEndpoints.recoverPassword,
      data: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
      },
    );
  }

  /// S04 — Pre-registro de nuevo cliente
  Future<UserDto> register({
    required String username,
    required String password,
    required String phone,
    required String email,
    required String businessType,
    required String cityId,
    String? referralCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.preRegister,
      data: {
        'username': username,
        'password': password,
        'phone': phone,
        'email': email,
        'business_type': businessType,
        'city_id': cityId,
        if (referralCode != null) 'referral_code': referralCode,
      },
    );
    return UserDto.fromJson(response.data!);
  }

  /// S05 — Registrar token FCM del dispositivo
  Future<void> registerFcmToken({
    required String userId,
    required String fcmToken,
  }) async {
    await _dio.post<void>(
      ApiEndpoints.registerFcmToken,
      data: {'user_id': userId, 'fcm_token': fcmToken},
    );
  }

  /// S06 — Renovar token de sesión
  Future<String> refreshToken(String currentToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'token': currentToken},
    );
    // Placeholder: asume que el backend devuelve { "session_token": "..." }
    return response.data!['session_token'] as String;
  }
}

/// Provider del data source — Riverpod lo inyecta donde se necesite.
/// @riverpod genera automáticamente `authRemoteDataSourceProvider`.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  // ref.watch obtiene el DioClient del provider global definido en core/providers/
  return AuthRemoteDataSource(ref.watch(dioClientProvider));
}
