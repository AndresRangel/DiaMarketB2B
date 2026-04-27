import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: obtener lista paginada de productos del catálogo.
///
/// Delega directamente al repositorio — no tiene validación propia
/// porque los parámetros de paginación siempre son válidos por defecto.
class GetProductsUseCase {
  final CatalogRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getProducts(limit: limit, offset: offset);
  }
}
