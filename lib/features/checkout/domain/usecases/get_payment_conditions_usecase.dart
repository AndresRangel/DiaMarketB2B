import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/payment_condition_entity.dart';
import '../repositories/checkout_repository.dart';

/// S24 — Obtener condiciones de pago disponibles para el cliente.
class GetPaymentConditionsUseCase {
  final CheckoutRepository _repository;
  const GetPaymentConditionsUseCase(this._repository);

  Future<Either<Failure, List<PaymentConditionEntity>>> call() =>
      _repository.getPaymentConditions();
}
