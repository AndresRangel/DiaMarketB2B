import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_creation_entity.dart';
import '../entities/order_result_entity.dart';
import '../repositories/checkout_repository.dart';

/// S19 — Crear pedido. CRÍTICO: sin cache, siempre validado contra el servidor.
///
/// Valida que el pedido tenga al menos una línea antes de ir a la red.
class CreateOrderUseCase {
  final CheckoutRepository _repository;
  const CreateOrderUseCase(this._repository);

  Future<Either<Failure, OrderResultEntity>> call(
    OrderCreationEntity order,
  ) {
    if (order.lines.isEmpty) {
      return Future.value(
        const Left(Failure.validation('El pedido no tiene productos')),
      );
    }
    if (order.branchId.isEmpty) {
      return Future.value(
        const Left(Failure.validation('Selecciona una sucursal de entrega')),
      );
    }
    if (order.paymentConditionId.isEmpty) {
      return Future.value(
        const Left(Failure.validation('Selecciona una condición de pago')),
      );
    }

    return _repository.createOrder(order);
  }
}
