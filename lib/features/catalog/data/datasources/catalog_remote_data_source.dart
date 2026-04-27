import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../dtos/brand_dto.dart';
import '../dtos/category_dto.dart';
import '../dtos/product_dto.dart';

part 'catalog_remote_data_source.g.dart';

/// Data source remoto del catálogo.
///
/// Habla directamente con Supabase REST (PostgREST).
/// Retorna DTOs — NO convierte a Entities (eso lo hace el repositorio).
/// NO captura errores — lanza DioException; el repositorio los convierte a Failure.
class CatalogRemoteDataSource {
  final DioClient _dio;

  const CatalogRemoteDataSource(this._dio);

  // ── Productos ─────────────────────────────────────────────────────────────

  /// S07 — Lista paginada de productos activos.
  Future<List<ProductDto>> getProducts({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.products,
      queryParameters: {
        'select':
            'id,sku,name,base_price,image_url,brand_id,category_id,tax_rule_id,is_active',
        'is_active': 'eq.true',
        'limit': limit,
        'offset': offset,
      },
    );
    return _parseList(response.data, ProductDto.fromJson);
  }

  /// S09 — Búsqueda por nombre (ilike, case-insensitive).
  Future<List<ProductDto>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.searchProducts,
      queryParameters: {
        'select':
            'id,sku,name,base_price,image_url,brand_id,category_id,tax_rule_id,is_active',
        'name': 'ilike.*$query*',
        'is_active': 'eq.true',
        'limit': limit,
      },
    );
    return _parseList(response.data, ProductDto.fromJson);
  }

  /// Producto por SKU exacto. Retorna null si no existe.
  Future<ProductDto?> getProductBySku(String sku) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.products,
      queryParameters: {
        'select':
            'id,sku,name,base_price,image_url,brand_id,category_id,tax_rule_id,is_active',
        'sku': 'eq.$sku',
      },
    );
    final list = response.data;
    if (list == null || list.isEmpty) return null;
    return ProductDto.fromJson(list.first as Map<String, dynamic>);
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  /// S07 — Todas las categorías (padres + hijas, ordenadas padres primero).
  Future<List<CategoryDto>> getCategories() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.categories,
      queryParameters: {
        'select': 'id,name,parent_id,sort_order,is_active',
        'order': 'parent_id.asc.nullsfirst,name.asc',
      },
    );
    return _parseList(response.data, CategoryDto.fromJson);
  }

  // ── Marcas ────────────────────────────────────────────────────────────────

  /// Lista de marcas. Soporta búsqueda parcial opcional.
  Future<List<BrandDto>> getBrands({
    int limit = 100,
    String? query,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.brands,
      queryParameters: {
        'select': 'id,name,provider_id,is_active',
        'order': 'name.asc',
        'limit': limit,
        if (query != null && query.isNotEmpty) 'name': 'ilike.*$query*',
      },
    );
    return _parseList(response.data, BrandDto.fromJson);
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  List<T> _parseList<T>(
    List<dynamic>? data,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      (data ?? [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
}

@riverpod
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) {
  return CatalogRemoteDataSource(ref.watch(dioClientProvider));
}
