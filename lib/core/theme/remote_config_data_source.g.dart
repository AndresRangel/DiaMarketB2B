// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteConfigDataSource)
final remoteConfigDataSourceProvider = RemoteConfigDataSourceProvider._();

final class RemoteConfigDataSourceProvider
    extends
        $FunctionalProvider<
          RemoteConfigDataSource,
          RemoteConfigDataSource,
          RemoteConfigDataSource
        >
    with $Provider<RemoteConfigDataSource> {
  RemoteConfigDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigDataSourceHash();

  @$internal
  @override
  $ProviderElement<RemoteConfigDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteConfigDataSource create(Ref ref) {
    return remoteConfigDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfigDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfigDataSource>(value),
    );
  }
}

String _$remoteConfigDataSourceHash() =>
    r'fa54e6d50ddad30ad5b28a98f9da33578bff0064';
