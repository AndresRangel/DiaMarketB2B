import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_config_model.dart';
import 'remote_config_repository.dart';

part 'theme_notifier.g.dart';

// Config pre-cargada desde caché ANTES de runApp().
// La setea main_*.dart para que el primer render no use el fallback.
// Así se evita el flash de color al arrancar la app.
RemoteAppConfig? _preloadedConfig;

/// Llama esto en main() antes de runApp() si encontraste config en caché.
void preloadThemeConfig(RemoteAppConfig config) {
  _preloadedConfig = config;
}

/// Provider del tema dinámico white-label.
///
/// ── ¿Qué es @Riverpod(keepAlive: true)? ──────────────────────────────────
/// Por defecto los providers de Riverpod se destruyen cuando nadie los escucha.
/// [keepAlive: true] hace que este provider viva durante TODA la sesión,
/// desde que la app arranca hasta que el usuario la cierra.
/// Tiene sentido aquí porque el tema se necesita en absolutamente todos los widgets.
///
/// En GetX el equivalente sería un GetxController registrado con Get.put()
/// (sin lazy loading) en el main — siempre vivo, nunca destruido.
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  /// build() es el equivalente al constructor en GetX.
  /// Define el estado inicial del provider.
  /// Riverpod lo llama automáticamente la primera vez que alguien hace
  /// ref.watch(themeNotifierProvider).
  @override
  RemoteAppConfig build() {
    // Si main() pre-cargó una config desde caché, úsala como estado inicial.
    // Así el primer render ya tiene los colores y logo correctos, sin flash.
    // Si no hay caché (primer arranque), usa el fallback neutro.
    return _preloadedConfig ?? RemoteAppConfig.fallback;
  }

  // ── Métodos públicos ─────────────────────────────────────────────────────
  // Los widgets acceden a estos métodos con:
  // ref.read(themeNotifierProvider.notifier).loadConfig(empresaId)

  /// Descarga la configuración de tema del backend (S43) y actualiza el estado.
  ///
  /// Flujo:
  /// 1. Intentar descargar del backend
  /// 2. Si falla → el repositorio intenta desde cache local automáticamente
  /// 3. Si tampoco hay cache → se mantiene el fallback (estado inicial)
  Future<void> loadConfig(String empresaId) async {
    // ref.read (no watch) porque solo ejecutamos la acción una vez,
    // no necesitamos reconstruir el notifier si el repositorio cambia.
    final repo = ref.read(remoteConfigRepositoryProvider);

    final result = await repo.getConfig(
      empresaId: empresaId.isEmpty ? null : empresaId,
    );

    // fold() maneja los dos casos del Either<Failure, RemoteAppConfig>:
    // - Left(failure): API falló Y no había cache → mantenemos el fallback
    // - Right(config): éxito (red o cache) → aplicamos la config al estado
    result.fold(
      (failure) {
        // El repositorio ya intentó el cache antes de retornar Left.
        // Si llegamos aquí no hay nada mejor que el fallback — no tocamos state.
      },
      (config) => state = config,
    );
  }

  /// Actualiza el estado directamente con una config ya descargada.
  /// Útil para tests y para cuando el cache local responde primero.
  void applyConfig(RemoteAppConfig config) {
    state = config;
  }

  /// Vuelve al estado fallback.
  /// Se llama si el backend y el cache ambos fallan.
  void resetToFallback() {
    state = RemoteAppConfig.fallback;
  }
}
