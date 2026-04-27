import 'cache_policy.dart';

/// Entrada de cache que guarda el dato junto con su timestamp de creación.
/// Con el timestamp podemos saber si el TTL ya expiró.
class CacheEntry<T> {
  final T data;
  final DateTime createdAt;

  const CacheEntry({required this.data, required this.createdAt});

  /// Devuelve true si el TTL todavía no ha expirado.
  bool isValid(Duration? ttl) {
    if (ttl == null) return true; // Sin TTL = nunca expira
    return DateTime.now().difference(createdAt) < ttl;
  }
}

/// Gestor de cache en memoria (RAM).
///
/// Cada repositorio recibe una instancia de este manager y lo usa para
/// guardar y leer datos según la [CachePolicy] que le corresponde.
///
/// El cache en disco (Hive) se integrará en el Bloque 10 cuando
/// inicializamos Hive al arrancar la app.
class CacheManager {
  /// Almacén en memoria: clave → entrada con dato y timestamp.
  final Map<String, CacheEntry<dynamic>> _memoryCache = {};

  final CachePolicy policy;
  final String key;

  CacheManager({required this.policy, required this.key});

  // ── Lectura ──────────────────────────────────────────────────────────────

  /// Devuelve el dato cacheado si existe y todavía es válido.
  /// Devuelve null si no hay cache o si ya expiró.
  T? get<T>() {
    if (policy.lifetime == CacheLifetime.none) return null;
    if (!_useMemory) return null;

    final entry = _memoryCache[key];
    if (entry == null) return null;
    if (!entry.isValid(policy.customTtl)) {
      _memoryCache.remove(key); // Limpia entradas expiradas
      return null;
    }

    return entry.data as T?;
  }

  // ── Escritura ────────────────────────────────────────────────────────────

  /// Guarda un dato en el cache según la política configurada.
  void set<T>(T data) {
    if (policy.lifetime == CacheLifetime.none) return;
    if (!_useMemory) return;

    _memoryCache[key] = CacheEntry(data: data, createdAt: DateTime.now());
  }

  // ── Invalidación ─────────────────────────────────────────────────────────

  /// Elimina el dato cacheado para esta clave.
  /// Útil para forzar una recarga desde la red.
  void invalidate() {
    _memoryCache.remove(key);
  }

  /// Limpia TODO el cache en memoria.
  /// Se llama al cerrar sesión para que el próximo usuario vea datos frescos.
  static void clearAll(List<CacheManager> managers) {
    for (final manager in managers) {
      manager._memoryCache.clear();
    }
  }

  // ── Helpers privados ─────────────────────────────────────────────────────

  bool get _useMemory =>
      policy.layer == CacheLayer.memory || policy.layer == CacheLayer.both;
}
