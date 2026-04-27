// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_remote_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkoutRemoteDataSource)
final checkoutRemoteDataSourceProvider = CheckoutRemoteDataSourceProvider._();

final class CheckoutRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CheckoutRemoteDataSource,
          CheckoutRemoteDataSource,
          CheckoutRemoteDataSource
        >
    with $Provider<CheckoutRemoteDataSource> {
  CheckoutRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CheckoutRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckoutRemoteDataSource create(Ref ref) {
    return checkoutRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutRemoteDataSource>(value),
    );
  }
}

String _$checkoutRemoteDataSourceHash() =>
    r'e717253d4503b75d514816f1570b54160a3c080f';
