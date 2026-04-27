import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product_entity.dart';
import 'catalog_notifier.dart';

part 'product_detail_notifier.g.dart';

// ── ProductDetailNotifier ─────────────────────────────────────────────────────

/// Notifier parametrizado por SKU: carga un producto por su código único.
///
/// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
/// `build(String sku)` retorna Future<ProductEntity?> →
/// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
///
/// Nota: null en el estado data significa "SKU no encontrado en el catálogo".
@riverpod
class ProductDetailNotifier extends _$ProductDetailNotifier {
  @override
  Future<ProductEntity?> build(String sku) async {
    // Primero intentamos desde el cache en memoria (catalogProvider).
    // Si ya cargamos el catálogo, el producto está disponible sin ir a la red.
    final catalogAsync = ref.read(catalogProvider);

    if (catalogAsync.hasValue) {
      final fromCache = catalogAsync.value!.products
          .where((p) => p.sku == sku)
          .firstOrNull;

      // Si lo encontramos en el catálogo en memoria, retornamos inmediatamente.
      if (fromCache != null) return fromCache;
    }

    // Fallback: buscar en la API (por ejemplo, si el usuario abre el detalle
    // por deep link sin haber pasado por el home).
    final useCase = ref.read(getProductBySkuUseCaseProvider);
    final result = await useCase(sku);

    return result.fold(
      (failure) => throw failure,
      (product) => product,
    );
  }
}
