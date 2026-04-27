import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/branch_entity.dart';
import '../entities/order_creation_entity.dart';
import '../entities/order_result_entity.dart';
import '../entities/payment_condition_entity.dart';

/// Contrato abstracto del repositorio de checkout.
abstract class CheckoutRepository {
  /// S14 — Sucursales de entrega del cliente.
  Future<Either<Failure, List<BranchEntity>>> getBranches();

  /// S24 — Condiciones de pago disponibles para el cliente.
  Future<Either<Failure, List<PaymentConditionEntity>>>
      getPaymentConditions();

  /// S19 — Crear pedido. CRÍTICO: sin cache, siempre a la red.
  Future<Either<Failure, OrderResultEntity>> createOrder(
    OrderCreationEntity order,
  );

  /// S20 — Disparar pedido al ERP tras confirmación S19.
  Future<Either<Failure, bool>> triggerErpOrder(String orderId);
}
