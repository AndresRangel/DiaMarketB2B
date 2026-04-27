import 'cache_policy.dart';

/// Configuración central de todas las políticas de cache de la app.
///
/// ⚠️ REGLA IMPORTANTE: Para cambiar el comportamiento del cache de cualquier
/// tipo de dato, modificar SOLO este archivo. Nunca tocar los repositorios.
///
/// Las claves del mapa corresponden a los nombres de los tipos de dato.
/// El backend puede sobrescribir estas políticas vía el servicio S43 (branding).
class CachePoliciesConfig {
  static const Map<String, CachePolicy> defaults = {
    // ── 🔴 CRÍTICOS — Solo durante la sesión ────────────────────────────────
    // Estos datos deben estar frescos al abrir la app.
    // Se descargan una vez por sesión y se guardan en RAM.

    'catalog': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'prices': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'inventory': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'promotions': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'suggestedProducts': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),

    // ── 🟡 ESTABLES — Persistentes con TTL ──────────────────────────────────
    // Datos que cambian poco. Se guardan en disco y se reusan entre sesiones.
    // Cuando el TTL expira, se descargan de nuevo la próxima vez que se necesiten.

    'branches': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(days: 7),
    ),
    'paymentConditions': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(days: 7),
    ),
    'cities': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),

    // ── 🟢 CONFIGURACIÓN — Muy estables ─────────────────────────────────────

    'branding': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(hours: 24),
    ),
    'termsAndConditions': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),
    'businessTypes': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),

    // ── 🟢 COMUNICACIÓN ──────────────────────────────────────────────────────

    'messages': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(minutes: 30),
    ),
    'news': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(hours: 1),
    ),

    // ── ❌ NUNCA EN CACHE ────────────────────────────────────────────────────
    // Operaciones que involucran dinero o stock. Siempre van a la red.

    'orderCreation': CachePolicy(
      lifetime: CacheLifetime.none,
      layer: CacheLayer.memory,
    ),
    'couponValidation': CachePolicy(
      lifetime: CacheLifetime.none,
      layer: CacheLayer.memory,
    ),
    'paymentOperations': CachePolicy(
      lifetime: CacheLifetime.none,
      layer: CacheLayer.memory,
    ),
    'orderHistory': CachePolicy(
      lifetime: CacheLifetime.none,
      layer: CacheLayer.memory,
    ),
  };
}
