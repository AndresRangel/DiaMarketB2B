// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier parametrizado por SKU: carga un producto por su código único.
///
/// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
/// `build(String sku)` retorna Future<ProductEntity?> →
/// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
///
/// Nota: null en el estado data significa "SKU no encontrado en el catálogo".

@ProviderFor(ProductDetailNotifier)
final productDetailProvider = ProductDetailNotifierFamily._();

/// Notifier parametrizado por SKU: carga un producto por su código único.
///
/// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
/// `build(String sku)` retorna Future<ProductEntity?> →
/// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
///
/// Nota: null en el estado data significa "SKU no encontrado en el catálogo".
final class ProductDetailNotifierProvider
    extends $AsyncNotifierProvider<ProductDetailNotifier, ProductEntity?> {
  /// Notifier parametrizado por SKU: carga un producto por su código único.
  ///
  /// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
  /// `build(String sku)` retorna Future<ProductEntity?> →
  /// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
  ///
  /// Nota: null en el estado data significa "SKU no encontrado en el catálogo".
  ProductDetailNotifierProvider._({
    required ProductDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailNotifierHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductDetailNotifier create() => ProductDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is ProductDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailNotifierHash() =>
    r'2909b9ecc7ff4ee7f7718fbf06d3ec2c0c1790e8';

/// Notifier parametrizado por SKU: carga un producto por su código único.
///
/// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
/// `build(String sku)` retorna Future<ProductEntity?> →
/// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
///
/// Nota: null en el estado data significa "SKU no encontrado en el catálogo".

final class ProductDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductDetailNotifier,
          AsyncValue<ProductEntity?>,
          ProductEntity?,
          FutureOr<ProductEntity?>,
          String
        > {
  ProductDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Notifier parametrizado por SKU: carga un producto por su código único.
  ///
  /// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
  /// `build(String sku)` retorna Future<ProductEntity?> →
  /// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
  ///
  /// Nota: null en el estado data significa "SKU no encontrado en el catálogo".

  ProductDetailNotifierProvider call(String sku) =>
      ProductDetailNotifierProvider._(argument: sku, from: this);

  @override
  String toString() => r'productDetailProvider';
}

/// Notifier parametrizado por SKU: carga un producto por su código único.
///
/// Al ser un "family" provider, cada SKU diferente tiene su propio estado.
/// `build(String sku)` retorna Future<ProductEntity?> →
/// Riverpod lo convierte en AsyncValue<ProductEntity?> automáticamente.
///
/// Nota: null en el estado data significa "SKU no encontrado en el catálogo".

abstract class _$ProductDetailNotifier extends $AsyncNotifier<ProductEntity?> {
  late final _$args = ref.$arg as String;
  String get sku => _$args;

  FutureOr<ProductEntity?> build(String sku);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProductEntity?>, ProductEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductEntity?>, ProductEntity?>,
              AsyncValue<ProductEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
