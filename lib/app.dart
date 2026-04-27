import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme_notifier.dart';

/// Widget raíz de la app.
///
/// Es un ConsumerWidget para poder leer providers de Riverpod.
/// Se encarga de conectar el tema dinámico con MaterialApp
/// y de pasarle el router a la app.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch se suscribe al provider — cuando el tema cambie
    // (ej: al cargar config del backend), este widget se reconstruye
    // y MaterialApp aplica los colores nuevos automáticamente.
    final themeConfig = ref.watch(themeProvider);

    // ref.watch en el router: si el estado de auth cambia,
    // el router re-evalúa las redirecciones automáticamente.
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // go_router toma el control de la navegación
      routerConfig: router,

      // Tema dinámico generado desde la config del backend (S43)
      theme: themeConfig.toMaterialTheme(),

      // Configuración de easy_localization — se leen del contexto
      // porque EasyLocalization envuelve este widget en main_*.dart
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Oculta el banner rojo de DEBUG en la esquina superior derecha
      debugShowCheckedModeBanner: false,
    );
  }
}
