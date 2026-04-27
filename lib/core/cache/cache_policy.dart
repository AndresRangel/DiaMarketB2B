import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_policy.freezed.dart';

/// Define cuánto tiempo vive el dato cacheado.
enum CacheLifetime {
  /// Solo durante la sesión actual.
  /// Se borra cuando el usuario cierra la app.
  /// Ejemplo: catálogo, precios, inventario.
  session,

  /// Sobrevive entre sesiones (guardado en disco).
  /// Tiene un TTL opcional — si expira, se descarga de nuevo.
  /// Ejemplo: ciudades, condiciones de pago, branding.
  persistent,

  /// Sin cache. Siempre va a la red.
  /// Ejemplo: crear pedido, validar cupón, pagos.
  none,
}

/// Define en qué capa física se guarda el dato.
enum CacheLayer {
  /// Solo en RAM (provider de Riverpod).
  /// Velocidad instantánea. Se borra al cerrar la app.
  memory,

  /// Solo en disco (Hive).
  /// Sobrevive cierres. Más lento que memoria pero muy rápido igual.
  disk,

  /// RAM + disco.
  /// Lee de memoria si está disponible, cae a disco si no.
  /// La opción más completa para datos que se usan seguido.
  both,
}

/// Política completa de cache para un tipo de dato.
///
/// Combina [CacheLifetime] y [CacheLayer] para definir exactamente
/// cómo se cachea cada tipo de dato en la app.
@freezed
abstract class CachePolicy with _$CachePolicy {
  const factory CachePolicy({
    required CacheLifetime lifetime,
    required CacheLayer layer,

    /// TTL personalizado. Solo aplica cuando lifetime = persistent.
    /// Si es null y lifetime = persistent, el dato no expira nunca.
    Duration? customTtl,
  }) = _CachePolicy;
}
