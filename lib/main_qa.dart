import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';
import 'core/i18n/locale_setup.dart';
import 'core/services/secure_storage_service_mobile.dart';
import 'core/theme/app_config_model.dart';
import 'core/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.current = AppConfig.qa;

  // Leer config de tema desde caché ANTES de runApp.
  // Así el primer frame ya usa colores y logo correctos — sin flash.
  try {
    final storage = SecureStorageServiceMobile();
    final jsonStr = await storage.getString('remote_config_s43');
    if (jsonStr != null) {
      final config = RemoteAppConfig.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );
      preloadThemeConfig(config);
    }
  } catch (_) {
    // Sin caché en primer arranque — el fallback es suficiente
  }

  await EasyLocalization.ensureInitialized();

  runApp(
    // ProviderScope es el widget raíz de Riverpod.
    // TODOS los providers de la app viven dentro de este scope.
    // Es el equivalente al GetMaterialApp de GetX pero solo para estado.
    ProviderScope(
      child: EasyLocalization(
        // Idiomas soportados (definidos en LocaleSetup)
        supportedLocales: LocaleSetup.supportedLocales,
        // Dónde están los archivos JSON de traducción
        path: LocaleSetup.translationsPath,
        // Si el dispositivo tiene un idioma no soportado, usa este
        fallbackLocale: LocaleSetup.fallbackLocale,
        child: const App(),
      ),
    ),
  );
}
