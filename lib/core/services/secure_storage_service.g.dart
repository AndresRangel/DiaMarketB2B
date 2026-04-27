// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Usa [SecureStorageServiceMobile] en todas las plataformas.
///
/// flutter_secure_storage soporta web de forma nativa usando localStorage.
/// La implementación in-memory para web (SecureStorageServiceWeb) fue descartada
/// porque no persiste entre recargas — haciendo imposible el preloading del tema.
/// Para este app B2B (login obligatorio, sin datos ultra-sensibles en localStorage)
/// el tradeoff es aceptable.

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

/// Usa [SecureStorageServiceMobile] en todas las plataformas.
///
/// flutter_secure_storage soporta web de forma nativa usando localStorage.
/// La implementación in-memory para web (SecureStorageServiceWeb) fue descartada
/// porque no persiste entre recargas — haciendo imposible el preloading del tema.
/// Para este app B2B (login obligatorio, sin datos ultra-sensibles en localStorage)
/// el tradeoff es aceptable.

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          SecureStorageService,
          SecureStorageService,
          SecureStorageService
        >
    with $Provider<SecureStorageService> {
  /// Usa [SecureStorageServiceMobile] en todas las plataformas.
  ///
  /// flutter_secure_storage soporta web de forma nativa usando localStorage.
  /// La implementación in-memory para web (SecureStorageServiceWeb) fue descartada
  /// porque no persiste entre recargas — haciendo imposible el preloading del tema.
  /// Para este app B2B (login obligatorio, sin datos ultra-sensibles en localStorage)
  /// el tradeoff es aceptable.
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageService create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageService>(value),
    );
  }
}

String _$secureStorageHash() => r'9885b22f2c38b5b25dcf0d39e127d5bd3814244f';
