import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: buscar productos por nombre.
///
/// Valida que el término no esté vacío antes de ir a la red.
/// Búsqueda case-insensitive usando ilike en PostgREST.
class SearchProductsUseCase {
  final CatalogRepository _repository;

  const SearchProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    required String query,
    int limit = 20,
  }) {
    if (query.trim().isEmpty) {
      return Future.value(
        const Left(Failure.validation('Término de búsqueda requerido')),
      );
    }

    return _repository.searchProducts(
      query: query.trim(),
      limit: limit,
    );
  }
}
