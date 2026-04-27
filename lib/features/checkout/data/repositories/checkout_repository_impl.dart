import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/cache_policies_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/order_creation_entity.dart';
import '../../domain/entities/order_result_entity.dart';
import '../../domain/entities/payment_condition_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_data_source.dart';
import '../mappers/checkout_mappers.dart';

part 'checkout_repository_impl.g.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _remote;

  // Sucursales y condiciones de pago — persistent 7d (ver CachePoliciesConfig)
  final _branchesCache = CacheManager(
    policy: CachePoliciesConfig.defaults['branches']!,
    key: 'checkout_branches',
  );
  final _paymentCache = CacheManager(
    policy: CachePoliciesConfig.defaults['paymentConditions']!,
    key: 'checkout_payment_conditions',
  );

  CheckoutRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches() async {
    final cached = _branchesCache.get<List<BranchEntity>>();
    if (cached != null) return Right(cached);

    try {
      final dtos = await _remote.getBranches();
      final entities = dtos.map((d) => d.toEntity()).toList();
      _branchesCache.set(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentConditionEntity>>>
      getPaymentConditions() async {
    final cached =
        _paymentCache.get<List<PaymentConditionEntity>>();
    if (cached != null) return Right(cached);

    try {
      final dtos = await _remote.getPaymentConditions();
      final entities = dtos.map((d) => d.toEntity()).toList();
      _paymentCache.set(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderResultEntity>> createOrder(
    OrderCreationEntity order,
  ) async {
    // CRÍTICO: sin cache, siempre a la red.
    try {
      final dto = await _remote.createOrder(order);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> triggerErpOrder(String orderId) async {
    try {
      final result = await _remote.triggerErpOrder(orderId);
      return Right(result);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}

@riverpod
CheckoutRepository checkoutRepository(Ref ref) =>
    CheckoutRepositoryImpl(ref.watch(checkoutRemoteDataSourceProvider));
