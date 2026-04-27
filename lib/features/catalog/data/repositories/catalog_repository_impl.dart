import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/cache_policies_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';
import '../mappers/catalog_mappers.dart';

part 'catalog_repository_impl.g.dart';

/// Implementación concreta del catálogo.
///
/// Conecta:
///   - [CatalogRemoteDataSource] → llamadas a Supabase REST
///   - [CacheManager] × 3    → cache en RAM session-scoped
///
/// Política: los datos se descargan una vez por sesión y se sirven desde
/// memoria. Al cerrar la app el cache muere automáticamente (está en RAM).
/// Al reabrir, la primera petición va a la red y rellena el cache nuevamente.
///
/// Qué se cachea:
///   - [getProducts]   offset=0  → primera página (la más usada)
///   - [getCategories]           → lista completa (52 items, estable)
///   - [getBrands]     sin query → lista completa (estable durante sesión)
///
/// Qué NO se cachea:
///   - [searchProducts]          → resultado varía por query, siempre fresco
///   - [getProductBySku]         → consulta puntual, siempre fresco
///   - [getProducts] offset > 0  → páginas siguientes, siempre frescas
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remote;

  // Un CacheManager por recurso — misma política, clave de almacenamiento distinta.
  // La política 'catalog': session + memory (vive en RAM hasta que la app se cierra).
  final _productsCache = CacheManager(
    policy: CachePoliciesConfig.defaults['catalog']!,
    key: 'catalog_products',
  );
  final _categoriesCache = CacheManager(
    policy: CachePoliciesConfig.defaults['catalog']!,
    key: 'catalog_categories',
  );
  final _brandsCache = CacheManager(
    policy: CachePoliciesConfig.defaults['catalog']!,
    key: 'catalog_brands',
  );

  CatalogRepositoryImpl(this._remote);

  // ── Productos ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int limit = 50,
    int offset = 0,
  }) async {
    // Solo cacheamos la primera página. Páginas siguientes siempre van a la red.
    final useCache = offset == 0;

    if (useCache) {
      final cached = _productsCache.get<List<ProductEntity>>();
      if (cached != null) return Right(cached);
    }

    try {
      final dtos = await _remote.getProducts(limit: limit, offset: offset);
      final entities = dtos.map((d) => d.toEntity()).toList();
      if (useCache) _productsCache.set(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    // Sin cache — el resultado varía por cada término de búsqueda.
    try {
      final dtos = await _remote.searchProducts(query: query, limit: limit);
      return Right(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductBySku(String sku) async {
    // Sin cache — consulta puntual para detalle de producto.
    try {
      final dto = await _remote.getProductBySku(sku);
      return Right(dto?.toEntity());
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    final cached = _categoriesCache.get<List<CategoryEntity>>();
    if (cached != null) return Right(cached);

    try {
      final dtos = await _remote.getCategories();
      final entities = dtos.map((d) => d.toEntity()).toList();
      _categoriesCache.set(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  // ── Marcas ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands({
    int limit = 100,
    String? query,
  }) async {
    // Solo cacheamos la lista completa (sin filtro). Búsquedas van a la red.
    final useCache = query == null;

    if (useCache) {
      final cached = _brandsCache.get<List<BrandEntity>>();
      if (cached != null) return Right(cached);
    }

    try {
      final dtos = await _remote.getBrands(limit: limit, query: query);
      final entities = dtos.map((d) => d.toEntity()).toList();
      if (useCache) _brandsCache.set(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}

/// Provider del repositorio — Riverpod inyecta el data source automáticamente.
@riverpod
CatalogRepository catalogRepository(Ref ref) {
  return CatalogRepositoryImpl(ref.watch(catalogRemoteDataSourceProvider));
}
