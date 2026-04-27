import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../domain/usecases/get_product_by_sku_usecase.dart';

part 'catalog_notifier.g.dart';

// ── Providers de Use Cases ────────────────────────────────────────────────────

@riverpod
GetProductsUseCase getProductsUseCase(Ref ref) =>
    GetProductsUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
SearchProductsUseCase searchProductsUseCase(Ref ref) =>
    SearchProductsUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetProductBySkuUseCase getProductBySkuUseCase(Ref ref) =>
    GetProductBySkuUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) =>
    GetCategoriesUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetBrandsUseCase getBrandsUseCase(Ref ref) =>
    GetBrandsUseCase(ref.watch(catalogRepositoryProvider));

// ── Tipo de dato del catálogo ─────────────────────────────────────────────────

/// Agrupa los datos del catálogo que se cargan juntos al abrir la app.
/// Usamos un Dart record para evitar crear una clase extra.
typedef CatalogData = ({
  List<ProductEntity> products,
  List<CategoryEntity> categories,
});

// ── CatalogNotifier ───────────────────────────────────────────────────────────

/// Notifier del catálogo principal.
///
/// build() retorna Future<CatalogData> → Riverpod lo convierte automáticamente
/// en AsyncValue<CatalogData> con los estados loading/data/error.
///
/// Los dos recursos se cargan EN PARALELO: iniciamos ambas futures antes de
/// hacer await en ninguna → menor tiempo de espera total.
@riverpod
class CatalogNotifier extends _$CatalogNotifier {
  @override
  Future<CatalogData> build() async {
    // Iniciamos ambas peticiones antes de await → ejecución paralela.
    final productsFuture =
        ref.read(getProductsUseCaseProvider).call();
    final categoriesFuture =
        ref.read(getCategoriesUseCaseProvider).call();

    // Ahora esperamos ambas.
    final productsResult = await productsFuture;
    final categoriesResult = await categoriesFuture;

    // fold(): si es Left (Failure), lanzamos excepción → AsyncValue.error.
    //         si es Right (datos), los retornamos.
    final products = productsResult.fold(
      (failure) => throw failure,
      (data) => data,
    );
    final categories = categoriesResult.fold(
      (failure) => throw failure,
      (data) => data,
    );

    return (products: products, categories: categories);
  }

  /// Fuerza recarga desde la red, ignorando el cache.
  /// Se llama desde el pull-to-refresh de la HomePage.
  Future<void> refresh() async {
    // AsyncLoading mientras recarga.
    state = const AsyncLoading();
    // ref.invalidateSelf() descarta el estado actual y vuelve a llamar build().
    ref.invalidateSelf();
    await future;
  }
}
