// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

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
final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, RemoteAppConfig> {
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
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteAppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteAppConfig>(value),
    );
  }
}

String _$themeNotifierHash() => r'f3abdce5882da950bfa06272a0c943cf857b6ffa';

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

abstract class _$ThemeNotifier extends $Notifier<RemoteAppConfig> {
  RemoteAppConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RemoteAppConfig, RemoteAppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RemoteAppConfig, RemoteAppConfig>,
              RemoteAppConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
