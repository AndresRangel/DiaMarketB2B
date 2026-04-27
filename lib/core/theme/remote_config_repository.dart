import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../error/failures.dart';
import '../network/dio_client.dart';
import '../services/secure_storage_service.dart';
import 'app_config_model.dart';
import 'remote_config_data_source.dart';

part 'remote_config_repository.g.dart';

const _kConfigCacheKey = 'remote_config_s43';

abstract class RemoteConfigRepository {
  /// Descarga config del backend. Si falla, intenta desde cache.
  Future<Either<Failure, RemoteAppConfig>> getConfig({String? empresaId});

  /// Lee la config guardada en cache sin ir a la red.
  Future<RemoteAppConfig?> getCachedConfig();

  /// Persiste la config en cache para usarla si el backend no responde.
  Future<void> cacheConfig(RemoteAppConfig config);
}

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final RemoteConfigDataSource _dataSource;
  final SecureStorageService _storage;

  const RemoteConfigRepositoryImpl({
    required RemoteConfigDataSource dataSource,
    required SecureStorageService storage,
  })  : _dataSource = dataSource,
        _storage = storage;

  @override
  Future<Either<Failure, RemoteAppConfig>> getConfig({
    String? empresaId,
  }) async {
    try {
      final config = await _dataSource.getConfig(empresaId: empresaId);
      // Éxito: guardar en cache para la próxima vez que no haya red
      await cacheConfig(config);
      return Right(config);
    } on DioException catch (e) {
      // Red falló → intentar desde cache antes de retornar error
      final cached = await getCachedConfig();
      if (cached != null) return Right(cached);
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      final cached = await getCachedConfig();
      if (cached != null) return Right(cached);
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<RemoteAppConfig?> getCachedConfig() async {
    try {
      final jsonString = await _storage.getString(_kConfigCacheKey);
      if (jsonString == null) return null;
      return RemoteAppConfig.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheConfig(RemoteAppConfig config) async {
    try {
      await _storage.saveString(
        _kConfigCacheKey,
        jsonEncode(config.toJson()),
      );
    } catch (_) {
      // Si falla el cache no es crítico — la app sigue funcionando
    }
  }
}

@Riverpod(keepAlive: true)
RemoteConfigRepository remoteConfigRepository(Ref ref) =>
    RemoteConfigRepositoryImpl(
      dataSource: ref.watch(remoteConfigDataSourceProvider),
      storage: ref.watch(secureStorageProvider),
    );
