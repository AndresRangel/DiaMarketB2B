import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/branch_entity.dart';
import '../repositories/checkout_repository.dart';

/// S14 — Obtener sucursales de entrega del cliente.
class GetBranchesUseCase {
  final CheckoutRepository _repository;
  const GetBranchesUseCase(this._repository);

  Future<Either<Failure, List<BranchEntity>>> call() =>
      _repository.getBranches();
}
