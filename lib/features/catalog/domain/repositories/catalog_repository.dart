import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

/// Contrato abstracto del repositorio de catálogo.
///
/// Define QUÉ puede hacer el catálogo, sin decir CÓMO.
/// La implementación (CatalogRepositoryImpl) vive en la capa de datos
/// y decide si va a la red, al cache en memoria, o a Hive.
abstract class CatalogRepository {
  // ── Productos ─────────────────────────────────────────────────────────────

  /// S07 — Lista paginada de productos activos.
  /// [limit] máximo de resultados (default recomendado: 50).
  /// [offset] para paginación (0-based).
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int limit = 50,
    int offset = 0,
  });

  /// S09 — Búsqueda de productos por nombre (case-insensitive).
  /// [query] texto a buscar. Devuelve lista vacía si no hay coincidencias.
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    int limit = 20,
  });

  /// Obtiene un producto por su SKU exacto.
  /// Retorna null en Right si el SKU no existe (sin error).
  Future<Either<Failure, ProductEntity?>> getProductBySku(String sku);

  // ── Categorías ────────────────────────────────────────────────────────────

  /// S07 — Lista completa de categorías (padres + hijas, 52 total).
  /// Ordenadas: padres primero (parent_id IS NULL), luego hijas por nombre.
  /// La presentación construye el árbol desde esta lista plana.
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  // ── Marcas ────────────────────────────────────────────────────────────────

  /// Lista de marcas, ordenadas alfabéticamente.
  /// [limit] máximo de resultados.
  /// [query] si se proporciona, filtra por nombre (case-insensitive).
  Future<Either<Failure, List<BrandEntity>>> getBrands({
    int limit = 100,
    String? query,
  });
}
