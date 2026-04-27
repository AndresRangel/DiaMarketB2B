// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CartNotifier)
final cartProvider = CartNotifierProvider._();

final class CartNotifierProvider
    extends $NotifierProvider<CartNotifier, CartEntity> {
  CartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartNotifierHash();

  @$internal
  @override
  CartNotifier create() => CartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartEntity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartEntity>(value),
    );
  }
}

String _$cartNotifierHash() => r'436ca195d3abaafb886099412aa7c22d70ebe1a3';

abstract class _$CartNotifier extends $Notifier<CartEntity> {
  CartEntity build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CartEntity, CartEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CartEntity, CartEntity>,
              CartEntity,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
