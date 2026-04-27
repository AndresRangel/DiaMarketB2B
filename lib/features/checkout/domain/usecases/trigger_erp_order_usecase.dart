import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/checkout_repository.dart';

/// S20 — Disparar pedido al ERP tras crear con S19.
///
/// Se llama inmediatamente después de [CreateOrderUseCase] con éxito.
/// Si falla, el pedido fue creado pero no procesado — se notifica al usuario.
class TriggerErpOrderUseCase {
  final CheckoutRepository _repository;
  const TriggerErpOrderUseCase(this._repository);

  Future<Either<Failure, bool>> call(String orderId) {
    if (orderId.trim().isEmpty) {
      return Future.value(
        const Left(Failure.validation('ID de pedido requerido')),
      );
    }
    return _repository.triggerErpOrder(orderId.trim());
  }
}
