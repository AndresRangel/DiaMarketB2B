import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: obtener un producto por su SKU exacto.
///
/// Retorna Right(null) si el SKU no existe — no es un error de negocio.
/// Retorna Left(Failure) solo ante fallo de red o servidor.
class GetProductBySkuUseCase {
  final CatalogRepository _repository;

  const GetProductBySkuUseCase(this._repository);

  Future<Either<Failure, ProductEntity?>> call(String sku) {
    if (sku.trim().isEmpty) {
      return Future.value(
        const Left(Failure.validation('SKU requerido')),
      );
    }

    return _repository.getProductBySku(sku.trim());
  }
}
