import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: obtener todas las categorías del catálogo.
///
/// Retorna la lista plana de 52 categorías (padres + hijas).
/// La presentación decide cómo construir el árbol a partir de [parentId].
class GetCategoriesUseCase {
  final CatalogRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}
