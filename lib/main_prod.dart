import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';
import 'core/i18n/locale_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Asigna el ambiente PROD — debe ser lo primero antes de todo
  AppConfig.current = AppConfig.prod;

  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: LocaleSetup.supportedLocales,
        path: LocaleSetup.translationsPath,
        fallbackLocale: LocaleSetup.fallbackLocale,
        child: const App(),
      ),
    ),
  );
}
