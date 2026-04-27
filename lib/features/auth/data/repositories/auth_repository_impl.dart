import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../dtos/stored_session_dto.dart';
import '../mappers/auth_mappers.dart';

part 'auth_repository_impl.g.dart';

/// Clave con la que se guarda la sesión en SecureStorage.
const _kSessionKey = 'auth_session';

/// Implementación concreta del repositorio de autenticación.
///
/// Esta clase conecta:
/// - [AuthRemoteDataSource] → llamadas a la red
/// - [SecureStorageService]  → persistencia local segura
///
/// Patrón de cada método de red:
///   1. Llamar al data source (puede lanzar DioException)
///   2. Si falla → convertir DioException en Failure → retornar Left(failure)
///   3. Si funciona → convertir DTO en Entity con el mapper → retornar Right(entity)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  // ── Operaciones de red ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, AuthSessionEntity>> login({
    required String username,
    required String password,
    String? fcmToken,
    String? imei,
    String? companyCode,
  }) async {
    try {
      final dto = await _remoteDataSource.login(
        username: username,
        password: password,
        fcmToken: fcmToken,
        imei: imei,
        companyCode: companyCode,
      );
      // Convierte LoginResponseDto → AuthSessionEntity usando el mapper
      final session = dto.toEntity();
      // Persiste la sesión para que la próxima vez que abra la app
      // el usuario no tenga que volver a hacer login
      await saveSession(session);
      return Right(session);
    } on DioException catch (e) {
      // DioClient.handleDioException convierte el error HTTP en un Failure tipificado
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String phone) async {
    try {
      await _remoteDataSource.sendOtp(phone);
      return const Right(null);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final isValid = await _remoteDataSource.validateOtp(
        phone: phone,
        code: code,
      );
      return Right(isValid);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recoverPassword({
    String? username,
    String? email,
  }) async {
    try {
      await _remoteDataSource.recoverPassword(
        username: username,
        email: email,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String password,
    required String phone,
    required String email,
    required String businessType,
    required String cityId,
    String? referralCode,
  }) async {
    try {
      final dto = await _remoteDataSource.register(
        username: username,
        password: password,
        phone: phone,
        email: email,
        businessType: businessType,
        cityId: cityId,
        referralCode: referralCode,
      );
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerFcmToken({
    required String userId,
    required String fcmToken,
  }) async {
    try {
      await _remoteDataSource.registerFcmToken(
        userId: userId,
        fcmToken: fcmToken,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String currentToken) async {
    try {
      final newToken = await _remoteDataSource.refreshToken(currentToken);
      return Right(newToken);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ── Operaciones locales (SecureStorage) ──────────────────────────────────

  @override
  Future<AuthSessionEntity?> getSavedSession() async {
    try {
      final jsonString = await _secureStorage.getString(_kSessionKey);
      if (jsonString == null) return null;

      // jsonDecode convierte el String JSON en un Map<String, dynamic>
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final dto = StoredSessionDto.fromJson(json);
      return dto.toEntity();
    } catch (_) {
      // Si el JSON está corrupto o el formato cambió, ignorar y tratar
      // como si no hubiera sesión guardada
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSessionEntity session) async {
    // toStoredDto() convierte la entity en un DTO serializable
    // jsonEncode convierte el Map en un String para guardarlo
    final jsonString = jsonEncode(session.toStoredDto().toJson());
    await _secureStorage.saveString(_kSessionKey, jsonString);
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(_kSessionKey);
  }

  @override
  Future<void> updateSelectedCompany({
    required AuthSessionEntity session,
    required CompanyEntity company,
  }) async {
    // copyWith crea una copia de la sesión con la nueva empresa seleccionada
    final updatedSession = session.copyWith(selectedCompany: company);
    await saveSession(updatedSession);
  }
}

/// Provider del repositorio — inyecta sus dos dependencias automáticamente.
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}
