import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: obtener marcas del catálogo.
///
/// Soporta búsqueda opcional por nombre para autocomplete.
class GetBrandsUseCase {
  final CatalogRepository _repository;

  const GetBrandsUseCase(this._repository);

  Future<Either<Failure, List<BrandEntity>>> call({
    int limit = 100,
    String? query,
  }) {
    return _repository.getBrands(limit: limit, query: query);
  }
}
